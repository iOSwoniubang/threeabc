//
//  HXParcelCodeViewController.m
//  BaiMi
//
//  Created by licl on 16/7/7.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXParcelCodeViewController.h"
#import "UIImage+Resize.h"

@interface HXParcelCodeViewController ()

@end

@implementation HXParcelCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=@"取件码";
    self.view.backgroundColor=BackGroundColor;
    UIView*bgView=[[UIView alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20,270)];
    bgView.backgroundColor=[UIColor whiteColor];
    bgView.layer.cornerRadius=8.f;
    bgView.layer.borderColor=BolderColor.CGColor;
    bgView.layer.borderWidth=1.f;
    
    [self.view addSubview:bgView];
    
    UIImageView*barCodeImgView=[[UIImageView alloc] initWithFrame:CGRectMake(bgView.frame.size.width/2-150/2, 20, 150, 50)];
    [bgView addSubview:barCodeImgView];
    UILabel*codeLab=[[UILabel alloc] initWithFrame:CGRectMake(bgView.frame.size.width/2-200/2, ViewFrameY_H(barCodeImgView), 200, 20)];
    codeLab.textAlignment=NSTextAlignmentCenter;
    codeLab.text=[NSString stringWithFormat:@"[%@]",_code];
    [bgView addSubview:codeLab];
    
    UIImageView*qrCodeImgView=[[UIImageView alloc] initWithFrame:CGRectMake(bgView.frame.size.width/2-100/2, ViewFrameY_H(codeLab)+20,100 , 100)];
    [bgView addSubview:qrCodeImgView];
    
    
    
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(0, ViewFrameY_H(qrCodeImgView)+15, bgView.frame.size.width, 21)];
    label.text=@"使用扫一扫,快速轻松取。更多方便,更多安全。";
    label.textColor=LightBlueColor;
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:13.f];
    [bgView addSubview:label];
    
   
    UIImage*barImg=[UIImage generateBarCode:_code width:barCodeImgView.frame.size.width height:barCodeImgView.frame.size.height];
    barCodeImgView.image=barImg;
    
    UIImage*qrImg=[UIImage generateQRCode:_code width:qrCodeImgView.frame.size.width height:qrCodeImgView.frame.size.height];
    qrCodeImgView.image=qrImg;
    
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
