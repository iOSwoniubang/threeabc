//
//  HXSelePointViewController.h
//  BaiMi
//
//  Created by licl on 16/7/16.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "HXPlace.h"

@class HXSelePointViewController;
@protocol HXSelectPointDelegate <NSObject>
-(void)selectVC:(HXSelePointViewController*)selectVC NewPoint:(AMapCloudPOI*)poi pointPlace:(HXPlace*)pointPlace;

@end

@interface HXSelePointViewController : UIViewController
@property(assign,nonatomic)id<HXSelectPointDelegate>delegate;
@property(strong,nonatomic)AMapCloudPOI*poi;
@property(strong,nonatomic)NSMutableArray*nearList;


@end
