//
//  NSUserDefaultsUtil.h
//  BaiMi
//
//  Created by licl on 16/6/23.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXLoginUser.h"
#import "HXUserLocation.h"

@interface NSUserDefaultsUtil : NSObject
//// 开发模式
+ (BOOL)isDevMode;
+ (void)setDevMode:(BOOL)devMode;

//判断是不是第一次在当前版本运行。
+ (BOOL)isFirstRunInThisVersion;
+(void)setFirstRunBundleVersion;

//// 服务器配置
//+ (NSString *)urlWebServer;
//+ (void)setUrlWebServer:(NSString *)url;

// 个推clientId
+ (NSString *)geTuiClientId;
+ (void)setGeTuiClientId:(NSString *)geTuiClientId;

//当前用户信息
+(void)setLoginUser:(HXLoginUser*)user;
+(HXLoginUser*)getLoginUser;
+(void)removeUser;

//记录登录用户的手机号码，用于下次登录时的默认填写值
+(void)setLastUserPhone:(NSString*)userPhone;
+(NSString*)getLastUserPhone;

////用户当前位置
+(void)setUserLocation:(HXUserLocation*)userLocation;
+(HXUserLocation*)getUserLocation;

//是否有广告条
+(BOOL)isHasBannerList;
+(void)setBannerListState:(BOOL)state;

////短信验证码时获取的token值
//+(void)setToken:(NSString *)token;
//+(NSString *)getToken;

////webView cookie 值
//+ (void)setCookie:(NSDictionary *)cookieDict;
//+(NSDictionary *)getCookie;
//+(void)removeCookie;
//兑吧免登接口的保存
+ (void)setDuiBaUrl:(NSString *)url andTime:(NSString *)timeString;
+ (NSDictionary *)getDuiBaSave;
+ (void)removeDuiBaUrl;
@end
