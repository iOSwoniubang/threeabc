//
//  UIImage+Resize.h
//  BaiMi
//
//  Created by licl on 16/7/7.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)
+ (UIImage *)grayscale:(UIImage *)anImage;//将图片转换为黑白色
+ (CGSize)resizeOfSize:(CGSize)size LimitByMaxWidth:(CGFloat)maxwidth MaxHeight:(CGFloat)maxheight;
// 缩放图像到给定的尺寸
- (UIImage *)scaleImageToSize:(CGSize)size;

+ (UIImage *)imageFromURLString: (NSString *) urlstring;
//获取视频缩略图
+(UIImage *)getVedioImage:(NSString *)videoURL;

//生成二维码图片
+ (UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height;
//带logo的二维码图片（将二维码图片与logo合并）
+(UIImage *)addIconToQRCodeImage:(UIImage *)qrcodeImage withIcon:(UIImage *)icon withIconSize:(CGSize)iconSize;

//生成条形码图片
+ (UIImage *)generateBarCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height;

@end
