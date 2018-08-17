//
//  HXEditImageViewController.m
//  BaiMi
//
//  Created by HXMAC on 16/7/21.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXEditImageViewController.h"

@interface HXEditImageViewController ()<UIScrollViewDelegate>
{
    CGPoint point;
    UIView *coreView;
    UIScrollView *myscrollView;
    UIImage *compressImage;
}
@property (nonatomic,strong)UIImageView *editImageView;
@end

@implementation HXEditImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 40, 30);
    right.backgroundColor = [UIColor clearColor];
    [right setTitle:@"完成" forState:UIControlStateNormal];
    [right addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    
    
    self.title = @"编辑照片";
    myscrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:myscrollView];
    compressImage = [self imageCompressForSize:_editImage targetSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    
    _editImageView = [[UIImageView alloc]initWithFrame:myscrollView.frame];
    [_editImageView setImage:compressImage];
    [myscrollView addSubview:_editImageView];
    
    myscrollView.contentSize = CGSizeMake(SCREEN_WIDTH ,SCREEN_HEIGHT - 64);
    
    myscrollView.delegate = self;
    myscrollView.maximumZoomScale = 2.0;
    myscrollView.minimumZoomScale = 1.0;
    UIView *backView = [[UIView alloc]initWithFrame:myscrollView.frame];
    backView.backgroundColor = [UIColor whiteColor];
    backView.alpha = 0.3;
    [_editImageView addSubview:backView];
    
    coreView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 150, 100, 300, 300)];
    coreView.backgroundColor = [UIColor blackColor];
    coreView.alpha = 0.1;
    coreView.layer.cornerRadius = 150;
    [self.view addSubview:coreView];
    
    point = coreView.center;
    
}
//按比例缩放
-(UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _editImageView;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view{
    
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
    if (scale > 1) {
        scrollView.contentSize = view.frame.size;
    }
    if (scale < 1) {
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    compressImage = [self imageCompressForSize:compressImage targetSize:CGSizeMake(_editImageView.frame.size.width, _editImageView.frame.size.height)];
}
- (void)finish{
    UIImage *editImg = [self getSubImage:compressImage mCGRect:CGRectMake(myscrollView.contentOffset.x + (SCREEN_WIDTH/2 - 150), 100 + myscrollView.contentOffset.y, 80, 80)];
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(getPhotoByEdit:)]) {
        [self.delegate performSelector:@selector(getPhotoByEdit:) withObject:editImg];
    }
    [_picker dismissViewControllerAnimated:YES completion:nil];
}
-(UIImage*)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect
{
    //重绘圆角图片
    CGRect rect = mCGRect;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    
    
    //////*********
    UIGraphicsBeginImageContext(smallImage.size);
    CGContextRef context1 = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context1, 0.5);
    CGContextSetStrokeColorWithColor(context1, [UIColor whiteColor].CGColor);
    CGRect rect1 = CGRectMake(0, 0, smallImage.size.width, smallImage.size.height);
    CGContextAddEllipseInRect(context1, rect1);
    CGContextClip(context1);
    
    [smallImage drawInRect:rect1];
    CGContextAddEllipseInRect(context1, rect1);
    CGContextStrokePath(context1);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
