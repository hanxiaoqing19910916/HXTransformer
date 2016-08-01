//
//  HXResponsResult.h
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/25.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,HXResponsStatus) {
    HXResponsStatusSuccess, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层决定。
    HXResponsStatusTimeout,
    HXResponsStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};

@interface HXResponsResult : NSObject

@property (nonatomic,assign) HXResponsStatus status;

@property (nonatomic,assign,readonly) NSNumber *taskID;

@property (nonatomic,strong,readonly) id respObject;

@property (nonatomic,strong,readonly) NSError *resError;


+ (instancetype)errorResultWithTaskID:(NSNumber *)taskID request:(NSURLRequest *)request error:(NSError *)error;

+ (instancetype)successResultWithTaskID:(NSNumber *)taskID request:(NSURLRequest *)request responseObject:(id)respObject;

@end
