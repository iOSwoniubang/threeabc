//
//  HXPersonHeadCollectionCell.m
//  BaiMi
//
//  Created by HXMAC on 16/7/20.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXPersonHeadCollectionCell.h"
#import "Masonry.h"
@implementation HXPersonHeadCollectionCell
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        for (UIView *subView in [self subviews]) {
            [subView removeFromSuperview];
        }
        __weak typeof (self)weakSelf = self;
        self.iconImageView = [[UIImageView alloc]init];
        [self addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).with.offset(10);
            make.top.equalTo(weakSelf).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.textColor = [UIColor grayColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).with.offset(22);
            make.left.equalTo(self.iconImageView.mas_right).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(frame.size.width - 35, 20));
        }];
        
        self.infoLabel = [[UILabel alloc]init];
        self.infoLabel.font = [UIFont systemFontOfSize:14];
        self.infoLabel.textColor = [UIColor blackColor];
        self.infoLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.infoLabel];
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf).with.offset(-5);
            make.right.equalTo(weakSelf).with.offset(-5);
            make.size.mas_equalTo(CGSizeMake(frame.size.width, 25));
        }];
    }
    return self;
}

@end
