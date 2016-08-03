//
//  HXHttpResInterFace.h
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/22.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  底层网络接口 跟AFNetworking产生关联，作为解耦层。将来更换网络请求框架，就只修改这个类的一些方法
 */

@class HXResponsResult;

typedef void(^resultSuccess)(HXResponsResult *response);
typedef void(^resultFail)(HXResponsResult *response);


@interface HXHttpResInterFace : NSObject

+ (instancetype)shareInterface;

- (NSUInteger)httpGETWithURLStr:(NSString *)URLStr params:(NSDictionary *)params resultCallBackSuccess:(resultSuccess)resultSuccess resultCallBackFail:(resultFail)resultFail;

- (NSUInteger)httpPOSTWithURLStr:(NSString *)URLStr params:(NSDictionary *)params resultCallBackSuccess:(resultSuccess)resultSuccess resultCallBackFail:(resultFail)resultFail;


- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestsWithIDs:(NSArray *)IDs;


@end
