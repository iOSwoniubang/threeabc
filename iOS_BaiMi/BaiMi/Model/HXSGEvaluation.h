//
//  HXSGEvaluation.h
//  BaiMi
//
//  Created by 王放 on 16/7/22.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <Foundation/Foundation.h>
//师哥评价
@interface HXSGEvaluation : NSObject
@property(strong,nonatomic)NSString*appraiserLogo;//评价人头像
@property(strong,nonatomic)NSString*appraiserNickName;//昵称
@property(strong,nonatomic)NSDate*acceptTime;//任务时间
@property(assign,nonatomic)int appraiseStatus;//评价状态2赞3踩
@end
