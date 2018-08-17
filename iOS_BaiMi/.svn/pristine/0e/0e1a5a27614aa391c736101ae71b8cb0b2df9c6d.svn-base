//
//  HXMoreAddressCell.h
//  BaiMi
//
//  Created by HXMAC on 16/7/8.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXMoreAddressCellDelegate <NSObject>

- (void)changeCellState:(UIGestureRecognizer *)tap;

@end

@interface HXMoreAddressCell : UITableViewCell
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *addressLabel;
@property (nonatomic,strong)UILabel *phoneLabel;
@property (nonatomic,strong)UIImageView *editImageView;
@property (nonatomic,strong)UIImageView *deleteImageView;
@property (weak,nonatomic)id<HXMoreAddressCellDelegate> delegate;
@end
