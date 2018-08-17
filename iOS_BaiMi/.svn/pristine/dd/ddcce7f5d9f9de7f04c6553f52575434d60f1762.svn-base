//
//  HXTaskOrder.m
//  BaiMi
//
//  Created by 王放 on 16/7/8.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXTaskOrder.h"

@implementation HXTaskOrder


-(NSString *)remainingTime{
    NSString*str=[self.deadLine remainingTimeStrSinceNow];
    NSString*deadLineStr=[self.deadLine toStringByChineseDateTimeLine];
     NSArray *array = [deadLineStr componentsSeparatedByString:@"-"];
    _remainingTime = [NSString stringWithFormat:@"%@-%@前  %@",[array objectAtIndex:1],[array objectAtIndex:2],str];
    return _remainingTime;
}


+(UIView *)taskWater:(HXTaskOrder *)order withHigh:(float)waterHigh {
    UIView *view = [[UIView alloc] init];
    view.bounds = CGRectMake(0, 0, SCREEN_WIDTH, waterHigh);
    BOOL weatherEnd = YES;
    BOOL isFirstColor = YES;
    NSString *stringTime=@"";
    NSLog(@"11111222 创建时间%@, 接单时间 %@,完成时间%@",order.createTime,order.acceptTime,order.completeTime);
    for (int i = 6-order.status; i<5; i++) {
        if (i>6-order.status) {
            isFirstColor = NO;
            weatherEnd = NO;
        }
        
        NSString *titleShow = @"";
        if (i==0) {
            titleShow = [NSString stringWithFormat:@"用户%@确认到达",order.publisherNickName];
            stringTime = [order.completeTime toStringByChineseDateTimeLine];
        }else if (i==1){
            titleShow = [NSString stringWithFormat:@"师哥%@顺利送达",order.fetcherNickName];
            stringTime = [order.arriveTime toStringByChineseDateTimeLine];
        }else if (i==2){
            titleShow = [NSString stringWithFormat:@"师哥%@取快递",order.fetcherNickName];
            stringTime = [order.pickupTime toStringByChineseDateTimeLine];
        }else if (i==3){
            titleShow = [NSString stringWithFormat:@"师哥%@接受任务",order.fetcherNickName];
            stringTime = [order.acceptTime toStringByChineseDateTimeLine];
        }else if (i==4){
            titleShow = @"等待师哥取件";
            stringTime = [order.createTime toStringByChineseDateTimeLine];
        }
        NSLog(@"%@",stringTime);
        UIView *viewOne = [self createOneListTitle:titleShow andTime:stringTime weatherEnd:weatherEnd andIsFirstColor:isFirstColor];
        viewOne.frame =CGRectMake(0, 80*(i - (6-order.status)), SCREEN_WIDTH, 80);
        [view addSubview:viewOne];
    }
   
    return view;
}


+(UIView *)createOneListTitle:(NSString *)title andTime:(NSString *)TimeStr weatherEnd:(BOOL)weatherEnd andIsFirstColor:(BOOL)isFirstColor{
    UIView *view = [[UIView alloc] init];
    
    if (!weatherEnd) {
        UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(40, -60, 1, 60)];
        labelLine.backgroundColor = BolderColor;
        [view addSubview:labelLine];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, 20, 20)];
    imageView.image = [UIImage imageNamed:@"ico_2yuan.png"];
//    imageView.backgroundColor = LightBlueColor;
    [view addSubview:imageView];
    
    for (int i = 0; i<2; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 20 * i, SCREEN_WIDTH - 70, 20)];
        label.text = i==0?title:TimeStr;
        label.font = [UIFont systemFontOfSize:14.];
        if (i==0) {
            label.textColor = isFirstColor?RGBA(216, 95, 32, 1):LightBlueColor;
        }else{
            label.textColor = RGBA(89, 90, 91, 1);
        }
        
        [view addSubview:label];
    }
    return view;
}
@end
