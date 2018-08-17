//
//  HXScanViewController.h
//  BaiMi
//
//  Created by licl on 16/7/7.
//  Copyright © 2016年 licl. All rights reserved.
//
//二维码/条码扫描
#import <UIKit/UIKit.h>

@class HXScanDelegate;
@protocol HXScanDelegate <NSObject>
-(void)scanResultStr:(NSString*)scanResult;
@end

@interface HXScanViewController : UIViewController
@property(assign,nonatomic)id<HXScanDelegate>delegate;
@end
