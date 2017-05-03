//
//  NSObject+Extension.m
//  CustomExtensionDemo
//
//  Created by illScholar on 16/1/18.
//  Copyright © 2016年 Gome. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/runtime.h>

typedef void (^KVOBlock)(NSDictionary *change, void *context);

//objc_getAssociatedObject和objc_setAssociatedObject都需要指定一个固定的地址，这个固定的地址值用来表示属性的key，起到一个常量的作用。
static const void *StringProperty = &StringProperty;
static const void *IntegerProperty = &IntegerProperty;

// MethodSwizzle used from here: http://www.cocoadev.com/index.pl?MethodSwizzle
BOOL MethodSwizzle(Class klass, SEL origSel, SEL altSel) {
    
    // Make sure the class isn't nil
    if (klass == nil)
        return NO;
    
    // Look for the methods in the implementation of the immediate class
    Class iterKlass = klass;
    Method origMethod = NULL, altMethod = NULL;
    unsigned int methodCount = 0;
    Method *mlist = class_copyMethodList(iterKlass, &methodCount);
    if(mlist != NULL) {
        int i;
        for (i = 0; i < methodCount; ++i) {
            if(method_getName(mlist[i]) == origSel )
                origMethod = mlist[i];
            if (method_getName(mlist[i]) == altSel)
                altMethod = mlist[i];
        }
    }
    
    // if origMethod was not found, that means it is not in the immediate class
    // try searching the entire class hierarchy with class_getInstanceMethod
    // if not found or not added, bail out
    if(origMethod == NULL) {
        origMethod = class_getInstanceMethod(iterKlass, origSel);
        if(origMethod == NULL) {
            return NO;
        }
        
        if(class_addMethod(iterKlass, method_getName(origMethod), method_getImplementation(origMethod), method_getTypeEncoding(origMethod)) == NO) {
            return NO;
        }
    }
    
    // same thing with altMethod
    if(altMethod == NULL) {
        altMethod = class_getInstanceMethod(iterKlass, altSel);
        if(altMethod == NULL )
            return NO;
        if(class_addMethod(iterKlass, method_getName(altMethod), method_getImplementation(altMethod), method_getTypeEncoding(altMethod)) == NO )
            return NO;
    }
    
    //clean up
    free(mlist);
    
    // we now have to look up again for the methods in case they were not in the class implementation,
    //but in one of the superclasses. In the latter, that means we added the method to the class,
    //but the Leopard APIs is only 'class_addMethod', in which case we need to have the pointer
    //to the Method objects actually stored in the Class structure (in the Tiger implementation,
    //a new mlist was explicitely created with the added methods and directly added to the class;
    //thus we were able to add a new Method AND get the pointer to it)
    
    // for simplicity, just use the same code as in the first step
    origMethod = NULL;
    altMethod = NULL;
    methodCount = 0;
    mlist = class_copyMethodList(iterKlass, &methodCount);
    if(mlist != NULL) {
        int i;
        for (i = 0; i < methodCount; ++i) {
            if(method_getName(mlist[i]) == origSel )
                origMethod = mlist[i];
            if (method_getName(mlist[i]) == altSel)
                altMethod = mlist[i];
        }
    }
    
    // bail if one of the methods doesn't exist anywhere
    // with all we did, this should not happen, though
    if (origMethod == NULL || altMethod == NULL)
        return NO;
    
    // now swizzle
    method_exchangeImplementations(origMethod, altMethod);
    
    //clean up
    free(mlist);
    
    return YES;
}

void appendMethod(Class aClass, Class bClass, SEL bSel) {
    if(!aClass) return;
    if(!bClass) return;
    Method bMethod = class_getInstanceMethod(bClass, bSel);
    class_addMethod(aClass, method_getName(bMethod), method_getImplementation(bMethod), method_getTypeEncoding(bMethod));
}

void replaceMethod(Class toClass, Class fromClass, SEL aSelector) {
    if(!toClass) return;
    if(!fromClass) return;
    Method aMethod = class_getInstanceMethod(fromClass, aSelector);
    class_replaceMethod(toClass, method_getName(aMethod), method_getImplementation(aMethod), method_getTypeEncoding(aMethod));
}

