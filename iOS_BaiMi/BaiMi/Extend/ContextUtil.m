//
//  ContextUtil.m
//  BaiMi
//
//  Created by licl on 16/6/23.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "ContextUtil.h"

@implementation ContextUtil
//手机型号
+ (NSString *)phoneModel{
    return [[UIDevice currentDevice] model];
}

//设备标识号
+(NSString *)identifierForVendor{
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}

//IOS SDK系统版本号
+ (float)systemVersion{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

//此应用的app id，用于检查更新、评分、appstore应用下载等
+ (NSString*)appId{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"appId"];
}
//程序版本号，如2.5.3
+ (NSString *)version{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}
//内部版本号，数字,如23
+ (NSInteger)bundleCode{
    return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] integerValue];
}

////是否在模拟器上运行
//+ (BOOL)isRunInSimulator{
//#ifdef TARGET_IPHONE_SIMULATOR
//    return YES;
//#else
//    return NO;
//#endif
//}


////获取系统摄像头 拍照
+(BOOL)takePhoto:(UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>*)viewController{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] || ![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]){
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不支持相机访问功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    if ([ContextUtil systemVersion]>=7.0) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未授予相机访问权限" message:@"请在\"设置-隐私-相机\"中打开允许访问相机的开关以允许我们访问您的相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    UIImagePickerController* ip = [[UIImagePickerController alloc] init];
    [ip setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [ip setDelegate:viewController];
    [ip setAllowsEditing:NO];
    [ip setSourceType:UIImagePickerControllerSourceTypeCamera];
    [ip setShowsCameraControls:YES];
    [ip setCameraDevice:UIImagePickerControllerCameraDeviceRear];
    [ip setCameraCaptureMode:UIImagePickerControllerCameraCaptureModePhoto];
    
    [viewController presentViewController:ip animated:YES completion:^(){
    }];
    return YES;
}

////获取系统相册选照片
+(BOOL)selectPhoto:(UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>*)viewController{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不支持照片访问功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author ==ALAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未授予照片访问权限" message:@"请在\"设置-隐私-照片\"中打开允许访问照片的开关以允许我们访问您的照片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    UIImagePickerController* ip = [[UIImagePickerController alloc] init];
    [ip setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [ip setDelegate:viewController];
    [ip setAllowsEditing:NO];
    if ([ContextUtil  systemVersion]>=7.0)
        [ip setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    else
        [ip setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    
    [viewController presentViewController:ip animated:YES completion:^(){}];
    return YES;
}

@end
