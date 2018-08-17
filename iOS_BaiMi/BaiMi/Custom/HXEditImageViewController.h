//
//  HXEditImageViewController.h
//  BaiMi
//
//  Created by HXMAC on 16/7/21.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXEditImageDelegate <NSObject>

- (void)getPhotoByEdit:(UIImage *)image;

@end


@interface HXEditImageViewController : UIViewController
@property (nonatomic,strong)UIImage *editImage;
@property (nonatomic,strong)UIImagePickerController *picker;
@property (nonatomic,strong)id<HXEditImageDelegate> delegate;
@end
