//
//  HXParamsSignature.h
//  HXTransformer
//
//  Created by hanxiaoqing on 16/8/3.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HXParamsSignature : NSObject


+ (NSDictionary *)hx_signedParams:(NSDictionary *)params withKey:(NSString *)pkey;


@end
