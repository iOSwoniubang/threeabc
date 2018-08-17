//
//  UIImage+Resize.m
//  BaiMi
//
//  Created by licl on 16/7/7.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "UIImage+Resize.h"
#import <AVFoundation/AVFoundation.h>

@interface UIImage ()
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;
@end

@implementation UIImage (Resize)
//将彩色图片转化为黑白图片
+ (UIImage *)grayscale:(UIImage *)anImage{
    UIImage *image = [UIImage imageWithData:UIImagePNGRepresentation(anImage)];
    CGImageRef imageRef = image.CGImage;
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    bool shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    CGColorRenderingIntent intent = CGImageGetRenderingIntent(imageRef);
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    
    UInt8 *buffer = (UInt8 *)CFDataGetBytePtr(data);
    
    NSInteger x,y;
    for (y = 0; y < height; y++) {
        for (x = 0; x <width; x++) {
            UInt8 *tmp;
            tmp = buffer +y * bytesPerRow + x*4;
            
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            UInt8 brightness;
            
            brightness = (77 * red + 28 * green + 151 * blue) / 256;
            *(tmp + 0) = brightness;
            *(tmp + 1) = brightness;
            *(tmp + 2 ) = brightness;
        }
    }
    CFDataRef effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    CGDataProviderRef effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    CGImageRef effectedCgImage = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpace, bitmapInfo, effectedDataProvider, NULL, shouldInterpolate, intent);
    UIImage *effectedImage = [[UIImage alloc]initWithCGImage:effectedCgImage];
    
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    CFRelease(data);
    
    
    return effectedImage;
    
}

#pragma mark - 图片大小算法
+ (CGSize)resizeOfSize:(CGSize)size LimitByMaxWidth:(CGFloat)maxwidth MaxHeight:(CGFloat)maxheight{
    float width = size.width;
    float heigth = size.height;
    float rate;
    if (heigth > maxheight) {
        rate = heigth / maxheight;
        heigth = maxheight;
        width = width / rate;
    }
    if (width > maxwidth) {
        rate = width / maxwidth;
        width = maxwidth;
        heigth = heigth / rate;
    }
    return CGSizeMake(width, heigth);
}

#pragma mark -
- (UIImage*)scaleImageToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage *) imageFromURLString: (NSString *) urlstring
{
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlstring]]];
    
}

//获取视频缩略图
+(UIImage *)getVedioImage:(NSString *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
    
}


   // 生成二维码图片
+(UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    CIImage *qrcodeImage;
    NSData *data = [code dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:false];
    /*
    //dataUsingEncoding可以替换为其他形式，其枚举为：
     
     typedef NSUInteger NSStringEncoding;
     
     NS_ENUM(NSStringEncoding) {
     
     NSASCIIStringEncoding = 1,	// 0..127 only
    
    NSNEXTSTEPStringEncoding = 2,
    
    NSJapaneseEUCStringEncoding = 3,
    
    NSUTF8StringEncoding = 4,
    
    NSISOLatin1StringEncoding = 5,
    
    NSSymbolStringEncoding = 6,
    
    NSNonLossyASCIIStringEncoding = 7,
    
    NSShiftJISStringEncoding = 8,// kCFStringEncodingDOSJapanese
    
    NSISOLatin2StringEncoding = 9,
    
    NSUnicodeStringEncoding = 10,
    
    NSWindowsCP1251StringEncoding = 11, // Cyrillic; same as AdobeStandardCyrillic
    
    NSWindowsCP1252StringEncoding = 12, //WinLatin1
    
    NSWindowsCP1253StringEncoding = 13, // Greek
    
    NSWindowsCP1254StringEncoding = 14, // Turkish
    
    NSWindowsCP1250StringEncoding = 15, // WinLatin2
    
    NSISO2022JPStringEncoding = 21, // ISO 2022 Japanese encoding for e-mail
    
    NSMacOSRomanStringEncoding = 30,
    
    NSUTF16StringEncoding = NSUnicodeStringEncoding,  // An alias for NSUnicodeStringEncoding
    
    NSUTF16BigEndianStringEncoding = 0x90000100, // NSUTF16StringEncoding encoding with explicit endianness specified
    
    NSUTF16LittleEndianStringEncoding = 0x94000100,   // NSUTF16StringEncoding encoding with explicit endianness specified
    
    NSUTF32StringEncoding = 0x8c000100,
    
    NSUTF32BigEndianStringEncoding = 0x98000100, //NSUTF32StringEncoding encoding with explicit endianness specified
    
    NSUTF32LittleEndianStringEncoding = 0x9c000100, // NSUTF32StringEncoding encoding with explicit endianness specified
         */
//    二维码生成时，此处也可以替换
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    qrcodeImage = [filter outputImage];
    
    // 消除模糊
    
    CGFloat scaleX = width / qrcodeImage.extent.size.width; // extent 返回图片的frame
    
    CGFloat scaleY = height / qrcodeImage.extent.size.height;
    
    CIImage *transformedImage = [qrcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
    
}



+(UIImage *)addIconToQRCodeImage:(UIImage *)qrcodeImage withIcon:(UIImage *)icon withIconSize:(CGSize)iconSize {
    //通过两张图片进行位置和大小的绘制，实现两张图片的合并；其实此原理做法也可以用于多张图片的合并
    UIGraphicsBeginImageContextWithOptions(qrcodeImage.size, NO, [[UIScreen mainScreen] scale]);
    CGFloat qrImgWidth= qrcodeImage.size.width;
    CGFloat qrImgHeight = qrcodeImage.size.height;
    CGFloat iconWidth= iconSize.width;
    CGFloat iconHeight = iconSize.height;
    [qrcodeImage drawInRect:CGRectMake(0, 0, qrcodeImage.size.width, qrcodeImage.size.height)];
    [icon drawInRect:CGRectMake((qrImgWidth-iconWidth)/2, (qrImgHeight-iconHeight)/2,iconWidth, iconHeight)];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
   }



+ (UIImage *)generateBarCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    // 生成条形码图片    
    CIImage *barcodeImage;
    NSData *data = [code dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    barcodeImage = [filter outputImage];
    // 消除模糊
    CGFloat scaleX = width / barcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / barcodeImage.extent.size.height;
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    return [UIImage imageWithCIImage:transformedImage];
}


@end
