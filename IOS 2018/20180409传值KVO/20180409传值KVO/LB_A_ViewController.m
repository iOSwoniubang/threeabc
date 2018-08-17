//
//  LB_A_ViewController.m
//  20180409传值KVO
//
//  Created by baimi on 2018/4/9.
//  Copyright © 2018年 com.www.baimi. All rights reserved.
//

#import "LB_A_ViewController.h"

@interface LB_A_ViewController ()

@end

@implementation LB_A_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor yellowColor];
    _atf=[[UITextField alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 200, 100, 20)];
    _atf.layer.borderWidth=1;
    _atf.borderStyle=UITextBorderStyleNone;
    //_atf.layer.backgroundColor=[UIColor redColor].CGColor;
    [self.view addSubview:_atf];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"传值A" forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.frame=CGRectMake(30, 300, 100, 20);
    button.backgroundColor=[UIColor greenColor];
    [self.view addSubview:button];
    _b=[[LB_B_ViewController alloc]init];
   // [_b addObserver:self forKeyPath:@"lbstring" options:NSKeyValueObservingOptionNew context:nil];
    [_b addObserver:self forKeyPath:@"lbstring" options:NSKeyValueObservingOptionInitial context:nil];
    // Do any additional setup after loading the view.
}
/*-(void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    if ([keyPath isEqualToString:@"string"]) {
        _atf.text=_b.lbstring;
    }

}*/
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"lbstring"]) {
        _atf.text=_b.lbstring;
    }



}

-(void)dealloc
{
    [_b removeObserver:self forKeyPath:@"lbstring"];
   

}
-(void)buttonAction:(UIButton *)sender
{
    
    [self.navigationController pushViewController:_b animated:YES];

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
