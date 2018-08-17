//
//  HXSelectCouponViewController.m
//  BaiMi
//
//  Created by licl on 16/7/30.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXSelectCouponViewController.h"
#import "MJRefresh.h"
#import "HXCouponCell.h"

@interface HXSelectCouponViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView*tableView;
@property(assign,nonatomic)NSIndexPath *currentSelIndexPath;
@property(strong,nonatomic)NSMutableArray*couponList;
@property(assign,nonatomic)int currentPage;
@end

@implementation HXSelectCouponViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    if(_justForShow)
        self.title=@"优惠券";
    else
        self.title=@"选择优惠券";
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    _couponList=[NSMutableArray array];
    [self pullAvaliableCouponListHttp];
    
    //模拟数据结束
    __unsafe_unretained UITableView*tableView=self.tableView;
    tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage=0;
        [self pullAvaliableCouponListHttp];
    }];
    tableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉加载更多
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _currentPage++;
        [self pullAvaliableCouponListHttp];
    }];
}


-(void)pullAvaliableCouponListHttp{
    
    HXLoginUser*user=[NSUserDefaultsUtil getLoginUser];
    if (_justForShow) {
        NSString*skey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,[NSNumber numberWithInteger:_currentPage],@"2",user.token]];
        [HXHttpUtils requestJsonPostWithUrlStr:@"/user/couponList" params:@{@"phoneNumber":user.phoneNumber,@"sKey":skey,@"status":@"2",@"currentPage":[NSNumber numberWithInteger:_currentPage]} onComplete:^(NSError *error, NSDictionary *resultJson) {
            if (error) {
                [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
            }else{
                NSArray *array = [resultJson objectForKey:@"content"];
                NSMutableArray*contentArray = [NSMutableArray array];

                for (NSDictionary *mDict in array) {
                    HXCouponModel *model = [[HXCouponModel alloc]init];
                    model.title = [mDict objectForKey:@"title"];
                    model.couponNo = [mDict objectForKey:@"no"];
                    model.createTime=[NSDate dateWithTimeInMsSince1970:[[mDict objectForKey:@"createTime"] longLongValue]];
                    model.expireTime=[NSDate dateWithTimeInMsSince1970:[[mDict objectForKey:@"expireTime"]longLongValue]];
                    model.usesTime = [mDict objectForKey:@"usesTime"];
                    model.type = [[mDict objectForKey:@"type"] intValue];
                    model.businessType = [[mDict objectForKey:@"businessType"] intValue];
                    model.businessNo = [mDict objectForKey:@"businessNo"];
                    model.faceValue = [NSString stringWithFormat:@"%d",[[mDict objectForKey:@"faceValue"] intValue]];
                    if ([[mDict objectForKey:@"floor"]isKindOfClass:[NSNull class]] || [[mDict objectForKey:@"floor"] intValue] == 0 || [mDict objectForKey:@"floor"] == nil) {
                        model.floor = @"0";
                    }else
                        model.floor = [mDict objectForKey:@"floor"];
                    model.remark = [mDict objectForKey:@"remark"];
                    [contentArray addObject:model];
                }
                if (_currentPage==0) {
                    _couponList=[contentArray mutableCopy];
                }else
                    [_couponList addObjectsFromArray:contentArray];

            };
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
            
        }];

    }else{
    NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,[NSNumber numberWithInt:_currentPage],[NSNumber numberWithInt:_businessType],user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/availableCouponList" params:@{@"phoneNumber":user.phoneNumber,@"sKey":sKey,@"businessType":[NSNumber numberWithInt:_businessType],@"currentPage":[NSNumber numberWithInt:_currentPage]} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
            return ;
        }else{
            NSArray*content=[resultJson objectForKey:@"content"];
            NSMutableArray*array=[NSMutableArray array];
            for(NSDictionary*dic in content){
                HXCouponModel*coupon=[HXCouponModel new];
                coupon.title=[dic objectForKey:@"title"];
                coupon.couponNo=[dic objectForKey:@"no"];
                coupon.createTime=[NSDate dateWithTimeInMsSince1970:[[dic objectForKey:@"createTime"] longLongValue]];
                coupon.expireTime=[NSDate dateWithTimeInMsSince1970:[[dic objectForKey:@"expireTime"]longLongValue]];
                coupon.type=[[dic objectForKey:@"type"] intValue];
                coupon.faceValue=[dic objectForKey:@"faceValue"];
                coupon.remark=[dic objectForKey:@"remark"];
                if ([[dic objectForKey:@"floor"]isKindOfClass:[NSNull class]] || [[dic objectForKey:@"floor"] intValue] == 0 || [dic objectForKey:@"floor"] == nil) {
                    coupon.floor = @"0";
                }else
                    coupon.floor = [dic objectForKey:@"floor"];
               [array addObject:coupon];
            }
            if (_currentPage==0) {
                _couponList=[array mutableCopy];
            }else
                [_couponList addObjectsFromArray:array];
        }    
        [self fixSelectCoupon];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }];
    }
}


