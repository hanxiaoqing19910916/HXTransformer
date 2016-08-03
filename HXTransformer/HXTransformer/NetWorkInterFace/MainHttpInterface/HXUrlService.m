//
//  HXUrlService.m
//  HXTransformer
//
//  Created by hanxiaoqing on 16/8/1.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import "HXUrlService.h"


NSString *const GET_TIME_SERVICE  = @"api/player/getTime";
NSString *const MAIN_PAGE_SERVICE = @"api/article/getProjectList";


@implementation HXUrlService

+ (instancetype)defalutUrlService {
    static HXUrlService *defalutUrlService;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defalutUrlService = [[self alloc] init];
    });
    return defalutUrlService;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _baseUrl = [self generatorBaseUrl];
    }
    return self;
}


- (NSString *)generatorBaseUrl {
    NSString *url;
#ifdef DEBUG
    url = @"http://192.168.1.173:1004";
#else
    url = @"http://app.zuiyouxi.com"
#endif
    return url;
}


- (NSString *)urlWithServiceId:(NSString *)serviceId {
    return [NSString stringWithFormat:@"%@/%@",self.baseUrl,serviceId];
}

@end
