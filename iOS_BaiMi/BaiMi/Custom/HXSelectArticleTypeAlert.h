//
//  HXSelectArticleTypeAlert.h
//  BaiMi
//
//  Created by licl on 16/7/19.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXArticleTypeDao.h"

@class HXSelectArticleTypeAlert;
@protocol HXSelectArticleTypeDelegate <NSObject>
-(void)alertView:(HXSelectArticleTypeAlert*)alertView selectArticleType:(HXArticleType*)articleType;
@end

@interface HXSelectArticleTypeAlert : UIAlertView
@property(assign,nonatomic)id<HXSelectArticleTypeDelegate>Cudelegate;
- (id)initWithFrame:(CGRect)frame;
@end
