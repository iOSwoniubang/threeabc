//
//  HXLoginUser.h
//  BaiMi
//
//  Created by licl on 16/6/23.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXLoginUser : NSObject

@property(strong, nonatomic)NSString *phoneNumber;//手机号码
@property(strong,nonatomic)NSString*securityCode;//securityCode 登录时的短信验证码
@property(strong,nonatomic)NSString*token;//token

@property(strong, nonatomic)NSString *nickName;//用户昵称
@property(strong, nonatomic)NSString *logoUrl;//头像地址

//@property(strong, nonatomic)NSDate *lastLoginTime; //上次登录时间  7天未登录转为手动登录,改为服务器限制

@property(strong,nonatomic)NSString *collegeNo; //学校编号
@property(strong,nonatomic)NSString *collegeName; //学校名称
@property(strong,nonatomic)NSString *adress; //详细地址
@property(strong,nonatomic)NSString *pointNo; //网点编号
@property(strong,nonatomic)NSString *pointName;//网点名称
@property(strong,nonatomic)NSString*pointAddressJsonStr;//网点地址信息(网点所在省市区详细地址)

@property(strong,nonatomic)NSString *dormitoryHouseNo;//寝室楼栋编号
@property(strong,nonatomic)NSString *dormitoryDes; //楼栋名称
@property(strong,nonatomic)NSString *dormitoryNo;//寝室号
@property(nonatomic,strong)NSString *areaNo;//区域编号
@property (nonatomic,strong)NSString *areaName;//区域名称
@property(assign,nonatomic)float balance; //账户余额
@property(assign,nonatomic)long long praiseCount; //赞总数
@property(assign,nonatomic)long long despiseCount;  //踩总数
@property(assign,nonatomic)HXVerifyStatus verifyStatus; //实名认证状态
@property (assign,nonatomic)HXVerifyStatus studentVerificationStatus;//学生认证状态
@property(strong,nonatomic)NSString *inviteCode;//邀请码
@property(strong,nonatomic)NSString *refererCode;//邀请人邀请码

@property(strong,nonatomic)NSString *realName;//真实姓名
@property(strong,nonatomic)NSString *idCardNo;//身份证
@property(strong,nonatomic)NSString *studentId;//学生证

@property(strong,nonatomic)NSString*idCardUrl;//身份证照片url
@property(assign,nonatomic)long long integral; //积分
@property(assign,nonatomic)float frozenAmount; //冻结金额

@property(strong,nonatomic)NSString*defaultAddressJsonStr;//常用地址中默认地址jsonStr<格式 defaultAddress:{ id:1,hunamName:'李欣',contactNumber:'',province：'浙江省',city:'杭州市',area:'江干区',address:'下沙区6号大街新加坡杭州科技园2栋19楼'}>


-(void)fixUser;

+(NSMutableDictionary*)dicOfLoginUser:(HXLoginUser*)user;
+(HXLoginUser*)getUserByDic:(NSDictionary*)dict;

@end
