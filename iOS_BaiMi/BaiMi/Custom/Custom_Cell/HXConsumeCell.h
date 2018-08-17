//
//  HXConsumeCell.h
//  BaiMi
//
//  Created by licl on 16/7/6.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXConsumeCell : UITableViewCell
@property(strong,nonatomic)UILabel*noLab;
@property(strong,nonatomic)UILabel*packageNameLab;
@property(strong,nonatomic)UILabel*positionLab;
@property(strong,nonatomic)UILabel*timeLab;
@property(strong,nonatomic)UILabel*feeLab;
-(id)init;
@end
