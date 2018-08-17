//
//  HXShowImageView.h
//  BaiMi
//
//  Created by HXMAC on 16/7/8.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnBlock)(UIButton *button);

@interface HXShowImageView : UIView
@property (nonatomic,strong)UIImageView *backImageView;
@property (nonatomic,strong)UILabel *noLabel;//没有图片时显示的文字
@property (copy,nonatomic)returnBlock returnButtonBlock;

- (void)getButtonBlock:(returnBlock)block;
@end
