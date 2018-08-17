//
//  HXAboutProductViewController.m
//  BaiMi
//
//  Created by HXMAC on 16/8/1.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXAboutProductViewController.h"
#import "Masonry.h"
#import "ContextUtil.h"
#import "AFNetworking.h"

@interface HXAboutProductViewController ()<UIAlertViewDelegate>

@end

@implementation HXAboutProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于大师哥";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    __weak typeof (self) weakSelf = self;
    
    UIScrollView *backScrollView=  [[UIScrollView alloc]init];
    [self.view addSubview:backScrollView];
    
    [backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).with.offset(0);
        make.top.equalTo(weakSelf.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64 ));
    }];
    
    
    UIImageView *iconImageView = [[UIImageView alloc]init];
    [iconImageView setImage:[UIImage imageNamed:@"shareIcon.png"]];
    iconImageView.layer.cornerRadius = 40;
    iconImageView.layer.masksToBounds = YES;
    [backScrollView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(backScrollView).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

    UILabel *versionLabel = [[UILabel alloc]init];
    versionLabel.text = [NSString stringWithFormat:@"V %@",version];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.font = [UIFont systemFontOfSize:14];
    [backScrollView addSubview:versionLabel];
    
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(iconImageView.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 20));
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"校园好帮手  佰米大师哥";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [backScrollView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(versionLabel.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 30));
    }];
    
    
    UILabel *contentlabel = [[UILabel alloc]init];
    contentlabel.font = [UIFont systemFontOfSize:12];
    contentlabel.backgroundColor = [UIColor clearColor];
    contentlabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentlabel.textAlignment = NSTextAlignmentLeft;
    contentlabel.numberOfLines = 0;
    contentlabel.text = @"*本软件使用完全免费，使用过程中产生的网络流量费用由网络运营商收取*";
    contentlabel.textColor = [UIColor grayColor];
    [backScrollView addSubview:contentlabel];
    CGSize sizeInfo = [contentlabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 10, MAXFLOAT)];;
    [contentlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 20, sizeInfo.height));
    }];
    
    UILabel *infoLabel = [[UILabel alloc]init];
    infoLabel.font = [UIFont systemFontOfSize:12];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.lineBreakMode = NSLineBreakByCharWrapping;;
    infoLabel.numberOfLines = 0;
    infoLabel.textColor = [UIColor grayColor];
    infoLabel.text = @"警告：本客户端受著作权法和国际公约的保护，未经授权擅自复制或传播本程序的部分或全部，乐能受到严厉的民事以刑事制裁，并将在法律许可的范围内受到可能的起诉。本软件最终解释权归佰米智能科技发展有限公司所有。";
    CGSize size = [infoLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 10, MAXFLOAT)];;
    [backScrollView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).with.offset (10);
        make.top.equalTo(contentlabel.mas_bottom).with.offset (20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 20, size.height + 10));
    }];
    NSString *coprRightStr = [NSString stringWithFormat:@"咨询电话:%@\n佰米智能　版权所有\nCopyright 2015 © BaiMi",HX_ServicePhone];
    CGSize sizec = [coprRightStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.hidden = YES;
    [button setTitle:@"更新到最新版本" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:LightBlueColor];
    button.layer.cornerRadius = 15;
//    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [backScrollView addSubview:button];

    
    UILabel *coprRight = [[UILabel alloc]init];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:coprRightStr];
    coprRight.textColor = [UIColor grayColor];

    [AttributedStr addAttribute:NSForegroundColorAttributeName value:LightBlueColor range:NSMakeRange(5, 12)];
    coprRight.attributedText = AttributedStr;
    coprRight.textAlignment = NSTextAlignmentCenter;
    coprRight.font = [UIFont systemFontOfSize:14];
    coprRight.numberOfLines = 0;
    coprRight.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callPhone)];
    [coprRight addGestureRecognizer:tap];
    [backScrollView addSubview:coprRight];

    if ((SCREEN_HEIGHT - 64) - (210 + size.height + sizeInfo.height) < 30 + sizec.height + 80) {
//        [button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(weakSelf.view);
//            make.top.equalTo(infoLabel.mas_bottom).with.offset(80);
//            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, 30));
//        }];
        
        [coprRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view);
            make.top.equalTo(infoLabel.mas_bottom).with.offset(100);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, sizec.height + 10));
        }];
        [backScrollView setContentSize:CGSizeMake(SCREEN_WIDTH,320 + sizeInfo.height + size.height + sizec.height+ 30)];

    }else{
        [coprRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view).with.offset(-20);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, sizec.height + 10));
        }];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo (weakSelf.view);
            make.bottom.equalTo(coprRight.mas_top).with.offset (-10);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, 30));
        }];
    }
}
- (void)callPhone{
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:HX_ServicePhone message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alter show];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
       if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",HX_ServicePhone]] options:[NSDictionary dictionary] completionHandler:^(BOOL success) {
            NSLog(@"openSuccess:%d",success);
        }];
       }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",HX_ServicePhone]]];
       }
    }
}
//- (void)buttonClick{
//    NSString*appId=[ContextUtil appId];
//    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//
//    NSError *error;
//    NSData *response = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",appId]]] returningResponse:nil error:nil];
//    if (response == nil) {
//        NSLog(@"你没有连接网络哦");
//        return;
//    }
//    NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//    if (error) {
//        NSLog(@"hsUpdateAppError:%@",error);
//        return;
//    }
//    NSArray *array = appInfoDic[@"results"];
//    NSDictionary *dic = array[0];
//    NSString *appStoreVersion = dic[@"version"];
//    //打印版本号
//    NSLog(@"当前版本号:%@\n商店版本号:%@",version,appStoreVersion);
//    //4当前版本号小于商店版本号,就更新
//    if([version floatValue] < [appStoreVersion floatValue])
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本有更新" message:[NSString stringWithFormat:@"检测到新版本(%@),是否更新?",appStoreVersion] delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"更新",nil];
//        [alert show];
//    }else{
//        [HXAlertViewEx showInTitle:nil Message:@"检测到不需要更新" ViewController:self];
//    }
//    
//
////    NSString * appUrl=[NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@?mt=8",appId];
////    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectZero];
////    [self.view addSubview:webView];
////    
////    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:appUrl]];
////    [webView loadRequest:request];
////    return;
//}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSString*appId=[ContextUtil appId];
//
//    //5实现跳转到应用商店进行更新
//    if(buttonIndex==1)
//    {
//        //6此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", appId]];
//        [[UIApplication sharedApplication] openURL:url];
//    }
//}
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
