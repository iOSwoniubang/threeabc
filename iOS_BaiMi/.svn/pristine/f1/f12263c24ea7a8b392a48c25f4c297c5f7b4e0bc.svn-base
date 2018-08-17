//
//  HXUserCenterViewController.m
//  BaiMi
//
//  Created by licl on 16/6/23.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXUserCenterViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "HXPersonTableViewCell.h"
#import "HXPersonHeadCell.h"
#import "HXCertificationViewController.h"
#import "HXMoreAddressViewController.h"
#import "HXPersonMoneyViewController.h"
#import "HXMyOrderViewController.h"
#import "HXSGCertificationViewController.h"
#import "HXMyinformationViewController.h"
#import "HXShareListViewController.h"
#import "HXHelpOrticklingViewController.h"
#import "HXCouponViewController.h"
#import "HXMyTaskViewController.h"
#import "HXEditImageViewController.h"
#import "ContextUtil.h"
#import "HXShopMallViewController.h"
#import "CreditWebViewController.h"
#import "CreditNavigationController.h"
#import "HXLoginViewController.h"
#import "HXAboutProductViewController.h"
@interface HXUserCenterViewController ()<UITableViewDelegate,UITableViewDataSource,HXPersonHeadCellDelegate,UIActionSheetDelegate,HXEditImageDelegate,UIImagePickerControllerDelegate>
{
    UIScrollView *_backScrollView;
    UIImageView *_iconImageView;//个人头像
    UILabel *_personNameLabel;//昵称
    UIImageView *_editImageView;//编辑
    UIImageView *_renzhengImageView;//实名认证
    UIImageView *_addressImageView;//常用地址
    UIImageView *_personMoneyImageView;//个人财富
    UITableView *_myTableView;
    NSArray *_iconArray;
    NSArray *_titleArray;
    UIView *barView;
}
@end

@implementation HXUserCenterViewController
//自定义navigationBar时
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title=@"个人中心";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = BackGroundColor;
//     添加上这一句，可以去掉导航条下边的shadowImage，就可以正常显示了
    self.navigationController.navigationBar.clipsToBounds = NO;
    [self.navigationController.navigationBar setBackgroundColor:LightBlueColor];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    _iconArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"ico_indent.png"],[UIImage imageNamed:@"ico_mttask.png"],[UIImage imageNamed:@"ico_shige_center.png"],[UIImage imageNamed:@"ico_market.png"],[UIImage imageNamed:@"ico_ticket.png"],[UIImage imageNamed:@"ico_service.png"],[UIImage imageNamed:@"ico_friend.png"],[UIImage imageNamed:@"ico_about.png"], nil];
    _titleArray = [NSArray arrayWithObjects:@"我的账单",@"我的任务",@"师哥名片",@"积分商城",@"优惠券",@"帮助与反馈",@"与好友分享APP",@"关于大师哥", nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"EDIT_SUCCEED" object:nil];
    [self resetNavBar];

    [self createUI];

}
- (void)notification:(NSNotification *)noti{
    if ([noti.name isEqualToString:@"EDIT_SUCCEED"]) {
        NSArray *sourceArray = noti.object;
        [_iconImageView setImage:[sourceArray objectAtIndex:1]];
        _personNameLabel.text = [sourceArray objectAtIndex:0];
    }
}
-(void)resetNavBar{
    barView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    barView.backgroundColor=LightBlueColor;
    
//    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 13, 20)];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"btnBack.png"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [barView addSubview:backBtn];
    
    UILabel*titleLab=[[UILabel alloc] initWithFrame:CGRectMake(80, 30, SCREEN_WIDTH-80*2, 20)];
    titleLab.text=@"个人中心";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    titleLab.font=[UIFont boldSystemFontOfSize:20.0];
    [barView addSubview:titleLab];
    [self.view addSubview:barView];
}

