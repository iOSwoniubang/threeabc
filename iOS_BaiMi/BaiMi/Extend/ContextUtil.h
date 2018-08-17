//
//  ContextUtil.h
//  BaiMi
//
//  Created by licl on 16/6/23.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>

@interface ContextUtil : NSObject
//手机型号
+ (NSString *)phoneModel;
+(NSString *)identifierForVendor;

//IOS SDK系统版本号
+ (float)systemVersion;

//此应用的app id，用于检查更新、评分等
+ (NSString*)appId;
//程序版本号，如2.5.3
+ (NSString *)version;
//内部版本号，数字,如23
+ (NSInteger)bundleCode;

//是否在模拟器上运行
+ (BOOL)isRunInSimulator;


//获取系统摄像头拍照
+(BOOL)takePhoto:(UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>*)viewController;

//获取系统相册选照片
+(BOOL)selectPhoto:(UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>*)viewController;

//保存图片到本地
//+(void)savePhoto:(UIImage *)image;
@end
