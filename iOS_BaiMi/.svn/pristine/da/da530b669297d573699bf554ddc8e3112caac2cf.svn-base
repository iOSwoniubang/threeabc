//
//  HXOrderCell.h
//  BaiMi
//
//  Created by licl on 16/7/13.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,HXParcelCellType){
    HXCellTypeTwoLines =1, //已收件、已退件
    HXCellTypeThreeLines=2,//未收件
    HXCellTypeSelectLines=3, //代领发布任务选择用
};


@interface HXOrderCell : UITableViewCell
@property(strong,nonatomic)UIImageView*iconImgView; //快递头像
@property(strong,nonatomic)UILabel*titleLab; //快递名称
@property(strong,nonatomic)UILabel*timeLab;  //时间
@property(strong,nonatomic)UILabel*subtitleLab; //快递单号或取件、寄件地址
@property(strong,nonatomic)UILabel*stateLab;//订单状态

@property(strong,nonatomic)UIImageView*checkImgView;

-(id)initWithCellType:(HXParcelCellType)cellType;
@end