- (void)createUI{
    __weak typeof (self) weakSelf = self;
    _myTableView = [[UITableView alloc]init];
    _myTableView.delegate = self;
    _myTableView.backgroundColor = BackGroundColor;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(barView.mas_bottom).with.offset(0);
        make.left.equalTo(weakSelf.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 64 - 10));
    }];
    [_myTableView setSeparatorInset:(UIEdgeInsetsMake(0, 2, 0, 2))];
    UIView *headView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    
    HXLoginUser *user = [NSUserDefaultsUtil getLoginUser];
    _iconImageView = [[UIImageView alloc]init];
    _iconImageView.userInteractionEnabled = YES;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = 30;
    [_iconImageView setImageWithURL:[NSURL URLWithString:user.logoUrl] placeholderImage:HXDefaultLogoImg];
    [headView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.left.equalTo(headView).with.offset(20);
        make.top.equalTo(headView).with.offset(10);
    }];
    
    _personNameLabel = [[UILabel alloc]init];
    _personNameLabel.font = [UIFont systemFontOfSize:14];
    _personNameLabel.textColor = [UIColor whiteColor];
    _personNameLabel.text = user.nickName==nil?@"用户昵称":user.nickName;
    
    _personNameLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:_personNameLabel];
    [_personNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).with.offset(10);
        make.top.equalTo(headView).with.offset(30);
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    view.tag = 100;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headCellSelected:)];
    [view addGestureRecognizer:tap];
    [headView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_iconImageView);
        make.right.equalTo(headView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    UIImageView *editImageView = [[UIImageView alloc]init];
    editImageView.userInteractionEnabled = YES;
//    editImageView.tag = 100;
    [editImageView setImage:[UIImage imageNamed:@"ico_wright.png"]];
        [view addSubview:editImageView];
    [editImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_iconImageView);
        make.right.equalTo(view).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    UIView *secondView = [[UIView alloc]init];
    secondView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:secondView];
    [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 80));
        make.left.equalTo(headView).with.offset(0);
        make.top.equalTo(_iconImageView.mas_bottom).with.offset(10);
    }];
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = BackGroundColor;
    [headView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondView.mas_bottom).with.offset(0);
        make.left.equalTo(headView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 20));
    }];
    
    for (int i = 0; i < 3; i ++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.userInteractionEnabled= YES;
        imageView.tag = 101 + i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headCellSelected:)];
        [imageView addGestureRecognizer:tap];
        [secondView addSubview:imageView];
        switch (i) {
            case 0:
            {
                UILabel *infoLabel = [[UILabel alloc]init];
                infoLabel.text = @"信息认证";
                infoLabel.backgroundColor = [UIColor clearColor];
                infoLabel.textColor = [UIColor blackColor];
                infoLabel.font = [UIFont systemFontOfSize:14];
                infoLabel.textAlignment = NSTextAlignmentCenter;
                [secondView addSubview:infoLabel];
                [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(secondView).with.offset(20);
                    make.bottom.equalTo(secondView).with.offset(-5);
                    make.size.mas_equalTo(CGSizeMake(60, 20));
                }];

                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(infoLabel);
                    make.bottom.equalTo(infoLabel.mas_top).with.offset(-5);
                    make.size.mas_equalTo(CGSizeMake(40, 40));
                }];
                [imageView setImage:[UIImage imageNamed:@"ico_zhengjian.png"]];

                
            }
                break;
            case 1:
            {
                UILabel *infoLabel = [[UILabel alloc]init];
                infoLabel.text = @"常用地址";
                infoLabel.backgroundColor = [UIColor clearColor];
                infoLabel.textColor = [UIColor blackColor];
                infoLabel.font = [UIFont systemFontOfSize:14];
                infoLabel.textAlignment = NSTextAlignmentCenter;
                [secondView addSubview:infoLabel];
                [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(secondView);
                    make.bottom.equalTo(secondView).with.offset(-5);
                    make.size.mas_equalTo(CGSizeMake(60, 20));
                }];

                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(secondView);
                    make.bottom.equalTo(infoLabel.mas_top).with.offset(-5);
                    make.size.mas_equalTo(CGSizeMake(40, 40));
                }];
                [imageView setImage:[UIImage imageNamed:@"ico_adress.png"]];


            }
                break;
            case 2:
            {
                UILabel *infoLabel = [[UILabel alloc]init];
                infoLabel.text = @"个人财富";
                infoLabel.backgroundColor = [UIColor clearColor];
                infoLabel.textColor = [UIColor blackColor];
                infoLabel.font = [UIFont systemFontOfSize:14];
                infoLabel.textAlignment = NSTextAlignmentCenter;
                [secondView addSubview:infoLabel];
                [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.width.offset(-20);
                    make.bottom.equalTo(secondView).with.offset(-5);
                    make.size.mas_equalTo(CGSizeMake(60, 20));
                }];

                
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(infoLabel);
                    make.bottom.equalTo(infoLabel.mas_top).with.offset(-5);
                    make.size.mas_equalTo(CGSizeMake(40, 40));
                }];
                [imageView setImage:[UIImage imageNamed:@"ico_money.png"]];

                

            }
                break;
            default:
                break;
        }
    }
    [_myTableView setTableHeaderView:headView];
    _myTableView.tableHeaderView.backgroundColor = LightBlueColor;
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    footView.backgroundColor = BackGroundColor;
    UIButton *loginOut = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginOut setBackgroundColor:RGBA(250, 100, 96, 1.0)];
    loginOut.layer.cornerRadius = 20;
    [loginOut setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginOut addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:loginOut];
    
    [loginOut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footView).with.offset(20);
        make.centerX.equalTo(footView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 100, 40));
    }];
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [footView addSubview:lineLabel];

    [_myTableView setTableFooterView:footView];

    
}
- (void)getPhotoByEdit:(UIImage *)image{
    HXLoginUser *user = [NSUserDefaultsUtil getLoginUser];
    NSData *data = UIImagePNGRepresentation(image);
    NSString*skey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,user.token]];
    [HXHttpUtils requestJsonFormDataPostWithUrlStr:@"/user/editInfo" params:@{@"phoneNumber":user.phoneNumber,@"sKey":skey} ImgDataParams:@{@"logoPicture":data} showHud:YES onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            [_iconImageView setImage:image];    
        }
    }];
}
- (void)headCellSelected:(UITapGestureRecognizer *)tap{
    switch (tap.view.tag - 100) {
        case 0:
        {
            NSLog(@"编辑");
            HXMyinformationViewController *myInformation = [[HXMyinformationViewController alloc]init];
            myInformation.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myInformation animated:YES];
        }
            break;
        case 1:
        {
            NSLog(@"实名认证");
            HXCertificationViewController *certification = [[HXCertificationViewController alloc]init];
            certification.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:certification animated:YES];
        }
            break;
        case 2:
        {
            HXMoreAddressViewController *moreAddress = [[HXMoreAddressViewController alloc]init];
            moreAddress.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:moreAddress animated:YES];
        }
            NSLog(@"常用地址");
            break;
        case 3:
        {
            HXPersonMoneyViewController *personMoney = [[HXPersonMoneyViewController alloc]init];
            personMoney.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:personMoney animated:YES];
        }
            NSLog(@"个人财富");
            break;
        default:
            break;
    }

}

