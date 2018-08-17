//
//  HXMyConsumptionCell.m
//  BaiMi
//
//  Created by 王放 on 16/7/9.
//  Copyright © 2016年 licl. All rights reserved.
//
#define TXTFONT [UIFont systemFontOfSize:14.]
#define WIDOFTXT 10
#import "HXMyConsumptionCell.h"

@implementation HXMyConsumptionCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(WIDOFTXT, 28, SCREEN_WIDTH - WIDOFTXT * 2.0, 2)];
        labelLine.backgroundColor = BackGroundColor;
        [self addSubview:labelLine];
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(WIDOFTXT, 30, 60, 40)];
        labelTitle.text = @"订单号：";
        labelTitle.font = TXTFONT;
        [self addSubview:labelTitle];
        
    }
    
    return self;
}
-(UILabel *)createTimeLabel{
    if (!_createTimeLabel) {
        _createTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDOFTXT, 0, SCREEN_WIDTH, 28)];
        _createTimeLabel.font = TXTFONT;
        [self addSubview:_createTimeLabel];
    }
    return _createTimeLabel;
}
-(UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, SCREEN_WIDTH - 210, 28)];
        _remarkLabel.font = TXTFONT;
        _remarkLabel.textAlignment = NSTextAlignmentRight;
        _remarkLabel.textColor = [UIColor orangeColor];
        [self addSubview:_remarkLabel];
    }
    return _remarkLabel;
}
-(UILabel *)businessNoLabel{
    if (!_businessNoLabel) {
        _businessNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDOFTXT+50, 30, SCREEN_WIDTH - (WIDOFTXT+60), 40)];
        _businessNoLabel.font = TXTFONT;
        [self addSubview:_businessNoLabel];
    }
    return _businessNoLabel;
}
-(UILabel *)businessTypeLabel{
    if (!_businessTypeLabel) {
        _businessTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDOFTXT, 30+40, SCREEN_WIDTH, 30)];
        _businessTypeLabel.font = [UIFont systemFontOfSize:16.];
        [self addSubview:_businessTypeLabel];
    }
    return _businessTypeLabel;
}
-(UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 30, SCREEN_WIDTH-210, 80)];
        _amountLabel.textColor = [UIColor redColor];
        _amountLabel.textAlignment = NSTextAlignmentRight;
        _amountLabel.font = [UIFont systemFontOfSize:30];
        [self addSubview:_amountLabel];
    }
    return _amountLabel;
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
