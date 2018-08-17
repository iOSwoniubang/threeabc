//
//  HXPayResultOfFastPayViewController.m
//  BaiMi
//
//  Created by licl on 16/7/25.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXPayResultOfFastPayViewController.h"
#import "HXFastPayViewController.h"

@interface HXPayResultOfFastPayViewController ()

@end

@implementation HXPayResultOfFastPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"支付结果";
    self.view.backgroundColor=BackGroundColor;
    [self resetBackBtn];
    [self createUI];
}


-(void)resetBackBtn{
        UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 13, 20)];
        UIImage*backImg=[UIImage imageNamed:@"btnBack.png"];
        [b setBackgroundImage:backImg forState:UIControlStateNormal];
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:b];
    [b addTarget:self action:@selector(reScanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem=btn;
}




-(void)createUI{
    UIButton*payResultBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    payResultBtn.backgroundColor=[UIColor whiteColor];
    [payResultBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:payResultBtn];
    
    if (_paySuccess) {
        [payResultBtn setImage:[UIImage imageNamed:@"ico_succeed.png"] forState:UIControlStateNormal];
        [payResultBtn setTitle:@"恭喜您,支付成功" forState:UIControlStateNormal];
        [payResultBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        
        UIView*infoView=[[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 81)];
        infoView.backgroundColor=[UIColor whiteColor];
        UIImageView*dotLineImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        dotLineImgView.image=[UIImage imageNamed:@"dottedLine.png"];
        [infoView addSubview:dotLineImgView];
        UILabel*infoLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 13, SCREEN_WIDTH-20, 21)];
        infoLab.text=[NSString stringWithFormat:@"商品信息:%@",_selectPackage.name];
        infoLab.font=[UIFont systemFontOfSize:15.f];
        [infoView addSubview:infoLab];
        UILabel*activePreLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 46, 100, 21)];
        activePreLab.text=@"您的激活码是:";
        activePreLab.font=[UIFont systemFontOfSize:15.f];
        [infoView addSubview:activePreLab];
        UILabel*activeLab=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-140, 40, 140, 30)];
        activeLab.layer.cornerRadius=activeLab.frame.size.height/2;
        activeLab.layer.borderColor=LightBlueColor.CGColor;
        activeLab.layer.borderWidth=1;
        activeLab.textColor=LightBlueColor;
        activeLab.text=_activeCode;
        activeLab.textAlignment=NSTextAlignmentCenter;
        [infoView addSubview:activeLab];
        [self.view addSubview:infoView];
        
    }else{
        [payResultBtn setImage:[UIImage imageNamed:@"ico_fail.png"] forState:UIControlStateNormal];
        [payResultBtn setTitle:@"支付失败" forState:UIControlStateNormal];
        [payResultBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        UIButton*reScanBtn=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-(SCREEN_WIDTH*0.8)/2, ViewFrameY_H(payResultBtn)+44, SCREEN_WIDTH*0.8, 40)];
        [reScanBtn setTitle:@"重新扫码" forState:UIControlStateNormal];
        reScanBtn.titleLabel.font=[UIFont systemFontOfSize:16.f];
        reScanBtn.backgroundColor=LightBlueColor;
        reScanBtn.layer.cornerRadius=reScanBtn.frame.size.height/2;
        [reScanBtn addTarget:self action:@selector(reScanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:reScanBtn];
    };
    
}

-(void)reScanBtnClicked:(id)sender{
  //重新扫码
    NSArray*vcArray=self.navigationController.viewControllers;
    for(UIViewController*vc in vcArray){
        if ([vc isKindOfClass:[HXFastPayViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
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
