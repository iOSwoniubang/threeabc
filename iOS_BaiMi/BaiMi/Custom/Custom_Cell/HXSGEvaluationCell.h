//
//  HXSGEvaluationCell.h
//  BaiMi
//
//  Created by 王放 on 16/7/11.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSGEvaluationCell : UITableViewCell
@property(assign,nonatomic)BOOL isHeadCell;
@property (nonatomic,strong)UIImageView *iconImageView;//头像
@property (nonatomic,strong)UIImageView *topImageView;//顶
@property (nonatomic,strong)UIImageView *stepImageView;//踩
@property (nonatomic,strong)UILabel *sGNameLabel;//昵称
//@property (nonatomic,strong)UILabel *phoneLabel;//评价时间
@property (nonatomic,strong)UILabel *evaluationTimeLabel;//评价时间
//@property (nonatomic,strong)UILabel *remarkLabel;//备注
//@property (nonatomic,strong)UILabel *topLabel;//顶
//@property (nonatomic,strong)UILabel *stepLabel;//踩

@end
