//
//  HXSelectDateAlert.m
//  walrusWuLiuCP
//
//  Created by 海象 on 15/9/28.
//  Copyright (c) 2015年 海象. All rights reserved.
//

#import "HXSelectDateAlert.h"
#import "AppDelegate.h"

#define totalHeight  215

@implementation HXSelectDateAlert

- (id)initWithFrame:(CGRect)frame selectDateStr:(NSString*)dateStr{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds=YES;
        self.backgroundColor=[UIColor whiteColor];
        self.layer.cornerRadius=5;
        self.frame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, totalHeight);
     
        UILabel*titleLab=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-80, 5, 160, 21)];
        titleLab.textAlignment=NSTextAlignmentCenter;
        titleLab.text=@"选择时间";
        titleLab.font=[UIFont boldSystemFontOfSize:15.f];
        titleLab.textColor=[UIColor blackColor];
        [self addSubview:titleLab];
        
        UIImageView*lineImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, ViewFrameY_H(titleLab)+5, self.frame.size.width, 1)];
        lineImgView.image=[UIImage imageNamed:@"dottedLine.png"];
        [self addSubview:lineImgView];

        _datePicker=[[UIDatePicker alloc] init];
        _datePicker.frame=CGRectMake(0, ViewFrameY_H(lineImgView)+10, self.frame.size.width,165);
        _datePicker.datePickerMode=UIDatePickerModeDateAndTime;
        NSLocale *locale=[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.locale=locale;
        _datePicker.minimumDate=[NSDate date];
        if (!dateStr.length)
            dateStr=[[[NSDate date] dateByAddingTimeInterval:24*3600] toStringByChineseDateTimeLine];
        
        NSString*str=[NSString stringWithFormat:@"%@",dateStr];
        NSLog(@"%@",str);
        NSDateFormatter*formatter=[[NSDateFormatter alloc] init];
        [formatter setLocale:locale];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        _datePicker.date=[formatter dateFromString:str];
        [self addSubview:_datePicker];
        
        UIImageView*lineImgView2=[[UIImageView alloc] initWithFrame:CGRectMake(0,ViewFrameY_H(_datePicker)+10, self.frame.size.width, 1)];
        lineImgView2.image=[UIImage imageNamed:@"dottedLine.png"];
        [self addSubview:lineImgView2];
        
        UIButton*confirmBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-(self.frame.size.width*0.5)/2,ViewFrameY_H(lineImgView2)+10, self.frame.size.width*0.5, 30)];
        confirmBtn.backgroundColor=LightBlueColor;
        [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        confirmBtn.titleLabel.font=[UIFont systemFontOfSize:15.f];;
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        confirmBtn.layer.cornerRadius=confirmBtn.frame.size.height/2;
        [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirmBtn];
        CGRect rect=self.frame;
        rect.size.height=ViewFrameY_H(confirmBtn)+10;
        self.frame=rect;
    }
    return self;
}

//确定点击
-(void)confirmBtnClicked:(id)sender{
    NSLog(@"%@",_datePicker.date);
   NSString* dateStr=[_datePicker.date toStringByChineseDateTimeLine];
    if ([_Cudelegate respondsToSelector:@selector(selectDateStr:Date:)]) {
        [_Cudelegate selectDateStr:dateStr Date:_datePicker.date];
    }
    [self alertRemoveFromSuperview];
}


-(void)show{
    AppDelegate*appDelegate=[AppDelegate appDelegate];
    _bgView=[[UIControl alloc] initWithFrame:CGRectMake(appDelegate.window.frame.origin.x, appDelegate.window.frame.origin.y, appDelegate.window.frame.size.width, appDelegate.window.frame.size.height)];
    _bgView.backgroundColor=[UIColor lightGrayColor];
    _bgView.alpha=0.8;
    
    self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [appDelegate.window addSubview:_bgView];
    [appDelegate.window addSubview:self];
    [_bgView addTarget:self action:@selector(alertRemoveFromSuperview) forControlEvents:UIControlEventTouchUpInside];
}
-(void)alertRemoveFromSuperview
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.alpha=0;
    _bgView.alpha=0;
    [UIView commitAnimations];
    [_bgView removeFromSuperview];
    [self removeFromSuperview];
    
}

@end
