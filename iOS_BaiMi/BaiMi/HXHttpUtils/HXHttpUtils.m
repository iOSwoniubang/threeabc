
//
//  HXHttpUtils.m
//  BaiMi
//
//  Created by licl on 16/6/24.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXHttpUtils.h"
#import "AFNetworking.h"
#import "NSString+Encryption.h"
#import "AppDelegate.h"


@implementation HXHttpUtils

//普通post请求
+(void)requestJsonPostWithUrlStr:(NSString*)urlStr params:(NSDictionary*)params onComplete:(void (^)(NSError* error,NSDictionary* resultJson))onComplete{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    __block NSDictionary*resultJson=nil;
    __block NSError*error=nil;
    NSString*urlString=[NSString stringWithFormat:@"%@%@",HXURLWebServer ,urlStr];
    NSLog(@"request url:%@  params:%@",urlString,params);
    [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         resultJson=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        int flag=[[resultJson objectForKey:@"flag"] intValue];
        int code=[[resultJson objectForKey:@"errorCode"] intValue];
        if (flag!=SUCCESS|code!=10000){
        error= [NSError errorWithDomain:HXCodeString(code) code:code userInfo:nil];
            NSLog(@"request url:%@\n error:%@",urlString,error);
        }else
            NSLog(@"request url:%@\n%@\n",urlString,[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
         onComplete(error,resultJson);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSHTTPURLResponse*respon= [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"];
        long code=(long)error.code;
        NSLog(@"error1:%@",error);
        if ([error.domain isEqualToString:NSURLErrorDomain])
            code= (code==-1001)?2:1;
        //仅线上判定无效令牌为异地登录，开发测试阶段注意参数或url错误
        if(respon.statusCode==403){
//            code=10700;
//            该账号已在其他终端登录
            [[AppDelegate appDelegate] loginOut];
            return ;
        }
        error=[NSError errorWithDomain:HXCodeString(code) code:code userInfo:nil];
        NSLog(@"request url:%@\n error2:%@",urlString,error);
        onComplete(error,resultJson);
    }];
}


//表单样式post请求
+(void)requestJsonFormDataPostWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params ImgDataParams:(NSDictionary *)imgDataParams showHud:(BOOL)showHud onComplete:(void (^)(NSError *, NSDictionary *))onComplete{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    __block NSDictionary*resultJson=nil;
    __block NSError*error=nil;
    NSString*urlString=[NSString stringWithFormat:@"%@%@",HXURLWebServer ,urlStr];
   [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
       for(NSString*key in imgDataParams.keyEnumerator){
           [formData appendPartWithFileData:[imgDataParams objectForKey:key] name:key fileName:[NSString stringWithFormat:@"%@.jpg",key] mimeType:@"image/jpeg"];
       }
   } progress:^(NSProgress * _Nonnull uploadProgress) {
       
   } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       //请求成功
       [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
       resultJson=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
       int flag=[[resultJson objectForKey:@"flag"] intValue];
       int code=[[resultJson objectForKey:@"errorCode"] intValue];
       if (flag!=SUCCESS|code!=10000){
           error=[NSError errorWithDomain:HXCodeString(code) code:code userInfo:nil];
           NSLog(@"request url:%@\n error:%@",urlString,error);
       }else
           NSLog(@"request url:%@\n%@\n",urlString,[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
       onComplete(error,(NSDictionary*)resultJson);
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       //请求失败
       [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
       long code=(long)error.code;
       if ([error.domain isEqualToString:NSURLErrorDomain])
           code= (code==-1001)?2:1;
       error=[NSError errorWithDomain:HXCodeString(error.code) code:error.code userInfo:nil];
       NSLog(@"request url:%@\n error:%@",urlString,error);
       onComplete(error,(NSDictionary*)resultJson);
   }];
}


//Get请求
+(void)requestJsonGetWithUrlStr:(NSString *)urlStr params:(NSDictionary*)params onComplete:(void (^)(NSError* error,NSDictionary* resultJson))onComplete{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    __block NSDictionary*resultJson=nil;
    __block NSError*error=nil;
    NSString*urlString=[NSString stringWithFormat:@"%@%@",HXURLWebServer ,urlStr];
    NSLog(@"request url:%@  params:%@",urlString,params);
    [manager GET:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        resultJson=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        int flag=[[resultJson objectForKey:@"flag"] intValue];
        int code=[[resultJson objectForKey:@"errorCode"] intValue];
        if (flag!=SUCCESS|code!=10000){
            error= [NSError errorWithDomain:HXCodeString(code) code:code userInfo:nil];
            NSLog(@"request url:%@\n error:%@",urlString,error);
        }else
            NSLog(@"request url:%@\n%@\n",urlString,[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        onComplete(error,resultJson);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        long code=(long)error.code;
        NSLog(@"error1:%@",error);
        if ([error.domain isEqualToString:NSURLErrorDomain])
            code= (code==-1001)?2:1;
        error=[NSError errorWithDomain:HXCodeString(code) code:code userInfo:nil];
        NSLog(@"request url:%@\n error:%@",urlString,error);
        onComplete(error,resultJson);
    }];
}


//快递鸟查询(传入参数：ShipperCode:快递公司编码 ，LogisticCode:快递编号)
+(void)requestJsonPostOfKdniaoTrackQueryAPIWithShipperCode:(NSString*)expressCompanyNo LogisticCode:(NSString*)expressNo onComplete:(void (^)(NSString* errorReason,NSDictionary* resultJson))onComplete{

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *EBusinessID = @"1255438";
    NSString*AppKey=@"d8d92da3-1075-4b43-ab8f-7b16484b8a75";
    NSString*reqUrl=@"http://api.kdniao.cc/Ebusiness/EbusinessOrderHandle.aspx";
    NSDictionary*params=@{@"OrderCode":@"",@"ShipperCode":expressCompanyNo,@"LogisticCode":expressNo};
    NSString*paramsStr=[HXNSStringUtil getJsonStringFromDicOrArray:params];
    //url加密
    NSString* requestData=[paramsStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString*dataSign=[NSString stringWithFormat:@"%@%@",paramsStr,AppKey];
    dataSign=dataSign.md5HexDigest;
    dataSign=dataSign.base64String;
    dataSign= [dataSign stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //url解码
    //NSString *str = [dataSign stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary*paramDic=@{@"RequestData":requestData,@"EBusinessId":EBusinessID,@"RequestType":@"1002",@"DataSign":dataSign,@"DataType":@"2"};
    
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    __block NSDictionary*resultJson=nil;
    __block NSString*errorReason=nil;
    
    [manager POST:reqUrl parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        resultJson=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        int Success=[[resultJson objectForKey:@"Success"] intValue];
        if (Success!=SUCCESS){
            errorReason=[resultJson objectForKey:@"Reason"];
            NSLog(@"request url:%@\n errorReason: %@\n",reqUrl,errorReason);
        }else
            NSLog(@"request url:%@\n%@\n",reqUrl,[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        onComplete(errorReason,resultJson);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        long code=(long)error.code;
        if ([error.domain isEqualToString:NSURLErrorDomain])
            code= (code==-1001)?2:1;
        errorReason=HXCodeString(code);
        NSLog(@"request url:%@\n errorReason:%@",reqUrl,errorReason);
        onComplete(errorReason,resultJson);
    }];
}



//微支付协议获取激活码
+(void)requestJsonPostOfActiveCodeApiwithParams:(NSDictionary*)params onComplete:(void (^)(NSString* errorReason,NSDictionary* resultJson))onComplete{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    __block NSDictionary*resultJson=nil;
    __block NSString*errorReason=nil;
    NSString*urlStr=@"http://wx.wjziyu.com/Interface/API/ApiHttpHandler.ashx";
    NSLog(@"urlStr:%@,paramms:%@",urlStr,params);

    [manager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        resultJson=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        int errCode=[[resultJson objectForKey:@"err"] intValue];
        if (errCode!=0) {
        //失败
            errorReason= [resultJson objectForKey:@"errMsg"];
            NSLog(@"request url:%@\n errorReason: %@\n",urlStr,errorReason);
        }else
        //成功
            NSLog(@"request url:%@\n result: %@\n",urlStr,resultJson);

        onComplete(errorReason,resultJson);

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        long code=(long)error.code;
        if ([error.domain isEqualToString:NSURLErrorDomain])
            code= (code==-1001)?2:1;
        errorReason=HXCodeString(code);
        NSLog(@"request url:%@\n errorReason:%@",urlStr,errorReason);
        onComplete(errorReason,resultJson);
    }];
}


+(NSString *)whetherNil:(id)str {
    if ([str isKindOfClass:[NSNull class]] || !str) {
        str = @"";
    }
    return [NSString stringWithFormat:@"%@",str];
}
@end
