//
//  HXTaskOrder.h
//  BaiMi
//
//  Created by 王放 on 16/7/8.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXTaskOrder : NSObject
@property(strong,nonatomic)NSString*expressNo;//快递单号
@property(strong,nonatomic)NSString*expressCompanyName;//快递公司名称
@property(strong,nonatomic)NSString*orderNo; //订单编号
@property(strong,nonatomic)NSString*deliverCode; //取件码


@property(strong,nonatomic)NSString*publisherPhoneNumber;//发布人手机号码
@property(strong,nonatomic)NSString*publisherNickName;//发布人昵称
@property(strong,nonatomic)NSString*publisherLogo; //发布人头像
@property(strong,nonatomic)NSString*publisherCollegeNo;//发布者学校编号
@property(strong,nonatomic)NSString*publisherHouseNo;//发布者楼栋编号
@property(strong,nonatomic)NSString*publisherPointNo;//发布者所属网点编号
@property(strong,nonatomic)NSString*source; //取件地
@property(strong,nonatomic)NSString*target; //送件地
@property(strong,nonatomic)NSString*position;//具体柜子包裹摆放位置
@property(strong,nonatomic)NSDate*deadLine;//任务截止时间(精确到分)

@property(strong,nonatomic)NSString*remark; //留言
@property(assign,nonatomic)HXWeightType weightType; //重量类型
@property(assign,nonatomic)float fee; //费用
@property(strong,nonatomic)NSString*cancelRemark; //取消原因

@property(assign,nonatomic)int appraiseStatus;//评价状态(1:未评价 2:赞 3:踩)

@property(strong,nonatomic)NSString*fetcherLogo;//接任务人头像
@property(strong,nonatomic)NSString*fetcherPhoneNumber;//接任务人号码
@property(strong,nonatomic)NSString*fetcherNickName; //接任务人昵称

@property(strong,nonatomic)NSDate*createTime; //任务发布时间
@property(strong,nonatomic)NSDate*pickupTime; //取件时间
@property(strong,nonatomic)NSDate*completeTime; //任务完成时间
@property(strong,nonatomic)NSDate*acceptTime;//接单时间
@property(strong,nonatomic)NSDate*arriveTime;//送达时间

@property(strong,nonatomic)NSString*remainingTime;//剩余时间

@property(assign,nonatomic)HXTaskStatus status;//代领任务状态


-(NSString *)remainingTime;
+(UIView *)taskWater:(HXTaskOrder *)order withHigh:(float)waterHigh;
@end
