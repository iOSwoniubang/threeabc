//
//  HXNavigationController.m
//  BaiMi
//
//  Created by licl on 16/6/23.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXNavigationController.h"

@implementation HXNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
//      self.navigationController.navigationBar.translucent = NO;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    
    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1) {
        viewController.navigationItem.leftBarButtonItem =[self createBackButton];
    }
    viewController.edgesForExtendedLayout = UIRectEdgeNone;
    //    viewController.navigationController.navigationBar.translucent = NO;
}
-(UIBarButtonItem*) createBackButton{
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 13, 20)];
    UIImage*backImg=[UIImage imageNamed:@"btnBack.png"];
    [b setBackgroundImage:backImg forState:UIControlStateNormal];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:b];
    [b addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
-(void)onBack{
    [super popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
