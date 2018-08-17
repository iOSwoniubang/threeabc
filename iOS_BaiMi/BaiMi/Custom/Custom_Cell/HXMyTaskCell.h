//
//  HXMyTaskCell.h
//  BaiMi
//
//  Created by 王放 on 16/7/16.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HXMyTaskCell : UITableViewCell

@property (nonatomic,strong)UIImageView *iconImageView;//
@property (nonatomic,strong)UILabel *feeLabel;//费用
@property (nonatomic,strong)UILabel *weightLabel;//重量
@property (nonatomic,strong)UILabel *acceptTimeLabel;//接受任务时间
@property (nonatomic,strong)UILabel *completeTimeLabel;//完成任务时间
@property (nonatomic,strong)UILabel *sourceLabel;//取件
@property (nonatomic,strong)UILabel *targetLabel;//收件
@property (nonatomic,strong)UILabel *fetcherNickNameLabel;//发布人

@property (nonatomic,strong)UILabel *changeTitleLabel;//对应发布人留言等等
@property (nonatomic,strong)UILabel *publisherPhoneLabel;//发布人手机号
@property (nonatomic,strong)UIView *viewPhone;

@property (nonatomic,strong)UILabel *remainingTimeLabel;//剩余时间
@property (nonatomic,strong)UILabel *remarkLabel;//备注
@property (nonatomic,strong)UILabel *terminationLabel;//终止原因

//@property (nonatomic,strong)UILabel *labelTask;//师哥取消任务
//@property (nonatomic,strong)UIImageView *cancelTask;//发布人取消任务
//@property (nonatomic,strong)UIImageView *payTask;//发布人支付money
//@property (nonatomic,strong)UIView *viewShowBtn;


@property (nonatomic,strong)UIView *praiseView;//点赞
@property (nonatomic,strong)UIView *contemptView;//踩



@property (nonatomic,strong)UILabel * weatherClean;
@end
