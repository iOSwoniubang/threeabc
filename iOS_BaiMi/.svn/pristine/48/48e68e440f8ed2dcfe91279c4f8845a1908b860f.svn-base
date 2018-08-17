//
//  HXMoreAddressViewController.h
//  BaiMi
//
//  Created by HXMAC on 16/7/7.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXConventionalAddModel.h"

@class HXMoreAddressViewController;
@protocol HXSelectAddressDelegate <NSObject>
-(void)selectAddressVC:(HXMoreAddressViewController*)moreAddressVC selectAddress:(HXConventionalAddModel*)address;
@end

@interface HXMoreAddressViewController : UIViewController
@property(assign,nonatomic)id<HXSelectAddressDelegate>delegate;
@property(assign,nonatomic)BOOL forSelect; //外部文件选择常用地址
@property(strong,nonatomic)NSIndexPath *seleIndexPath;
@property(strong,nonatomic)HXConventionalAddModel*orginalAddress; //寄件带进来的地址
@end
