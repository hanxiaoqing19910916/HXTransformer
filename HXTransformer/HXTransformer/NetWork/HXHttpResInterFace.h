//
//  HXHttpResInterFace.h
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/22.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HXResponsResult;

typedef void(^resultSuccess)(HXResponsResult *response);
typedef void(^resultFail)(HXResponsResult *response);


@interface HXHttpResInterFace : NSObject

+ (instancetype)shareInterface;

- (NSUInteger)httpGETWithServiceId:(NSString *)serviceId method:(NSString *)method params:(NSDictionary *)params resultCallBackSuccess:(resultSuccess)resultSuccess resultCallBackFail:(resultFail)resultFail;

- (NSUInteger)httpPOSTWithServiceId:(NSString *)serviceId method:(NSString *)method params:(NSDictionary *)params resultCallBackSuccess:(resultSuccess)resultSuccess resultCallBackFail:(resultFail)resultFail;


- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestsWithIDs:(NSArray *)IDs;


@end
