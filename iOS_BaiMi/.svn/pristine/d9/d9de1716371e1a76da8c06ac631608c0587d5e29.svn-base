//
//
//  HXSGCertificationCell.m
//  BaiMi
//
//  Created by 王放 on 16/7/11.
//  Copyright © 2016年 licl. All rights reserved.
//
#define CELLHIGH 44
#import "HXSGCertificationCell.h"

@implementation HXSGCertificationCell

-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(_weatherCertification?10:20, 0, 100, CELLHIGH)];
        _title.textColor = [UIColor lightGrayColor];
        [self addSubview:_title];
    }
    return _title;
}
-(UITextField *)sGTextField{
    if (!_sGTextField) {
        _sGTextField = [[UITextField alloc] initWithFrame:CGRectMake(ViewFrame_X(_title)+20 + STRING_SIZE_FONT(500,_title.text,17).width, 0, 200, CELLHIGH)];
        if (_weatherCertification) {
            _sGTextField.enabled = NO;
        }
        [self addSubview:_sGTextField];
    }
    return _sGTextField;
}
-(UIImageView *)certificationImageView{
    if (!_certificationImageView) {
        _certificationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 7, 20, 30)];
        
        [self addSubview:_certificationImageView];
    }
    return _certificationImageView;
}
-(UILabel *)certificationLabel{
    if (!_certificationLabel) {
        _certificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 0, 60, CELLHIGH)];
        _certificationLabel.textColor = [UIColor greenColor];
        [self addSubview:_certificationLabel];
    }
    return _certificationLabel;
}
-(UIImageView *)studentImageView{
    if (!_studentImageView) {
        _studentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, CELLHIGH, 80 , 80)];
        _studentImageView.userInteractionEnabled = YES;
        [self addSubview:_studentImageView];
    }
    return _studentImageView;
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
