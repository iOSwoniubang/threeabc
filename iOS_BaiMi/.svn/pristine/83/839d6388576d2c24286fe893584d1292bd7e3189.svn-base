//
//  HXScanHelper.m
//  BaiMi
//
//  Created by licl on 16/7/7.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXScanHelper.h"
@interface HXScanHelper ()<AVCaptureMetadataOutputObjectsDelegate>
@property(strong,nonatomic)AVCaptureSession*session; //输入输出的中间桥梁
@property(strong,nonatomic)AVCaptureVideoPreviewLayer*layer;//捕捉视频预览层
@property(strong,nonatomic)AVCaptureMetadataOutput*output;//捕获元数据输出
@property(strong,nonatomic)AVCaptureDeviceInput*input; //采集设备输入
@property(strong,nonatomic)UIView*superView; //图层的父类

@property(strong,nonatomic)UIImageView*scanImageView; //扫描动画imgView
@property(assign,nonatomic)BOOL isAnimationing;
@property(assign,nonatomic)CGRect animationRect;

@end

@implementation HXScanHelper


+ (instancetype)manager{
    static HXScanHelper *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[HXScanHelper alloc] init];
    });
    return singleton;
}

-(id)init{
    self=[super init];
    if (self) {
        if (!TARGET_IPHONE_SIMULATOR) {
                       //获取摄像设备
            AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            //创建输入流
            _input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            
            //创建输出流
            _output = [[AVCaptureMetadataOutput alloc]init];
            //设置代理 在主线程里刷新
            [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            
            //初始化链接对象
            _session = [[AVCaptureSession alloc]init];
            //高质量采集率
            [_session setSessionPreset:AVCaptureSessionPresetHigh];
            [_session addInput:_input];
            [_session addOutput:_output];
            
            
            //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
            _output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
            
            _layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
            _layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
            
        }
    }
    return self;
}

//开始捕获
-(void)startRunning{
    [_session startRunning];
}

//结束捕获
-(void)stopRunning{
    [_session stopRunning];
}

#pragma mark--AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        NSLog(@"%@",metadataObject.stringValue);
        [self stopAnimating];
        [self stopRunning];
        if (self.scanBlock) {
            self.scanBlock(metadataObject.stringValue);
        }
    }
}

#pragma mark--设置扫描范围区域CGRectMack(y的起点/屏幕的高,x的起点/屏幕的宽，扫描的区域的高/屏幕的高，扫描的区域的宽/屏幕的宽)
//scanRect 扫描范围
//scanView 扫描框
-(void)setScanningRect:(CGRect)scanRect scanView:(UIView*)scanView{
    CGFloat x,y ,width,height;
    x=scanRect.origin.y/_layer.frame.size.height;
    y=scanRect.origin.x/_layer.frame.size.width;
    width=scanRect.size.height/_layer.frame.size.height;
    height=scanRect.size.width/_layer.frame.size.width;
    _output.rectOfInterest=CGRectMake(x, y, width, height);
    self.scanView=scanView;
    if (self.scanView) {
        self.scanView.frame=scanRect;
        if (_superView) {
            [_superView addSubview:self.scanView];
        }
    }  
}


//显示图层
-(void)showLayer:(UIView*)superView{
    _superView=superView;
    _layer.frame=superView.layer.frame;
    [superView.layer insertSublayer:_layer atIndex:0];
    
    //扫描区域
    CGSize scanSize=CGSizeMake(SCREEN_WIDTH*3/4,SCREEN_WIDTH*3/4);
    CGRect scanRect=CGRectMake(SCREEN_WIDTH/2-scanSize.width/2, 80, scanSize.width, scanSize.height);
    UIView*scanRectView=[UIView new];
    scanRectView.layer.borderColor=LightBlueColor.CGColor;
    scanRectView.layer.borderWidth=1;
    //扫描区域动画
    _scanImageView=[[UIImageView alloc] init];
    scanRectView.clipsToBounds=YES;
    [scanRectView addSubview:_scanImageView];
    [self startAnimatingWithRect:scanRect InView:scanRectView Image:[UIImage imageNamed:@"scan_full_net.png"]];
  //扫描区域
    [self setScanningRect:scanRect scanView:scanRectView];
}

-(void)startAnimatingWithRect:(CGRect)animationRect InView:(UIView*)parentView Image:(UIImage*)image{
    _scanImageView.image=image;
    _animationRect=animationRect;
    _isAnimationing=YES;
    [self stepAnimation];
    
}


-(void)stepAnimation{
    if (!_isAnimationing)
        return;

    CGFloat scanNetImageViewW = _animationRect.size.width;
    CGFloat scanNetImageH = _animationRect.size.height;
    
    _scanImageView.alpha = 0.5;
    _scanImageView.frame = CGRectMake(0, -scanNetImageH, scanNetImageViewW, scanNetImageH);
    [UIView animateWithDuration:1.4 animations:^{
        _scanImageView.alpha = 1.0;
        _scanImageView.frame = CGRectMake(0, scanNetImageViewW-scanNetImageH, scanNetImageViewW, scanNetImageH);
    } completion:^(BOOL finished){
         [self performSelector:@selector(stepAnimation) withObject:nil afterDelay:0.3];
     }];
}


- (void)stopAnimating{
    _isAnimationing = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}





@end
