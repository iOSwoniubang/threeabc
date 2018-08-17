//
//  HXScanViewController.m
//  BaiMi
//
//  Created by licl on 16/7/7.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXScanViewController.h"
#import "HXScanHelper.h"

@interface HXScanViewController ()<UIAlertViewDelegate>
@end

@implementation HXScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"扫描二维码/条形码";
    
    if (!TARGET_IPHONE_SIMULATOR) {
        BOOL cameraPermission=[self isGetCameraPermission];
        if(!cameraPermission){
//            UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"未授予相机访问权限" message:@"请在\"设置-隐私-相机\"中打开允许访问相机的开关以允许我们访问您的相机" preferredStyle:UIAlertControllerStyleAlert];
//            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                [self.navigationController popViewControllerAnimated:YES];
//            }]];
//            [self presentViewController:alert animated:YES completion:nil];
            UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"未授予相机访问权限" message:@"请在\"设置-隐私-相机\"中打开允许访问相机的开关以允许我们访问您的相机" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [alert show];
            return;
        }
        
        HXScanHelper*manager=[HXScanHelper manager];
        [manager showLayer:self.view];
        [manager startRunning];
        [manager setScanBlock:^(NSString*scanResult){
            NSLog(@"%@",scanResult);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scanResult" object:scanResult];
            if ([_delegate respondsToSelector:@selector(scanResultStr:)]){
                [_delegate scanResultStr:scanResult];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}


- (BOOL)isGetCameraPermission{
    BOOL isCameraValid = YES;
    //ios7之前系统默认拥有权限
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied){
            isCameraValid = NO;
        }
    }
    return isCameraValid;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1)
        [self.navigationController popViewControllerAnimated:YES];
    return;
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
