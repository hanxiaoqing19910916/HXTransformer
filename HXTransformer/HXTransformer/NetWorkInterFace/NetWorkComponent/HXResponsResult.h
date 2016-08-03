//
//  HXResponsResult.h
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/25.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,HXResponsStatus) {
    HXResponsStatusSuccess, //成功收到服务器响应
    HXResponsStatusTimeout, //超时
    HXResponsStatusErrorNoNetwork, // 默认除了超时以外的错误都是无网络错误。
    HXResponsStatusDiskCacheData // 成功返回的是本地磁盘的数据
};

@interface HXResponsResult : NSObject

/** 请求回调结果状态 */
@property (nonatomic,assign) HXResponsStatus status;

/** 请求回调结果对应的任务id */
@property (nonatomic,assign,readonly) NSNumber *taskID;

/** 返回的结果（afn请求返回值id类型） */
@property (nonatomic,strong,readonly) id respObject;

/** 进行json解析后的结果 */
@property (nonatomic,strong,readonly) id json_obj;

/** 错误 */
@property (nonatomic,strong,readonly) NSError *resError;

/**
 *  根据请求底层网络回调相关信息，实例化相应结果对象
 *
 *  @param taskID     对应请求的NSURLSessionDataTask对象的taskID
 *  @param request    request对象
 *  @param respObject 成功请求返回的数据
 *  @param error      失败请求返回的错误
 *
 *  @return 请求失败对应生成的的HXResponsResult对象
 */
+ (instancetype)errorResultWithTaskID:(NSNumber *)taskID request:(NSURLRequest *)request error:(NSError *)error;

+ (instancetype)successResultWithTaskID:(NSNumber *)taskID request:(NSURLRequest *)request responseObject:(id)respObject;

@end