@implementation NSObject (Extension)
#pragma mark -
#pragma mark Runtime
+ (void)customSwizzleMethod:(_Nonnull SEL)originalMethod withMethod:(_Nonnull SEL)newMethod {
    MethodSwizzle([self class], originalMethod, newMethod);
}

+ (void)customAppendMethod:(_Nonnull SEL)newMethod fromClass:(_Nonnull Class)aClass {
    appendMethod([self class], aClass, newMethod);
}

+ (void)customReplaceMethod:(_Nonnull SEL)aMethod fromClass:(_Nonnull Class)aClass {
    replaceMethod([self class], aClass, aMethod);
}

- (BOOL)customRespondsToSelector:(_Nonnull SEL)aSelector untilClass:(_Nonnull Class)aStopClass {
    return [self.class customInstancesRespondToSelector:aSelector untilClass:aStopClass];
}

- (BOOL)customSuperRespondsToSelector:(_Nonnull SEL)aSelector {
    return [self.superclass instancesRespondToSelector:aSelector];
}

- (BOOL)customSuperRespondsToSelector:(_Nonnull SEL)aSelector untilClass:(_Nonnull Class)aStopClass {
    return [self.superclass customInstancesRespondToSelector:aSelector untilClass:aStopClass];
}

+ (BOOL)customInstancesRespondToSelector:(_Nonnull SEL)aSelector untilClass:(_Nonnull Class)aStopClass {
    BOOL __block (^ __weak block_self)(Class klass, SEL selector, Class stopClass);
    BOOL (^block)(Class klass, SEL selector, Class stopClass) = [^(Class klass, SEL selector, Class stopClass) {
        if (!klass || klass == stopClass)
            return NO;
        
        unsigned methodCount = 0;
        Method *methodList = class_copyMethodList(klass, &methodCount);
        
        if (methodList)
            for (unsigned i = 0; i < methodCount; ++i)
                if (method_getName(methodList[i]) == selector)
                    return YES;
        
        return block_self(klass.superclass, selector, stopClass);
    } copy];
    
    block_self = block;
    
    return block(self.class, aSelector, aStopClass);
}

#pragma mark -
#pragma mark AssociatedObject
- (void)customAssociateValue:(id _Nonnull)value withKey:(void * _Nonnull)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN);
}

- (void)customWeaklyAssociateValue:(id _Nonnull)value withKey:(void * _Nonnull)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (id _Nullable)customAssociatedValueForKey:(void * _Nonnull)key {
    return objc_getAssociatedObject(self, key);
}

#pragma mark -
#pragma mark Property
@dynamic stringProperty;
//set
/**
 *  @brief  catgory runtime实现get set方法增加一个字符串属性
 */
- (void)setStringProperty:(NSString *)stringProperty{
    //use that a static const as the key
    objc_setAssociatedObject(self, StringProperty, stringProperty, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //use that property's selector as the key:
    //objc_setAssociatedObject(self, @selector(stringProperty), stringProperty, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//get
- (NSString *)stringProperty {
    return objc_getAssociatedObject(self, StringProperty);
}

//set
/**
 *  @brief  catgory runtime实现get set方法增加一个NSInteger属性
 */
- (void)setIntegerProperty:(NSInteger)integerProperty{
    NSNumber *number = [[NSNumber alloc]initWithInteger:integerProperty];
    objc_setAssociatedObject(self, IntegerProperty, number, OBJC_ASSOCIATION_ASSIGN);
}
//get
- (NSInteger)integerProperty{
    return [objc_getAssociatedObject(self, IntegerProperty) integerValue];
}

- (BOOL)customIsValid {
    return !(self == nil || [self isKindOfClass:[NSNull class]]);
}

- (id _Nonnull)customPerformSelector:(SEL _Nonnull)aSelector withObjects:(id _Nullable)object, ... {
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    if (signature) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:aSelector];
        
        va_list args;
        va_start(args, object);
        
        [invocation setArgument:&object atIndex:2];
        
        id arg = nil;
        int index = 3;
        while ((arg = va_arg(args, id))) {
            [invocation setArgument:&arg atIndex:index];
            index++;
        }
        
        va_end(args);
        
        [invocation invoke];
        if (signature.methodReturnLength) {
            id anObject;
            [invocation getReturnValue:&anObject];
            return anObject;
        }
        else {
            return nil;
        }
    }
    else {
        return nil;
    }
}

