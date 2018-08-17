//
//  HXTaskDetailViewController.h
//  BaiMi
//
//  Created by 王放 on 16/7/8.
//  Copyright © 2016年 licl. All rights reserved.
//
typedef NS_ENUM(NSInteger,HXTaskButtonType){
    HXTaskButtonTypePay =1, //确认支付
    HXTaskButtonTypeCancel=2,//取消任务
    HXTaskButtonTypeArrive=3, //确认到达
    HXTaskButtonTypeAccept=4, //接受任务
};
#import <UIKit/UIKit.h>
#import "HXTaskOrder.h"
@interface HXTaskDetailViewController : UIViewController
@property(strong,nonatomic)HXTaskOrder *order;
@property(assign,nonatomic)BOOL isHelpView;//是否是帮助页面

@end
