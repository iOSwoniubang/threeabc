//
//  HXPayResultOfFastPayViewController.h
//  BaiMi
//
//  Created by licl on 16/7/25.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXPackage.h"

@interface HXPayResultOfFastPayViewController : UIViewController
@property(assign,nonatomic)BOOL paySuccess;
@property(strong,nonatomic)HXPackage*selectPackage;
@property(strong,nonatomic)NSString*activeCode;
@end
