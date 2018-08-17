//
//  HXShopMallViewController.m
//  BaiMi
//
//  Created by HXMAC on 16/7/22.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXShopMallViewController.h"
#import "MJRefresh.h"
@interface HXShopMallViewController ()<UIWebViewDelegate>
{
    NSString *_urlString;
    UIWebView *_webView;
}
@end

@implementation HXShopMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"兑吧";
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [self setUpRefresh];
    [self getDUIBAUrl];
}
- (void)getDUIBAUrl{
    HXLoginUser *user = [NSUserDefaultsUtil getLoginUser];
    
    NSString *sKey = [HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,user.token]];
    
    [HXHttpUtils requestJsonPostWithUrlStr:@"/duiba/doAutoLogin" params:@{@"sKey":sKey,@"phoneNumber":user.phoneNumber} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            _urlString = [[resultJson objectForKey:@"content"] objectForKey:@"url"];
            [self refrshWebView];
        }
    }];
}
- (void)setUpRefresh{
    __unsafe_unretained HXShopMallViewController *weakSelf = self;
    _webView.scrollView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refrshWebView];
    }];
    _webView.scrollView.mj_header.automaticallyChangeAlpha = YES;
}
- (void)refrshWebView{
    NSURL *url = [NSURL URLWithString:_urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    return YES;
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
