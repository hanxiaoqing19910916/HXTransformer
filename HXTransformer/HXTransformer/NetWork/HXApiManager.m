//
//  HXApiManager.m
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/19.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import "HXApiManager.h"

@interface HXApiManager ()

//@property (nonatomic,strong) id responseObject;

@end


@implementation HXApiManager

+ (instancetype)manager {
     return [[self alloc] init];
}


- (void)loadGETwithService:(NSString *)serviceId params:(NSDictionary *)params success:(loadSuccess)resultSuccess fail:(loadFailer)resultFail{
    
    
    // 判断是否先取缓存数据 根据serviceId，取出缓存数据
    
    // 判断网络状态（增加网络状态回调，方便外界一些需求：(无网络的时候展示提示检查网络页面)）
    
    // 检查参数params 格式（牵扯手机号，邮箱验证等）
    
    // params进行签名，排序加密等。。
    
    
    HXHttpResInterFace *httpResInterFace = [HXHttpResInterFace shareInterface];
    [httpResInterFace httpGETWithURLStr:[[HXUrlService defalutUrlService] urlWithServiceId:serviceId] params:params resultCallBackSuccess:^(HXResponsResult *response) {
        // 请求成功，根据iscache，判断是否缓存数据 （serviceId为key，value为缓存数据）
        
      } resultCallBackFail:^(HXResponsResult *response) {
        // 请求失败
        
        
    }];
    
}








@end
