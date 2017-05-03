//
//  NSObject+Extension.h
//  CustomExtensionDemo
//
//  Created by illScholar on 16/1/18.
//  Copyright © 2016年 Gome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)

#pragma mark -
#pragma mark Runtime
/**
 *	@brief	Exchange methods
 *
 *	@param 	originalMethod 	Method to exchange
 *	@param 	newMethod 	Method to exchange
 *
 */
+ (void)customSwizzleMethod:(_Nonnull SEL)originalMethod withMethod:(_Nonnull SEL)newMethod;

/**
 *	@brief	Append a new method to an object.
 *
 *	@param 	newMethod 	Method to exchange
 *	@param 	aClass 	Host class
 *
 */
+ (void)customAppendMethod:(_Nonnull SEL)newMethod fromClass:(_Nonnull Class)aClass;

/**
 *	@brief	 Replace a method in an object.
 *
 *	@param 	aMethod 	Method to exchange
 *	@param 	aClass 	Host class
 *
 */
+ (void)customReplaceMethod:(_Nonnull SEL)aMethod fromClass:(_Nonnull Class)aClass;

/**
 *	@brief	Check whether the receiver implements or inherits a specified method up to and exluding a particular class in hierarchy.
 *
 *	@param 	aSelector 	A selector that identifies a method.
 *	@param 	aStopClass 	A final super class to stop quering (excluding it).
 *
 *	@return	YES if one of super classes in hierarchy responds a specified selector.
 */
- (BOOL)customRespondsToSelector:(_Nonnull SEL)aSelector untilClass:(_Nonnull Class)aStopClass;

/**
 *	@brief	Check whether a superclass implements or inherits a specified method.
 *
 *	@param 	aSelector 	A selector that identifies a method.
 *
 *	@return	YES if one of super classes in hierarchy responds a specified selector.
 */
- (BOOL)customSuperRespondsToSelector:(_Nonnull SEL)aSelector;

/**
 *	@brief	Check whether a superclass implements or inherits a specified method.
 *
 *	@param 	aSelector 	A selector that identifies a method.
 *	@param 	aStopClass 	A final super class to stop quering (excluding it).
 *
 *	@return	YES if one of super classes in hierarchy responds a specified selector.
 */
- (BOOL)customSuperRespondsToSelector:(_Nonnull SEL)aSelector untilClass:(_Nonnull Class)aStopClass;

/**
 *	@brief	Check whether a superclass implements or inherits a specified method.
 *
 *	@param 	aSelector 	A selector that identifies a method.
 *	@param 	aStopClass 	A final super class to stop quering (excluding it).
 *
 *	@return	YES if one of super classes in hierarchy responds a specified selector.
 */
+ (BOOL)customInstancesRespondToSelector:(_Nonnull SEL)aSelector untilClass:(_Nonnull Class)aStopClass;

#pragma mark -
#pragma mark AssociatedObject
/**
 *  @brief  附加一个stong对象
 *
 *  @param value 被附加的对象
 *  @param key   被附加对象的key
 */
- (void)customAssociateValue:(id _Nonnull)value withKey:(void * _Nonnull)key; // Strong reference
/**
 *  @brief  附加一个weak对象
 *
 *  @param value 被附加的对象
 *  @param key   被附加对象的key
 */
- (void)customWeaklyAssociateValue:(id _Nonnull)value withKey:(void * _Nonnull)key;

/**
 *  @brief  根据附加对象的key取出附加对象
 *
 *  @param key 附加对象的key
 *
 *  @return 附加对象
 */
- (id _Nullable)customAssociatedValueForKey:(void * _Nonnull)key;

#pragma mark -
#pragma mark Property
/**
 *  @brief  catgory runtime实现get set方法增加一个字符串属性
 */
@property (nonatomic, strong) NSString * _Nullable stringProperty;
/**
 *  @brief  catgory runtime实现get set方法增加一个NSInteger属性
 */
@property (nonatomic, assign) NSInteger integerProperty;

/**
 *	@brief	Check if the object is valid (not nil or null)
 *
 *	@return	Returns if the object is valid
 */
- (BOOL)customIsValid;

/**
 *	@brief	Perform selector with unlimited objects
 *
 *	@param 	aSelector 	The selector
 *	@param 	object 	The objects
 *
 *	@return	An object that is the result of the message
 */
- (id _Nonnull)customPerformSelector:(SEL _Nonnull)aSelector
                         withObjects:(id _Nullable)object, ... NS_REQUIRES_NIL_TERMINATION;


#pragma mark -
#pragma mark GCD
/**
 *  @brief  异步执行代码块
 *
 *  @param aBlock 代码块
 */
- (void)customPerformAsynchronous:(void(^ _Nullable)(void))aBlock;

