//
//  HXPersonMoneyCollectionCell.m
//  BaiMi
//
//  Created by HXMAC on 16/7/20.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXPersonMoneyCollectionCell.h"
#import "Masonry.h"
@implementation HXPersonMoneyCollectionCell
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
            make.centerX.equalTo(weakSelf);
            make.top.equalTo(weakSelf).with.offset(40/3);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.top.equalTo(self.iconImageView.mas_bottom).with.offset(40/3);
            make.size.mas_equalTo(CGSizeMake(frame.size.width, 20));
        }];
    }
    return self;
}
@end
