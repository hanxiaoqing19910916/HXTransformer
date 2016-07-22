//
//  HXHttpResInterFace.m
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/22.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import "HXHttpResInterFace.h"

@interface HXHttpResInterFace ()


@end



@implementation HXHttpResInterFace

+ (instancetype)shareInterface {
    static HXHttpResInterFace *shareInterface = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInterface = [[self alloc] init];
    });
    return shareInterface;
}


- (void)httpGETWithServiceId:(NSString *)serviceId method:(NSString *)method params:(NSDictionary *)params resultCallBack:(resultCallBack) resultCallBack {
    
    
    
    
}

- (void)httpPOSTWithServiceId:(NSString *)serviceId method:(NSString *)method params:(NSDictionary *)params resultCallBack:(resultCallBack) resultCallBack {
    
    
}
@end
