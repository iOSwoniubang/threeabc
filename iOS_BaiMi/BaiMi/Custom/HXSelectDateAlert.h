//
//  HXSelectDateAlert.h
//  walrusWuLiuCP
//
//  Created by 海象 on 15/9/28.
//  Copyright (c) 2015年 海象. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HXSelectDateAlert;
@protocol HXSelectDateAlertDelegate <NSObject>
-(void)selectDateStr:(NSString*)dateStr Date:(NSDate*)seldate;
@end
@interface HXSelectDateAlert : UIAlertView
@property(assign,nonatomic)id<HXSelectDateAlertDelegate>Cudelegate;
//@property(strong,nonatomic)NSString*dateStr;
//@property(strong,nonatomic)NSDate*seldate;
@property(strong,nonatomic)UIControl *bgView;
@property(strong,nonatomic)UIDatePicker *datePicker;

- (id)initWithFrame:(CGRect)frame selectDateStr:(NSString*)dateStr;
@end
