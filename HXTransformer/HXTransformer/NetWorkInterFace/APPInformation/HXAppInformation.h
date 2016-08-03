//
//  HXAppInformation.h
//  HXTransformer
//
//  Created by hanxiaoqing on 16/8/3.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HXAppInformation : NSObject

/**
 *  实例化app信息单例对象 （开启了afn 的网络状态监听）
 */
+ (instancetype)sharedInstance;

/**
 *  网络是否可连接
 */
- (BOOL)isReachable;
/**
 *  记录服务器本地时间差
 */
+ (void)recordServerDiffTime:(id)resObj;

/** 
 * 返回去除时间差的时间戳
 */
+ (NSString *)exceptDiffServerTime;

@end