- (void)imageTarget:(UITapGestureRecognizer *)tap{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return 44;
    

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return _titleArray.count;
    
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
- (void)loginOut{
    NSLog(@"退出登录");
    [NSUserDefaultsUtil removeUser];
    [NSUserDefaultsUtil removeDuiBaUrl];
    self.tabBarController.viewControllers = nil;
    [[UIApplication sharedApplication].keyWindow.rootViewController removeFromParentViewController];
    HXLoginViewController*loginVC=[[HXLoginViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController=loginVC;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                NSLog(@"我的账单");
                HXMyOrderViewController *VCCon = [[HXMyOrderViewController alloc] init];
                VCCon.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:VCCon animated:YES];
            }
                break;
            case 1:
            {
                NSLog(@"我的任务");
                HXMyTaskViewController *VCCon = [[HXMyTaskViewController alloc] init];
                VCCon.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:VCCon animated:YES];
            }
                break;
            case 2:
            {
                NSLog(@"师哥认证");
                HXSGCertificationViewController *VCCon = [[HXSGCertificationViewController alloc] init];
                VCCon.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:VCCon animated:YES];
            }
                break;
            case 3:
            {
                NSLog(@"积分商城");
                [self getDuiBaUrl];
            }
                break;
            case 4:
            {
                HXCouponViewController *coupomVc = [[HXCouponViewController alloc]init];
                coupomVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:coupomVc animated:YES];
                NSLog(@"优惠券");
            }
                break;
            case 5:
            {
                HXHelpOrticklingViewController *help = [[HXHelpOrticklingViewController alloc]init];
                help.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:help animated:YES];
                NSLog(@"帮助与反馈");
            }
                break;
            case 6:{
                HXShareListViewController *shareList = [[HXShareListViewController alloc]init];
                shareList.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:shareList animated:YES];
                NSLog(@"分享");
            }
                break;
            case 7:{
                HXAboutProductViewController *aboutProduct = [[HXAboutProductViewController alloc]init];
                aboutProduct.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:aboutProduct animated:YES];
                NSLog(@"关于");
            }
                break;
            default:
                break;
        }
    }
}
- (void)getDuiBaUrl{
    __block NSString *myString = nil;
    HXLoginUser *user = [NSUserDefaultsUtil getLoginUser];
    
    NSString *sKey = [HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,user.token]];
    
    [HXHttpUtils requestJsonPostWithUrlStr:@"/duiba/doAutoLogin" params:@{@"sKey":sKey,@"phoneNumber":user.phoneNumber} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            myString = [[resultJson objectForKey:@"content"] objectForKey:@"url"];
            NSString *dateString=[[NSDate date] toStringBySecond];
            [NSUserDefaultsUtil setDuiBaUrl:myString andTime:dateString];
            
            CreditWebViewController *web=[[CreditWebViewController alloc]initWithUrl:myString];//实际中需要改为开发者服务器的地址，开发者服务器再重定向到一个带签名的自动登录地址
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
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
