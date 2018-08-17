//
//  HXMyOrderViewController.m
//  BaiMi
//
//  Created by HXMAC on 16/7/8.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXMyOrderViewController.h"
#import "HXMyConsumptionCell.h"
#import "HXMyConsumption.h"
#import "MJRefresh.h"
@interface HXMyOrderViewController ()<UITableViewDelegate,UITableViewDataSource>//UISearchBarDelegate
@property(strong,nonatomic)UITableView *table;
@property(assign,nonatomic)int currentPage;
@property(strong,nonatomic)NSMutableArray *arrayList;
@property(strong,nonatomic)UIButton *selectBtn;
@property(strong,nonatomic)UILabel *moveLine;
@property(strong,nonatomic)UIView*noneView;

@end

@implementation HXMyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createHeadUI];
}
-(void)createHeadUI{
    self.title = @"我的账单";
    self.view.backgroundColor = BackGroundColor;
    UIView *BGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 42)];
    BGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:BGView];
    for (int i = 0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20 + i * 80, 0, 80, 40);
        [button setTitle:i==0?@"支出":@"收入" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:LightBlueColor forState:UIControlStateSelected];
        if (i==0) {
            button.tag = 2;
            button.selected = YES;
            _selectBtn = button;
        }else{
            button.tag = 1;
        }
        [button addTarget:self action:@selector(chouseType:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.view addSubview:button];
    }
    _moveLine = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 80, 2)];
    _moveLine.backgroundColor = LightBlueColor;
    [self.view addSubview:_moveLine];
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, ViewFrame_Y(_moveLine)+2, SCREEN_WIDTH, SCREEN_HEIGHT - (ViewFrame_Y(_moveLine)+2) - 64) style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.dataSource = self;
    _table.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_table];
    
    _noneView=[[UIView alloc] initWithFrame:self.table.frame];
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
    self.table.hidden=YES;
    _noneView.hidden=YES;

    [self refreshDeal];
    _currentPage = 0;
    [self httpService];
}

-(void)updateUI:(BOOL)hasData{
    if (hasData) {
        self.table.hidden=NO;
        _noneView.hidden=YES;
    }else{
        self.table.hidden=YES;
        _noneView.hidden=NO;
    }
}


-(void)refreshDeal{
    //下拉刷新
    __unsafe_unretained UITableView*tableView=self.table;
    tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 0;
        [self httpService];
    }];
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉加载更多
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _currentPage++;
        [self httpService];
    }];
}

-(void)chouseType:(UIButton *)button{
    if (button.isSelected)return;
    _selectBtn.selected = NO;
    button.selected = YES;
    _selectBtn = button;
    _currentPage = 0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationRepeatCount:1.0];
    _moveLine.frame = CGRectMake(20 + (_selectBtn.tag==2?0:1)* 80, 40, 80, 2);
    [UIView commitAnimations];
    [self httpService];
}
-(void)httpService{
    HXLoginUser *user = [NSUserDefaultsUtil getLoginUser];
    if (!_arrayList) {
        _arrayList = [[NSMutableArray alloc] init];
    }
    NSString*skey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,[NSString stringWithFormat:@"%d",_currentPage],[NSNumber numberWithInteger:_selectBtn.tag],user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/billList" params:@{@"phoneNumber":user.phoneNumber,@"sKey":skey,@"type":[NSNumber numberWithInteger:_selectBtn.tag],@"currentPage":[NSNumber numberWithInt:_currentPage]} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (_currentPage==0) {
            [_arrayList removeAllObjects];
        }
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            NSArray *arrayResult = [resultJson objectForKey:@"content"];
            for (NSDictionary *dictionary in arrayResult) {
                HXMyConsumption *oneOrder = [[HXMyConsumption alloc] init];
                oneOrder.createTime = [HXHttpUtils whetherNil:[dictionary objectForKey:@"createTime"]];
                oneOrder.businessNo = [HXHttpUtils whetherNil:[dictionary objectForKey:@"no"]];
                oneOrder.businessType = [[HXHttpUtils whetherNil:[dictionary objectForKey:@"businessType"]] intValue];
                oneOrder.amount = [[HXHttpUtils whetherNil:[dictionary objectForKey:@"amount"]] floatValue];
                oneOrder.remark = [HXHttpUtils whetherNil:[dictionary objectForKey:@"remark"]];
                [_arrayList addObject:oneOrder];
            }
        }
        [_table reloadData];
        [_table.mj_header endRefreshing];
        [_table.mj_footer endRefreshing];
        [self updateUI:_arrayList.count>0?YES:NO];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrayList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *strCell = @"cell";
    HXMyConsumptionCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell){
        cell = [[HXMyConsumptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    HXMyConsumption *order = [_arrayList objectAtIndex:indexPath.section];
    cell.createTimeLabel.text = order.createTime;
    cell.businessNoLabel.text = order.businessNo;
    cell.businessTypeLabel.text = HXBillTypeStr(order.businessType);
//    cell.remarkLabel.text = order.remark;
    if (_selectBtn.tag == 1) {
        cell.amountLabel.text = [NSString stringWithFormat:@"+%.2f",order.amount];
        cell.amountLabel.textColor = LightBlueColor;
    }else{
        cell.amountLabel.text = [NSString stringWithFormat:@"-%.2f",order.amount];
        cell.amountLabel.textColor = [UIColor redColor];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
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