//匹配查找
-(void)fixSelectCoupon{
    if (_selectCoupon.couponNo.length) {
        for(HXCouponModel*c in _couponList){
            if ([_selectCoupon.couponNo isEqualToString:c.couponNo]) {
                c.selected=YES;
            }
        }
    }
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _couponList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIde = @"cellIdentifier";
    HXCouponModel *coupon = [_couponList objectAtIndex:indexPath.row];
    
    HXCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell == nil) {
        if (_justForShow)
            cell=[[HXCouponCell alloc] initWithCouponValueStr:coupon.faceValue selectStyle:NO];
        else
            cell=[[HXCouponCell alloc] initWithCouponValueStr:coupon.faceValue selectStyle:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSTimeInterval interval=[coupon.expireTime timeIntervalSinceNow];
    if (interval<=0)
        [cell.backImageView setImage:[UIImage imageNamed:@"ico_guoqi.png"]];
    else
       [cell.backImageView setImage:[UIImage imageNamed:@"ico_youhui.png"]];
   
    if (coupon.selected)
        cell.seleImgView.image=[UIImage imageNamed:@"icon_check.png"];
    else
        cell.seleImgView.image=[UIImage imageNamed:@"icon_uncheck.png"];
    
    cell.infoLabel.text = coupon.remark;
    cell.titleLabel.text=HXCouponTypeStr(coupon.type);
    cell.userTyleLabel.text = [NSString stringWithFormat:@"满%@元可用",coupon.floor];
    cell.timeOutLabel.text = [NSString stringWithFormat:@"有效期\n%@\n%@",[coupon.createTime toStringByChineseDateTimeSecondLine],[coupon.expireTime toStringByChineseDateTimeSecondLine]];
    
//    cell.titleLabel.text=HXCouponTypeStr(coupon.type);
//    cell.userTyleLabel.text = coupon.remark;
//    cell.timeOutLabel.text = [NSString stringWithFormat:@"有效期\n%@\n%@",[coupon.createTime toStringByChineseDateTimeSecondLine],[coupon.expireTime toStringByChineseDateTimeSecondLine]];
//    cell.infoLabel.text = @"· 未使用 ·";
//    cell.infoLabel.textColor = [UIColor colorWithRed:15/255.0 green:220/255.0 blue:0/255.2 alpha:1.0];

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_justForShow)
        return;

    HXCouponModel*coupon=[_couponList objectAtIndex:indexPath.row];
    coupon.selected=!coupon.selected;
    
    HXCouponCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    
    if (coupon.selected){
        NSTimeInterval interval=[coupon.expireTime timeIntervalSinceNow];
        if (interval<=0){
            [HXAlertViewEx showInTitle:nil Message:@"该优惠券已过期" ViewController:self];
            return;
        }
        cell.seleImgView.image=[UIImage imageNamed:@"icon_check.png"];
        _selectCoupon=coupon;
        [self selectDelegateAndBack];
    }else{
        cell.seleImgView.image=[UIImage imageNamed:@"icon_uncheck.png"];
        if ([_selectCoupon.couponNo isEqualToString:coupon.couponNo])
            _selectCoupon=nil;
        [self selectDelegateAndBack];
    }
   
}

-(void)selectDelegateAndBack{
    if ([_delegate respondsToSelector:@selector(selectCouponVC:selectCoupon:)]) {
        [_delegate selectCouponVC:self selectCoupon:_selectCoupon];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
