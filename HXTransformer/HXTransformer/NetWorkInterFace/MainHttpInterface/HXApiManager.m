//
//  HXApiManager.m
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/19.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import "HXApiManager.h"
#import "YYCache.h"


#define HXCallAPI(REQUEST_METHOD)                                                                \
{                                                                                                \
   [[HXHttpResInterFace shareInterface] http##REQUEST_METHOD##WithURLStr:url params:processedDic \
        resultCallBackSuccess:^(HXResponsResult *response) {                                     \
        [self successedOnCallingAPI:response key:cacheKey];                                 \
     } resultCallBackFail:^(HXResponsResult *response) {                                         \
        [self failedOnCallingAPI:response];                                    \
    }];                                                                                          \
}


@interface HXApiManager ()

@property (nonatomic,copy) loadSuccess success;
@property (nonatomic,copy) loadFailer fail;

@property (nonatomic,strong) YYCache *responseCache;


@end


@implementation HXApiManager



+ (instancetype)manager {
     return [[self alloc] init];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachePath = [paths objectAtIndex:0];
        self.responseCache = [[YYCache alloc] initWithPath:cachePath];
    }
    return self;
}

- (YYCache *)currentUsedCache
{
    if (self.responseCache) return self.responseCache;
    return nil;
}

- (void)loadGETwithService:(NSString *)serviceId params:(NSDictionary *)params success:(loadSuccess)resultSuccess fail:(loadFailer)resultFail {
    
    self.success = resultSuccess;
    self.fail = resultFail;
    
    NSString *url = self.urlStirng;
    
    // 缓存处理 以及网络判断
    NSString *cacheKey = [HXParamsSignature generateOnlyKeyOfUrl:url param:params];
    // 缓存处理 以及网络判断
    if ([self beginRequestWithKey:cacheKey]) {
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
    
    NSString *url = self.urlStirng;
    
    // 缓存处理 以及网络判断
    NSString *cacheKey = [HXParamsSignature generateOnlyKeyOfUrl:url param:params];
    
    if ([self beginRequestWithKey:cacheKey]) {
        return;
    }
    // 检查参数params 格式（牵扯手机号，邮箱验证等） 签名，排序加密等处理
    NSDictionary *processedDic = [self processedParams:params];
    
    // 开始正式的网络请求
    HXCallAPI(POST);
    
}

- (NSDictionary *)processedParams:(NSDictionary *)orignParams {
    if (!orignParams) return nil;
    return [HXParamsSignature  hx_signedParams:orignParams withKey:[ZYXSDK getInstance].configure.appkey];
}



- (BOOL)beginRequestWithKey:(NSString *)key  {
    
    // 判断网络状态
    if (![self isNetWorkAvailable]) {
        
        //（可增加网络状态回调，方便外界一些需求：(例如无网络的时候展示提示检查网络页面)）
        // ...........
        
        
        //网络不好的情况下 判断是否先取缓存数据 根据serviceId，取出缓存数据
        if (self.usingCache) {
            HXResponsResult *response = [[HXResponsResult alloc] init];
            NSDictionary *resDic = [self cachedResultForKey:key];
            if (!resDic) { // 没有可用的缓存数据
//                [MBProgressHUD showError:@"没有可用数据!请检查网络!"];
                response.status = HXResponsStatusErrorNoNetwork;
                self.fail ? self.fail(response) : nil;
                return YES;
            }
//            [MBProgressHUD showError:@"网络异常,请检查网络!"];
            response.status = HXResponsStatusDiskCacheData;
            response.cacheResponesDic = resDic;
            self.success ? self.success(response) : nil;
            return YES;
        }
    }
    return NO;
}



- (void)successedOnCallingAPI:(HXResponsResult *)response key:(NSString *)key {
    
    if (self.usingCache) {
        [self cacheResult:response.json_obj forKey:key];
    }
    self.success ? self.success(response) : nil;
}


- (void)failedOnCallingAPI:(HXResponsResult *)response {
    
    self.fail ? self.fail(response) : nil;
}



- (BOOL)isNetWorkAvailable {
    return [[HXAppInformation sharedInstance] isReachable];
}





/* *本地缓存请求数据 */
- (NSDictionary *)cachedResultForKey:(NSString *)key
{
    return (NSDictionary *)[self.responseCache objectForKey:key];
}

- (void)cacheResult:(NSDictionary *)result forKey:(NSString *)key
{
    [self.responseCache setObject:result forKey:key];
}




@end
