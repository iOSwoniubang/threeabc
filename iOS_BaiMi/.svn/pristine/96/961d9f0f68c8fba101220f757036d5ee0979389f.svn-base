//
//  HXExpress.h
//  BaiMi
//
//  Created by licl on 16/7/11.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXAdditonService.h"
#import "HXPlace.h"
#import "HXArticleType.h"
#import "HXCouponModel.h"
@interface HXExpress : NSObject

@property(strong,nonatomic)NSString*orderId;//订单编号 唯一标识符

@property(strong,nonatomic)NSString *expressNo;//快递单号
@property(strong,nonatomic)NSString *companyNo;//快递公司编号
@property(strong,nonatomic)NSString *companyName;//快递公司名称
@property(strong,nonatomic)NSString *companyLogoUrl;//快递公司头像

@property(strong,nonatomic)NSDate *searchTime;//搜索时间(快递查询时)
@property(strong,nonatomic)NSDate *modifyTime;

@property(assign,nonatomic)HXReceiveOrderStatus status; //收件单状态
@property(assign,nonatomic)HXReceiveOrderSharedStatus shareStatus;//收件单分享状态

@property(strong,nonatomic)NSString *pointName;//网点名称
@property(strong,nonatomic)NSString *pointNo;//网点编号
@property(strong,nonatomic)NSString *location;//取件地址

@property(strong,nonatomic)NSString *ownerId; //用户id（用户手机号，操作数据库时）

@property(assign,nonatomic)BOOL expand;//（一键查询行展合时）
@property(assign,nonatomic)HXReciveOrderPaymentType paymentType;//取件列表中 未收件中单子的付款状态（已付款的可以查看取件码，未付款的到付）
@property(strong,nonatomic)NSMutableArray*traceArray; //物流信息

//寄快递
@property(strong,nonatomic)NSDate *createTime;//创建时间
@property(strong,nonatomic)HXPlace*recivePlace; //收件地址

@property(assign,nonatomic)HXSendOrderStatus sendStatus; //寄件单状态;
@property(strong,nonatomic)HXPlace*shipperPlace; //寄件地址

@property(strong,nonatomic)NSString*shipperNickName;//寄件人昵称
@property(strong,nonatomic)NSString*shipperPhone;//寄件人手机号码
@property(strong,nonatomic)NSString*recipientName;//收件人姓名
@property(strong,nonatomic)NSString*recipientPhone;//收件人手机号
@property(assign,nonatomic)float weight;//重量
@property(assign,nonatomic)float fee;//运费
@property(assign,nonatomic)float insurance;//保价

@property(assign,nonatomic)BOOL isIndoor;//是否上门
@property(strong,nonatomic)NSString*serviceTimeStr;  //上门服务时间（为时间段，@"9:00-12:00",@"13:00-17:00",@"17:30-19:30"）
@property(strong,nonatomic)NSString*remark;//寄件时备注信息

@property(strong,nonatomic)HXAdditonService*addition;//增值服务
@property(strong,nonatomic)HXArticleType*articleType;//寄件物品类型
@property(strong,nonatomic)HXCouponModel*coupon;//优惠券（寄件时）
@property(assign,nonatomic)BOOL isDeliveryPay;//是否到付

@property(strong,nonatomic)NSString*deliverCode;//取件码
@end
