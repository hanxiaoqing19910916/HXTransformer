//
//  HXViewController_A.m
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/14.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import "HXViewController_home.h"
#import "HXApiManager.h"
#import <objc/runtime.h>

@interface HXViewController_home ()


@end


@implementation HXViewController_home


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 200, 100, 40);
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor purpleColor]];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    



}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

//    unsigned int count = 0;
//    Ivar *ivars = class_copyIvarList(NSClassFromString(@"UINavigationItemButtonView"), &count);
//    for (int index = 0;index < count -1;index ++) {
//        Ivar ivar = ivars[index];
//        NSLog(@"%s" ,ivar_getName(ivar));
//    };
    
     NSLog(@"%@",self.navigationController.navigationItem);
    
    
    
//    for (UIView *childview in self.navigationController.navigationBar.subviews) {
//        if ([childview isKindOfClass:NSClassFromString(@"UINavigationItemButtonView")]) {
//            for (UIView *itemButtonViewChild in childview.subviews) {
//                NSLog(@"%@",[itemButtonViewChild valueForKey:@"font"]);
//            }
//        }
//    }
//    
    
    
}


- (void)back {
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}
@end
