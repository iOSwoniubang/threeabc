//
//  HXNSStringUtil.h
//  BaiMi
//
//  Created by licl on 16/6/23.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXNSStringUtil : NSObject

//获取skey
+(NSString*)getSkeyByParamInfo:(NSArray*)paramArray;

#pragma mark--正则
//座机号
+(BOOL)isZPhoneNumber:(NSString*)telephoneNum;
//手机号
+(BOOL)isMobilePhoneNumber:(NSString*)phoneNum;

//密码（6-16位 的 字母字符数字三种元素组成格式无先后，字母不分大小写）
+(BOOL)isPassword:(NSString*)password;

//身份证
+(BOOL)isIdCardNumber:(NSString*)idCardNum;

//银行卡
+(BOOL)isBankCardNumber:(NSString*)bankCarNum;


//json-->jsonStr (obj 数组或字典对象)
+(NSString*)getJsonStringFromDicOrArray:(id)obj;
//jsonStr-->json
+(id)getJsonArrayOrJsonDicFormJsonStr:(NSString*)jsonStr;

////在混合文本字符串中将emoji code码转为表情
//+(NSString*)getEmojiStringByReplaceEmojiCodeFromText:(NSString*)showStr;
@end
