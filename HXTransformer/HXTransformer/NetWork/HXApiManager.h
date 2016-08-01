//
//  HXApiManager.h
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/19.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXResponsResult.h"
#import "HXUrlService.h"
#import "HXHttpResInterFace.h"

//#import "HXProcessProtocol.h"


typedef NS_ENUM(NSInteger,ApiMethod) {
    ApiMethodGET,
    ApiMethodPOST
};

typedef void(^loadSuccess)(HXResponsResult *response);
typedef void(^loadFailer)(HXResponsResult *response);


@interface HXApiManager : NSObject

+ (instancetype)manager;


@property (nonatomic,assign) BOOL isMemorycache;

@property (nonatomic,assign) BOOL isNativecache;


- (void)loadGETwithService:(NSString *)serviceId params:(NSDictionary *)params success:(loadSuccess)resultSuccess fail:(loadFailer)resultFail;

//- (void)loadPOST


@end
