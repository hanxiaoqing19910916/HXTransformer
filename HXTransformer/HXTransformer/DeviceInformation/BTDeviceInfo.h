//
//  BTDeviceInfo.h
//  BTAnalytics
//
//  Created by hanxiaoqing on 16/4/12.
//  Copyright © 2016年 Babeltime. All rights reserved.

#import <Foundation/Foundation.h>

/***   导入 CoreTelephony.framework SystemConfiguration.framework  Security.framework */

@interface BTDeviceInfo : NSObject

/** 设备机型 */
@property (copy, nonatomic,readonly) NSString *Model;

/** 设备分辨率 */
@property (copy, nonatomic,readonly) NSString *Resolution;

/** 操作系统 */
@property (copy, nonatomic,readonly) NSString *OS;

/** 联网方式 */
@property (copy, nonatomic,readonly) NSString *NetMode;

/** 网络运营商 */
@property (copy, nonatomic,readonly) NSString *Operator;

/** ipd地址 */
@property (copy, nonatomic,readonly) NSString *ipAddress;


/** 是否越狱
@property (assign, nonatomic) BOOL isJailbroken;
 */


/*** --begin 接入方调用请求事件接口时候实时的获取信息   ***/

/**
 *  实时获取的设备信息
 *  @return 赋值后的对象
 */
+ (instancetype)currentDevInfo;

/**
 *  获取设备实时网络状态
 *  @return yes 有网 no 无网络
 */
+ (BOOL)isNetWorkEnable;

/** 获取Uuid */
+ (NSString *)getDeviceUuid;

/** 实时获取时间戳  */
+ (NSString *)logCreateUnixTime;


/*** --end    **/

@end
