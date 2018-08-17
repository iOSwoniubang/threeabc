//
//  HXLogisticTraceCell.m
//  BaiMi
//
//  Created by licl on 16/7/14.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXLogisticTraceCell.h"

@implementation HXLogisticTraceCell

-(id)initWithFrame:(CGRect)frame Trace:(HXLogisticTrace*)trace{
    self=[super initWithFrame:frame];
    if (self) {
    self.frame=frame;
    int origonX=40;
    _stationLab=[[UILabel alloc] initWithFrame:CGRectMake(origonX, 10, self.frame.size.width-origonX-10, 21)];
    _stationLab.font=[UIFont systemFontOfSize:14.f];
    _stationLab.numberOfLines=0;
    CGRect rect=_stationLab.frame;
    float height=STRING_SIZE_FONT(self.frame.size.width-50, trace.acceptStation, 14.f).height;
    rect.size.height=height>21?height:21;
    _stationLab.frame=rect;
    [self addSubview:_stationLab];
    _timeLab=[[UILabel alloc] initWithFrame:CGRectMake(origonX, ViewFrameY_H(_stationLab), _stationLab.frame.size.width, 21)];
    _timeLab.font=[UIFont systemFontOfSize:12.F];
    _timeLab.textColor=[UIColor grayColor];
    [self addSubview:_timeLab];
        CGRect rect1=self.frame;
        rect1.size.height=ViewFrameY_H(_timeLab)+10;
        self.frame=rect1;
    }
    _volumnline=[[UIView alloc] initWithFrame:CGRectMake(19.5, 0, 1, self.frame.size.height)];
    _volumnline.backgroundColor=BolderColor;
    [self addSubview:_volumnline];
    
    _iconImgView=[[UIImageView alloc] initWithFrame:CGRectMake(14, self.frame.size.height/2-16/2, 12, 12)];
    _iconImgView.image=[UIImage imageNamed:@"icon_point.png"];
    [self addSubview:_iconImgView];
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
