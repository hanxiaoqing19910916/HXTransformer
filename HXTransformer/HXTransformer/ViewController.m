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
#import "UsefulDefines.h"
#import "BTDeviceInfo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HXApiManager *mag = [HXApiManager manager];
    [mag loadGETwithService:GET_TIME_SERVICE params:nil success:^(HXResponsResult *response) {
        // 记录服务器时间 得出时间差
        [HXAppInformation recordServerDiffTime:response.respObject];
    } fail:^(HXResponsResult *response) {
    }];
    
    
    
  BTDeviceInfo *dinfo = [BTDeviceInfo currentDevInfo];
    
    NSLog(@"%@----%@----%@----%@----%@----%@",dinfo.Model,dinfo.Resolution,dinfo.OS,dinfo.NetMode,dinfo.Operator,dinfo.ipAddress);
    
    
}

- (IBAction)jumpVc:(id)sender {
    HXTransformer *transformer = [HXTransformer shareInstance];
    UIViewController *homePageVc = [transformer giveHomeVc];
    [transformer test_no_return_func];
    [self.navigationController pushViewController:homePageVc animated:YES];
}



- (IBAction)requestAction:(id)sender {
    HXApiManager *mag = [HXApiManager manager];
    NSDictionary *dic = @{@"app":@"zyx"};
    [mag loadGETwithService:MAIN_PAGE_SERVICE params:dic success:^(HXResponsResult *response) {
        NSLog(@"%@",response.json_obj);
    } fail:^(HXResponsResult *response) {
        
    }];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    

    
}


@end
