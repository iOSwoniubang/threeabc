//
//  HXSelectCouponViewController.h
//  BaiMi
//
//  Created by licl on 16/7/30.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXCouponModel.h"

@class HXSelectCouponViewController;
@protocol HXSelectCouponDelegate <NSObject>
-(void)selectCouponVC:(HXSelectCouponViewController*)selectVC selectCoupon:(HXCouponModel*)coupon;
@end

@interface HXSelectCouponViewController : UIViewController
@property(assign,nonatomic)id<HXSelectCouponDelegate>delegate;
@property(strong,nonatomic)HXCouponModel*selectCoupon;
@property(assign,nonatomic)HXBusinessType businessType;  //可用的优惠券业务类型，从外部传入
@property(nonatomic,assign)BOOL justForShow; //YES: 只展示，不选择  NO:选择
 @end
