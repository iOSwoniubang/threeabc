//
//  HXMyTaskViewController.h
//  BaiMi
//
//  Created by 王放 on 16/7/12.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>
//列表选项卡对应值不要改动，与订单列表中按钮tag值对应
typedef NS_ENUM(NSInteger, HXSendOrderSegment){
    HXOrderSegmentDoing=1, //进行中
    HXOrderSegmentFinish=2,  //已完成
    HXOrderSegmentEnd=3,   //已终止
};
@interface HXMyTaskViewController : UIViewController
@property(assign,nonatomic)HXSendOrderSegment orderSegment;

@end
