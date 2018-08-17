//
//  HXTaskCell.h
//  BaiMi
//
//  Created by 王放 on 16/7/8.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXTaskCell : UITableViewCell
@property (nonatomic,strong)UIImageView *iconImageView;//
@property (nonatomic,strong)UILabel *feeLabel;//费用
@property (nonatomic,strong)UILabel *weightLabel;//重量
@property (nonatomic,strong)UILabel *sourceLabel;//取件
@property (nonatomic,strong)UILabel *targetLabel;//收件
@property (nonatomic,strong)UILabel *remainingTimeLabel;//剩余时间
@property (nonatomic,strong)UILabel *remarkLabel;//备注
@property (nonatomic,strong)UILabel *labelTask;
@end
