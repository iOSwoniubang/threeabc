//
//  HXLoginViewController.m
//  BaiMi
//
//  Created by licl on 16/6/23.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXLoginViewController.h"
#import "AppDelegate.h"
#import "HXMainTabBarController.h"
#import "HXLoginUser.h"
#import "HXAlertViewEx.h"
#import "AFNetworking.h"
#import "HXNumberTextField.h"

#define FrontWide 20

@interface HXLoginViewController ()
@property(strong,nonatomic)HXNumberTextField *phoneTF;
@property(strong,nonatomic)HXNumberTextField *verifyTF;
@property(strong,nonatomic)UIButton *verifyBtn;
@property(strong,nonatomic)UIButton *loginBtn;
@property(strong,nonatomic)NSString*token;
@property(strong,nonatomic)HXLoginUser *user;
@end

@implementation HXLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=LightBlueColor;
    [self createLoginUI];
}

-(void)createLoginUI{
    
    UIImageView*bgImgView=[[UIImageView alloc] initWithFrame:self.view.frame];
    bgImgView.backgroundColor=LightBlueColor;
    bgImgView.userInteractionEnabled=YES;
    bgImgView.image=[UIImage imageNamed:@"loginBg.png"];
    [self.view addSubview:bgImgView];
    
    UIImageView*logoImgView=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-150/2, 200/2-50/2, 150, 50)];
    logoImgView.image=[UIImage imageNamed:@"loginLogo.png"];
    [bgImgView addSubview:logoImgView];
    
    
    UIView *loginView = [[UIView alloc]initWithFrame:CGRectMake(FrontWide, 200, SCREEN_WIDTH - FrontWide *2.0, 98)];
