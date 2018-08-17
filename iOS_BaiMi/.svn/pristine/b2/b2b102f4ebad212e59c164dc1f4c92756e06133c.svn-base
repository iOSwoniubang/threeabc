//
//  HXPersonHeadCell.m
//  BaiMi
//
//  Created by HXMAC on 16/7/7.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXPersonHeadCell.h"
#import "Masonry.h"
@implementation HXPersonHeadCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        __weak typeof (self) weakself = self;
        
//        UINavigationBar *bar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 64)];
//        bar.backgroundColor = LightBlueColor;
//        
//        [self.superview addSubview:bar];
        UIView *headView = [[UIView alloc]init];
        headView.layer.borderWidth = 0.1;
        headView.layer.borderColor = LightBlueColor.CGColor;
        headView.backgroundColor = LightBlueColor;
        [self addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakself);
            make.top.equalTo(weakself).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 110 + 64));
        }];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.backgroundColor =[UIColor clearColor];
        titleLabel.text = @"个人中心";
        titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakself).with.offset(0);
            make.top.equalTo(weakself).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 64));
        }];
        
        
        self.iconImageView = [[UIImageView alloc]init];
        self.iconImageView.layer.masksToBounds = YES;
        self.iconImageView.layer.cornerRadius = 40;
//        [self.iconImageView setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"defaultImg.png"]];
        [self addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 80));
            make.left.equalTo(weakself).with.offset(10);
            make.top.equalTo(weakself).with.offset(10);
        }];
        
        self.personNameLabel = [[UILabel alloc]init];
        self.personNameLabel.font = [UIFont systemFontOfSize:14];
        self.personNameLabel.textColor = [UIColor redColor];
        self.personNameLabel.text = @"用户昵称";
        self.personNameLabel.textAlignment = NSTextAlignmentLeft;
        [headView addSubview:_personNameLabel];
        [_personNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImageView.mas_right).with.offset(10);
            make.top.equalTo(weakself).with.offset(60);
            make.size.mas_equalTo(CGSizeMake(150, 20));
        }];
        
        UIImageView *editImageView = [[UIImageView alloc]init];
        editImageView.userInteractionEnabled = YES;
        editImageView.tag = 100;
        [editImageView setImage:[UIImage imageNamed:@"edit.png"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTarget:)];
        [editImageView addGestureRecognizer:tap];
        [self addSubview:editImageView];
        [editImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headView);
            make.right.equalTo(weakself).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        UIView *secondView = [[UIView alloc]init];
        secondView.backgroundColor = [UIColor whiteColor];
        [self addSubview:secondView];
        [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 80));
            make.left.equalTo(weakself).with.offset(0);
            make.top.equalTo(headView.mas_bottom).with.offset(0);
        }];
        
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = BackGroundColor;
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(secondView.mas_bottom).with.offset(0);
            make.left.equalTo(weakself).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 20));
        }];
        
        for (int i = 0; i < 3; i ++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.userInteractionEnabled= YES;
            imageView.tag = 101 + i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTarget:)];
            [imageView addGestureRecognizer:tap];
            [secondView addSubview:imageView];
            switch (i) {
                case 0:
                {
                    [imageView setImage:[UIImage imageNamed:@"renzheng.png"]];
                    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(weakself).with.offset(20);
                        make.top.equalTo(headView.mas_bottom).with.offset(5);
                        make.size.mas_equalTo(CGSizeMake(70, 70));
                    }];
                }
                    break;
                case 1:
                {
                    [imageView setImage:[UIImage imageNamed:@"address.png"]];
                    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.equalTo(secondView);
                        make.top.equalTo(headView.mas_bottom).with.offset(5);
                        make.size.mas_equalTo(CGSizeMake(70, 70));
                    }];
                }
                    break;
                case 2:
                {
                    [imageView setImage:[UIImage imageNamed:@"money.png"]];
                    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.width.offset(-30);
                        make.top.equalTo(headView.mas_bottom).with.offset(5);
                        make.size.mas_equalTo(CGSizeMake(70, 70));
                    }];
                }
                    break;
                default:
                    break;
            }
        }

    }
    return self;
}
- (void)imageTarget:(UITapGestureRecognizer *)tap{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(headCellSelected:)]) {
        [self.delegate performSelector:@selector(headCellSelected:) withObject:tap];
    }
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
