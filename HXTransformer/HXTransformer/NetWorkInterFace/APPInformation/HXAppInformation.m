//
//  HXAppInformation.m
//  HXTransformer
//
//  Created by hanxiaoqing on 16/8/3.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import "HXAppInformation.h"

@implementation HXAppInformation


+ (instancetype)sharedInstance
{
    static HXAppInformation *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HXAppInformation alloc] init];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    return sharedInstance;
}

- (BOOL)isReachable
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}


+ (void)recordServerDiffTime:(id)resObj {
    NSString *serverTime = [[NSString alloc] initWithData:resObj encoding:NSUTF8StringEncoding];
    NSDate *localDate = [NSDate date]; //获取当前时间
    long localStamp = (long)[localDate timeIntervalSince1970];
    long diff = localStamp - [serverTime integerValue];
    [[NSUserDefaults standardUserDefaults] setFloat:diff forKey:@"time"];
    
}

+ (NSString *)exceptDiffServerTime {
    long diff = [[NSUserDefaults standardUserDefaults] floatForKey:@"time"];
    NSDate *localDate = [NSDate date]; //获取当前时间
    long unixTime = (long)[localDate timeIntervalSince1970];
    long currentStamp = unixTime - diff;
    return [NSString stringWithFormat:@"%ld",currentStamp];
}





@end
