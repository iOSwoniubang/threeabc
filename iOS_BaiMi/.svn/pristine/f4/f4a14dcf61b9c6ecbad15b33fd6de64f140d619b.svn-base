//
//  HXCouponCell.m
//  BaiMi
//
//  Created by HXMAC on 16/7/13.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXCouponCell.h"
#import "Masonry.h"
@implementation HXCouponCell

-(id)initWithCouponValueStr:(NSString*)valueStr selectStyle:(BOOL)isSelectStyle{
    self=[super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 130);
        self.backgroundColor=BackGroundColor;
        UIView*bgView=[[UIView alloc] initWithFrame:CGRectMake(5, 20, SCREEN_WIDTH-10, 110)];
        bgView.backgroundColor=BackGroundColor;
        [self addSubview:bgView];

        if (isSelectStyle) {
            bgView.frame=CGRectMake(10, 20, SCREEN_WIDTH-60, 110);
            self.seleImgView=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, self.frame.size.height/2-30/2, 30, 30)];
            [self addSubview:self.seleImgView];
        }
        __weak typeof (bgView)weakSelf = bgView;
        self.backImageView = [[UIImageView alloc]init];
        [bgView addSubview:self.backImageView];
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).with.offset(0);
            make.left.equalTo (weakSelf).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(ViewFrame_W(bgView), ViewFrame_H(bgView)));
        }];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).with.offset(0);
            make.left.equalTo(weakSelf).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(100, 30));
        }];
        
        self.moneyLabel = [[UILabel alloc]init];
        self.moneyLabel.textColor = [UIColor whiteColor];
        self.moneyLabel.font = [UIFont systemFontOfSize:16];
        self.moneyLabel.textAlignment = NSTextAlignmentLeft;
        NSString*feeStr=[NSString stringWithFormat:@"￥ %@",valueStr];
        NSMutableAttributedString*atr=[[NSMutableAttributedString alloc] initWithString:feeStr];
        NSRange range=[feeStr rangeOfString:@"￥"];
        [atr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:28.f]}  range:NSMakeRange(range.length,feeStr.length-range.length)];
        self.moneyLabel.attributedText=atr;
        [bgView addSubview:self.moneyLabel];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
            make.left.equalTo(weakSelf).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(ViewFrame_W(bgView) * 0.55 - 25, 30));
        }];
        
        self.userTyleLabel = [[UILabel alloc]init];
        self.userTyleLabel.textAlignment = NSTextAlignmentLeft;
        self.userTyleLabel.textColor = [UIColor whiteColor];
        self.userTyleLabel.font = [UIFont systemFontOfSize:16];
        [bgView addSubview:self.userTyleLabel];
        [self.userTyleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf).with.offset(-5);
            make.left.equalTo(weakSelf).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(100, 30));
        }];
        
        self.timeOutLabel = [[UILabel alloc]init];
        self.timeOutLabel.textColor = [UIColor grayColor];
        self.timeOutLabel.textAlignment = NSTextAlignmentCenter;
        self.timeOutLabel.font = [UIFont systemFontOfSize:12.f];
        self.timeOutLabel.numberOfLines = 0;
        [bgView addSubview:self.timeOutLabel];
        [self.timeOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).with.offset(0);
            make.right.equalTo(weakSelf).with.offset(0);
            if (isSelectStyle)
                make.size.mas_equalTo(CGSizeMake(ViewFrame_W(bgView) * 0.42, 80));
            else
                make.size.mas_equalTo(CGSizeMake(ViewFrame_W(bgView) * 0.42, 50));
   
        }];
        
        self.userTimeLabel = [[UILabel alloc]init];
        self.userTimeLabel.textColor = LightBlueColor;
        self.userTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.userTimeLabel.numberOfLines = 0;
        self.userTimeLabel.font = [UIFont systemFontOfSize:12.0f];
        [bgView addSubview:self.userTimeLabel];
        [self.userTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeOutLabel.mas_bottom).with.offset(0);
            make.right.equalTo(weakSelf).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(ViewFrame_W(bgView) * 0.42, 30));
        }];
        
        self.infoLabel = [[UILabel alloc]init];
        self.infoLabel.textColor = [UIColor grayColor];
        self.infoLabel.textAlignment = NSTextAlignmentCenter;
        self.infoLabel.font = [UIFont systemFontOfSize:12.f];
        self.infoLabel.numberOfLines = 0;
        [bgView addSubview:self.infoLabel];
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf).with.offset(0);
            make.right.equalTo(weakSelf).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(ViewFrame_W(bgView)* 0.42 - 10, 30));
        }];
        
    }
    return self;
}


