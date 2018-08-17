//
//  HXPersonTableViewCell.m
//  BaiMi
//
//  Created by HXMAC on 16/7/6.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXPersonTableViewCell.h"
#import "Masonry.h"
@implementation HXPersonTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconImageView = [[UIImageView alloc]init];
        [self addSubview:self.iconImageView];
        __weak typeof (self) weakSelf = self;
//        if (indexPath.row == 3 || indexPath.row == 4) {
//            [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(weakSelf).with.offset(20);
//                make.top.equalTo(weakSelf).with.offset(8);
//                make.size.mas_equalTo(CGSizeMake(28, 28));
//               }];
//
//        }else
//        {
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).with.offset(20);
            make.top.equalTo(weakSelf).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];
            
//        }
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).with.offset(10);
            make.top.equalTo(weakSelf).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(150, 24));
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
