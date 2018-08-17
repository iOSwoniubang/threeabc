//
//  HXMoreAddressCell.m
//  BaiMi
//
//  Created by HXMAC on 16/7/8.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXMoreAddressCell.h"
#import "Masonry.h"
@implementation HXMoreAddressCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        __weak typeof (self)weakSelf = self;
        self.iconImageView = [[UIImageView alloc]init];
        [self.iconImageView setImage:[UIImage imageNamed:@"ico_weixuan.png"]];
        [self addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).with.offset(5);
            make.top.equalTo(weakSelf).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).with.offset(10);
            make.top.equalTo(weakSelf).with.offset(5);
            make.size.mas_equalTo(CGSizeMake(100, 18));
        }];
        
        self.addressLabel = [[UILabel alloc]init];
        self.addressLabel.textAlignment = NSTextAlignmentLeft;
        self.addressLabel.font = [UIFont systemFontOfSize:14];
        self.addressLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:self.addressLabel];
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).with.offset(10);
            make.bottom.equalTo(weakSelf).with.offset(-5);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 100, 20));
        }];
       
//        self.deleteImageView = [[UIImageView alloc]init];
//        self.deleteImageView.userInteractionEnabled = YES;
//        [self.deleteImageView setImage:[UIImage imageNamed:@"ico_laji.png"]];
//        [self addSubview:self.deleteImageView];
//        [self.deleteImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(weakSelf).with.offset(-5);
//            make.top.equalTo(weakSelf).with.offset(10);
//            make.size.mas_equalTo(CGSizeMake(25, 25));
//        }];
        
        self.editImageView = [[UIImageView alloc]init];
        [self.editImageView setImage:[UIImage imageNamed:@"ico_gai.png"]];
        self.editImageView.userInteractionEnabled = YES;
        [self addSubview:self.editImageView];
        [self.editImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf).with.offset(-5);
            make.top.equalTo(weakSelf).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        self.phoneLabel = [[UILabel alloc]init];
        self.phoneLabel.textAlignment = NSTextAlignmentCenter;
        self.phoneLabel.textColor = [UIColor blackColor];
        self.phoneLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.phoneLabel];
        [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).with.offset(5);
            make.right.equalTo(self.editImageView.mas_left).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(100, 18));
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
