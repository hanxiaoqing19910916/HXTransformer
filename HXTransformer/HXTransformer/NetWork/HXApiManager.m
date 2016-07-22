//
//  HXApiManager.m
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/19.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import "HXApiManager.h"
#import "AFNetworking.h"
//    int (^block)(int a, int b) = ^(int a,int b) {
//        return a + b;
//    };



@interface HXApiManager ()

@property (nonatomic,strong) id responseObject;

@end


@implementation HXApiManager

//successBack:() successBack
- (void)requestForUrl:(NSString *)urlString params:(NSDictionary *)params successBack:(void(^)(id obj))successBack
             failBack:(void (^)(NSError *error))failCallBack
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.responseObject = responseObject;
        successBack(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failCallBack(error);
    }];
}



- (NSDictionary *)fetchDataWithProcesedModel:(id<HXProcessProtocol>)procesedModel {
    
    if (procesedModel == nil) {
        return self.responseObject;
    } else {
        return [procesedModel processModelWithManager:self];
    }
    
}


@end