#pragma mark -
#pragma mark GCD
- (void)customPerformAsynchronous:(void(^ _Nullable)(void))aBlock {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, aBlock);
}

- (void)customPerformOnMainThread:(void(^ _Nullable)(void))aBlock wait:(BOOL)aWait {
    if (aWait) {
        // Synchronous
        dispatch_sync(dispatch_get_main_queue(), aBlock);
    }
    else {
        // Asynchronous
        dispatch_async(dispatch_get_main_queue(), aBlock);
    }
}

- (void)customPerformAfter:(NSTimeInterval)aSeconds block:(void(^ _Nullable)(void))aBlock {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, aSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), aBlock);
}

#pragma mark -
#pragma mark KVO Blocks
- (void)customAddObserver:(NSObject * _Nonnull)observer
               forKeyPath:(NSString * _Nonnull)keyPath
                  options:(NSKeyValueObservingOptions)options
                  context:(void * _Nullable)context
                withBlock:(void (^ _Nullable)(NSDictionary * _Nonnull change, void * _Nullable context))block {
    objc_setAssociatedObject(observer, (__bridge const void *)(keyPath), block, OBJC_ASSOCIATION_COPY);
    [self addObserver:observer forKeyPath:keyPath options:options context:context];
}

- (void)customRemoveBlockObserver:(NSObject * _Nonnull)observer
                       forKeyPath:(NSString * _Nonnull)keyPath {
    objc_setAssociatedObject(observer, (__bridge const void *)(keyPath), nil, OBJC_ASSOCIATION_COPY);
    [self removeObserver:observer forKeyPath:keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    KVOBlock block = objc_getAssociatedObject(self, (__bridge const void *)(keyPath));
    block(change, context);
}

- (void)customAddObserverForKeyPath:(NSString * _Nonnull)keyPath
                            options:(NSKeyValueObservingOptions)options
                            context:(void * _Nullable)context
                          withBlock:(void (^ _Nullable)(NSDictionary * _Nonnull change, void * _Nullable context))block {
    [self customAddObserver:self forKeyPath:keyPath options:options context:context withBlock:block];
}

- (void)customRemoveBlockObserverForKeyPath:(NSString * _Nonnull)keyPath {
    [self customRemoveBlockObserver:self forKeyPath:keyPath];
}

#pragma mark -
#pragma mark Compare

- (NSComparisonResult)_isCompare:(id _Nonnull)anObject {
    SEL comparisonSelector = @selector(compare:);
    NSAssert([self respondsToSelector:comparisonSelector], @"To use the comparison methods, this object must respond to the selector `compare:`");
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[self class] instanceMethodSignatureForSelector:comparisonSelector]];
    invocation.selector = comparisonSelector;
    invocation.target = self;
    [invocation setArgument:&anObject atIndex:2];
    [invocation invoke];
    NSComparisonResult comparisonResult;
    [invocation getReturnValue:&comparisonResult];
    return comparisonResult;
}

- (BOOL)customIsEqualTo:(id _Nonnull)anObject {
    return [self _isCompare:anObject] == NSOrderedSame ;
}

- (BOOL)customIsLessThanOrEqualTo:(id _Nonnull)anObject {
    NSComparisonResult comparisonResult = [self _isCompare:anObject];
    return comparisonResult == NSOrderedSame || comparisonResult == NSOrderedAscending;
}

- (BOOL)customIsLessThan:(id _Nonnull)anObject {
    return [self _isCompare:anObject] == NSOrderedAscending;
}

- (BOOL)customIsGreaterThanOrEqualTo:(id _Nonnull)anObject {
    NSComparisonResult comparisonResult = [self _isCompare:anObject];
    return comparisonResult == NSOrderedSame || comparisonResult == NSOrderedDescending;
}

- (BOOL)customIsGreaterThan:(id _Nonnull)anObject {
    return [self _isCompare:anObject] == NSOrderedDescending;
}

- (BOOL)customIsNotEqualTo:(id _Nonnull)anObject {
    return [self _isCompare:anObject] != NSOrderedSame;
}

#pragma mark -
#pragma mark Reflection
- (NSString * _Nonnull)className {
    return NSStringFromClass([self class]);
}

