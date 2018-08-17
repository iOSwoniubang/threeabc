//
//  HXMachinePayViewController.h
//  BaiMi
//
//  Created by licl on 16/7/29.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXPackage.h"
#import "HXMachine.h"

@interface HXMachinePayViewController : UIViewController
@property(strong,nonatomic)UIButton*payBtn;
@property(strong,nonatomic)HXPackage*selectPackage; //选择的套餐
@property(strong,nonatomic)HXMachine*machine; //机器信息
@property(strong,nonatomic)UITableView*tableView;

@end