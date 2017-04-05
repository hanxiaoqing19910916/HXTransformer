//
//  HXParamsSignature.m
//  HXTransformer
//
//  Created by hanxiaoqing on 16/8/3.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import "HXParamsSignature.h"
#import "HXAppInformation.h"
#include <CommonCrypto/CommonDigest.h>

@implementation HXParamsSignature

static NSInteger alphabeticSort(id string1, id string2, void *reverse) {
    if (*(BOOL *)reverse == YES) {
        return [string2 localizedCaseInsensitiveCompare:string1];
    }
    return [string1 localizedCaseInsensitiveCompare:string2];
}


+ (NSDictionary *)hx_signedParams:(NSDictionary *)params withKey:(NSString *)pkey {
    
    NSMutableDictionary *param_ex = [params mutableCopy];
    if (!param_ex) {
        param_ex = [NSMutableDictionary dictionary];
    }
    param_ex[@"t"] = [HXAppInformation exceptDiffServerTime];
    
    NSArray *dic_keys = param_ex.allKeys;
    BOOL reverseSort = NO;//正序排列
    dic_keys = [dic_keys sortedArrayUsingFunction:alphabeticSort context:&reverseSort];
    NSString *params_str = @"";
    for (NSString *key in dic_keys) {
        NSString *key_value_str = [NSString stringWithFormat:@"%@%@",key,param_ex[key]];
        params_str = [params_str stringByAppendingString:key_value_str];
    }
    NSString *signed_str = [NSString stringWithFormat:@"%@%@",params_str,pkey];
    param_ex[@"sign"] = [self HX_md5:signed_str];
    //    NSLog(@"%@",param_ex);
    return param_ex;
}



+ (NSString *)HX_md5:(NSString *)orignString
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

// 根据url以及参数 生成一个能够标识请求的唯一的key

+ (NSString *)generateOnlyKeyOfUrl:(NSString *)url param:(NSDictionary *)params
{
    NSArray *dic_keys = params.allKeys;
    BOOL reverseSort = NO;//正序排列
    NSMutableString *values = [NSMutableString string];
    dic_keys = [dic_keys sortedArrayUsingFunction:alphabeticSort context:&reverseSort];
    for (NSString *key in dic_keys) {
        NSString *key_value_str = [NSString stringWithFormat:@"%@%@",key,params[key]];
        [values appendString:key_value_str];
    }
    NSString *signed_str = [NSString stringWithFormat:@"%@%@",url,values];
    return [self HX_md5:signed_str];
}





@end
