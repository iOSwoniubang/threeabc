//
//  HXPersonMoneyViewController.m
//  BaiMi
//
//  Created by HXMAC on 16/7/7.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXPersonMoneyViewController.h"
#import "Masonry.h"
#import "HXPersonMoneyCollectionCell.h"
#import "HXPersonHeadCollectionCell.h"
#import "HXCouponViewController.h"
#import "HXShopMallViewController.h"
#import "HXSelectCouponViewController.h"
#import "CreditWebViewController.h"
@interface HXPersonMoneyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_iconArray;
    NSMutableArray *_titleArray;
    NSDictionary *_mDict;
}
@property (nonatomic,strong)UILabel *balanceLabel;//余额
@property (nonatomic,strong)UILabel *couponLabel;//优惠券
@property (nonatomic,strong)UILabel *integralLabel;//积分
@property (nonatomic,strong)UICollectionView *myCollectionView;
@end

@implementation HXPersonMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人财富";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = BackGroundColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"REFRESH_CAIFU" object:nil];
    _iconArray = [NSMutableArray arrayWithObjects:@[[UIImage imageNamed:@"ico_caifu1.png"],[UIImage imageNamed:@"ico_caifu2.png"],[UIImage imageNamed:@"ico_caifu3.png"]],@[[UIImage imageNamed:@"ico_caifu4.png"],[UIImage imageNamed:@"ico_caifu5.png"],[UIImage imageNamed:@"ico_caifu6.png"],[UIImage imageNamed:@"ico_caifu7.png"]], nil];
    _titleArray = [NSMutableArray arrayWithObjects:@[@"余额",@"优惠券",@"积分"],@[@"充值",@"转账",@"提现",@"敬请期待"], nil];
