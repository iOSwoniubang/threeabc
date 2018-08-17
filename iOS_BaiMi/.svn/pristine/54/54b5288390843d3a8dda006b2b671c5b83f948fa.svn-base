//
//  HXSelectServiceTimeAlert.m
//  BaiMi
//
//  Created by licl on 16/7/20.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXSelectServiceTimeAlert.h"
#import "AppDelegate.h"

@interface HXSelectServiceTimeAlert ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property(strong,nonatomic)UIControl*bgView;
@property(strong,nonatomic)NSArray*serTimes;
@property(strong,nonatomic)NSString*serviceTimeStr;

@end

@implementation HXSelectServiceTimeAlert

- (id)initWithSelectServiceTimeStr:(NSString*)serviceTimeStr{
    self = [super init];
    if (self) {
        self.backgroundColor=[UIColor colorWithRed:(244/255.0) green:244/255.0 blue:244/255.0 alpha:1.0];
        self.clipsToBounds=YES;

        self.frame=CGRectMake(20, 150,SCREEN_WIDTH-40, 200);
        self.backgroundColor=[UIColor whiteColor];
        self.layer.cornerRadius=5;
        self.clipsToBounds=YES;
        UILabel*titleLab=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-80, 5, 160, 21)];
        titleLab.textAlignment=NSTextAlignmentCenter;
        titleLab.text=@"服务时间";
        titleLab.font=[UIFont boldSystemFontOfSize:15.f];
        titleLab.textColor=[UIColor blackColor];
        [self addSubview:titleLab];
        UIImageView*lineImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, ViewFrameY_H(titleLab)+5, self.frame.size.width, 1)];
        lineImgView.image=[UIImage imageNamed:@"dottedLine.png"];
        [self addSubview:lineImgView];
        _serTimes=@[@"9:00-12:00",@"13:00-17:00",@"17:30-19:30"];
        UIPickerView* pickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(10, ViewFrameY_H(lineImgView)+5, self.frame.size.width-20, 100)];
        pickerView.dataSource=self;
        pickerView.delegate=self;
        [self addSubview:pickerView];
        if (serviceTimeStr.length){
            _serviceTimeStr=serviceTimeStr;
            int selRow=(int)[_serTimes indexOfObject:serviceTimeStr];
            [pickerView selectRow:selRow inComponent:0 animated:NO];
        }else{
           [pickerView selectRow:1 inComponent:0 animated:NO];
            _serviceTimeStr=[_serTimes objectAtIndex:1];
        }
        
        UIImageView*lineImgView2=[[UIImageView alloc] initWithFrame:CGRectMake(0,ViewFrameY_H(pickerView)+5, self.frame.size.width, 1)];
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



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _serTimes.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString*title=[_serTimes objectAtIndex:row];
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _serviceTimeStr=[_serTimes objectAtIndex:row];
}

//确定点击
-(void)confirmBtnClicked:(id)sender{
    if ([_CusDelegate respondsToSelector:@selector(alertView:selectServiceTime:)]) {
        [_CusDelegate alertView:self selectServiceTime:_serviceTimeStr];
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
