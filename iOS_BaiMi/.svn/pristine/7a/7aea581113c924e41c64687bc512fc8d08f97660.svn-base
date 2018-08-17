//
//  HXSelectProvinceCityAlert.h
//  BaiMi
//
//  Created by licl on 16/7/29.
//  Copyright © 2016年 licl. All rights reserved.
//
//只选择省市

#import <UIKit/UIKit.h>

#import "HXPlace.h"
@class HXSelectProvinceCityAlert;
@protocol HXSelectProvinceCityDelegate <NSObject>
-(void)alertView:(HXSelectProvinceCityAlert*)alertView selectPlace:(HXPlace*)place;
@end

@interface HXSelectProvinceCityAlert : UIAlertView
@property(strong,nonatomic)HXPlace *place;

@property(assign,nonatomic)id<HXSelectProvinceCityDelegate>Cudelegate;

- (id)initWithPlace:(HXPlace*)place;
@end
