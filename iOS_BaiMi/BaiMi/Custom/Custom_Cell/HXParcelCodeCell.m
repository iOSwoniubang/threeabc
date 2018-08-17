//
//  HXParcelCodeCell.m
//  BaiMi
//
//  Created by licl on 16/7/12.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXParcelCodeCell.h"

@implementation HXParcelCodeCell

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.frame=CGRectMake(0, 0, SCREEN_WIDTH, 230);
        self.backgroundColor=BackGroundColor;
        UIView*bgView=[[UIView alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width-20, self.frame.size.height-10)];
        bgView.backgroundColor=[UIColor whiteColor];
        bgView.layer.cornerRadius=10;
        bgView.layer.borderColor=LightBlueColor.CGColor;
        bgView.layer.borderWidth=1;
        bgView.clipsToBounds=YES;
        _barCodeImgView=[[UIImageView alloc] initWithFrame:CGRectMake(bgView.frame.size.width/2-150/2,10, 150, 50)];
        [bgView addSubview:_barCodeImgView];
        _codeLab=[[UILabel alloc] initWithFrame:CGRectMake(bgView.frame.size.width/2-200/2, ViewFrameY_H(_barCodeImgView), 200, 20)];
        _codeLab.textAlignment=NSTextAlignmentCenter;
        [bgView addSubview:_codeLab];
        
        _qrCodeImgView=[[UIImageView alloc] initWithFrame:CGRectMake(bgView.frame.size.width/2-80/2, ViewFrameY_H(_codeLab)+10,80, 80)];
        [bgView addSubview:_qrCodeImgView];
        
        UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(0, ViewFrameY_H(_qrCodeImgView)+10, bgView.frame.size.width, 21)];
        label.text=@"使用扫一扫,快速轻松取。更多方便,更多安全。";
        label.textColor=LightBlueColor;
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:13.f];
        [bgView addSubview:label];

        [self addSubview:bgView];

    }
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
