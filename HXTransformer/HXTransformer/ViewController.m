//
//  ViewController.m
//  HXTransformer
//
//  Created by hanxiaoqing on 16/7/14.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import "ViewController.h"
#import "HXTransformer+HomePage.h"
#import "HXApiManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    HXApiManager *mag = [HXApiManager manager];
    [mag loadGETwithService:GET_TIME_SERVICE params:nil success:^(HXResponsResult *response) {
        // 记录服务器时间 得出时间差
        [HXAppInformation recordServerDiffTime:response.respObject];

    } fail:^(HXResponsResult *response) {
        
        
    }];
    
}

- (IBAction)jumpVc:(id)sender {
    
    HXTransformer *transformer = [HXTransformer shareInstance];
    UIViewController *homePageVc = [transformer giveHomeVc];
    [self presentViewController:homePageVc animated:YES completion:nil];
}



- (IBAction)requestAction:(id)sender {
    HXApiManager *mag = [HXApiManager manager];
    NSDictionary *dic = @{@"app":@"zyx",};
    [mag loadGETwithService:MAIN_PAGE_SERVICE params:dic success:^(HXResponsResult *response) {
        
        
        NSLog(@"%@",response.json_obj);
        
        
    } fail:^(HXResponsResult *response) {
        
    }];
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