+ (NSString * _Nonnull)className {
    return NSStringFromClass([self class]);
}

- (NSString * _Nonnull)superClassName {
    return NSStringFromClass([self superclass]);
}

+ (NSString * _Nonnull)superClassName {
    return NSStringFromClass([self superclass]);
}

//实例属性字典
- (NSDictionary * _Nonnull)propertyDictionary {
    //创建可变字典
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned int outCount;
    objc_property_t *props = class_copyPropertyList([self class], &outCount);
    for(int i=0;i<outCount;i++){
        objc_property_t prop = props[i];
        NSString *propName = [[NSString alloc]initWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];
        id propValue = [self valueForKey:propName];
        [dict setObject:propValue?:[NSNull null] forKey:propName];
    }
    free(props);
    return dict;
}

- (NSArray * _Nonnull)propertyKeys {
    return [[self class] propertyKeys];
}

+ (NSArray * _Nonnull)propertyKeys {
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList(self, &propertyCount);
    NSMutableArray * propertyNames = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    return propertyNames;
}

- (NSArray * _Nonnull)propertiesInfo {
    return [[self class] propertiesInfo];
}

+ (NSArray * _Nonnull)propertiesInfo {
    NSMutableArray *propertieArray = [NSMutableArray array];
    
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    
    for (int i = 0; i < propertyCount; i++)
    {
        [propertieArray addObject:({
            
            NSDictionary *dictionary = [self dictionaryWithProperty:properties[i]];
            
            dictionary;
        })];
    }
    
    free(properties);
    
    return propertieArray;
}

+ (NSArray * _Nonnull)propertiesWithCodeFormat {
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *properties = [[self class] propertiesInfo];
    
    for (NSDictionary *item in properties) {
        NSMutableString *format = ({
            NSMutableString *formatString = [NSMutableString stringWithFormat:@"@property "];
            //attribute
            NSArray *attribute = [item objectForKey:@"attribute"];
            attribute = [attribute sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj1 compare:obj2 options:NSNumericSearch];
            }];
            if (attribute && attribute.count > 0) {
                NSString *attributeStr = [NSString stringWithFormat:@"(%@)",[attribute componentsJoinedByString:@", "]];
                
                [formatString appendString:attributeStr];
            }
            
            //type
            NSString *type = [item objectForKey:@"type"];
            if (type) {
                [formatString appendString:@" "];
                [formatString appendString:type];
            }
            
            //name
            NSString *name = [item objectForKey:@"name"];
            if (name) {
                [formatString appendString:@" "];
                [formatString appendString:name];
                [formatString appendString:@";"];
            }
            
            formatString;
        });
        
        [array addObject:format];
    }
    
    return array;
}

