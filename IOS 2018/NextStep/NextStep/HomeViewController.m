//
//  HomeViewController.m
//  NextStep
//
//  Created by baimi on 2018/8/15.
//  Copyright © 2018年 liubang. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = CGRectMake(40, 80, 50, 50);
    UIButton * bt = [[UIButton alloc]initWithFrame:rect];
  //  bt.titleLabel.text = @"选择";
    [bt setTitle:@"选择" forState:UIControlStateNormal];
    [bt setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:bt];
    
     
    
    
    
    // Do any additional setup after loading the view.
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
