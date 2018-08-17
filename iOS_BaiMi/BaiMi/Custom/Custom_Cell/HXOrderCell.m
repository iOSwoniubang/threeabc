//
//  HXOrderCell.m
//  BaiMi
//
//  Created by licl on 16/7/13.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXOrderCell.h"

@implementation HXOrderCell

-(id)initWithCellType:(HXParcelCellType)cellType{
    self=[super init];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        int origonY=0;
        if (cellType==HXCellTypeTwoLines){
            self.frame=CGRectMake(0, 0, SCREEN_WIDTH, 90);
            origonY=self.frame.size.height/2-60/2+5;
        }
        else{
            self.frame=CGRectMake(0, 0, SCREEN_WIDTH, 110);
            origonY=self.frame.size.height/2-60/2-5;
        }
        _iconImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, self.frame.size.height/2-60/2, 60, 60)];
        _iconImgView.layer.cornerRadius=_iconImgView.frame.size.height/2;
        _iconImgView.clipsToBounds=YES;
        [self addSubview:_iconImgView];
        
        int Width=SCREEN_WIDTH-ViewFrameX_W(_iconImgView)-20;

        int origonX=SCREEN_WIDTH-130;
        if (cellType==HXCellTypeSelectLines){
            origonX=SCREEN_WIDTH-170;
           _checkImgView=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-5-30, self.frame.size.height/2-30/2,30, 30)];
            _checkImgView.userInteractionEnabled=YES;
            [self addSubview:_checkImgView];
            Width=Width-_checkImgView.frame.size.width;
        }
        _timeLab=[[UILabel alloc] initWithFrame:CGRectMake(origonX, origonY, 120, 21)];
        _timeLab.font=[UIFont systemFontOfSize:14.f];
        _timeLab.textColor=[UIColor lightGrayColor];
        _timeLab.textAlignment=NSTextAlignmentRight;
        [self addSubview:_timeLab];
        

        _titleLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(_iconImgView)+10, _timeLab.frame.origin.y,Width-_timeLab.frame.size.width, 21)];
        if(cellType==HXCellTypeSelectLines)
            _titleLab.frame=CGRectMake(_titleLab.frame.origin.x, _titleLab.frame.origin.y, Width, 21);
        _titleLab.font=[UIFont systemFontOfSize:17.f];
        [self addSubview:_titleLab];
        UIFont*myFont=[UIFont systemFontOfSize:15.f];
        _subtitleLab=[[UILabel alloc] initWithFrame:CGRectMake(_titleLab.frame.origin.x, ViewFrameY_H(_titleLab)+5, Width, 21)];
        _subtitleLab.font=myFont;
        _subtitleLab.textColor=[UIColor darkGrayColor];
        [self addSubview:_subtitleLab];
        
        if (cellType==HXCellTypeThreeLines | cellType==HXCellTypeSelectLines) {
            self.frame=CGRectMake(0, 0, SCREEN_WIDTH, 110);
            _stateLab=[[UILabel alloc] initWithFrame:CGRectMake(_titleLab.frame.origin.x, ViewFrameY_H(_subtitleLab)+5, Width, 21)];
            _stateLab.font=myFont;
            _stateLab.textColor=[UIColor redColor];
            [self addSubview:_stateLab];
        }
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
