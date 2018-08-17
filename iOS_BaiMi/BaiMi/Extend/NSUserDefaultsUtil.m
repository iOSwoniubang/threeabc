//
//  NSUserDefaultsUtil.m
//  BaiMi
//
//  Created by licl on 16/6/23.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "NSUserDefaultsUtil.h"
#import "ContextUtil.h"
#import "HXMacroKeys.h"

static NSString* KEY_DEV_MODE           = @"key.is.dev.mode";
static NSString* KEY_BUNDLE_CODE_IN_USER_DEFAULTS = @"key.bundle.code.in.user.defaults";
static NSString* KEY_URL_WebServer      = @"key.url.web.server";
static NSString* KEY_GETUI_CLIENTID     = @"key.getui.clientId";
static NSString* KEY_LOGIN_USER         = @"key.login.user";
static NSString* KEY_LOGIN_USER_PHONE   = @"key.login.user.phone";
static NSString* KEY_USER_LOCATION      = @"key.user.location";
static NSString* KEY_HAS_BANNERList      = @"key.has.bannerList";
static NSString* KEY_GET_TOKEN    = @"key.get.token";

@implementation NSUserDefaultsUtil
////是否是测试模式
+(BOOL)isDevMode{
    return [[NSUserDefaults standardUserDefaults] boolForKey:KEY_DEV_MODE];
}
+(void)setDevMode:(BOOL)devMode{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:devMode forKey:KEY_DEV_MODE];
    [ud synchronize];
}


//是否是第一次登录
+(BOOL)isFirstRunInThisVersion{
    NSInteger buildCodeInUserDefaults = [[NSUserDefaults standardUserDefaults] integerForKey:KEY_BUNDLE_CODE_IN_USER_DEFAULTS];
    if(buildCodeInUserDefaults == [ContextUtil bundleCode]){
        return NO;
    }
    return YES;
}

+(void)setFirstRunBundleVersion{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:[ContextUtil bundleCode] forKey:KEY_BUNDLE_CODE_IN_USER_DEFAULTS];
    [ud synchronize];
}

////服务器地址
//+ (NSString *)urlWebServer{
//    NSString* url = nil;
//    if([self isDevMode])
//        url = [[NSUserDefaults standardUserDefaults] stringForKey:KEY_URL_WebServer];
//    if(!url)
//        url = HXURLWebServer;
//    return url;
//}
//+ (void)setUrlWebServer:(NSString *)url{
//    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
//    [ud setObject:url forKey:KEY_URL_WebServer];
//    [ud synchronize];
//}

//个推clientId
+(NSString *)geTuiClientId{
    NSString* b = [[NSUserDefaults standardUserDefaults] stringForKey:KEY_GETUI_CLIENTID];
    if(!b)
        b = @"";
    return b;
}
+(void)setGeTuiClientId:(NSString *)geTuiClientId{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:geTuiClientId forKey:KEY_GETUI_CLIENTID];
    [ud synchronize];
}

//当前用户信息
+(void)setLoginUser:(HXLoginUser*)user{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary*dict=[HXLoginUser dicOfLoginUser:user];
    [ud setObject:dict forKey:KEY_LOGIN_USER];
    [ud synchronize];
}
+(HXLoginUser*)getLoginUser{
    NSDictionary*dict=[[NSUserDefaults standardUserDefaults] dictionaryForKey:KEY_LOGIN_USER];
    if (dict) {
        HXLoginUser*user=[HXLoginUser getUserByDic:dict];
        return user;
    }
    return nil;
}
+(void)removeUser{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KEY_LOGIN_USER];
}


//记录登录用户的手机号码，用于下次登录时的默认填写值
+(void)setLastUserPhone:(NSString*)userPhone{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:userPhone forKey:KEY_LOGIN_USER_PHONE];
    [ud synchronize];
}

+(NSString*)getLastUserPhone{
    NSString* phone = [[NSUserDefaults standardUserDefaults] stringForKey:KEY_LOGIN_USER_PHONE];
    if(!phone)
        phone = @"";
    return phone;
}

//用户当前位置
+(void)setUserLocation:(HXUserLocation*)userLocation{
 NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary*dict=[HXUserLocation dicOfLUserLocation:userLocation];
    [ud setObject:dict  forKey:KEY_USER_LOCATION];
    [ud synchronize];
}
+(HXUserLocation*)getUserLocation{
    NSDictionary*dict=[[NSUserDefaults standardUserDefaults] dictionaryForKey:KEY_USER_LOCATION];
    if (dict) {
        HXUserLocation*userLocation=[HXUserLocation getUserLocationByDic:dict];
        return userLocation;
    }
    return nil;
}


//是否有广告条
+(BOOL)isHasBannerList{
    return [[NSUserDefaults standardUserDefaults] boolForKey:KEY_HAS_BANNERList];
}
+(void)setBannerListState:(BOOL)state{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:state forKey:KEY_HAS_BANNERList];
    [ud synchronize];
}


//webView cookie 值
//+ (void)setCookie:(NSDictionary *)cookieDict{
//    NSUserDefaults *hander = [NSUserDefaults standardUserDefaults];
//    [hander setObject:cookieDict forKey:@"cookie"];
//    [hander synchronize];
//}
//+(NSDictionary *)getCookie{
//    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"cookie"];
//    if (dict) {
//        return dict;
//    }
//    return nil;
//}
//+(void)removeCookie{
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cookie"];
//}

//+(void)setToken:(NSString *)token{
//    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
//    [ud setObject:token forKey:KEY_GET_TOKEN];
//    [ud synchronize];
//
//}
//+(NSString *)getToken{
//    NSString *token=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_GET_TOKEN];
//    if (token)
//        return token;
//    return nil;
//}
+ (void)setDuiBaUrl:(NSString *)url andTime:(NSString *)timeString{
    NSUserDefaults *hander = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:url,@"urlString",timeString,@"timeString", nil];
    [hander setObject:dict forKey:@"DUI_BA_URL"];
    [hander synchronize];
}
+ (NSDictionary *)getDuiBaSave{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"DUI_BA_URL"];
    if (dict) {
        return dict;
    }
    return nil;
}
+ (void)removeDuiBaUrl{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DUI_BA_URL"];
}

@end
