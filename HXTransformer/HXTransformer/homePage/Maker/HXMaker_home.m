//
//  HXViewControllerMaker.m
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/14.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import "HXMaker_home.h"

@implementation HXMaker_home

- (UIViewController *)homeVc {
    UIViewController *vc_A = [[HXViewController_home alloc] init];
    return vc_A;
}


- (void)no_return_func {
    NSLog(@"执行了一个没有返回值的方法");
}
@end
