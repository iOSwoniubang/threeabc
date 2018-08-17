//
//  HXSGEvaluationCell.m
//  BaiMi
//
//  Created by 王放 on 16/7/11.
//  Copyright © 2016年 licl. All rights reserved.
//
#define CELLH 60
#define INTEAVAL 10
#define TXTFONT [UIFont systemFontOfSize:13.]
#import "HXSGEvaluationCell.h"

@implementation HXSGEvaluationCell

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.clipsToBounds = YES;
        _iconImageView.frame = CGRectMake(INTEAVAL, 10, 40, 40);
        _iconImageView.layer.cornerRadius = 20;
        
        [self addSubview:_iconImageView];
    }
    return _iconImageView;
}
-(UILabel *)sGNameLabel{
    if (!_sGNameLabel) {
        _sGNameLabel = [[UILabel alloc] init];
        _sGNameLabel.frame = CGRectMake(INTEAVAL*2.0 + 40, 0, 150, 30);
        _sGNameLabel.font = [UIFont systemFontOfSize:15.];
        [self addSubview:_sGNameLabel];
    }
    return _sGNameLabel;
}
//-(UILabel *)phoneLabel{
//    if (!_phoneLabel) {
//        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(INTEAVAL*2.0 + CELLH - 10*2, 10 + (CELLH - 10*2)/2.0, 150, (CELLH - 10*2)/2.0)];
//        [self addSubview:_phoneLabel];
//        
//    }
//    return _phoneLabel;
//}

-(UILabel *)evaluationTimeLabel{
    if (!_evaluationTimeLabel) {
        _evaluationTimeLabel = [[UILabel alloc] init];
        _evaluationTimeLabel.font = TXTFONT;
        _evaluationTimeLabel.textColor = RGBA(131, 132, 133, 1);
        _evaluationTimeLabel.frame = CGRectMake(INTEAVAL*2.0 + 40, 30, 150, 30);

        [self addSubview:_evaluationTimeLabel];
    }
    return _evaluationTimeLabel;
}
//-(UILabel *)remarkLabel{
//    if (!_remarkLabel) {
//        _remarkLabel = [[UILabel alloc] init];
//        _remarkLabel.font = TXTFONT;
//        _remarkLabel.textColor = RGBA(235, 102, 102, 1);
//        if (_phoneLabel) {
//            _remarkLabel.frame = CGRectMake(INTEAVAL*2.0 + CELLH - 10*2, 10 + CELLH/2.0, 150, CELLH/2.0 - 10);
//        }else{
//            _remarkLabel.frame = CGRectMake(INTEAVAL*2.0 + CELLH - 10*2 - CELLH / 2.0 + CELLH / 2.0,  10 + CELLH/2.0, 150, CELLH/2.0 - 10);
//        }
//
//        [self addSubview:_remarkLabel];
//    }
//    return _remarkLabel;
//}
-(UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc]init];
        _topImageView.frame = CGRectMake(SCREEN_WIDTH - 20 - 20, (60-25)/2.0, 25, 25);
        [self addSubview:_topImageView];
    }
    return _topImageView;
}
//-(UILabel *)topLabel{
//    if (!_topLabel) {
//        _topLabel = [[UILabel alloc] init];
////        _topLabel.font = TXTFONT;
//        _topLabel.textAlignment = NSTextAlignmentCenter;
//        _topLabel.textColor = RGBA(235, 102, 102, 1);
//        if (_phoneLabel) {
//            _topLabel.frame = CGRectMake(SCREEN_WIDTH - 100 + CELLH / 4.0, 0, 50 - (CELLH / 4.0), CELLH);
//        }
//        [self addSubview:_topLabel];
//    }
//    return _topLabel;
//}

-(UIImageView *)stepImageView{
    if (!_stepImageView) {
        _stepImageView = [[UIImageView alloc]init];
        _stepImageView.frame = CGRectMake(SCREEN_WIDTH - 20 - 20, (60-25)/2.0, 25, 25);
        [self addSubview:_stepImageView];
    }
    return _stepImageView;
}
//-(UILabel *)stepLabel{
//    if (!_stepLabel) {
//        _stepLabel = [[UILabel alloc] init];
//        _stepLabel.textColor = RGBA(235, 102, 102, 1);
//        _stepLabel.textAlignment = NSTextAlignmentCenter;
//        if (_phoneLabel) {
//            _stepLabel.frame = CGRectMake(SCREEN_WIDTH - 50 + CELLH / 4.0, 0, 50 - (CELLH / 4.0), CELLH);
//        }
//        [self addSubview:_stepLabel];
//    }
//    return _stepLabel;
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
