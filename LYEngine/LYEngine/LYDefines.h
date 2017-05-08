//
//  LYDefines.h
//  LYEngine
//
//  Created by lly on 2017/3/27.
//  Copyright © 2017年 franklin. All rights reserved.
//

#ifndef LYDefines_h
#define LYDefines_h

#import "LYAssertionHandler.h"

#define VDPropretyStrong(Type,Name) @property(nonatomic,strong) Type VD_##Name;
#define VDPropretyCopy(Type,Name) @property(nonatomic,copy) Type VD_##Name;
#define VDPropretyAssign(Type,Name) @property(nonatomic,assign) Type VD_##Name;
#define VDPropretyWeak(Type,Name) @property(nonatomic,weak) Type VD_##Name;
#define VDMethod(returnType,methodName) - (returnType)VD_##methodName;

#define VMPropretyStrong(Type,Name) @property(nonatomic,strong) Type VM_##Name;
#define VMPropretyCopy(Type,Name) @property(nonatomic,copy) Type VM_##Name;
#define VMPropretyAssign(Type,Name) @property(nonatomic,assign) Type VM_##Name;
#define VMPropretyWeak(Type,Name) @property(nonatomic,weak) Type VM_##Name;

#define LYSynthesizeProprety(Type,VDProperty,VMproperty) \
- (Type)VDProperty{ \
return self.VMproperty; \
} \
- (void)set##VMproperty:(Type)p{ \
[self set##VDProperty:p]; \
} \
- (void)set##VDProperty:(Type)p{ \
_##VMproperty = p; \
} \

#define LYSynthesizeMethod(returnType,VDMethod,VMMethod) \
- (returnType)VDMethod{\
[self VMMethod];\
}

#define LYLogDebugInfo	do {																			\
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
} while (0)


#define LYLog(format, ...)	do {																			\
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "----------------------\n");                                \
} while (0)


#define LYAssert(condition, desc, ...)	\
do {				\
__PRAGMA_PUSH_NO_EXTRA_ARG_WARNINGS \
if (!(condition)) {		\
NSString *__assert_file__ = [NSString stringWithUTF8String:__FILE__]; \
__assert_file__ = __assert_file__ ? __assert_file__ : @"<Unknown File>"; \
[[LYAssertionHandler currentHandler] handleFailureInMethod:_cmd \
object:self file:__assert_file__ \
lineNumber:__LINE__ description:(desc), ##__VA_ARGS__]; \
}				\
__PRAGMA_POP_NO_EXTRA_ARG_WARNINGS \
} while(0)

#ifdef __cplusplus
#define LY_EXTERN extern "C" __attribute__((visibility ("default")))
#else
#define LY_EXTERN extern __attribute__((visibility ("default")))
#endif

#endif /* LYDefines_h */
