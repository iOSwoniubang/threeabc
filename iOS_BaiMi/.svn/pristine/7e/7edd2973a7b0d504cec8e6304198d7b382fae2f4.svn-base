//
//  HXSelectProCityAreaAlert.h
//  BaiMi
//
//  Created by licl on 16/7/19.
//  Copyright © 2016年 licl. All rights reserved.
//
//选择省市区

#import <UIKit/UIKit.h>
#import "HXPlace.h"
@class HXSelectProCityAreaAlert;
@protocol HXSelectProvinceCityAreaDelegate <NSObject>
-(void)alertView:(HXSelectProCityAreaAlert*)alertView selectPlace:(HXPlace*)place;
@end

@interface HXSelectProCityAreaAlert : UIAlertView
@property(strong,nonatomic)HXPlace *place;

@property(assign,nonatomic)id<HXSelectProvinceCityAreaDelegate>Cudelegate;

- (id)initWithPlace:(HXPlace*)place;

@end
