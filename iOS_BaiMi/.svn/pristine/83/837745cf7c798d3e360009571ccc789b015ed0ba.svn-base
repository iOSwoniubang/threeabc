//
//  HXCityHeadView.h
//  BaiMi
//
//  Created by HXMAC on 16/7/16.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXCityHeadLabel.h"

@protocol HXCityHeadViewDelegate <NSObject>

- (void)showFirstListCell:(id)section;

@end
@interface HXCityHeadView : UIView
- (id)initWithFrame:(CGRect)frame andTag:(NSInteger)tag;
@property (nonatomic,assign)NSInteger selectedTag;
@property (nonatomic,weak)id<HXCityHeadViewDelegate>  delegate;
@property (nonatomic,strong)HXCityHeadLabel *headLabel;
@property (nonatomic,strong)UILabel *lineLabel;
@end
