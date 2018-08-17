//
//  HXSelectAdditionServiceAlert.h
//  BaiMi
//
//  Created by licl on 16/7/20.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXAdditonServiceDao.h"

@class HXSelectAdditionServiceAlert;
@protocol HXSelectAdditionServiceDelegate <NSObject>
-(void)alertView:(HXSelectAdditionServiceAlert*)alertView addition:(HXAdditonService*)addition;
@end

@interface HXSelectAdditionServiceAlert : UIAlertView
@property(assign,nonatomic)id<HXSelectAdditionServiceDelegate>CusDelegate;

- (id)initWithSelectAddition:(HXAdditonService*)addition;

@end
