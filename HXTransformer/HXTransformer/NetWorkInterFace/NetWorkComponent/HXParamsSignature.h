//
//  HXParamsSignature.h
//  HXTransformer
//
//  Created by hanxiaoqing on 16/8/3.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 请求参数进行处理
 tips:使用者可以根据自己公司的请求加密方案，修改hx_signedParams:params:withKey方法的实现
 */
@interface HXParamsSignature : NSObject

/**
 *  对请求参数进行处理（加密）
 *
 *  @param params 原本的请求参数
 *  @param pkey   公钥或者私钥
 *
 *  @return 处理好的参数
 */
+ (NSDictionary *)hx_signedParams:(NSDictionary *)params withKey:(NSString *)pkey;

+ (NSString *)generateOnlyKeyOfUrl:(NSString *)url param:(NSDictionary *)params;

@end
