//
//  HXCouponViewController.m
//  BaiMi
//
//  Created by HXMAC on 16/7/13.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXCouponViewController.h"
#import "HXCouponCell.h"
#import "HXCouponModel.h"
#import "HXExchangeViewController.h"
#import "MJRefresh.h"
@interface HXCouponViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_myTableView;
    NSInteger _currentPage;
    NSMutableArray *_dataArray;
    UIButton * _selectedButton;
    UILabel *_lineLabel;
    UIView*_noneView;
}
@end

@implementation HXCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"优惠券";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = BackGroundColor;
    _dataArray = [NSMutableArray array];
    _currentPage = 0;
//    [self createNav];
    
    [self createTableView];
    [self loadDataWithPage:_currentPage andType:0];
}
- (void)loadDataWithPage:(NSInteger)currentPage andType:(int)type{
    if (currentPage == 0 && _dataArray.count != 0 ) {
        [_dataArray removeAllObjects];
    }
    HXLoginUser *user = [NSUserDefaultsUtil getLoginUser];
    NSString *status;
    if (type == 0) {
        status = @"2";//未使用
    }else if (type == 1){
        status = @"3";//已使用
    }else if (type == 2){
        status = @"4";//已过期
    }
    NSString*skey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,[NSNumber numberWithInteger:_currentPage],status,user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/couponList" params:@{@"phoneNumber":user.phoneNumber,@"sKey":skey,@"status":status,@"currentPage":[NSNumber numberWithInteger:_currentPage]} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            NSArray *array = [resultJson objectForKey:@"content"];
            for (NSDictionary *mDict in array) {
                HXCouponModel *model = [[HXCouponModel alloc]init];
                model.title = [mDict objectForKey:@"title"];
                model.couponNo = [mDict objectForKey:@"no"];
                model.createTime=[NSDate dateWithTimeInMsSince1970:[[mDict objectForKey:@"createTime"] longLongValue]];
                model.expireTime=[NSDate dateWithTimeInMsSince1970:[[mDict objectForKey:@"expireTime"]longLongValue]];
                if (type == 1) {
                    model.usesTime = [NSDate dateWithTimeInMsSince1970:[[mDict objectForKey:@"usesTime"]longLongValue]];
                  }
                model.type = [[mDict objectForKey:@"type"] intValue];
                model.businessType = [[mDict objectForKey:@"businessType"] intValue];
                model.businessNo = [mDict objectForKey:@"businessNo"];
                model.faceValue = [mDict objectForKey:@"faceValue"];
                if ([[mDict objectForKey:@"floor"]isKindOfClass:[NSNull class]] || [[mDict objectForKey:@"floor"] intValue] == 0 || [mDict objectForKey:@"floor"] == nil) {
                    model.floor = @"0";
                }else
                model.floor = [mDict objectForKey:@"floor"];
                model.remark = [mDict objectForKey:@"remark"];
                [_dataArray addObject:model];
            }
        };
        [_myTableView.mj_header endRefreshing];
        [_myTableView.mj_footer endRefreshing];
        [_myTableView reloadData];
        [self updateUI:_dataArray.count>0?YES:NO];
    }];
}
//- (void)createNav{
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.frame = CGRectMake(0, 0, 100, 30);
//    [rightButton setTitle:@"兑换" forState:UIControlStateNormal];
//    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
//    [rightButton addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = rightBar;
//}

