//
//  HXShareListViewController.m
//  BaiMi
//
//  Created by HXMAC on 16/7/11.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXShareListViewController.h"
#import "HXPersonTableViewCell.h"
#import "UMSocialData.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UIImage+Resize.h"
#import "ContextUtil.h"

@interface HXShareListViewController ()<UITableViewDelegate,UITableViewDataSource,UMSocialUIDelegate>
{
    UITableView *_myTableView;
    NSArray *_iconArray;
    NSArray *_titleArray;
    NSString *appUrl;
    UIImageView*qrImgView; //二维码imgView
}
@end

@implementation HXShareListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BackGroundColor;
    self.title = @"分享";
    _iconArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"ico_wechat_big.png"],[UIImage imageNamed:@"ico_quan.png"],[UIImage imageNamed:@"ico_qq.png"],[UIImage imageNamed:@"ico_zone.png"],nil];
    _titleArray = @[@"微信",@"朋友圈",@"QQ好友",@"QQ空间"];
    [self createUI];
//    [self pullAppUrlHttp];
}
//- (void)getShareUrl{
//    [HXHttpUtils requestJsonPostWithUrlStr:@"/common/shareInfo" params:@{@"osType":[NSNumber numberWithInt:2]} onComplete:^(NSError *error, NSDictionary *resultJson) {
//        if (error) {
//            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
//        }else{
//            NSDictionary *dict = [resultJson objectForKey:@"content"];
//            if ([dict isKindOfClass:[NSNull class]] || dict == nil) {
//                return ;
//            }else{
//                urlString = [dict objectForKey:@"url"];
//                [codeImageView setImage:[UIImage addIconToQRCodeImage:[UIImage imageFromURLString:urlString] withIcon:[UIImage imageNamed:@"Icon-29.png"] withIconSize:codeImageView.frame.size]];
//            }
//        }
//    }];
//}
- (void)createUI{
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44*4+30) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.scrollEnabled = NO;
    [self.view addSubview:_myTableView];


    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    [headView setBackgroundColor:BackGroundColor];
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, SCREEN_WIDTH - 20, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.text = @"分享到";
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:label];
    [_myTableView setTableHeaderView:headView];
    
    
    UIView*qrBgView=[[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-120/2, ViewFrameY_H(_myTableView)+40, 120, 120)];
    [qrBgView setBackgroundColor:[UIColor whiteColor]];
    qrBgView.layer.shadowColor = [UIColor grayColor].CGColor;//阴影颜色
    qrBgView.layer.shadowOffset = CGSizeMake(0, 4);//偏移距离
    qrBgView.layer.shadowOpacity = 0.8;//不透明度
    qrBgView.layer.shadowRadius = 2.0;//半径
    [self.view addSubview:qrBgView];
   
     qrImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    [qrBgView addSubview:qrImgView];
    
    
    UIButton*tipBtn=[[UIButton alloc] initWithFrame:CGRectMake(qrBgView.frame.origin.x, ViewFrameY_H(qrBgView)+15, qrBgView.frame.size.width, 21)];
    [tipBtn setTitleColor:LightBlueColor forState:UIControlStateNormal];
    [tipBtn setTitle:@"扫一扫即可添加" forState:UIControlStateNormal];
    [tipBtn setImage:[UIImage imageNamed:@"ico_sao.png"] forState:UIControlStateNormal];
    [tipBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    tipBtn.titleLabel.font=[UIFont systemFontOfSize:13.f];
    [self.view addSubview:tipBtn];
    
    //设置appstore下载地址
    NSString*appId=[ContextUtil appId];
    appUrl=[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/tie-lu12306/id%@?mt=8",appId];
    UIImage*qrImage=[UIImage generateQRCode:appUrl width:qrImgView.frame.size.width height:qrImgView.frame.size.height];
    UIImage*qrIconImage=[UIImage addIconToQRCodeImage:qrImage withIcon:[UIImage imageNamed:@"shareIcon.png"] withIconSize:CGSizeMake(20, 20)];
    qrImgView.image=qrIconImage;
}


////获取官网下载地址
//- (void)pullAppUrlHttp{
//    [HXHttpUtils requestJsonPostWithUrlStr:@"/common/shareInfo" params:@{@"osType":[NSNumber numberWithInt:HXOsTypeIos]} onComplete:^(NSError *error, NSDictionary *resultJson) {
//        if (!error) {
//            id content = [resultJson objectForKey:@"content"];
//            if ([content isKindOfClass:[NSDictionary class]]) {
//                //                NSString*appVersion=[content objectForKey:@"appVersion"];
//                appUrl = [content objectForKey:@"url"];
//                UIImage*qrImage=[UIImage generateQRCode:appUrl width:qrImgView.frame.size.width height:qrImgView.frame.size.height];
//                UIImage*qrIconImage=[UIImage addIconToQRCodeImage:qrImage withIcon:[UIImage imageNamed:@"shareIcon.png"] withIconSize:CGSizeMake(20, 20)];
//                qrImgView.image=qrIconImage;
//            }
//        }
//    }];
//}


#pragma mark---UITableViewDataSource & UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _iconArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellide = @"cellIDE";
    HXPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellide];
    if (cell == nil) {
        cell = [[HXPersonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellide];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        [cell.iconImageView setImage:[_iconArray objectAtIndex:indexPath.row]];
        cell.titleLabel.text = [_titleArray objectAtIndex:indexPath.row];
        return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *shareType;
    switch (indexPath.row) {
        case 0:
        {
            shareType = UMShareToWechatSession;
            [UMSocialData defaultData].extConfig.wechatSessionData.url=appUrl;
        }
            break;
        case 1:
        {
            shareType = UMShareToWechatTimeline;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url=appUrl;
        }
            break;
        case 2:
        {
            shareType = UMShareToQQ;
             [UMSocialData defaultData].extConfig.qqData.url = appUrl;
        }
            break;
        case 3:
        {
            shareType = UMShareToQzone;
            [UMSocialData defaultData].extConfig.qzoneData.url=appUrl;
        }
            break;
        default:
            break;
    }
    //需要自定义面板样式的开发者需要自己绘制UI，在对应的分享按钮中调用此接口
    [UMSocialData defaultData].extConfig.title = @"大师哥";
    UIImage*shareIcon=[UIImage imageNamed:@"shareIcon.png"];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[shareType] content:@"佰米大师哥 | 校园好帮手" image:shareIcon location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
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
