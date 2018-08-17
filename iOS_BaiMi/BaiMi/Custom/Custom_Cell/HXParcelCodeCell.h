//
//  HXParcelCodeCell.h
//  BaiMi
//
//  Created by licl on 16/7/12.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXParcelCodeCell : UITableViewCell
@property(strong,nonatomic) UIImageView*barCodeImgView; //条形码
@property(strong,nonatomic) UILabel*codeLab;
@property(strong,nonatomic) UIImageView*qrCodeImgView; //二维码
@end
