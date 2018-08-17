//
//  HXShowImageView.m
//  BaiMi
//
//  Created by HXMAC on 16/7/8.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXShowImageView.h"
#import "Masonry.h"
@implementation HXShowImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

          }
    return self;
}
- (void)drawRect:(CGRect)rect{
    __weak typeof (self) weakSelf = self;
//    self.alpha = 0.8;
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor blackColor];
    headView.alpha = 0.6;
    [self addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(0);
        make.top.equalTo(weakSelf).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 150));
    }];
    
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor blackColor];
    footView.alpha = 0.6;
    [self addSubview:footView];
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(0);
        make.top.equalTo(weakSelf).with.offset(410);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 410));
    }];
    
    self.backImageView = [[UIImageView alloc]init];
    [self.backImageView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.backImageView];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(0);
        make.top.equalTo(weakSelf).with.offset(150);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 200));
    }];
    
    
    
    self.noLabel = [[UILabel alloc]init];
    self.noLabel.text = @"还没有照片哦～";
    self.noLabel.backgroundColor = [UIColor whiteColor];
    self.noLabel.textAlignment = NSTextAlignmentCenter;
    self.noLabel.textColor = [UIColor lightGrayColor];
    self.noLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.noLabel];
    self.noLabel.hidden = YES;
    [self.noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(0);
        make.top.equalTo(weakSelf).with.offset(150);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 200));
    }];
    
    NSArray *titleArray = @[@"选择本地照片",@"拍照",@"保存",@"取消"];
    for (int i = 0; i < 4; i ++) {
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [myButton setBackgroundColor:[UIColor whiteColor]];
        [myButton setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [myButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [myButton setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:myButton];
        myButton.tag = 100+i;
        [myButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [myButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.backImageView.mas_bottom).with.offset(i/2 * 30);
            make.left.equalTo(weakSelf).with.offset(i % 2 * (SCREEN_WIDTH/2));
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, 30));
        }];
    }
}
- (void)buttonClick:(UIButton *)button{
    self.returnButtonBlock(button);
}
- (void)getButtonBlock:(returnBlock)block{
    self.returnButtonBlock = block;
}
@end
