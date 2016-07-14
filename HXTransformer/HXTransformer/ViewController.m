//
//  ViewController.m
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/14.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import "ViewController.h"
#import "HXTransformer+HomePage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    HXTransformer *transformer = [HXTransformer shareInstance];
    UIViewController *homePageVc = [transformer giveHomeVc];
    [self presentViewController:homePageVc animated:YES completion:nil];

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