//    loginView.backgroundColor = RGBA(17, 130, 215, 1);
    loginView.backgroundColor = RGBA(0, 146, 215, 0.8);

    loginView.layer.cornerRadius = 10.f;
    loginView.layer.borderWidth = 1.f;
    loginView.layer.borderColor = RGBA(0, 150, 220, 1).CGColor;
    [bgImgView addSubview:loginView];
    
    UIFont*myFont=[UIFont systemFontOfSize:16.f];
    
    _phoneTF = [[HXNumberTextField alloc] initWithFrame:CGRectMake(10, 0, ViewFrame_W(loginView) -20, 48.0) Type:UIKeyboardTypePhonePad];
    _phoneTF.backgroundColor = [UIColor clearColor];
    _phoneTF.layer.masksToBounds = YES;
    _phoneTF.attributedPlaceholder=[[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _phoneTF.textColor=[UIColor whiteColor];
    _phoneTF.font=myFont;
    [loginView addSubview:_phoneTF];
    NSString*phoneNum=[NSUserDefaultsUtil getLastUserPhone];
    if (phoneNum.length)
        _phoneTF.text=phoneNum;
    
    UIView*lineView=[[UIView alloc] initWithFrame:CGRectMake(5, 48, ViewFrame_W(loginView)-10, 1)];
    lineView.backgroundColor=RGBA(65, 162, 222, 1);
    [loginView addSubview:lineView];
    
    
    //短信验证
    _verifyTF=[[HXNumberTextField alloc] initWithFrame:CGRectMake(_phoneTF.frame.origin.x, ViewFrameY_H(lineView),  _phoneTF.frame.size.width-105, 48) Type:UIKeyboardTypeNumberPad];
    _verifyTF.attributedPlaceholder=[[NSAttributedString alloc] initWithString:@"请输入短信验证码" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _verifyTF.textColor=[UIColor whiteColor];
    _verifyTF.font=myFont;
    _verifyTF.backgroundColor=[UIColor clearColor];
    
    _verifyBtn=[[UIButton alloc] initWithFrame:CGRectMake(ViewFrameX_W(_verifyTF)+5, ViewFrameY_H(lineView)+2, 100, 44)];
    [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _verifyBtn.backgroundColor=[UIColor clearColor];
    [_verifyBtn setTitleColor:RGBA(4, 243, 249, 1) forState:UIControlStateNormal];
    _verifyBtn.layer.cornerRadius=4.f;
    _verifyBtn.titleLabel.font=[UIFont systemFontOfSize:13.f];
    [_verifyBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_verifyBtn addTarget:self action:@selector(fetchVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:_verifyTF];
    [loginView addSubview:_verifyBtn];
    
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(FrontWide, ViewFrameY_H(loginView) + 50 , SCREEN_WIDTH - FrontWide * 2.0, 40);
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:LightBlueColor forState:UIControlStateNormal];
    _loginBtn.layer.cornerRadius=_loginBtn.frame.size.height/2;
    _loginBtn.tag = 1;
    _loginBtn.backgroundColor=[UIColor whiteColor];
    [_loginBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgImgView addSubview:_loginBtn];
}

//登录按钮点击
-(void)loginBtnClicked:(id)sender{
    if (![self matchPhoneNum])
        return;
    if(!_verifyTF.text.length){
        [HXAlertViewEx showInTitle:nil Message:@"请输入验证码" ViewController:self];
        return;
    }
    if (!_token.length) {
        [HXAlertViewEx showInTitle:nil Message:@"请先获取验证码" ViewController:self];
        return;
    }
    if(_loginBtn.enabled)
        [self loginHttp];
}


//登录请求
-(void)loginHttp{
    _loginBtn.enabled=NO;
     NSString*clientId=[NSUserDefaultsUtil geTuiClientId];
    NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[_phoneTF.text,clientId,_verifyTF.text,[NSNumber numberWithInt:HXOsTypeIos],_token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/doLogin" params:@{@"phoneNumber":_phoneTF.text,@"sKey":sKey,@"securityCode":_verifyTF.text,@"isAutoLogin":@"0",@"cid":clientId,@"osType":[NSNumber numberWithInt:HXOsTypeIos]} onComplete:^(NSError *error, NSDictionary *resultJson) {
        _loginBtn.enabled=YES;
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            NSDictionary*dict=[resultJson objectForKey:@"content"];
            NSString* phoneNumber=[dict objectForKey:@"phoneNumber"];
            HXLoginUser
            *user=[NSUserDefaultsUtil getLoginUser];
            if (!user) {
                user=[HXLoginUser new];
                user.phoneNumber=phoneNumber;
            }else
                user.phoneNumber=phoneNumber;
            user.securityCode=_verifyTF.text;
            user.token=_token;
            user.realName=[HXHttpUtils whetherNil:[dict objectForKey:@"name"]];
            user.nickName=[HXHttpUtils whetherNil:[dict objectForKey:@"nickName"]];
            user.logoUrl=[HXHttpUtils whetherNil:[dict objectForKey:@"icon"]];
            user.collegeNo=[HXHttpUtils whetherNil:[dict objectForKey:@"collegeNo"]];
            user.collegeName=[HXHttpUtils whetherNil:[dict objectForKey:@"collegeName"]];
            user.adress=[HXHttpUtils whetherNil:[dict objectForKey:@"adress"]];
            user.pointNo=[HXHttpUtils whetherNil:[dict objectForKey:@"pointNo"]];
            user.pointName=[HXHttpUtils whetherNil:[dict objectForKey:@"pointName"]];
            user.dormitoryHouseNo=[HXHttpUtils whetherNil:[dict objectForKey:@"dormitoryHouseNo"]];
            user.dormitoryDes=[HXHttpUtils whetherNil:[dict objectForKey:@"dormitoryHouseName"]];
            user.dormitoryNo=[HXHttpUtils whetherNil:[dict objectForKey:@"dormitoryNo"]];
            user.balance =[[HXHttpUtils whetherNil:[dict objectForKey:@"balance"] ]floatValue];
            user.praiseCount=[[HXHttpUtils whetherNil:[dict objectForKey:@"praiseCount"]] longLongValue];
            user.despiseCount=[[HXHttpUtils whetherNil:[dict objectForKey:@"despiseCount"]] longLongValue];
            
            user.verifyStatus=[[HXHttpUtils whetherNil:[dict objectForKey:@"verificationStatus"] ] intValue];
            user.studentVerificationStatus=[[HXHttpUtils whetherNil:[dict objectForKey:@"studentVerificationStatus"] ] intValue];
            user.inviteCode=[HXHttpUtils whetherNil:[dict objectForKey:@"inviteCode"]];
            user.refererCode=[HXHttpUtils whetherNil:[dict objectForKey:@"refererCode"]];
            user.areaNo=[HXHttpUtils whetherNil:[dict objectForKey:@"areaNo"]];
            user.areaName=[HXHttpUtils whetherNil:[dict objectForKey:@"areaName"]];
            user.idCardNo=[HXHttpUtils whetherNil:[dict objectForKey:@"idCradNo"]];
            user.idCardUrl=[HXHttpUtils whetherNil:[dict objectForKey:@"idCard"]];
            user.studentId=[HXHttpUtils whetherNil:[dict objectForKey:@"studentNo"]];
            user.integral=[[HXHttpUtils whetherNil:[dict objectForKey:@"integral"]] longLongValue];
            user.frozenAmount=[[HXHttpUtils whetherNil:[dict objectForKey:@"frozenAmount"]] floatValue];
            id defaultAddress=[dict objectForKey:@"defaultAddress"];
            if (![defaultAddress isKindOfClass:[NSNull class]]) {
                NSDictionary*defaultAddressDic=defaultAddress;
                user.defaultAddressJsonStr=[HXNSStringUtil getJsonStringFromDicOrArray:defaultAddressDic];
            }else
                user.defaultAddressJsonStr=@"";
            [NSUserDefaultsUtil setLoginUser:user];
            [NSUserDefaultsUtil setLastUserPhone:user.phoneNumber];
            
            [AppDelegate appDelegate].tabBarVC=[[HXMainTabBarController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController=[AppDelegate appDelegate].tabBarVC;
        }
    }];
}



-(BOOL)matchPhoneNum{
    if (!_phoneTF.text.length){
        [ HXAlertViewEx showInTitle:nil Message:@"请输入手机号码" ViewController:self];
        return NO;
    }
    if (![HXNSStringUtil isMobilePhoneNumber:_phoneTF.text]){
        [HXAlertViewEx showInTitle:nil Message:@"手机号码格式不正确" ViewController:self];
        return NO;
    }
    return YES;
    
}



//获取手机验证码按钮点击
-(void)fetchVerifyCode:(id)sender{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if (![self matchPhoneNum])
        return;
    if (_verifyBtn.enabled)
        [self verifyCodeHttp];
}

-(void)verifyCodeHttp{
    _verifyBtn.enabled=NO;
    [HXHttpUtils requestJsonPostWithUrlStr:@"/common/getCode" params:@{@"phoneNumber":_phoneTF.text}  onComplete:^(NSError *error, NSDictionary *resultJson) {
        NSLog(@"%@",resultJson);
        if (error) {
            _verifyBtn.enabled=YES;
            [HXAlertViewEx showInTitle:nil Message:@"手机验证码获取失败" ViewController:self];
        }else{
            NSDictionary*content=[resultJson objectForKey:@"content"];
            _token=[content objectForKey:@"token"];
            [HXAlertViewEx showInTitle:nil Message:@"验证码已发送，请输入手机验证码" ViewController:self];
            [NSThread detachNewThreadSelector:@selector(countDownCode) toTarget:self withObject:nil];
        }
    }];
}

//倒计时60秒
-(void)countDownCode{
    for(int i = 60;i>=0;i--){
        dispatch_async(dispatch_get_main_queue(), ^{
            [_verifyBtn setTitle:[NSString stringWithFormat:@"%d秒后重试",i] forState:UIControlStateNormal];
            if(i==0){
                _verifyBtn.enabled=YES;
                [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            }
        });
        [NSThread sleepForTimeInterval:1.0];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
