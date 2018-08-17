//
//  HXScanHelper.h
//  BaiMi
//
//  Created by licl on 16/7/7.
//  Copyright © 2016年 licl. All rights reserved.
//原生二维码/条形码扫描

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^HXScanSuccessBlock)(NSString*scanResult);

@interface HXScanHelper : NSObject
@property(strong,nonatomic)UIView*scanView;
@property(strong,nonatomic)HXScanSuccessBlock scanBlock;

+ (instancetype)manager;
-(void)startRunning;
-(void)stopRunning;
-(void)showLayer:(UIView*)superView;
//-(void)setScanningRect:(CGRect)scanRect scanView:(UIView*)scanView;

@end
