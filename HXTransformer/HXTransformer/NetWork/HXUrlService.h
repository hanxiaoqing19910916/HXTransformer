//
//  HXUrlService.h
//  HXTransformer
//
//  Created by hanxiaoqing on 16/8/1.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const GET_TIME_SERVICE;
extern NSString *const MAIN_PAGE_SERVICE;


@interface HXUrlService : NSObject

@property (nonatomic,copy) NSString *baseUrl;

/**
@property (nonatomic,copy) NSString *apiVerson;
@property (nonatomic,copy) NSString *method;
 */

+ (instancetype)defalutUrlService;

- (NSString *)urlWithServiceId:(NSString *)serviceId;


@end