- (void)createTableView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    UIView*line=[[UIView alloc] initWithFrame:CGRectMake(0,ViewFrame_H(headView)-0.5, headView.frame.size.width, 0.5)];
    line.backgroundColor=BolderColor;
    [headView addSubview:line];
    NSArray *titleArray = @[@"未使用",@"已使用",@"已过期"];
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH / 3, 1)];
    _lineLabel.backgroundColor = LightBlueColor;
    [headView addSubview:_lineLabel];
    for (int i = 0; i < 3; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * (SCREEN_WIDTH/3), 0, SCREEN_WIDTH/3, 39);
        button.tag = 100 + i;
        [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:LightBlueColor forState:UIControlStateSelected];
        if (i == 0) {
            button.selected = YES;
            _selectedButton = button;
        }
        [button addTarget:self action:@selector(gotoTableView:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:button];
    }
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ViewFrameY_H(headView), SCREEN_WIDTH, SCREEN_HEIGHT-ViewFrameY_H(headView)-64) style:UITableViewStyleGrouped];
    _myTableView.delegate = self;
    _myTableView.dataSource =self;
    [self.view addSubview:_myTableView];
    _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    _noneView=[[UIView alloc] initWithFrame:_myTableView.frame];
    _noneView.backgroundColor=[UIColor whiteColor];
    UIImageView*emptyImgView=[[UIImageView alloc] initWithFrame:CGRectMake(_noneView.frame.size.width/2-150/2,_noneView.frame.size.height*0.2 , 150, 150)];
    emptyImgView.image=[UIImage imageNamed:@"empty.png"];
    [_noneView addSubview:emptyImgView];
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(30, ViewFrameY_H(emptyImgView)+20, _noneView.frame.size.width-60, 42)];
    label.numberOfLines=2;
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:16.f];
    label.textColor=[UIColor darkGrayColor];
    label.text=@"你来到了一片荒芜之地，空空如也，什么都没有，实在太冷清了~(>_<)~";
    [_noneView addSubview:label];
    [self.view addSubview:_noneView];
    _myTableView.hidden=YES;
    _noneView.hidden=YES;
    
    //下拉刷新
    __unsafe_unretained UITableView*tableView=_myTableView;
    tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage=0;
        [self loadDataWithPage:_currentPage andType:(int)_selectedButton.tag - 100];
        
    }];
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉加载更多
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _currentPage++;
        [self loadDataWithPage:_currentPage andType:(int)_selectedButton.tag - 100];
    }];
    
}

-(void)updateUI:(BOOL)hasData{
    if (hasData) {
        _myTableView.hidden=NO;
        _noneView.hidden=YES;
    }else{
        _myTableView.hidden=YES;
        _noneView.hidden=NO;
    }
}


- (void)gotoTableView:(UIButton *)button{
    if (button == _selectedButton) {
        return;
    }else{
        CGRect frame = _lineLabel.frame;
        frame.origin.x = button.frame.origin.x;
        _lineLabel.frame = frame;
        [_dataArray removeAllObjects];
        _currentPage = 0;
        _selectedButton.selected = NO;
        button.selected = YES;
        _selectedButton = button;
        [self loadDataWithPage:_currentPage andType:(int)_selectedButton.tag - 100];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIde = @"cellIdentifier";
    HXCouponModel *model = [_dataArray objectAtIndex:indexPath.row];

    HXCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell == nil) {
        cell=[[HXCouponCell alloc] initWithCouponValueStr:model.faceValue selectStyle:NO];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_selectedButton.tag  == 100) {
        [cell.backImageView setImage:[UIImage imageNamed:@"ico_youhui.png"]];
//        cell.infoLabel.text = @"· 未使用 ·";
//        cell.infoLabel.textColor = [UIColor colorWithRed:15/255.0 green:220/255.0 blue:0/255.2 alpha:1.0];
        cell.userTimeLabel.hidden = YES;
    }else if(_selectedButton.tag == 101){
        [cell.backImageView setImage:[UIImage imageNamed:@"ico_yiyong.png"]];
//        cell.infoLabel.text = @"· 已使用 ·";
//        cell.infoLabel.textColor = LightBlueColor;
        cell.userTimeLabel.hidden = NO;
        cell.userTimeLabel.text = [NSString stringWithFormat:@"使用时间\n%@",[model.usesTime toStringByChineseDateTimeSecondLine]];
    }else{
        [cell.backImageView setImage:[UIImage imageNamed:@"ico_guoqi.png"]];
//         cell.infoLabel.text = @"· 已过期 ·";
//        cell.infoLabel.textColor = [UIColor grayColor];
        cell.userTimeLabel.hidden = YES;
    }
        cell.infoLabel.text = model.remark;
        cell.titleLabel.text=HXCouponTypeStr(model.type);
        cell.userTyleLabel.text = [NSString stringWithFormat:@"满%@元可用",model.floor];
        cell.timeOutLabel.text = [NSString stringWithFormat:@"有效期\n%@\n%@",[model.createTime toStringByChineseDateTimeSecondLine],[model.expireTime toStringByChineseDateTimeSecondLine]];
    return cell;
}
//- (void)exchange{
//    NSLog(@"兑换");
//    HXExchangeViewController *enchageVC = [[HXExchangeViewController alloc]init];
//    [self.navigationController pushViewController:enchageVC animated:YES];
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
