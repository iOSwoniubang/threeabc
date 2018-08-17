//
//  PECropRectView.h
//  PhotoCropEditor
//
//  Created by kishikawa katsumi on 2013/05/21.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PECropRectView : UIView

@property (nonatomic) id delegate;
@property (nonatomic) BOOL showsGridMajor;
@property (nonatomic) BOOL showsGridMinor;

@property(nonatomic) float height_width_scale;

- (id)initWithFrame:(CGRect)frame cropHeight_width_scale:(float)height_weight_scale;
@end

@protocol PECropRectViewDelegate <NSObject>

- (void)cropRectViewDidBeginEditing:(PECropRectView *)cropRectView;
- (void)cropRectViewEditingChanged:(PECropRectView *)cropRectView;
- (void)cropRectViewDidEndEditing:(PECropRectView *)cropRectView;



@end

