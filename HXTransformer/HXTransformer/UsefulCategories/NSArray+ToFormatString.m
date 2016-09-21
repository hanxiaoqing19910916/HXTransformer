//
//  NSArray+ToFormatString.m
//  BTAnalytics
//
//  Created by hanxiaoqing on 16/4/22.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import "NSArray+ToFormatString.h"

@implementation NSArray (ToFormatString)

- (NSString *)toDotSegmentString {
    
    NSMutableString *formatString = [NSMutableString string];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //拼接请求参数字符串（","分割）
        if ([obj isKindOfClass:[NSString class]]) {
            //最后一个参数后不加 ","
            if (idx == self.count - 1) {
                [formatString appendFormat:@"%@",(NSString *)obj];
            } else {
                [formatString appendFormat:@"%@,",(NSString *)obj];
            }
        }
    }];
    return formatString;
}



- (NSString *)toVerticalLineSegmentString {
    
    NSMutableString *formatString = [NSMutableString string];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //拼接请求参数字符串（","分割）
        if ([obj isKindOfClass:[NSString class]]) {
            //最后一个参数后不加 ","
            if (idx == self.count - 1) {
                [formatString appendFormat:@"%@",(NSString *)obj];
            } else {
                [formatString appendFormat:@"%@|",(NSString *)obj];
            }
        }
    }];
    return formatString;
}
@end
