//
//  HXSelectServiceTimeAlert.h
//  BaiMi
//
//  Created by licl on 16/7/20.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSelectServiceTimeAlert;
@protocol HXSelectServiceTimeDelegate <NSObject>
-(void)alertView:(HXSelectServiceTimeAlert*)alertView selectServiceTime:(NSString*)serviceTime;
@end

@interface HXSelectServiceTimeAlert : UIAlertView
@property(assign,nonatomic)id<HXSelectServiceTimeDelegate>CusDelegate;

- (id)initWithSelectServiceTimeStr:(NSString*)serviceTimeStr;
@end
