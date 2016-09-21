//
//  NSDictionary+OrderedString.m
//  BTAnalytics
//
//  Created by hanxiaoqing on 16/4/20.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import "NSDictionary+OrderedString.h"
#include <CommonCrypto/CommonDigest.h>

@implementation NSDictionary (OrderedString)


- (NSString *)paramsForOrderedString {
    
    NSArray *valuesArray  = [self allValues];
    NSMutableArray *stringValuesArray = [NSMutableArray array];
    [valuesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //所有的 NSNumber 对象转成 NSString
        if ([obj isKindOfClass:[NSNumber class]]) {
            obj = [NSString stringWithFormat:@"%d",[obj intValue]];
        }
        [stringValuesArray addObject:obj];
    }];
    
    NSMutableString *orderedString = [NSMutableString string];
    [stringValuesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //拼接请求参数字符串（"|"分割）
        if ([obj isKindOfClass:[NSString class]]) {
            //最后一个参数后不加 "|"
            if (idx == stringValuesArray.count - 1) {
                [orderedString appendFormat:@"%@",(NSString *)obj];
            } else {
                [orderedString appendFormat:@"%@|",(NSString *)obj];
            }
        }
    }];
    return orderedString;
}

static  NSInteger alphabeticSort(id string1, id string2, void *reverse) {
    if (*(BOOL *)reverse == YES) {
        return [string2 localizedCaseInsensitiveCompare:string1];
    }
    return [string1 localizedCaseInsensitiveCompare:string2];
}

- (NSDictionary *)ecodeParamWithKey:(NSString *)key
{
    NSMutableDictionary *param_ex = [self mutableCopy];
    NSArray *dic_keys = param_ex.allKeys;
    BOOL reverseSort = NO;//正序排列
    dic_keys = [dic_keys sortedArrayUsingFunction:alphabeticSort context:&reverseSort];
    NSString *params_str = @"";
    for (NSString *key in dic_keys) {
        NSString *key_value_str = [NSString stringWithFormat:@"%@=%@",key,param_ex[key]];
        params_str = [params_str stringByAppendingString:key_value_str];
    }
    NSString *signed_str = [NSString stringWithFormat:@"%@%@",params_str,key];
//    NSLog(@"校验字符串%@",signed_str);
    param_ex[@"c"] = [self HX_md5:signed_str];
//    NSLog(@"增加校验参数后的字典参数%@",param_ex);
    return param_ex;
    
}


- (NSString *)HX_md5:(NSString *)orignString
{
    NSData* inputData = [orignString dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char outputData[CC_MD5_DIGEST_LENGTH];
    CC_MD5([inputData bytes], (unsigned int)[inputData length], outputData);
    
    NSMutableString* hashStr = [NSMutableString string];
    int i = 0;
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; ++i)
        [hashStr appendFormat:@"%02x", outputData[i]];
    
    return hashStr;
}









@end
