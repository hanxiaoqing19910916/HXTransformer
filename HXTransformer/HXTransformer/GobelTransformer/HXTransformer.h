//
//  HXTransformer.h
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/14.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXTransformer : NSObject

+ (instancetype)shareInstance;

- (id)performWithMaker:(NSString *)targetStr process_SEL:(NSString *)process_SEL_Str withDic:(NSDictionary *)infoDic;


@end
