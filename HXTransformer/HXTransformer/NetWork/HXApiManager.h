//
//  HXApiManager.h
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/19.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXProcessProtocol.h"
@interface HXApiManager : NSObject


- (void)requestForUrl:(NSString *)urlString params:(NSDictionary *)params successBack:(void(^)(id obj))successBack
             failBack:(void (^)(NSError *error))failCallBack;

- (NSDictionary *)fetchDataWithProcesedModel:(id<HXProcessProtocol>)procesedModel;

@end
