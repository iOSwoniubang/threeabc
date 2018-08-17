//
//  HXPayHelper.m
//  BaiMi
//
//  Created by licl on 16/8/3.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXPayHelper.h"
#import "HXMachinePayViewController.h"
#import "AppDelegate.h"

static  HXPayHelper*payHelper = nil;

@interface HXPayHelper ()
@property(strong,nonatomic)NSTimer *timer; //定时器，控制30s之后 支付宝无返回结果，手动调接口查询付款结果
@property(assign,nonatomic)NSInteger timeCount;
@property(assign,nonatomic)BOOL hasPayResult; //支付返回结果
@property(strong,nonatomic)UIViewController*payVC;
@property(strong,nonatomic)NSString* payNo; //支付编码
@end


@implementation HXPayHelper

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        payHelper = [super allocWithZone:zone];
    });
    return payHelper;
}

+(HXPayHelper*)sharePayHelper{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        payHelper=[[HXPayHelper alloc] init];
    });
    return payHelper;
}

- (id)copyWithZone:(NSZone *)zone
{
    return payHelper;
}


//开始支付调用
-(void)payDealOfPayType:(HXPayType)payType payFee:(float)fee businessType:(HXBillType)businessType businessNo:(NSString*)businessNo payVC:(UIViewController*)payVC{
    
    HXLoginUser*user=[NSUserDefaultsUtil getLoginUser];
    if (payType==HXPayTypeBalance) {
    //余额支付
        if (user.balance<fee) {
            [HXAlertViewEx showInTitle:nil Message:@"余额不足" ViewController:payVC];
            return;
        }
        [self balancePayHttp:user businessType:businessType businessNo:businessNo];
    }else{
    //第三方支付
        _payVC=payVC;
        [HXLoadingImageView showLoadingView:[AppDelegate appDelegate].window];
        [self getPayParamsHttp:user businessType:businessType businessNo:businessNo payType:payType payVC:payVC];
    }
}



//余额支付
-(void)balancePayHttp:(HXLoginUser*)user businessType:(HXBillType)businessType businessNo:(NSString*)businessNo{
    NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,[NSNumber numberWithInt:businessType],businessNo,user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/payment/balance/pay" params:@{@"phoneNumber":user.phoneNumber,@"sKey":sKey,@"businessType":[NSNumber numberWithInt:businessType],@"businessNo":businessNo} onComplete:^(NSError *error, NSDictionary *resultJson) {
        HXPayResult*payResult=[HXPayResult new];
        if (error) {
            NSLog(@"支付失败");
            
            payResult.errCode=1;
            payResult.errStr=HXCodeString(error.code);
            
        }else{
            NSLog(@"支付成功");
            NSDictionary*content=[resultJson objectForKey:@"content"];
            user.balance=[[content objectForKey:@"balance"] floatValue];
            [NSUserDefaultsUtil setLoginUser:user];
            payResult.errCode=0;
            payResult.errStr=@"";
        }
        if ([_delegate respondsToSelector:@selector(payResult:)]) {
            [_delegate payResult:payResult];
        }
    }];
}


//支付参数（获取支付参数，再调用支付sdk）
-(void)getPayParamsHttp:(HXLoginUser*)user businessType:(HXBillType)businessType businessNo:(NSString*)businessNo payType:(HXPayType)payType payVC:(UIViewController*)payVC{
    NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,businessNo,[NSNumber numberWithInt:businessType],user.token]];
    
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/payment/getparameter" params:@{@"phoneNumber":user.phoneNumber,@"sKey":sKey,@"businessType":[NSNumber numberWithInt:businessType],@"businessNo":businessNo,@"paymentMethod":[NSNumber  numberWithInt:payType]} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            [HXLoadingImageView hideViewForView:[AppDelegate appDelegate].window];
            [HXAlertViewEx showInTitle:@"" Message:@"支付调取失败" ViewController:payVC];
        }else{
            NSDictionary*payParamDic=[resultJson objectForKey:@"content"];
            _payNo=[payParamDic objectForKey:@"no"];
            NSString*paramStr=nil;
            
            if (payType==HXPayTypeAlipay){
                //支付宝sdk
                paramStr =[payParamDic objectForKey:@"param"];
                [self alipaySdkByPayParamStr:paramStr];
            }
            else{
                //微信支付sdk
                paramStr=[HXNSStringUtil getJsonStringFromDicOrArray:payParamDic];
                [self weiXinPaySdkByPayParamStr:paramStr payVC:payVC];
            }
        }
    }];
}



//支付宝sdk
-(void)alipaySdkByPayParamStr:(NSString*)payParamStr{
    [[AlipaySDK defaultService] payOrder:payParamStr fromScheme:AlipayAppScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"");
        int resultStatus=[[resultDic objectForKey:@"resultStatus"] intValue];
        if(resultStatus==AlipayStatusSuccess){
            if (!_hasPayResult)
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendresult) userInfo:nil repeats:YES];
        }else{
            HXPayResult*payResult=[HXPayResult new];
            payResult.errCode=1;
            payResult.errStr=@"支付失败";
            [self payCallBackResult:payResult];
        }
    }];
}


