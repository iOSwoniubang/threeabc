//
//  HXCityHeadView.m
//  BaiMi
//
//  Created by HXMAC on 16/7/16.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXCityHeadView.h"

@implementation HXCityHeadView
- (id)initWithFrame:(CGRect)frame andTag:(NSInteger)tag{
    self = [super initWithFrame:frame];
    if (self) {
        _selectedTag = tag;
        [self drawRect:frame];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    self.backgroundColor = [UIColor whiteColor];
    _headLabel = [[HXCityHeadLabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width, 39)];
    _headLabel.textAlignment = NSTextAlignmentLeft;
    _headLabel.userInteractionEnabled = YES;
    _headLabel.font = [UIFont systemFontOfSize:14];
    _headLabel.backgroundColor = [UIColor clearColor];
    _headLabel.tag = 10000 + _selectedTag;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showFirstCell:)];
    [_headLabel addGestureRecognizer:tap];
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, self.frame.size.width, 1)];
    _lineLabel.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_headLabel];
    [self addSubview:_lineLabel];
    
}
- (void)showFirstCell:(UITapGestureRecognizer *)tap{
    //采用代理方法掉到viewcontroller中执行
    [self.delegate performSelector:@selector(showFirstListCell:) withObject:tap];
}

@end
