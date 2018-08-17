//
//  HXPackageCell.m
//  BaiMi
//
//  Created by licl on 16/7/9.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXPackageCell.h"

@implementation HXPackageCell


-(id)initWithFrame:(CGRect)frame Style:(HXStyle)style{
    self=[super initWithFrame:frame];
    if (self) {
        self.frame=frame;
        self.backgroundColor=[UIColor whiteColor];
        
        int imgViewWidth=0;
        int imgSepY=0;
        if (style==HXStylePackage) {
            imgViewWidth=8;
            imgSepY=-2;
        }else{
            imgViewWidth=30;
            imgSepY=0;
        }
        self.imgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, self.frame.size.height/2-imgViewWidth/2+imgSepY, imgViewWidth, imgViewWidth)];
        [self addSubview:self.imgView];

        self.titleLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(self.imgView)+10, self.frame.size.height/2-10.5, self.frame.size.width-10-20-100-26, 21)];
        [self addSubview:self.titleLab];

        self.selImgView=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-26-10, self.frame.size.height/2-13, 26, 26)];
        [self addSubview:self.selImgView];

        self.feeLab=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-self.imgView.frame.size.width-self.titleLab.frame.size.width-10, self.titleLab.frame.origin.y, 100, 21)];
        [self addSubview:self.feeLab];
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
