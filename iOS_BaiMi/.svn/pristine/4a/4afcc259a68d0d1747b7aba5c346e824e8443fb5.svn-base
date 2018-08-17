//
//  HXPayResultOfTaskViewController.m
//  BaiMi
//
//  Created by licl on 16/8/5.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXPayResultOfTaskViewController.h"
#import "HXMyTaskViewController.h"
#import "HXSGActingViewController.h"

@interface HXPayResultOfTaskViewController ()

@end

@implementation HXPayResultOfTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cteateUI];
    [self resetLiftBarItem];
}


-(void)resetLiftBarItem{
    UIButton *liftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    liftBtn.frame = CGRectMake(0, 0, 13, 20);
    [liftBtn setImage:[UIImage imageNamed:@"btnBack.png"] forState:UIControlStateNormal];
    
    [liftBtn addTarget:self action:@selector(liftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *liftButton = [[UIBarButtonItem alloc] initWithCustomView:liftBtn];
    self.navigationItem.leftBarButtonItem = liftButton;
}
-(void)liftBtnClick{
    if(_paySuccess){
        Class fixClass=nil;
        if (_isMyTaskCome)
            fixClass=[HXMyTaskViewController class];
        else
            fixClass=[HXSGActingViewController class];
        for(UIViewController*vc in self.navigationController.viewControllers){
            if ([vc isKindOfClass:fixClass]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)cteateUI{
    self.view.backgroundColor = BackGroundColor;
    UIView *viewBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    viewBG.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewBG];
    self.title = @"师哥代领";
    UIButton*payResultBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    payResultBtn.backgroundColor=[UIColor whiteColor];
    [payResultBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:payResultBtn];
    if (_paySuccess) {
        [payResultBtn setImage:[UIImage imageNamed:@"ico_succeed.png"] forState:UIControlStateNormal];
        [payResultBtn setTitle:@"恭喜您,发布成功" forState:UIControlStateNormal];
        [payResultBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        
    }else{
        [payResultBtn setImage:[UIImage imageNamed:@"ico_fail.png"] forState:UIControlStateNormal];
        [payResultBtn setTitle:@"发布失败" forState:UIControlStateNormal];
        [payResultBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        UIButton*rePublishBtn=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-(SCREEN_WIDTH*0.8)/2, ViewFrameY_H(payResultBtn)+44, SCREEN_WIDTH*0.8, 40)];
        [rePublishBtn setTitle:@"重新发布" forState:UIControlStateNormal];
        rePublishBtn.titleLabel.font=[UIFont systemFontOfSize:16.f];
        rePublishBtn.backgroundColor=LightBlueColor;
        rePublishBtn.layer.cornerRadius=rePublishBtn.frame.size.height/2;
        [rePublishBtn addTarget:self action:@selector(rePublishBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rePublishBtn];
    };
}



-(void)rePublishBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