- (NSArray * _Nonnull)methodList {
    u_int               count;
    NSMutableArray *methodList = [NSMutableArray array];
    Method *methods= class_copyMethodList([self class], &count);
    for (int i = 0; i < count ; i++) {
        SEL name = method_getName(methods[i]);
        NSString *strName = [NSString  stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
        [methodList addObject:strName];
    }
    free(methods);
    return methodList;
}

+ (NSArray * _Nonnull)methodList {
    u_int               count;
    NSMutableArray *methodList = [NSMutableArray array];
    Method * methods= class_copyMethodList([self class], &count);
    for (int i = 0; i < count ; i++) {
        SEL name = method_getName(methods[i]);
        NSString *strName = [NSString  stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
        [methodList addObject:strName];
    }
    free(methods);
    
    return methodList;
}

- (NSArray * _Nonnull)methodListInfo {
    u_int               count;
    NSMutableArray *methodList = [NSMutableArray array];
    Method *methods= class_copyMethodList([self class], &count);
    for (int i = 0; i < count ; i++)
    {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        
        Method method = methods[i];
        SEL name = method_getName(method);
        // 返回方法的参数的个数
        int argumentsCount = method_getNumberOfArguments(method);
        //获取描述方法参数和返回值类型的字符串
        const char *encoding =method_getTypeEncoding(method);
        //取方法的返回值类型的字符串
        const char *returnType =method_copyReturnType(method);
        
        NSMutableArray *arguments = [NSMutableArray array];
        for (int index=0; index<argumentsCount; index++) {
            // 获取方法的指定位置参数的类型字符串
            char *arg =   method_copyArgumentType(method,index);
            //            NSString *argString = [NSString stringWithCString:arg encoding:NSUTF8StringEncoding];
            [arguments addObject:[[self class] decodeType:arg]];
        }
        
        NSString *returnTypeString =[[self class] decodeType:returnType];
        NSString *encodeString = [[self class] decodeType:encoding];
        NSString *nameString = [NSString  stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
        
        [info setObject:arguments forKey:@"arguments"];
        [info setObject:[NSString stringWithFormat:@"%d",argumentsCount] forKey:@"argumentsCount"];
        [info setObject:returnTypeString forKey:@"returnType"];
        [info setObject:encodeString forKey:@"encode"];
        [info setObject:nameString forKey:@"name"];
        //        [info setObject:imp_f forKey:@"imp"];
        [methodList addObject:info];
    }
    free(methods);
    return methodList;
}

+ (NSArray * _Nullable)registedClassList {
    NSMutableArray *result = [NSMutableArray array];
    
    unsigned int count;
    Class *classes = objc_copyClassList(&count);
    for (int i = 0; i < count; i++)
    {
        [result addObject:NSStringFromClass(classes[i])];
    }
    free(classes);
    [result sortedArrayUsingSelector:@selector(compare:)];
    
    return result;
}
//实例变量
+ (NSArray * _Nullable)instanceVariable {
    unsigned int outCount;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        NSString *type = [[self class] decodeType:ivar_getTypeEncoding(ivars[i])];
        NSString *name = [NSString stringWithCString:ivar_getName(ivars[i]) encoding:NSUTF8StringEncoding];
        NSString *ivarDescription = [NSString stringWithFormat:@"%@ %@", type, name];
        [result addObject:ivarDescription];
    }
    free(ivars);
    return result.count ? [result copy] : nil;
}

- (NSDictionary * _Nullable)protocolList {
    return [[self class]protocolList];
}

+ (NSDictionary * _Nullable)protocolList {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    unsigned int count;
    Protocol * __unsafe_unretained * protocols = class_copyProtocolList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        Protocol *protocol = protocols[i];
        
        NSString *protocolName = [NSString stringWithCString:protocol_getName(protocol) encoding:NSUTF8StringEncoding];
        
        NSMutableArray *superProtocolArray = ({
            
            NSMutableArray *array = [NSMutableArray array];
            
            unsigned int superProtocolCount;
            Protocol * __unsafe_unretained * superProtocols = protocol_copyProtocolList(protocol, &superProtocolCount);
            for (int ii = 0; ii < superProtocolCount; ii++)
            {
                Protocol *superProtocol = superProtocols[ii];
                
                NSString *superProtocolName = [NSString stringWithCString:protocol_getName(superProtocol) encoding:NSUTF8StringEncoding];
                
                [array addObject:superProtocolName];
            }
            free(superProtocols);
            
            array;
        });
        
        [dictionary setObject:superProtocolArray forKey:protocolName];
    }
    free(protocols);
    
    return dictionary;
}

- (BOOL)hasPropertyForKey:(NSString * _Nonnull)key {
    objc_property_t property = class_getProperty([self class], [key UTF8String]);
    return (BOOL)property;
}

- (BOOL)hasIvarForKey:(NSString * _Nonnull)key {
    Ivar ivar = class_getInstanceVariable([self class], [key UTF8String]);
    return (BOOL)ivar;
}

+ (NSDictionary *)dictionaryWithProperty:(objc_property_t)property {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    //name
    
    NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
    [result setObject:propertyName forKey:@"name"];
    
    //attribute
    
    NSMutableDictionary *attributeDictionary = ({
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        
        unsigned int attributeCount;
        objc_property_attribute_t *attrs = property_copyAttributeList(property, &attributeCount);
        
        for (int i = 0; i < attributeCount; i++) {
            NSString *name = [NSString stringWithCString:attrs[i].name encoding:NSUTF8StringEncoding];
            NSString *value = [NSString stringWithCString:attrs[i].value encoding:NSUTF8StringEncoding];
            [dictionary setObject:value forKey:name];
        }
        
        free(attrs);
        
        dictionary;
    });
    
    NSMutableArray *attributeArray = [NSMutableArray array];
    
    /***
     https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW6
     
     R           | The property is read-only (readonly).
     C           | The property is a copy of the value last assigned (copy).
     &           | The property is a reference to the value last assigned (retain).
     N           | The property is non-atomic (nonatomic).
     G<name>     | The property defines a custom getter selector name. The name follows the G (for example, GcustomGetter,).
     S<name>     | The property defines a custom setter selector name. The name follows the S (for example, ScustomSetter:,).
     D           | The property is dynamic (@dynamic).
     W           | The property is a weak reference (__weak).
     P           | The property is eligible for garbage collection.
     t<encoding> | Specifies the type using old-style encoding.
     */
    
    //R
    if ([attributeDictionary objectForKey:@"R"]) {
        [attributeArray addObject:@"readonly"];
    }
    //C
    if ([attributeDictionary objectForKey:@"C"]) {
        [attributeArray addObject:@"copy"];
    }
    //&
    if ([attributeDictionary objectForKey:@"&"]) {
        [attributeArray addObject:@"strong"];
    }
    //N
    if ([attributeDictionary objectForKey:@"N"]) {
        [attributeArray addObject:@"nonatomic"];
    }
    else {
        [attributeArray addObject:@"atomic"];
    }
    //G<name>
    if ([attributeDictionary objectForKey:@"G"]) {
        [attributeArray addObject:[NSString stringWithFormat:@"getter=%@", [attributeDictionary objectForKey:@"G"]]];
    }
    //S<name>
    if ([attributeDictionary objectForKey:@"S"]) {
        [attributeArray addObject:[NSString stringWithFormat:@"setter=%@", [attributeDictionary objectForKey:@"G"]]];
    }
    //D
    if ([attributeDictionary objectForKey:@"D"]) {
        [result setObject:[NSNumber numberWithBool:YES] forKey:@"isDynamic"];
    }
    else {
        [result setObject:[NSNumber numberWithBool:NO] forKey:@"isDynamic"];
    }
    //W
    if ([attributeDictionary objectForKey:@"W"]) {
        [attributeArray addObject:@"weak"];
    }
    //P
    if ([attributeDictionary objectForKey:@"P"]) {
        //TODO:P | The property is eligible for garbage collection.
    }
    //T
    if ([attributeDictionary objectForKey:@"T"]) {
        /*
         https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
         c               A char
         i               An int
         s               A short
         l               A long l is treated as a 32-bit quantity on 64-bit programs.
         q               A long long
         C               An unsigned char
         I               An unsigned int
         S               An unsigned short
         L               An unsigned long
         Q               An unsigned long long
         f               A float
         d               A double
         B               A C++ bool or a C99 _Bool
         v               A void
         *               A character string (char *)
         @               An object (whether statically typed or typed id)
         #               A class object (Class)
         :               A method selector (SEL)
         [array type]    An array
         {name=type...}  A structure
         (name=type...)  A union
         bnum            A bit field of num bits
         ^type           A pointer to type
         ?               An unknown type (among other things, this code is used for function pointers)
         
         */
        
        NSDictionary *typeDic = @{@"c":@"char",
                                  @"i":@"int",
                                  @"s":@"short",
                                  @"l":@"long",
                                  @"q":@"long long",
                                  @"C":@"unsigned char",
                                  @"I":@"unsigned int",
                                  @"S":@"unsigned short",
                                  @"L":@"unsigned long",
                                  @"Q":@"unsigned long long",
                                  @"f":@"float",
                                  @"d":@"double",
                                  @"B":@"BOOL",
                                  @"v":@"void",
                                  @"*":@"char *",
                                  @"@":@"id",
                                  @"#":@"Class",
                                  @":":@"SEL",
                                  };
        //TODO:An array
        NSString *key = [attributeDictionary objectForKey:@"T"];
        
        id type_str = [typeDic objectForKey:key];
        
        if (type_str == nil) {
            if ([[key substringToIndex:1] isEqualToString:@"@"] && [key rangeOfString:@"?"].location == NSNotFound) {
                type_str = [[key substringWithRange:NSMakeRange(2, key.length - 3)] stringByAppendingString:@"*"];
            }
            else if ([[key substringToIndex:1] isEqualToString:@"^"]) {
                id str = [typeDic objectForKey:[key substringFromIndex:1]];
                
                if (str) {
                    type_str = [NSString stringWithFormat:@"%@ *",str];
                }
            }
            else {
                type_str = @"unknow";
            }
        }
        
        [result setObject:type_str forKey:@"type"];
    }
    
    [result setObject:attributeArray forKey:@"attribute"];
    
    return result;
}

+ (NSString *)decodeType:(const char *)cString {
    if (!strcmp(cString, @encode(char)))
        return @"char";
    if (!strcmp(cString, @encode(int)))
        return @"int";
    if (!strcmp(cString, @encode(short)))
        return @"short";
    if (!strcmp(cString, @encode(long)))
        return @"long";
    if (!strcmp(cString, @encode(long long)))
        return @"long long";
    if (!strcmp(cString, @encode(unsigned char)))
        return @"unsigned char";
    if (!strcmp(cString, @encode(unsigned int)))
        return @"unsigned int";
    if (!strcmp(cString, @encode(unsigned short)))
        return @"unsigned short";
    if (!strcmp(cString, @encode(unsigned long)))
        return @"unsigned long";
    if (!strcmp(cString, @encode(unsigned long long)))
        return @"unsigned long long";
    if (!strcmp(cString, @encode(float)))
        return @"float";
    if (!strcmp(cString, @encode(double)))
        return @"double";
    if (!strcmp(cString, @encode(bool)))
        return @"bool";
    if (!strcmp(cString, @encode(_Bool)))
        return @"_Bool";
    if (!strcmp(cString, @encode(void)))
        return @"void";
    if (!strcmp(cString, @encode(char *)))
        return @"char *";
    if (!strcmp(cString, @encode(id)))
        return @"id";
    if (!strcmp(cString, @encode(Class)))
        return @"class";
    if (!strcmp(cString, @encode(SEL)))
        return @"SEL";
    if (!strcmp(cString, @encode(BOOL)))
        return @"BOOL";
    
    //    NSDictionary *typeDic = @{@"c":@"char",
    //                              @"i":@"int",
    //                              @"s":@"short",
    //                              @"l":@"long",
    //                              @"q":@"long long",
    //                              @"C":@"unsigned char",
    //                              @"I":@"unsigned int",
    //                              @"S":@"unsigned short",
    //                              @"L":@"unsigned long",
    //                              @"Q":@"unsigned long long",
    //                              @"f":@"float",
    //                              @"d":@"double",
    //                              @"B":@"BOOL",
    //                              @"v":@"void",
    //                              @"*":@"char *",
    //                              @"@":@"id",
    //                              @"#":@"Class",
    //                              @":":@"SEL",
    //                              };
    
    //@TODO: do handle bitmasks
    NSString *result = [NSString stringWithCString:cString encoding:NSUTF8StringEncoding];
    //    if ([typeDic objectForKey:result]) {
    //        return [typeDic objectForKey:result];
    //    }
    if ([[result substringToIndex:1] isEqualToString:@"@"] && [result rangeOfString:@"?"].location == NSNotFound) {
        result = [[result substringWithRange:NSMakeRange(2, result.length - 3)] stringByAppendingString:@"*"];
    }
    else {
        if ([[result substringToIndex:1] isEqualToString:@"^"]) {
            result = [NSString stringWithFormat:@"%@ *",
                      [NSString decodeType:[[result substringFromIndex:1] cStringUsingEncoding:NSUTF8StringEncoding]]];
        }
    }
    return result;
}

#pragma mark -------
+ (void)swizzMethodWithOrgSel:(SEL)orgSel newSel:(SEL)newSel{
    Method orgMet = class_getInstanceMethod([self class], orgSel);
    Method newMet = class_getInstanceMethod([self class], newSel);
    BOOL didAddMethod =
    class_addMethod([self class],orgSel,method_getImplementation(newMet),
                    method_getTypeEncoding(newMet));
    
    if (didAddMethod) {
        class_replaceMethod([self class],newSel,method_getImplementation(orgMet),
                            method_getTypeEncoding(orgMet));
    } else {
        method_exchangeImplementations(orgMet, newMet);
    }
}
@end
