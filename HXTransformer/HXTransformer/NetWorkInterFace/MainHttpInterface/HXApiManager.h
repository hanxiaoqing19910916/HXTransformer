//
//  HXApiManager.h
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/19.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXResponsResult.h"
#import "HXHttpResInterFace.h"
#import "HXAppInformation.h"
#import "HXParamsSignature.h"
#import "YYCache.h"

/**
 网络优化：
 1.客户端直接走IP请求，绕过DNS服务的耗时，缺点：抛开域名，很多加速做不了，cookie也没法用
 dns解析可以忽略的，尽量不用。做IP请求没法用cdn，也不能做负载均衡，得不偿失  另外，一些接口还需要auth认证之类的，用IP是做不到的。
 2.本地有一份IP列表，这些IP是所有提供API的服务器的IP，每次应用启动的时候，针对这个列表里的所有IP取ping延时时间，然后取延时时间最小的那个IP作为今后发起请求的IP地址 缺点：轮询查一遍ip，也是耗时的
 具体实现：
 应用启动的时候获得本地列表中所有IP的ping值，然后通过NSURLProtocol的手段将URL中的HOST修改为我们找到的最快的IP。另外，这个本地IP列表也会需要通过一个API来维护，一般是每天第一次启动的时候读一次API，然后更新到本地。
 
 App内置了一组Server IP列表，同时每个IP具备权重。每次建立新连接，会选择权重最高的IP地址进行连接。App启动时，IP列表的所有权重是相同的，此时会启动一组Ping的操作，根据Ping值的延迟时间来计算IP的权重，这么做的原理是Ping值越小的IP地址，连接后的网络传输延迟也应该相对更小。业界也有使用HTTP DNS方式来解决DNS劫持问题，同时返回最合适用户网络的Server IP。然而HTTP DNS的开发和部署需要不小的开发成本，我们目前没有使用。
 
 内置Server IP列表也会被更新，每次App启动后会有个Mobile Config服务（支持TCP和HTTP两种网络类型服务）更新Server IP列表，同时支持不同产品线的Server IP列表更新。因此，传统DNS解析能够解决多IDC导流的功能也可以通过此方法解决。
 
 
 可能存在的问题：
 每次打开应用的时候轮询，这样只能请求一台服务器 这对于小应用可以，复杂应用可能是需要负载均衡。
 */

typedef void(^loadSuccess)(HXResponsResult *response);
typedef void(^loadFailer)(HXResponsResult *response);


@interface HXApiManager : NSObject

+ (instancetype)manager;

@property (nonatomic,copy) NSString *urlStirng;

@property (nonatomic,assign,readonly) BOOL isNetWorkAvailable;

@property (nonatomic,assign) BOOL usingCache;
@property (nonatomic,strong,readonly) YYCache *currentUsedCache;


- (void)loadGETwithService:(NSString *)serviceId params:(NSDictionary *)params success:(loadSuccess)resultSuccess fail:(loadFailer)resultFail;

- (void)loadPOSTwithService:(NSString *)serviceId params:(NSDictionary *)params success:(loadSuccess)resultSuccess fail:(loadFailer)resultFail;


@end
