//
//  HXProcessProtocol.h
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/19.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HXApiManager;

@protocol HXProcessProtocol <NSObject>

- (NSDictionary *)processModelWithManager:(HXApiManager *)manager;

@end