//
//  HXHttpResInterFace.m
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/22.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import "HXResponsResult.h"
#import "HXHttpResInterFace.h"
#import "AFNetworking.h"

static NSTimeInterval kCTNetworkingTimeoutSeconds = 20.0f;

@interface HXHttpResInterFace ()

@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic,strong) AFHTTPRequestSerializer *httpRequestSerializer;

@property (nonatomic,strong) NSMutableDictionary *taskRecordDic;


@end



@implementation HXHttpResInterFace

+ (instancetype)shareInterface {
    static HXHttpResInterFace *shareInterface = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInterface = [[self alloc] init];
    });
    return shareInterface;
}


- (NSMutableDictionary *)taskRecordDic
{
    if (_taskRecordDic == nil) {
        _taskRecordDic = [[NSMutableDictionary alloc] init];
    }
    return _taskRecordDic;
}


- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _sessionManager;
}

- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = kCTNetworkingTimeoutSeconds;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}


- (NSUInteger)httpGETWithServiceId:(NSString *)serviceId method:(NSString *)method params:(NSDictionary *)params resultCallBackSuccess:(resultSuccess)resultSuccess resultCallBackFail:(resultFail)resultFail {
    
    NSString *baseUrl = @"http://baidu.com";
    NSString *apiVersion =  @"1.0";
    NSString *_method = method;
    NSString *urlString;
    if (apiVersion.length) {
        urlString = [NSString stringWithFormat:@"%@/%@/%@",baseUrl,apiVersion,_method];
    } else {
        urlString = [NSString stringWithFormat:@"%@/%@",baseUrl,_method];
    }
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:params error:NULL];
    return [self httpRequestWith:request Success:resultSuccess Fail:resultFail];
}

- (NSUInteger)httpPOSTWithServiceId:(NSString *)serviceId method:(NSString *)method params:(NSDictionary *)params resultCallBackSuccess:(resultSuccess)resultSuccess resultCallBackFail:(resultFail)resultFail {

    NSString *baseUrl = @"http://baidu.com";
    NSString *apiVersion =  @"1.0";
    NSString *_method = method;
    NSString *urlString;
    if (apiVersion.length) {
        urlString = [NSString stringWithFormat:@"%@/%@/%@",baseUrl,apiVersion,_method];
    } else {
        urlString = [NSString stringWithFormat:@"%@/%@",baseUrl,_method];
    }
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:params error:NULL];
    
#warning - HTTPBody是否有必要赋值有待于考证。
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params options:0 error:NULL];
    
#warning - NSMutableURLRequest分类增加 requestParams属性有什么作用有待于考证
 // request.requestParams = requestParams;
    
  return [self httpRequestWith:request Success:resultSuccess Fail:resultFail];

}


- (NSUInteger)httpRequestWith:(NSURLRequest *)request Success:(resultSuccess)resultSuccess Fail:(resultFail)resultFail {
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                            
        NSNumber *taskID = @(dataTask.taskIdentifier);
        [self.taskRecordDic removeObjectForKey:taskID];
        
        if (error) {
            HXResponsResult *errorResult = [HXResponsResult resultWithTaskID:taskID responseObject:responseObject request:request error:error];
            resultFail? resultFail(errorResult) : nil;
        } else {
            HXResponsResult *sResult = [HXResponsResult resultWithTaskID:taskID responseObject:responseObject request:request status:HXResponsStatusSuccess];
            resultFail? resultFail(sResult) : nil;
        }
    }];
    
    [self.taskRecordDic setObject:dataTask forKey:@(dataTask.taskIdentifier)];
    [dataTask resume];
    return dataTask.taskIdentifier;
}





- (void)cancelRequestWithRequestID:(NSNumber *)requestID {
    NSURLSessionDataTask *task = self.taskRecordDic[requestID];
    [task cancel];
    [self.taskRecordDic removeObjectForKey:requestID];
    
}

- (void)cancelRequestsWithIDs:(NSArray *)IDs {
    for (NSNumber *taskId in IDs) {
        [self cancelRequestWithRequestID:taskId];
    }
    
}


@end
