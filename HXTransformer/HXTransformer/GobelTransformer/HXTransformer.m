//
//  HXTransformer.m
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/14.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import "HXTransformer.h"
#import <objc/runtime.h>

@implementation HXTransformer

+ (instancetype)shareInstance {
    static HXTransformer *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)performWithMaker:(NSString *)targetStr process_SEL:(NSString *)process_SEL_Str withDic:(NSDictionary *)infoDic {
    
    // 传入空字符串 直接返回
    if (targetStr.length == 0 || process_SEL_Str.length == 0) return nil;
    
    // 反射 NSString -> class
    Class cls = NSClassFromString(targetStr);
    
    // 不存在直接返回
    if (!cls) return nil;
    
    // 反射 NSString -> SEL
    SEL selector_ = NSSelectorFromString(process_SEL_Str);
    
    // selector_ 存在
    if (selector_) {
        // 实例化 class
        id targetObj = [[cls alloc] init];
        // 方法定义并且实现
        if ([targetObj respondsToSelector:selector_]) {
            // 从 SEL selector_ 获取返回值类型
            Method instaceMethod = class_getInstanceMethod(cls, selector_);
            char *retutnType = method_copyReturnType(instaceMethod);
            
            // 当方法无返回值的时候 接收performSelector:performSelector返回值的时候会有崩溃
            // 解决方法：判断方法无返回值的时候，调用-(void)performSelector:withObject:afterDelay:
            if (!strcmp("v", retutnType)) { // 实例方法无返回值
                NSLog(@"no return value");
                [targetObj performSelector:selector_ withObject:infoDic afterDelay:0.0];
                return nil;
            } else { // 实例方法有返回值
                NSLog(@"has return value");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                return [targetObj performSelector:selector_ withObject:infoDic];
#pragma clang diagnostic pop
            }
            // 方法未实现 根据需求可以加一些操作
        } else {
            return nil;
        }
        
    }
    // selector_ 不存在
    return nil;

    return nil;
    
}


@end
