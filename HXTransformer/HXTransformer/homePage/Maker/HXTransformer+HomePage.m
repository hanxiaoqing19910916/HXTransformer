//
//  HXTransformer+HomePage.m
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/14.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import "HXTransformer+HomePage.h"

@implementation HXTransformer (HomePage)

- (UIViewController *)giveHomeVc {
    
    UIViewController *homeVc = [self performWithMaker:@"HXMaker_home" process_SEL:@"homeVc" withDic:nil];
    return homeVc;
}


@end
