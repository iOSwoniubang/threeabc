//
//  HXConsumeCell.m
//  BaiMi
//
//  Created by licl on 16/7/6.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXConsumeCell.h"

@implementation HXConsumeCell


-(id)init{
    self=[super init];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.frame=CGRectMake(0, 0, SCREEN_WIDTH, 72);
        UIFont*myFont=[UIFont systemFontOfSize:14];

//        self.feeLab=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-5-50,self.frame.size.height/2-21/2 , 50, 21)];
//        self.feeLab.textColor=LightBlueColor;
//        self.feeLab.textAlignment=NSTextAlignmentRight;
//        self.feeLab.font=myFont;
//        [self addSubview:self.feeLab];
//        
//        UIView*volumnLine=[[UIView alloc] initWithFrame:CGRectMake(ViewFrame_X(self.feeLab)-6, 10, 1, self.frame.size.height-20)];
//        volumnLine.backgroundColor=BolderColor;
//        [self addSubview:volumnLine];
//        
//        self.packageNameLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrame_X(volumnLine)-5-100, 10, 100, 21)];
//        self.packageNameLab.font=myFont;
//        self.packageNameLab.textAlignment=NSTextAlignmentLeft;
//        [self addSubview:self.packageNameLab];
//        self.timeLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrame_X(self.packageNameLab),ViewFrameY_H(self.packageNameLab)+5, 100, 21)];
//        self.timeLab.font=myFont;
//        self.timeLab.textAlignment=NSTextAlignmentLeft;
//        self.timeLab.textColor=[UIColor grayColor];
//        [self addSubview:self.timeLab];
//        self.noLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 10,ViewFrame_X(self.packageNameLab)-5-10, 21)];
//        self.noLab.font=myFont;
//        self.noLab.textAlignment=NSTextAlignmentLeft;
//        [self addSubview:self.noLab];
//        self.positionLab=[[UILabel alloc] initWithFrame:CGRectMake(10, ViewFrameY_H(self.noLab)+5,self.noLab.frame.size.width, 21)];
//        self.positionLab.textAlignment=NSTextAlignmentLeft;
//        self.positionLab.font=myFont;
//        self.positionLab.textColor=[UIColor grayColor];
//        [self addSubview:self.positionLab];
        
        
        self.feeLab=[[UILabel alloc] initWithFrame:CGRectMake(5,self.frame.size.height/2-21/2 , 55, 21)];
        self.feeLab.textColor=LightBlueColor;
        self.feeLab.textAlignment=NSTextAlignmentCenter;
        self.feeLab.font=myFont;
        [self addSubview:self.feeLab];
        
        self.noLab=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-5-100, self.frame.size.height/2-30/2,100, 30)];
        self.noLab.font=myFont;
        self.noLab.textColor=LightBlueColor;
        self.noLab.textAlignment=NSTextAlignmentCenter;
        self.noLab.layer.cornerRadius=self.noLab.frame.size.height/2;
        self.noLab.layer.borderColor=LightBlueColor.CGColor;
        self.noLab.layer.borderWidth=1;
        [self addSubview:self.noLab];

        int middleWidth=SCREEN_WIDTH-60-105-6;
        self.positionLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(self.feeLab)+3, 10,middleWidth,21)];
        self.positionLab.textAlignment=NSTextAlignmentLeft;
        self.positionLab.font=myFont;
        self.positionLab.textColor=[UIColor grayColor];
        [self addSubview:self.positionLab];

        
        self.packageNameLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrame_X(self.positionLab), ViewFrameY_H(self.positionLab)+5, 100, 21)];
        self.packageNameLab.font=myFont;
        self.packageNameLab.textColor=[UIColor grayColor];
        self.packageNameLab.textAlignment=NSTextAlignmentLeft;
        [self addSubview:self.packageNameLab];
        
        self.timeLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(self.packageNameLab)+3,ViewFrame_Y(self.packageNameLab), 100, 21)];
        if (SCREEN_HEIGHT<iPhone6) {
            CGRect frame1=CGRectMake(ViewFrame_X(self.packageNameLab),ViewFrameY_H(self.packageNameLab)+5, 100, 21);
            CGRect rect=self.frame;
            self.timeLab.frame=frame1;
            rect.size.height=rect.size.height+21;
            self.frame=rect;
        }
        self.timeLab.font=myFont;
        self.timeLab.textAlignment=NSTextAlignmentLeft;
        self.timeLab.textColor=[UIColor grayColor];
        [self addSubview:self.timeLab];

//        self.noLab.backgroundColor=[UIColor redColor];
//        self.positionLab.backgroundColor=[UIColor greenColor];
//        self.packageNameLab.backgroundColor=[UIColor yellowColor];
//        self.timeLab.backgroundColor=[UIColor redColor];
//        self.feeLab.backgroundColor=[UIColor redColor];
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
