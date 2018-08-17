//
//  HXCertificationTableViewCell.m
//  BaiMi
//
//  Created by HXMAC on 16/7/7.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXCertificationTableViewCell.h"
#import "Masonry.h"
@implementation HXCertificationTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconImageView = [[UIImageView alloc]init];
        [self addSubview:self.iconImageView];
        __weak typeof (self) weakSelf = self;
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).with.offset(10);
            make.top.equalTo(weakSelf).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = [UIColor lightGrayColor];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).with.offset(20);
            make.top.equalTo(weakSelf).with.offset(5);
            make.size.mas_equalTo(CGSizeMake(100, 20));
        }];
        
        self.contentTF = [[UITextField alloc]init];
        self.contentTF.font = [UIFont systemFontOfSize:16];
//        self.contentTF.textColor = [UIColor grayColor];
        [self addSubview:self.contentTF];
        [self.contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).with.offset(20);
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 100, 30));
        }];
        self.biaozhiImageView = [[UIImageView alloc]init];
        [self addSubview:self.biaozhiImageView];
        [self.biaozhiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf).with.offset(-10);
            make.centerY.equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
