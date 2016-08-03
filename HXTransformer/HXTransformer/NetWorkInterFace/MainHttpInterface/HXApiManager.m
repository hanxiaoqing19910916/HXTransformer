//
//  HXApiManager.m
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/19.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import "HXApiManager.h"


#define HXCallAPI(REQUEST_METHOD)                                                                \
{                                                                                                \
    NSString *url = [[HXUrlService defalutUrlService] urlWithServiceId:serviceId];               \
   [[HXHttpResInterFace shareInterface] http##REQUEST_METHOD##WithURLStr:url params:processedDic \
        resultCallBackSuccess:^(HXResponsResult *response) {                                     \
        [self successedOnCallingAPI:response service:serviceId];                                 \
     } resultCallBackFail:^(HXResponsResult *response) {                                         \
        [self failedOnCallingAPI:response service:serviceId];                                    \
    }];                                                                                          \
}


@interface HXApiManager ()

@property (nonatomic,copy) loadSuccess success;
@property (nonatomic,copy) loadFailer fail;

@end


@implementation HXApiManager

+ (instancetype)manager {
     return [[self alloc] init];
}


- (void)loadGETwithService:(NSString *)serviceId params:(NSDictionary *)params success:(loadSuccess)resultSuccess fail:(loadFailer)resultFail {
    
    self.success = resultSuccess;
    self.fail = resultFail;
    
    // 缓存处理 以及网络判断
    if ([self beginRequestWithService:serviceId]) {
        return;
    }
    // 检查参数params 格式（牵扯手机号，邮箱验证等） 签名，排序加密等处理
    NSDictionary *processedDic = [self processedParams:params];
    
    // 开始正式的网络请求
    HXCallAPI(GET);
    
}

- (void)loadPOSTwithService:(NSString *)serviceId params:(NSDictionary *)params success:(loadSuccess)resultSuccess fail:(loadFailer)resultFail {
    
    self.success = resultSuccess;
    self.fail = resultFail;
    
    // 缓存处理 以及网络判断
    if ([self beginRequestWithService:serviceId]) {
        return;
    }
    // 检查参数params 格式（牵扯手机号，邮箱验证等） 签名，排序加密等处理
    NSDictionary *processedDic = [self processedParams:params];

    // 开始正式的网络请求
    HXCallAPI(POST);
    
}

- (NSDictionary *)processedParams:(NSDictionary *)orignParams {
    
    return [HXParamsSignature hx_signedParams:orignParams withKey:@"grl3afaf8aflf21034e1efeio"];
}



- (BOOL)beginRequestWithService:(NSString *)serviceId {

    // 判断网络状态
    if (![self isNetWorkAvailable]) {
        
        //（可增加网络状态回调，方便外界一些需求：(例如无网络的时候展示提示检查网络页面)）
        // ...........
        
        
        //网络不好的情况下 判断是否先取缓存数据 根据serviceId，取出缓存数据
        if (self.isNativecache) {
            HXResponsResult *response = [self responesForService:serviceId];
            response.status = HXResponsStatusDiskCacheData;
            self.success ? self.success(response) : nil;
            return YES;
        }
        
        HXResponsResult *response = [[HXResponsResult alloc] init];
        response.status = HXResponsStatusErrorNoNetwork;
        self.fail ? self.fail(response) : nil;
        return YES;
    }
    return NO;
}



- (void)successedOnCallingAPI:(HXResponsResult *)response service:(NSString *)serviceId {
    
    if (self.isNativecache) {
        [self cacheRespones:response forService:serviceId];
    }
    self.success ? self.success(response) : nil;
}

- (void)failedOnCallingAPI:(HXResponsResult *)response service:(NSString *)serviceId {
    
    self.fail ? self.fail(response) : nil;
}



- (BOOL)isNetWorkAvailable {
    return [[HXAppInformation sharedInstance] isReachable];
}





/* *本地缓存请求数据 */
- (HXResponsResult *)responesForService:(NSString *)serviceId
{
    return nil;
}

- (void)cacheRespones:(HXResponsResult *)response forService:(NSString *)serviceId
{
    
}



- (void)dealloc {
    
    
}


@end
