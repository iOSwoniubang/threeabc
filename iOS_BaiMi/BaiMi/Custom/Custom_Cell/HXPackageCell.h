//
//  HXPackageCell.h
//  BaiMi
//
//  Created by licl on 16/7/9.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,HXStyle){
   HXStylePackage =0,//机器信息套餐样式 smallIcon+title+fee+selectImg
   HXStylePay =1, //支付样式  bigIcon+title +rightfee+selectImg
};


@interface HXPackageCell : UITableViewCell
@property(strong,nonatomic)UIImageView*imgView;
@property(strong,nonatomic)UILabel*titleLab;
@property(strong,nonatomic)UILabel*feeLab;
@property(strong,nonatomic)UIImageView*selImgView;

-(id)initWithFrame:(CGRect)frame Style:(HXStyle)style;
@end
