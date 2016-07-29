//
//  HXViewController_A.m
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/14.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import "HXViewController_home.h"
#import "HXApiManager.h"
#import "HXProcessProtocol.h"

@interface HXViewController_home ()

@property (nonatomic ,strong) id <HXProcessProtocol> processedModel;

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



- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //    requestForUrl
    
    
    HXApiManager *mag = [[HXApiManager alloc] init];
    [mag requestForUrl:@"xxx/api.com" params:nil successBack:^(id obj) {
        
        NSDictionary *reformedData = [mag fetchDataWithProcesedModel:self.processedModel];
        
    } failBack:^(NSError *error) {
        
        
    }];
    
    
    
    
}
@end
