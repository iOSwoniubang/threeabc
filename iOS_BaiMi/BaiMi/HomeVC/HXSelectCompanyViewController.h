//
//  HXSelectCompanyViewController.h
//  BaiMi
//
//  Created by licl on 16/7/11.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXCompany.h"

@class HXSelectCompanyViewController;
@protocol HXSelectCompanyDelegate <NSObject>

-(void)selectCompanyVC:(HXSelectCompanyViewController*)selectVC selectCompany:(HXCompany*)company;

@end

@interface HXSelectCompanyViewController : UIViewController
@property(assign,nonatomic)id<HXSelectCompanyDelegate>delegate;
@property(strong,nonatomic)NSIndexPath*seleIndexPath;
@property(strong,nonatomic)HXCompany*originalCompany;
@end
