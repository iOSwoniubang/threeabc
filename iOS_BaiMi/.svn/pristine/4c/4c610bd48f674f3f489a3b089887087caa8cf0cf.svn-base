//
//  HXPersonHeadCell.h
//  BaiMi
//
//  Created by HXMAC on 16/7/7.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXPersonHeadCellDelegate <NSObject>

- (void)headCellSelected:(UITapGestureRecognizer *)tap;

@end

@interface HXPersonHeadCell : UITableViewCell
@property(nonatomic,strong) UIImageView *iconImageView;//个人头像
@property(nonatomic,strong) UILabel *personNameLabel;//昵称
@property(nonatomic,strong) UIImageView *editImageView;//编辑
@property(nonatomic,strong) UIImageView *renzhengImageView;//实名认证
@property(nonatomic,strong) UIImageView *addressImageView;//常用地址
@property(nonatomic,strong) UIImageView *personMoneyImageView;//个人财富

@property (weak,nonatomic) id<HXPersonHeadCellDelegate> delegate;

@end
