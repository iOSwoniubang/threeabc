//
//  HXAgreementViewController.m
//  BaiMi
//
//  Created by licl on 16/8/1.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXAgreementViewController.h"

@interface HXAgreementViewController ()<UIWebViewDelegate>
@property(strong,nonatomic)UIWebView*webView;

@end

@implementation HXAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=BackGroundColor;
    
    switch (_agreementType) {
        case HXAgreementTypeIntroduction:self.title=@"功能介绍";break;
        case HXAgreementTypePrivacy:self.title=@"隐私说明";break;
        case HXAgreementTypeService:self.title=@"服务协议";break;
        default:
            break;
    }
    
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    
    NSString*urlStr=[NSString stringWithFormat:@"%@/common/agreement?type=%ld",HXURLWebServer,(long)_agreementType];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    _webView.delegate=self;
    [self.view addSubview:_webView];
    _webView.backgroundColor=[UIColor whiteColor];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
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
