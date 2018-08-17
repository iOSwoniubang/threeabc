//
//  HXExchangeViewController.m
//  BaiMi
//
//  Created by HXMAC on 16/7/15.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXExchangeViewController.h"

@interface HXExchangeViewController ()
{
    UITableView *_myTableView;
}
@end

@implementation HXExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title  = @"兑换记录";
    self.view.backgroundColor = BackGroundColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
