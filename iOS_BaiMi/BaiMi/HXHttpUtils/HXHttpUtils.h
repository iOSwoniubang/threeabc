//
//  HXHttpUtils.h
//  BaiMi
//
//  Created by licl on 16/6/24.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HXHttpUtils : NSObject

//普通post请求
+(void)requestJsonPostWithUrlStr:(NSString*)urlStr params:(NSDictionary*)params onComplete:(void (^)(NSError* error,NSDictionary* resultJson))onComplete;

//表单样式post请求(图文字典参数，其中图片字典的value为二进制data)
+(void)requestJsonFormDataPostWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params ImgDataParams:(NSDictionary *)imgDataParams showHud:(BOOL)showHud onComplete:(void (^)(NSError *, NSDictionary *))onComplete;


//Get请求
+(void)requestJsonGetWithUrlStr:(NSString *)urlStr params:(NSDictionary*)params onComplete:(void (^)(NSError* error,NSDictionary* resultJson))onComplete;


//快递鸟查询(传入参数：ShipperCode:快递公司编码 ，LogisticCode:快递编号)
+(void)requestJsonPostOfKdniaoTrackQueryAPIWithShipperCode:(NSString*)expressCompanyNo LogisticCode:(NSString*)expressNo onComplete:(void (^)(NSString* errorReason,NSDictionary* resultJson))onComplete;

//微支付协议获取激活码(传入参数:来源标识:sign,板卡编号:sn,脉冲次数:currency,调用类型【1-微信端调用，2-APP端调用】:interfacetype,用户姓名:username,性别:sex,电话号码:mobile,出生日期(选填):birthdays,微信端openid(选填):openid,商户订单号(需保持唯一性):partner_trade_no)
+(void)requestJsonPostOfActiveCodeApiwithParams:(NSDictionary*)params onComplete:(void (^)(NSString* errorReason,NSDictionary* resultJson))onComplete;

+(NSString *)whetherNil:(id)str;
@end
