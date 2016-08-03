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

/**
 * 关于https请求 AFSecurityPolicy三种验证模式：
 
 AFSSLPinningModeNone
 
 这个模式表示不做SSL pinning，只跟浏览器一样在系统的信任机构列表里验证服务端返回的证书。若证书是信任机构签发的就会通过，若是自己服务器生成的证书，这里是不会通过的。
 
 AFSSLPinningModeCertificate
 
 这个模式表示用证书绑定方式验证证书，需要客户端保存有服务端的证书拷贝，这里验证分两步，第一步验证证书的域名/有效期等信息，第二步是对比服务端返回的证书跟客户端返回的是否一致。
 
 这里还没弄明白第一步的验证是怎么进行的，代码上跟去系统信任机构列表里验证一样调用了SecTrustEvaluate，只是这里的列表换成了客户端保存的那些证书列表。若要验证这个，是否应该把服务端证书的颁发机构根证书也放到客户端里？
 
 AFSSLPinningModePublicKey
 
 这个模式同样是用证书绑定方式验证，客户端要有服务端的证书拷贝，只是验证时只验证证书里的公钥，不验证证书的有效期等信息。只要公钥是正确的，就能保证通信不会被窃听，因为中间人没有私钥，无法解开通过公钥加密的数据。
 
 整个AFSecurityPolicy就是实现这这几种验证方式，剩下的就是实现细节了，详见源码。
 原文链接：http://www.jianshu.com/p/5a1b3596f3f7

 */

- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        _sessionManager.securityPolicy
    }
    return _sessionManager;
}

- (AFHTTPRequestSerializer *)httpRequestSerializer {
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = kCTNetworkingTimeoutSeconds;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}


- (NSUInteger)httpGETWithURLStr:(NSString *)URLStr params:(NSDictionary *)params resultCallBackSuccess:(resultSuccess)resultSuccess resultCallBackFail:(resultFail)resultFail {
    
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:URLStr parameters:params error:NULL];
    return [self httpRequestWith:request Success:resultSuccess Fail:resultFail];
}

- (NSUInteger)httpPOSTWithURLStr:(NSString *)URLStr params:(NSDictionary *)params resultCallBackSuccess:(resultSuccess)resultSuccess resultCallBackFail:(resultFail)resultFail {
    
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:URLStr parameters:params error:NULL];
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
            HXResponsResult *errorResult = [HXResponsResult errorResultWithTaskID:taskID
                                                                          request:request
                                                                            error:error];
            resultFail? resultFail(errorResult) : nil;
        } else {
            HXResponsResult *sResult = [HXResponsResult successResultWithTaskID:taskID
                                                                        request:request
                                                                 responseObject:responseObject];
            resultSuccess? resultSuccess(sResult) : nil;
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
