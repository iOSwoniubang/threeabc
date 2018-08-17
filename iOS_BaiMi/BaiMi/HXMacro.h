//
//  HXMacro.h
//  BaiMi
//
//  Created by licl on 16/6/23.
//  Copyright © 2016年 licl. All rights reserved.
//

#ifndef HXMacro_h
#define HXMacro_h

#pragma mark--- HXNotification 消息通知

#define HXNTFNetWorkBannerRefresh  @"HXNTFNetWorkBannerRefresh" //有网络了并且上次广告条是拉取失败的广告条更新
#define HXNTFHouseTaskRefresh  @"HXNTFHouseTaskRefresh" //本楼代领任务数
#define HXNTFSystemParamsHttpRefresh @"HXNTFSystemParamsHttpRefresh" //获取后台系统配置参数接口更新（获取寄件物品类型、附加增值服务）
#define HXNTFDoingSendOrderListRefresh  @"HXNTFDoingSendOrderListRefresh"  //进行中寄件列表刷新，用于寄件单创建成功后寄件单列表显示新增订单。
#define HXNTFReceiveOrderSharedRefresh @"HXNTFReceiveOrderSharedRefresh" //未收件分享给好友（qq、微信、短信）

#pragma mark--推送消息通知
//#define HXNTFPayResultNotice  @"HXNTFPayResultNotice" //付款结果推送通知
#define HXNTFTaskAcceptedNotice @"HXNTFTaskAcceptedNotice" //取件任务通知（广场取件任务被接后发送的通知）
#define HXNTFNewRecieveOrderNotice @"HXNTFNewRecieveOrderNotice"//包裹通知（包裹上架/入柜发送的通知，新增包裹）
#pragma mark-----HXEnums 枚举

//苹果设备高度
typedef NS_ENUM(NSInteger, AppleType){
    iPhone4=480,
    iPhone5=568,
    iPhone6=667,
    iPhone6Plus=736,
    iPad=1024,
};

// 操作系统
typedef NS_ENUM(NSInteger, HXOsType){
    HXOsTypeAndroid=1,
    HXOsTypeIos=2,
};

//取件单状态
typedef NS_ENUM(NSInteger, HXReceiveOrderStatus){
    HXReceiveOrderKeyIn=1, //已录入(未入柜)
    HXReceiveOrderInCupboard=2, //已入柜(未取件)
    HXReceiveOrderOnShelf=3, //已上架(未取件)
    HXReceiveOrderTake=6,//已取
    HXReceiveOrderTimeOut=7,//已超时（已入超时区）
    HXReceiveOrderReturn=8,//已退回（物流公司已取回）
    HXReceiveOrderInvalid=9,//已作废(异常件作废)
};

CG_INLINE NSString* HXReceiveOrderStateStr(HXReceiveOrderStatus i){
    NSString* str = nil;
    switch (i) {
        case HXReceiveOrderInCupboard:
        case HXReceiveOrderOnShelf:str=@"待领取";break;
        case HXReceiveOrderTake: str=@"已领取";break;
        case HXReceiveOrderTimeOut: str=@"已超时（已入超时区）";break;
        case HXReceiveOrderReturn: str=@"已退回（物流公司已取回）";break;
        case HXReceiveOrderInvalid: str=@"已作废(异常件作废)";break;
        default:str=@"";break;
    }
    return str;
};

//取件单分享状态
typedef NS_ENUM(NSInteger, HXReceiveOrderSharedStatus){
    HXReceiveOrderUnShared=0, //未分享
    HXReceiveOrderShared=1, //已分享给好友
    HXReceiveOrderInTaskSquare=2, //已发布至任务广场
   };

CG_INLINE NSString* HXReceiveOrderSharedStateStr(HXReceiveOrderSharedStatus i){
    NSString* str = nil;
    switch (i) {
        case HXReceiveOrderShared: str=@"待领取 已分享";break;
        case HXReceiveOrderInTaskSquare: str=@"待领取 已发布至任务广场";break;
        default:str=@"";break;
    }
    return str;
};


//取件单未收件付款状态
typedef NS_ENUM(NSInteger, HXReciveOrderPaymentType){
    HXPaymentTypePayed=1, //已付款
    HXPaymentTypeUnpayed=2,//未付款（到付）
};


//寄件单状态
typedef NS_ENUM(NSInteger, HXSendOrderStatus){
    HXSendOrderKeyIn=1, //已录入(未付款)
    HXSendOrderPayed=2, //已付款(已通知快递公司揽件)
    HXSendOrderDispatched=3, //已发货
    HXSendOrderReturn=4, //已退回
    HXSendOrderInvalid=9,//已作废
};

CG_INLINE NSString* HXSendOrderStateStr(HXSendOrderStatus i){
    NSString* str = nil;
    switch (i) {
        case HXSendOrderKeyIn:str=@"未付款";break;
        case HXSendOrderPayed:str=@"已通知快递公司揽件";break;
        case HXSendOrderDispatched: str=@"已发货";break;
        case HXSendOrderReturn: str=@"已退回";break;
        case HXSendOrderInvalid: str=@"已取消";break;
        default:str=@"";break;
    }
    return str;
};

//实名认证状态
typedef NS_ENUM(NSInteger,HXVerifyStatus){
    HXVerifyStatusSuccessed=1,//认证成功
    HXVerifyStatusFailed =2, //认证失败
    HXVerifyStatusUncommit=5, //未提交认证
    HXVerifyStatusCommited=4, //认证已提交
};