//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 130);
//        self.backgroundColor=BackGroundColor;
//        UIView*bgView=[[UIView alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 110)];
//        bgView.backgroundColor=BackGroundColor;
//        [self addSubview:bgView];
////        __weak typeof (self)weakSelf = self;
//        __weak typeof (bgView)weakSelf = bgView;
//        self.backImageView = [[UIImageView alloc]init];
////        [self addSubview:self.backImageView];
//         [bgView addSubview:self.backImageView];
//        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(weakSelf).with.offset(0);
//            make.left.equalTo (weakSelf).with.offset(0);
//            make.size.mas_equalTo(CGSizeMake(ViewFrame_W(bgView), ViewFrame_H(bgView)));
//        }];
//        
//        self.titleLabel = [[UILabel alloc]init];
//        self.titleLabel.textColor = [UIColor whiteColor];
//        self.titleLabel.font = [UIFont systemFontOfSize:16];
//        self.titleLabel.textAlignment = NSTextAlignmentLeft;
//        [bgView addSubview:self.titleLabel];
//        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(weakSelf).with.offset(0);
//            make.left.equalTo(weakSelf).with.offset(20);
//            make.size.mas_equalTo(CGSizeMake(100, 30));
//        }];
//        
//        self.moneyLabel = [[UILabel alloc]init];
//        self.moneyLabel.textColor = [UIColor whiteColor];
//        self.moneyLabel.font = [UIFont systemFontOfSize:20];
//        self.moneyLabel.textAlignment = NSTextAlignmentLeft;
//        [bgView addSubview:self.moneyLabel];
//        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(0);
//            make.left.equalTo(weakSelf).with.offset(20);
//            make.size.mas_equalTo(CGSizeMake(ViewFrame_W(bgView) * 0.6 - 20, 60));
//        }];
//        
//        self.userTyleLabel = [[UILabel alloc]init];
//        self.userTyleLabel.textAlignment = NSTextAlignmentLeft;
//        self.userTyleLabel.textColor = [UIColor whiteColor];
//        self.userTyleLabel.font = [UIFont systemFontOfSize:16];
//        [bgView addSubview:self.userTyleLabel];
//        [self.userTyleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.moneyLabel.mas_bottom).with.offset(-10);
//            make.left.equalTo(weakSelf).with.offset(20);
//            make.size.mas_equalTo(CGSizeMake(100, 30));
//        }];
//        
//        self.timeOutLabel = [[UILabel alloc]init];
//        self.timeOutLabel.textColor = [UIColor grayColor];
//        self.timeOutLabel.textAlignment = NSTextAlignmentCenter;
//        self.timeOutLabel.font = [UIFont systemFontOfSize:12.f];
//        self.timeOutLabel.numberOfLines = 0;
//        [bgView addSubview:self.timeOutLabel];
//        [self.timeOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(weakSelf).with.offset(-5);
//            make.right.equalTo(weakSelf).with.offset(0);
//            make.size.mas_equalTo(CGSizeMake(ViewFrame_W(bgView) * 0.4, 60));
//        }];
//        
//        self.infoLabel = [[UILabel alloc]init];
//        self.infoLabel.textColor = [UIColor grayColor];
//        self.infoLabel.textAlignment = NSTextAlignmentLeft;
//        self.infoLabel.font = [UIFont systemFontOfSize:12.f];
//        self.infoLabel.numberOfLines = 0;
//        [bgView addSubview:self.infoLabel];
//        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(weakSelf).with.offset(0);
//            make.right.equalTo(weakSelf).with.offset(-5);
//            make.size.mas_equalTo(CGSizeMake(ViewFrame_W(bgView)* 0.4 - 10, 60));
//        }];
//        
//    }
//    return self;
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
