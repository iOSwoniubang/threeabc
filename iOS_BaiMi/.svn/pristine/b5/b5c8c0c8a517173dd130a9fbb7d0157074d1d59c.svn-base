//
//  HXLoadingImageView.m
//  Health
//
//  Created by wade on 15/12/21.
//  Copyright (c) 2015年 海象. All rights reserved.
//

#import "HXLoadingImageView.h"
@implementation HXLoadingImageView
+ (void)showLoadingView:(UIView *)view{
    UIImageView* mainImageView= [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40, (SCREEN_HEIGHT - 64 - 50)/2 - 40, 80, 80)];
    mainImageView.animationImages = [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"loading_1.png"],
                                     [UIImage imageNamed:@"loading_2.png"],
                                     [UIImage imageNamed:@"loading_3.png"],
                                     [UIImage imageNamed:@"loading_4.png"],
                                     [UIImage imageNamed:@"loading_5.png"],
                                     [UIImage imageNamed:@"loading_6.png"],
                                     [UIImage imageNamed:@"loading_7.png"],
                                     [UIImage imageNamed:@"loading_8.png"],nil];
    mainImageView.tag = 10000;
    [mainImageView setAnimationDuration:2.0f];
    [mainImageView setAnimationRepeatCount:0];
    [mainImageView startAnimating];
    [view addSubview:mainImageView];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.backgroundColor = [UIColor lightGrayColor];
    backView.alpha = 0.8;
    backView.tag = 10001;
    [view bringSubviewToFront:backView];
    [view addSubview:backView];
    
}
+ (void)hideViewForView:(UIView *)view {
    UIImageView *imageView = (UIImageView *)[view viewWithTag:10000];
    [imageView stopAnimating];
    [imageView removeFromSuperview];
    
    UIView *backView = [view viewWithTag:10001];
    [backView removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