/**
 *  @brief  GCD主线程执行代码块
 *
 *  @param aBlock 代码块
 *  @param aWait  是否同步请求
 */
- (void)customPerformOnMainThread:(void(^ _Nullable)(void))aBlock wait:(BOOL)aWait;

/**
 *  @brief  延迟执行代码块
 *
 *  @param aSeconds 延迟时间 秒
 *  @param aBlock   代码块
 */
- (void)customPerformAfter:(NSTimeInterval)aSeconds block:(void(^ _Nullable)(void))aBlock;

#pragma mark -
#pragma mark KVO Blocks
- (void)customAddObserver:(NSObject * _Nonnull)observer
               forKeyPath:(NSString * _Nonnull)keyPath
                  options:(NSKeyValueObservingOptions)options
                  context:(void * _Nullable)context
                withBlock:(void (^ _Nullable)(NSDictionary * _Nonnull change, void * _Nullable context))block;

- (void)customRemoveBlockObserver:(NSObject * _Nonnull)observer
                       forKeyPath:(NSString * _Nonnull)keyPath;

- (void)customAddObserverForKeyPath:(NSString * _Nonnull)keyPath
                            options:(NSKeyValueObservingOptions)options
                            context:(void * _Nullable)context
                          withBlock:(void (^ _Nullable)(NSDictionary * _Nonnull change, void * _Nullable context))block;

- (void)customRemoveBlockObserverForKeyPath:(NSString * _Nonnull)keyPath;

#pragma mark -
#pragma mark Compare
/**
 *  Returns whether the reciever is equal to the object passed in.
 *
 *  This method uses `compare:` to determine equality, not `isEquals:`.
 *
 *  @param anObject The object to compare to.
 *
 *  @return `YES` if the receiver is equal to the first parameter, otherwise `NO`.
 */
- (BOOL)customIsEqualTo:(id _Nonnull)anObject;

/**
 *  Returns whether the reciever is less than or equal to the object passed in.
 *
 *  @param anObject The object to compare to.
 *
 *  @return `YES` if the receiver is less than or equal to the first parameter, otherwise `NO`.
 */
- (BOOL)customIsLessThanOrEqualTo:(id _Nonnull)anObject;

/**
 *  Returns whether the reciever is less than the object passed in.
 *
 *  @param anObject The object to compare to.
 *
 *  @return `YES` if the receiver is less than the first parameter, otherwise `NO`.
 */
- (BOOL)customIsLessThan:(id _Nonnull)anObject;

/**
 *  Returns whether the reciever is greater than or equal to the object passed in.
 *
 *  @param anObject The object to compare to.
 *
 *  @return `YES` if the receiver is greater than or equal to the first parameter, otherwise `NO`.
 */
- (BOOL)customIsGreaterThanOrEqualTo:(id _Nonnull)anObject;

/**
 *  Returns whether the reciever is greater than the object passed in, otherwise `NO`.
 *
 *  @param anObject The object to compare to.
 *
 *  @return `YES` if the receiver is equal to the first parameter.
 */
- (BOOL)customIsGreaterThan:(id _Nonnull)anObject;

/**
 *  Returns whether the reciever is not equal to the object passed in.
 *
 *  @param anObject The object to compare to.
 *
 *  @return `YES` if the receiver is not equal to the first parameter, otherwise `NO`.
 */
- (BOOL)customIsNotEqualTo:(id _Nonnull)anObject;

#pragma mark -
#pragma mark Reflection
- (NSString * _Nonnull)className;
+ (NSString * _Nonnull)className;

- (NSString * _Nonnull)superClassName;
+ (NSString * _Nonnull)superClassName;

- (NSDictionary * _Nonnull)propertyDictionary;

//属性名称列表
- (NSArray * _Nonnull)propertyKeys;
+ (NSArray * _Nonnull)propertyKeys;

//属性详细信息列表
- (NSArray * _Nonnull)propertiesInfo;
+ (NSArray * _Nonnull)propertiesInfo;

//格式化后的属性列表
+ (NSArray * _Nonnull)propertiesWithCodeFormat;

//方法列表
- (NSArray * _Nonnull)methodList;
+ (NSArray * _Nonnull)methodList;

- (NSArray * _Nonnull)methodListInfo;

//创建并返回一个指向所有已注册类的指针列表
+ (NSArray * _Nullable)registedClassList;
//实例变量
+ (NSArray * _Nullable)instanceVariable;

//协议列表
- (NSDictionary * _Nullable)protocolList;
+ (NSDictionary * _Nullable)protocolList;

- (BOOL)hasPropertyForKey:(NSString * _Nonnull)key;
- (BOOL)hasIvarForKey:(NSString * _Nonnull)key;

/**
 *  wizzMethod
 */
+ (void)swizzMethodWithOrgSel:(SEL _Nonnull)orgSel newSel:(SEL _Nonnull)newSel;
@end