//    _iconArray = [NSMutableArray arrayWithObjects:@[[UIImage imageNamed:@"ico_caifu1.png"],[UIImage imageNamed:@"ico_caifu2.png"],[UIImage imageNamed:@"ico_caifu3.png"]],@[[UIImage imageNamed:@"ico_caifu7.png"]], nil];
//    _titleArray = [NSMutableArray arrayWithObjects:@[@"余额",@"优惠券",@"积分"],@[@"敬请期待"], nil];
    
    [self createUI];
    [self loadData];
}
- (void)notification:(NSNotification *)noti{
    if ([noti.name isEqualToString:@"REFRESH_CAIFU"]) {
        [self loadData];
    }
}
- (void)loadData{
    HXLoginUser *user = [NSUserDefaultsUtil getLoginUser];
    NSString *sKey = [HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/wealth" params:@{@"phoneNumber":user.phoneNumber,@"sKey":sKey} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            _mDict = [resultJson objectForKey:@"content"];
            user.balance=[[_mDict objectForKey:@"balance"] floatValue];
            user.integral=[[_mDict objectForKey:@"integral"] longLongValue];
            [NSUserDefaultsUtil setLoginUser:user];
        }
        [_myCollectionView reloadData];
    }];
}
- (void)createUI{
    UICollectionViewFlowLayout *layouyt = [[UICollectionViewFlowLayout alloc]init];
    layouyt.minimumLineSpacing = 0.0f;
    _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:layouyt];
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    _myCollectionView.backgroundColor = BackGroundColor;
    [_myCollectionView registerClass:[HXPersonHeadCollectionCell class] forCellWithReuseIdentifier:@"headcell"];
    [_myCollectionView registerClass:[HXPersonMoneyCollectionCell class] forCellWithReuseIdentifier:@"personMoneyCell"];
    [self.view addSubview:_myCollectionView];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return [[_iconArray objectAtIndex:section] count];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _iconArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake((SCREEN_WIDTH - 2)/3, 80);
    }else{
        return CGSizeMake((SCREEN_WIDTH - 2)/3, 120);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 0);
    }else{
        return CGSizeMake(SCREEN_WIDTH, 20);
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HXPersonHeadCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headcell" forIndexPath:indexPath];
        cell.iconImageView.image = [[_iconArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.titleLabel.text = [[_titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            NSString *contentString = [NSString stringWithFormat:@"%.2f",[[_mDict objectForKey:@"balance"] floatValue]];
            NSString*feeStr=[NSString stringWithFormat:@"%@ 元",contentString];
            NSMutableAttributedString*atr=[[NSMutableAttributedString alloc] initWithString:feeStr];
            NSRange range=[feeStr rangeOfString:@"元"];
            [atr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.f]}  range:NSMakeRange(0,range.location)];
            cell.infoLabel.attributedText = atr;
        }else if (indexPath.row == 1){
            NSString *contentString = [NSString stringWithFormat:@"%d",[[_mDict objectForKey:@"couponCount"] intValue]];
            NSString*feeStr=[NSString stringWithFormat:@"%@ 张",contentString];
            NSMutableAttributedString*atr=[[NSMutableAttributedString alloc] initWithString:feeStr];
            NSRange range=[feeStr rangeOfString:@"张"];
            [atr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.f]}  range:NSMakeRange(0,range.location)];
            cell.infoLabel.attributedText = atr;
        }else if (indexPath.row == 2){
            NSString *contentString = [NSString stringWithFormat:@"%d",[[_mDict objectForKey:@"integral"] intValue]];
            NSString*feeStr=[NSString stringWithFormat:@"%@ 分",contentString];
            NSMutableAttributedString*atr=[[NSMutableAttributedString alloc] initWithString:feeStr];
            NSRange range=[feeStr rangeOfString:@"分"];
            [atr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.f]}  range:NSMakeRange(0,range.location)];
            cell.infoLabel.attributedText = atr;
        }
        return cell;
    }else{
        HXPersonMoneyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"personMoneyCell" forIndexPath:indexPath];
        cell.iconImageView.image = [[_iconArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.titleLabel.text = [[_titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        return cell;
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0.5, 0.5, 0.5, 0);
}
//这个是两行之间的间距（上下cell间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.5f;
}

//这个方法是两个之间的间距（同一行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0f;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    NSLog(@"余额");
                }
                    break;
                case 1:
                {
                    if ([[_mDict objectForKey:@"couponCount"] intValue] == 0) {
                        return;
                    }
                    HXSelectCouponViewController *coupomVc = [[HXSelectCouponViewController alloc]init];
                    coupomVc.justForShow=YES;
                    [self.navigationController pushViewController:coupomVc animated:YES];
                }
                    break;
                case 2:
                {
                    NSLog(@"积分商城");
                    [self getDuiBaUrl];
//                    NSDictionary *dict = [NSUserDefaultsUtil getDuiBaSave];
//                    if (dict != nil) {
//                        NSString *timeString = [dict objectForKey:@"timeString"];
//                        NSDate *currentDate = [NSDate date];//获取当前时间，日期
//                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//                        [dateFormatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
//                        NSString *dateString = [dateFormatter stringFromDate:currentDate];
//                        
//                        NSDate *date1=[dateFormatter dateFromString:timeString];
//                        NSDate *date2=[dateFormatter dateFromString:dateString];
//                        NSTimeInterval time=[date2 timeIntervalSinceDate:date1];
//                        
//                        int hours=((int)time)/60;
//                        if (hours > 4) {
//                            [NSUserDefaultsUtil removeDuiBaUrl];
//                            [self getDuiBaUrl];
//                        }else{
//                            CreditWebViewController *web=[[CreditWebViewController alloc]initWithUrl:[dict objectForKey:@"urlString"]];//实际中需要改为开发者服务器的地址，开发者服务器再重定向到一个带签名的自动登录地址
//                            web.hidesBottomBarWhenPushed = YES;
//                            [self.navigationController pushViewController:web animated:YES];
//                        }
//                    }else{
//                        [self getDuiBaUrl];
//                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:{
            if (indexPath.row == 3) {
                return;
            }
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该功能尚未开通,敬请期待" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alter show];

//            switch (indexPath.row) {
//                case 0:
//                {
//                    NSLog(@"充值");
//                }
//                    break;
//                case 1:
//                {
//                    NSLog(@"转账");
//                }
//                    break;
//                case 2:
//                {
//                    NSLog(@"提现");
//                }
//                    break;
//                case 3:
//                {
//                    NSLog(@"敬请期待");
//                }
//                    break;
//                default:
//                    break;
//            }
        }
            break;
        default:
            break;
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

- (void)Binding{
    NSLog(@"绑定");
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
