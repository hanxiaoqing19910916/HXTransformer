//
//  HXHttpResInterFace.h
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/22.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^resultCallBack)(NSURLResponse *response);

@interface HXHttpResInterFace : NSObject

+ (instancetype)shareInterface;

- (void)httpGETWithServiceId:(NSString *)serviceId method:(NSString *)method params:(NSDictionary *)params resultCallBack:(resultCallBack) resultCallBack;

- (void)httpPOSTWithServiceId:(NSString *)serviceId method:(NSString *)method params:(NSDictionary *)params resultCallBack:(resultCallBack) resultCallBack;


@end
