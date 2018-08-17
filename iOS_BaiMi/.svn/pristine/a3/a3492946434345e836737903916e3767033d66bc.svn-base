//
//  HXSelectAdditionServiceAlert.m
//  BaiMi
//
//  Created by licl on 16/7/20.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXSelectAdditionServiceAlert.h"
#import "AppDelegate.h"

@interface HXSelectAdditionServiceAlert ()
@property(strong,nonatomic)UIControl*bgView;
@property(strong,nonatomic)HXAdditonService*addition;
@property(strong,nonatomic)NSArray*additions;
@end

@implementation HXSelectAdditionServiceAlert

- (id)initWithSelectAddition:(HXAdditonService*)addition{
    self=[super init];
    if (self) {
        self.backgroundColor=[UIColor colorWithRed:(244/255.0) green:244/255.0 blue:244/255.0 alpha:1.0];
        self.clipsToBounds=YES;
        self.frame=CGRectMake(10, 150, SCREEN_WIDTH-20, 220);
        
        self.backgroundColor=[UIColor whiteColor];
        self.layer.cornerRadius=5;
        self.clipsToBounds=YES;
        UILabel*titleLab=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-80, 5, 160, 21)];
        titleLab.textAlignment=NSTextAlignmentCenter;
        titleLab.text=@"增值服务";
        titleLab.font=[UIFont boldSystemFontOfSize:15.f];
        titleLab.textColor=[UIColor blackColor];
        [self addSubview:titleLab];
        
        UIButton*cancelBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-10-20, 5, 20, 20)];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"ico_xiugai.png"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(canBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        UIImageView*lineImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, ViewFrameY_H(titleLab)+5, self.frame.size.width, 1)];
        lineImgView.image=[UIImage imageNamed:@"dottedLine.png"];
        [self addSubview:lineImgView];
        
        _additions=[[HXAdditonServiceDao new] fetchAllAdditions];
        if (addition)
            _addition=addition;
        
        UIFont*myFont=[UIFont systemFontOfSize:14.f];
        UIView*view=[[UIView alloc] initWithFrame:CGRectMake(20, ViewFrameY_H(lineImgView)+10, self.frame.size.width-20*2, 30*_additions.count)];
        for(int i=0;i<_additions.count;i++){
            UIImageView*dotImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10,30*i+15,5, 5)];
            dotImgView.image=[UIImage imageNamed:@"icon_dot.png"];
            [view addSubview:dotImgView];
            
            HXAdditonService*add=[_additions objectAtIndex:i];
            
            UIButton*selBtn=[[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width-10-20, 30*i+5, 20, 20)];
            [selBtn setBackgroundImage:[UIImage imageNamed:@"icon_uncheck.png"] forState:UIControlStateNormal];
            [selBtn setBackgroundImage:[UIImage imageNamed:@"icon_check.png"] forState:UIControlStateSelected];
            [selBtn addTarget:self action:@selector(selBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            selBtn.tag=i;
            [view addSubview:selBtn];
            
            UILabel*feeLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrame_X(selBtn)-60,ViewFrame_Y(selBtn), 60, 21)];
            feeLab.text=[NSString stringWithFormat:@"%@元",add.feeStr];
            feeLab.font=myFont;
            [view addSubview:feeLab];
            
            int origonX=ViewFrameX_W(dotImgView)+10;
            int seperRight=90;
            UILabel*descriptionLab=[[UILabel alloc] initWithFrame:CGRectMake(origonX,ViewFrame_Y(selBtn), view.frame.size.width-origonX-seperRight, 21)];
            descriptionLab.text=add.descriptin;
            descriptionLab.font=myFont;
            [view addSubview:descriptionLab];
            if (addition && [add.descriptin isEqualToString:addition.descriptin])
                selBtn.selected=YES;
        }
        [self addSubview:view];

        UIImageView*lineImgView2=[[UIImageView alloc] initWithFrame:CGRectMake(0,ViewFrameY_H(view)+10, self.frame.size.width, 1)];
        lineImgView2.image=[UIImage imageNamed:@"dottedLine.png"];
        [self addSubview:lineImgView2];
        

        UIButton*confirmBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-(self.frame.size.width*0.5)/2,ViewFrameY_H(lineImgView2)+10, self.frame.size.width*0.5, 30)];
        confirmBtn.backgroundColor=LightBlueColor;
        [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        confirmBtn.titleLabel.font=[UIFont systemFontOfSize:15.f];
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

-(void)selBtnClicked:(id)sender{
    UIButton*btn=(UIButton*)sender;
    btn.selected=!btn.selected;
    if (btn.selected)
        _addition=[_additions objectAtIndex:btn.tag];
    else
        _addition=nil;
}


-(void)canBtnClicked:(id)sender{
    [self alertRemoveFromSuperview];
}


//确定点击
-(void)confirmBtnClicked:(id)sender{
    if ([_CusDelegate respondsToSelector:@selector(alertView:addition:)]) {
        [_CusDelegate alertView:self addition:_addition];
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
