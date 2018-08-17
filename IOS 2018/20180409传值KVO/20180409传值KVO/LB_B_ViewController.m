//
//  LB_B_ViewController.m
//  20180409传值KVO
//
//  Created by baimi on 2018/4/9.
//  Copyright © 2018年 com.www.baimi. All rights reserved.
//

#import "LB_B_ViewController.h"

@interface LB_B_ViewController ()

@end

@implementation LB_B_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 _btf=[[UITextField alloc]initWithFrame:CGRectMake(40, 130, 180, 20)];
    _btf.placeholder=@"请输出传输的内容";
    _btf.layer.backgroundColor=[UIColor redColor].CGColor;
    _btf.layer.borderColor=[UIColor greenColor].CGColor;
    self.title=@"B";
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_btf];
    UIButton *bbtt=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    bbtt.backgroundColor=[UIColor magentaColor];
    bbtt.layer.borderWidth=3;
    [bbtt setTitle:@"给我传" forState:UIControlStateNormal];
    bbtt.frame=CGRectMake(80, 300, 100, 30);
    [bbtt addTarget:self action:@selector(bbutonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bbtt];
    // Do any additional setup after loading the view.
}
-(void)bbutonAction:(UIButton *)sender
{
    self.lbstring=_btf.text;
    [self.navigationController popToRootViewControllerAnimated:YES];
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
