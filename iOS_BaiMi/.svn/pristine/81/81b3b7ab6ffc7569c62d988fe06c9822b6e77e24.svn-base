//
//  HXError.h
//  BaiMi
//
//  Created by licl on 16/6/23.
//  Copyright © 2016年 licl. All rights reserved.
//
#import "NSUserDefaultsUtil.h"

#ifndef HXError_h
#define HXError_h

#define HXSTRErrorUnkonwReal           @"功能升级中"
#define HXSTRErrorUnkonwDev            @"未知错误"

#pragma mark - ERROR Type

CG_INLINE NSString* HXCodeString(NSInteger code){
    NSString *str = nil;
        NSArray *array = nil;
        switch (code) {
           //系统返回网络请求错误码
            case 1:     array = @[@"网络连接失败,请检查您的网络"]; break;
            case 2:     array= @[@"网络连接超时,请稍后再试"]; break;
           //服务器返回错误码
            case 10000: array=@[@"成功"];break;
            case 10001: array=@[@"无效的信息"];break;
            case 10002:array=@[@"任务已失效"];break;
            case 10003:array=@[@"无效的验证码"];break;
            case 10004:array=@[@"无效的优惠券"];break;
            case 10005:array=@[@"无效的支付编码"];break;
            case 10006:array=@[@"无效的支付信息"];break;
            case 10007:array=@[@"任务当前不可评价"];break;
            case 10008:array=@[@"无效的账户信息"];break;
            case 10009:array=@[@"无效的订单"];break;
            case 10010:array=@[@"账户余额不足"];break;
            case 10011:array=@[@"账户积分不足"];break;
            case 10100: array=@[@"操作失败"];break;
            case 10200: array=@[@"错误的请求"];break;
            case 10300: array=@[@"系统错误"];break;
            case 10301: array=@[@"未知错误"];break;
            case 10400: array=@[@"签名验证失败"];break;
            case 10500: array=@[@"无效参数"];break;
            case 10600: array=@[@"无效的时间戳"];break;
            case 10700: array=@[@"无效的令牌"];break;
            case 10701:array=@[@"令牌已失效"];break;
            case 10800:array=@[@"用户已认证"];break;
            case 10900:array=@[@"验证码发送失败"];break;
            case 10901:array=@[@"无效的地址信息"];break;
            case 11005:array=@[@"无可用费用信息"];break;
            case 11007:array=@[@"无效的设备信息"];break;
            default:    array = @[HXSTRErrorUnkonwDev,HXSTRErrorUnkonwReal]; break;
        }
        if (array == nil)
            array = @[HXSTRErrorUnkonwDev,HXSTRErrorUnkonwReal];
        if([NSUserDefaultsUtil isDevMode])
            str = [array firstObject];
        else
            str = [array lastObject];
    return str;
}



#endif /* HXError_h */
