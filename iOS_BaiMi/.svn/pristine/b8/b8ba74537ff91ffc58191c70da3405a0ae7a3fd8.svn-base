//
//  HXLoginUser.m
//  BaiMi
//
//  Created by licl on 16/6/23.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXLoginUser.h"

@implementation HXLoginUser

-(void)fixUser{
    if (!_nickName)
        _nickName=@"";
    if (!_realName)
        _realName=@"";
    if (!_logoUrl)
        _logoUrl=@"";
    if (!_collegeNo)
        _collegeNo=@"";
    if (!_collegeName)
        _collegeName=@"";
    if (!_adress)
        _adress=@"";
    if (!_pointNo)
        _pointNo=@"";
    if (!_pointName)
        _pointName=@"";
    if (!_pointAddressJsonStr)
        _pointAddressJsonStr=@"";
    if (!_dormitoryHouseNo)
        _dormitoryHouseNo=@"";
    if (!_dormitoryDes)
        _dormitoryDes=@"";
    if (!_dormitoryNo)
        _dormitoryNo=@"";
    if(!_inviteCode)
        _inviteCode=@"";
    if(!_idCardNo)
        _idCardNo=@"";
    if(!_studentId)
        _studentId=@"";
    if (!_areaNo)
        _areaNo = @"";
    if (!_areaName)
        _areaName = @"";
    if (!_refererCode)
        _refererCode = @"";
    if (!_inviteCode)
        _inviteCode=@"";
    if (!_idCardNo)
        _idCardNo=@"";
    if (!_idCardUrl)
        _idCardUrl=@"";
    if (!_studentId)
        _studentId=@"";
    if (!_defaultAddressJsonStr)
        _defaultAddressJsonStr=@"";
    if (!_studentVerificationStatus) {
        _studentVerificationStatus = 0;
    }
}


+(NSMutableDictionary*)dicOfLoginUser:(HXLoginUser*)user{
    [user fixUser];
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    [dict setObject:user.phoneNumber forKey:@"phoneNumber"];
    [dict setObject:user.securityCode forKey:@"securityCode"];
    [dict setObject:user.token forKey:@"token"];
    [dict setObject:user.realName forKey:@"realName"];
    [dict setObject:user.nickName forKey:@"nickName"];
    [dict setObject:user.logoUrl forKey:@"logoUrl"];
//    [dict setObject:user.lastLoginTime forKey:@"lastLoginTime"];
    [dict setObject:user.collegeNo forKey:@"collegeNo"];
    [dict setObject:user.collegeName forKey:@"collegeName"];
    [dict setObject:user.adress forKey:@"adress"];
    [dict setObject:user.pointNo forKey:@"pointNo"];
    [dict setObject:user.pointName forKey:@"pointName"];
    [dict setObject:user.pointAddressJsonStr forKey:@"pointAddressJsonStr"];
    [dict setObject:user.dormitoryHouseNo forKey:@"dormitoryHouseNo"];
    [dict setObject:user.dormitoryDes forKey:@"dormitoryDes"];
    [dict setObject:user.dormitoryNo forKey:@"dormitoryNo"];
    [dict setObject:user.areaNo forKey:@"areaNo"];
    [dict setObject:user.areaName forKey:@"areaName"];
    [dict setObject:[NSNumber numberWithFloat:user.balance] forKey:@"balance"];
    [dict setObject:[NSNumber numberWithLongLong:user.praiseCount] forKey:@"praiseCount"];
    [dict setObject:[NSNumber numberWithLongLong:user.despiseCount] forKey:@"contempCount"];
    [dict setObject:[NSNumber numberWithInt:user.verifyStatus] forKey:@"verifyStatus"];
    [dict setObject:[NSNumber numberWithInt:user.studentVerificationStatus] forKey:@"studentVerificationStatus"];
    [dict setObject:user.inviteCode forKey:@"inviteCode"];
    [dict setObject:user.refererCode forKey:@"refererCode"];
    [dict setObject:user.realName forKey:@"realName"];
    [dict setObject:user.idCardNo forKey:@"idCardNo"];
    [dict setObject:user.idCardUrl forKey:@"idCardUrl"];
    [dict setObject:user.studentId forKey:@"studentId"];
    [dict setObject:[NSNumber numberWithLongLong:user.integral] forKey:@"integral"];
    [dict setObject:[NSNumber numberWithFloat:user.frozenAmount] forKey:@"frozenAmount"];
    [dict setObject:user.defaultAddressJsonStr forKey:@"defaultAddressJsonStr"];
    
    return dict;
}

+(HXLoginUser*)getUserByDic:(NSDictionary*)dict{
    HXLoginUser*user=[HXLoginUser new];
    user.phoneNumber=[dict objectForKey:@"phoneNumber"];
    user.securityCode=[dict objectForKey:@"securityCode"];
    user.token=[dict objectForKey:@"token"];
    user.realName=[dict objectForKey:@"realName"];
    user.nickName=[dict objectForKey:@"nickName"];
    user.logoUrl=[dict objectForKey:@"logoUrl"];
//    user.lastLoginTime=[dict objectForKey:@"lastLoginTime"];
    user.collegeNo=[dict objectForKey:@"collegeNo"];
    user.collegeName=[dict objectForKey:@"collegeName"];
    user.adress=[dict objectForKey:@"adress"];
    user.pointNo=[dict objectForKey:@"pointNo"];
    user.pointName=[dict objectForKey:@"pointName"];
    user.pointAddressJsonStr=[dict objectForKey:@"pointAddressJsonStr"];
    user.dormitoryHouseNo=[dict objectForKey:@"dormitoryHouseNo"];
    user.dormitoryDes=[dict objectForKey:@"dormitoryDes"];
    user.dormitoryNo=[dict objectForKey:@"dormitoryNo"];
    user.areaNo = [dict objectForKey:@"areaNo"];
    user.areaName = [dict objectForKey:@"areaName"];
    user.balance=[[dict objectForKey:@"balance"] floatValue];
    user.praiseCount=[[dict objectForKey:@"praiseCount"] longValue];
    user.despiseCount=[[dict objectForKey:@"contempCount"] longValue];
    user.verifyStatus=[[dict objectForKey:@"verifyStatus"] intValue];
    user.studentVerificationStatus=[[dict objectForKey:@"studentVerificationStatus"] intValue];
    user.inviteCode=[dict objectForKey:@"inviteCode"];
    user.refererCode = [dict objectForKey:@"refererCode"];
    user.realName=[dict objectForKey:@"realName"];
    user.idCardNo=[dict objectForKey:@"idCardNo"];
    user.idCardUrl=[dict objectForKey:@"idCardUrl"];
    user.studentId=[dict objectForKey:@"studentId"];
    user.integral=[[dict objectForKey:@"integral"] longLongValue];
    user.frozenAmount=[[dict objectForKey:@"frozenAmount"] floatValue];
    user.defaultAddressJsonStr=[dict objectForKey:@"defaultAddressJsonStr"];
    return user;
}

@end
