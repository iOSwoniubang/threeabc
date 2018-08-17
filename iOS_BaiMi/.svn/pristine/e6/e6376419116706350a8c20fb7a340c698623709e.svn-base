//
//  HXNoticeView.m
//  BaiMi
//
//  Created by licl on 16/8/11.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXNoticeView.h"
#import "AppDelegate.h"

@implementation HXNoticeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    UILabel*lab=[[UILabel alloc] initWithFrame:CGRectMake(20, 30, SCREEN_WIDTH, 21)];
    lab.text=_title;
    lab.textColor=[UIColor whiteColor];
    lab.font=[UIFont boldSystemFontOfSize:14.0f];
    lab.backgroundColor=[UIColor clearColor];
    UILabel*contentLab=[[UILabel alloc] initWithFrame:CGRectMake(20, 40, SCREEN_WIDTH, 42)];
    contentLab.text=_content;
    contentLab.textColor=[UIColor whiteColor];
    contentLab.backgroundColor=[UIColor clearColor];
    contentLab.font=[UIFont systemFontOfSize:15.0f];
    [self addSubview:lab];
    [self addSubview:contentLab];
    self.backgroundColor=[UIColor lightGrayColor];
    self.alpha=0.8;
}

-(void)ViewTipShow{
    AppDelegate *appDelegate = [AppDelegate appDelegate];
    [appDelegate.window addSubview:self];
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame=CGRectMake(0,0, SCREEN_WIDTH, 80);    } completion:^(BOOL finished) {
            [self ViewTipHidden];
        }];
}

-(void)ViewTipHidden{
    [UIView animateWithDuration:0.3f delay:2.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame=CGRectMake(0,-80, SCREEN_WIDTH, 80);   } completion:^(BOOL finished) {
        }];
}


@end