CG_INLINE NSString* HXVerifyStr(HXVerifyStatus i){
    NSString* str = nil;
    switch (i) {
        case HXVerifyStatusSuccessed: str=@"已认证";break;
        case HXVerifyStatusFailed: str=@"认证失败";break;
        case HXVerifyStatusUncommit: str=@"未提交";break;
        case HXVerifyStatusCommited: str=@"审核中";break;
        default:str=@"";break;
    }
    return str;
};

//代领件重量类型
typedef NS_ENUM(NSInteger,HXWeightType){
    HXWeightTypeBelow2kg =1, //2kg以下
    HXWeightType2To5kg=2,//2-5kg
    HXWeightType5To10kg=3, //5-10kg
    HXWeightType10To20kg=4, //10-20kg
    HXWeightTypeAbove20kg=5, //20kg以上
};

CG_INLINE NSString* HXWeightTypeStr(HXWeightType i){
    NSString* str = nil;
    switch (i) {
        case HXWeightTypeBelow2kg: str=@"2kg以下";break;
        case HXWeightType2To5kg: str=@"2-5kg";break;
        case HXWeightType5To10kg: str=@"5-10kg";break;
        case HXWeightType10To20kg: str=@"10-20kg";break;
        case HXWeightTypeAbove20kg:str=@"20kg以上";break;
        default:str=@"";break;
    }
    return str;
};


//抵用券业务类型
typedef NS_ENUM(NSInteger,HXBusinessType){
    HXBusinessTypeSendParcel=1,//寄件优惠券
    HXBusinessTypeWashClothes=2,//洗衣优惠券
    HXBusinessTypeRepairComputer=3,//修电脑优惠券
    HXBusinessTypeOrderDish=4,//订餐优惠券
};



//优惠券类型
typedef NS_ENUM(NSInteger,HXCouponType){
   HXCouponTypeCash=1,//现金抵用券
   HXCouponTypeDiscount=2//折扣券
};


CG_INLINE NSString* HXCouponTypeStr(HXCouponType i){
    NSString* str = nil;
    switch (i) {
        case HXCouponTypeCash: str=@"现金抵用券";break;
        case HXCouponTypeDiscount: str=@"折扣券";break;
        default:str=@"";break;
    }
    return str;
};


//账单业务类型
typedef NS_ENUM(NSInteger,HXBillType){
    HXBillTypeTopUp =1, //充值
    HXBillTypePublishTask=2,//发布任务
    HXBillTypeAcceptTask=3, //接任务
    HXBillTypeGetParcel=4, //取快递
    HXBillTypeSendParcel=5, //寄快递
    HXBillTypeWashClothes=6, //洗衣
    HXBillTypeRepairComputer=7, //修电脑
    HXBillTypeOrderDish=8,//订餐
};

CG_INLINE NSString* HXBillTypeStr(HXBillType i){
    NSString* str = nil;
    switch (i) {
        case HXBillTypeTopUp: str=@"充值";break;
        case HXBillTypePublishTask: str=@"发布任务";break;
        case HXBillTypeAcceptTask: str=@"接任务";break;
        case HXBillTypeGetParcel: str=@"取快递";break;
        case HXBillTypeSendParcel:str=@"寄快递";break;
        case HXBillTypeWashClothes: str=@"洗衣";break;
        case HXBillTypeRepairComputer:str=@"修电脑";break;
        case HXBillTypeOrderDish:str=@"订餐";break;
        default:str=@"";break;
    }
    return str;
};


//(任务广场订单流程)代领任务状态
typedef NS_ENUM(NSInteger,HXTaskStatus){
    HXTaskStatusCreate =1, //已生成
    HXTaskStatusPublish=2,//已付款(已发布)
    HXTaskStatusAccept=3, //已接单
    HXTaskStatusPickup=4, //已代领
    HXTaskStatusComplete=5, //已送达(接任务人操作)
    HXTaskStatusGetGoods=6, //已确认送达(已付款)
    HXTaskStatusCancel=7, //已取消
};


CG_INLINE NSString* HXTaskStateStr(HXTaskStatus i){
    NSString* str = nil;
    switch (i) {
        case HXTaskStatusCreate: str=@"已生成";break;
        case HXTaskStatusPublish: str=@"已付款(已发布)";break;
        case HXTaskStatusAccept: str=@"已接单";break;
        case HXTaskStatusPickup: str=@"已代领";break;
        case HXTaskStatusComplete:str=@"已送达(接任务人操作)";break;
        case HXTaskStatusGetGoods: str=@"已确认送达(已付款)";break;
        case HXTaskStatusCancel:str=@"已取消";break;
        default:str=@"";break;
    }
    return str;
};



//协议类型
typedef NS_ENUM(NSInteger, HXAgreementType){
    HXAgreementTypeIntroduction=1, //功能介绍
    HXAgreementTypePrivacy=2, //隐私说明
    HXAgreementTypeService=3,   //服务协议
};




#pragma mark--alipayErrorInfo

typedef NS_ENUM(NSInteger,AlipayStatus){
    AlipayStatusSuccess =9000, //订单支付成功 sdk调用成功
    AlipayStatusDealing=8000,//正在处理中
    AlipayStatusFail=4000, //订单支付失败
    AlipayStatusCancel=6001, //用户中途取消
    AlipayStatusURLError=6002,//网络连接出错
};

CG_INLINE NSString* AlipayMemo(AlipayStatus i){
    NSString* str = nil;
    switch (i) {
        case AlipayStatusSuccess: str=@"订单支付成功";break;
        case AlipayStatusDealing: str=@"正在处理中";break;
        case AlipayStatusFail: str=@"订单支付失败";break;
        case AlipayStatusCancel: str=@"用户中途取消";break;
        case AlipayStatusURLError:str=@"网络连接出错";break;
        default:str=@"未知错误";break;
    }
    return str;
};


#endif /* HXMacro_h */