//appdelegate 阿里支付 openUrl 回调反馈
-(void)payCallBackResult:(HXPayResult*)payResult{
    if ([_delegate respondsToSelector:@selector(payResult:)]){
        [HXLoadingImageView hideViewForView:[AppDelegate appDelegate].window];
        [_delegate payResult:payResult];
    }
}


#pragma mark--WeXinPay start

//微信支付sdk
-(void)weiXinPaySdkByPayParamStr:(NSString*)payParamStr payVC:(UIViewController*)payVC{
    NSString *res =[self jumpToBizPay:payParamStr];
    if( ![@"" isEqual:res] ){
        //调起微信支付失败
        [HXLoadingImageView hideViewForView:[AppDelegate appDelegate].window];
        [HXAlertViewEx showInTitle:nil Message:res ViewController:payVC];
        if ([payVC isKindOfClass:[HXMachinePayViewController class]]) {
            HXMachinePayViewController*vc=(HXMachinePayViewController*)payVC;
            vc.payBtn.enabled=YES;
        }
        return;
    }else{
        NSLog(@"已跳转到微信支付页");
    }
}

#pragma mark--WechatPay start
//唤起微信支付
-(NSString *)jumpToBizPay:(NSString*)paramsStr{
    
    if(![WXApi isWXAppInstalled]){
        return @"没有安装微信";
    }else if (![WXApi isWXAppSupportApi]){
        return @"不支持微信支付";
    }
    
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    response=[paramsStr dataUsingEncoding:NSUTF8StringEncoding];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                return @"";
            }else{
                return [dict objectForKey:@"retmsg"];
            }
        }else{
            return @"服务器返回错误，未获取到json对象";
        }
    }else{
        return @"服务器返回错误";
    }
}

#pragma mark--WeXinPay end





#pragma mark--支付结果手动查询开始

- (void)sendresult{
    if (_timeCount>=30) {
        [_timer invalidate];
        if (!_hasPayResult)
            [self getPayResultHttp];
        return;
    }
    _timeCount ++;
}


//查询付款结果
- (void)getPayResultHttp{
    HXLoginUser*user=[NSUserDefaultsUtil getLoginUser];
    NSLog(@"%@",_payNo);
    NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,_payNo,user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/payment/getPaymentResult" params:@{@"phoneNumber":user.phoneNumber,@"no":_payNo,@"sKey":sKey}  onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            [self getPayRepet];
        }else{
            NSDictionary *resultDict = [resultJson objectForKey:@"content"];
            int status=[[resultDict objectForKey:@"status"] intValue];
            
            if (status == 0 || status==1) {//(返回状态0:失败 1:成功 2:处理中)
                if (!_hasPayResult) {
                    [_timer invalidate];
                    _hasPayResult=YES;
                    
                    HXPayResult*payResult=[HXPayResult new];
                    if (status==0){
                       //支付失败
                        payResult.errCode=1;
                        payResult.errStr=HXCodeString(error.code);
                    }else{
                        //支付成功后
                        payResult.errCode=0;
                        payResult.errStr=@"";
                        
                    }
                    [self payCallBackResult:payResult];
                }
            }else{
                [self getPayRepet];
            }
        }
    }];
}


-(void)getPayRepet{
    if (!_hasPayResult){
        if (_timer)
            [_timer invalidate];
        _timer=[NSTimer timerWithTimeInterval:5 target:self selector:@selector(getResultPer5s) userInfo:nil repeats:YES];
    }
}

-(void)getResultPer5s{
    if (!_hasPayResult) {
        [self getPayResultHttp];
    }
}

#pragma mark--支付结果手动查询结束

//微信支付sdk回调，实际支付结果需要去微信服务器端查询
-(void)weixinSdkPayResp:(PayResp*)resp{
    switch (resp.errCode) {
        case WXSuccess:{
            NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
            //如无支付结果推送定时30秒后去接口查询支付结果
            if (!_hasPayResult)
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendresult) userInfo:nil repeats:YES];
        };break;
        default:{
            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
            HXPayResult*payResult=[HXPayResult new];
            payResult.errCode=1;
            if (resp.errCode==WXErrCodeUserCancel)
                payResult.errStr=@"用户已取消支付";
            else
                payResult.errStr=resp.errStr;
            [self payCallBackResult:payResult];
        };break;
    }
}


//支付结果推送处理
-(void)payResultNotification:(NSDictionary*)dict{
    if (dict) {
        NSString*no=[dict objectForKey:@"no"];
        if ([no isEqualToString:_payNo]) {
            [_timer invalidate];
            _hasPayResult=YES;
            int result=[[dict objectForKey:@"result"] intValue];
            HXPayResult*payResult=[HXPayResult new];
            if (result==1){
                payResult.errCode=0;
                payResult.errStr=@"";
            }else{
                //支付失败
                payResult.errCode=1;
                payResult.errStr=@"支付失败";
            }
            [self payCallBackResult:payResult];
        }
    }
}

#pragma mark--支付结果推送结束

@end