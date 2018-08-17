//
//  HXTaskListViewController.m
//  BaiMi
//
//  Created by licl on 16/7/5.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXTaskListViewController.h"
#import "HXTaskDetailViewController.h"
#import "HXTaskCell.h"
#import "HXTaskOrder.h"
#import "MJRefresh.h"
@interface HXTaskListViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property(strong,nonatomic)UITableView *table;
@property(strong,nonatomic)UIButton *firstBtn;
@property(strong,nonatomic)UIButton *selectBtn;
@property(strong,nonatomic)UILabel *moveLine;
@property(assign,nonatomic)int currentPage;
@property(strong,nonatomic)NSMutableArray *arrayList;
@property(strong,nonatomic)HXTaskOrder *selectOrder;
@property(strong,nonatomic)UIView*noneView;
@end

@implementation HXTaskListViewController
-(void)viewWillAppear:(BOOL)animated{
    _currentPage = 0;
    [self httpService];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:HXNTFHouseTaskRefresh object:nil];
    [self createHeadUI];
}


-(void)onNotification:(NSNotification*)notification{
    if ([notification.name isEqualToString:HXNTFHouseTaskRefresh]) {
        [self chouseType:_firstBtn];
    }
}

-(void)resetBarTitle{
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 21)];
    label.text=@"领任务";
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont boldSystemFontOfSize:20.f];
    self.navigationItem.titleView=label;
}
-(void)createHeadUI{
    [self resetBarTitle];
    for (int i = 0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(15 + i * 80, 0, 80, 40);
        [button setTitle:i==0?@"本楼代领":@"所有任务" forState:UIControlStateNormal];
        [button setTitleColor:RGBA(53, 54, 56, 1) forState:UIControlStateNormal];
        [button setTitleColor:LightBlueColor forState:UIControlStateSelected];
        if (i==0) {
            _firstBtn = button;
            button.selected = YES;
            _selectBtn = button;
        }
        button.tag = i+1;
        [button addTarget:self action:@selector(chouseType:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.view addSubview:button];
    }
    _moveLine = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 80, 2)];
    _moveLine.backgroundColor = LightBlueColor;
    [self.view addSubview:_moveLine];
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0,40+2, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40 -2 - 49) style:UITableViewStylePlain];
    _table.dataSource = self;
    _table.delegate = self;
    _table.showsVerticalScrollIndicator = NO;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    _currentPage = 0;
    _selectBtn.selected = NO;
    button.selected = YES;
    _selectBtn = button;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationRepeatCount:1.0];
    _moveLine.frame = CGRectMake(15 + (button.tag -1)* 80, 40, 80, 2);
    [UIView commitAnimations];
    [self httpService];
}
-(void)httpService{
    HXLoginUser *user = [NSUserDefaultsUtil getLoginUser];
    if (!_arrayList) {
        _arrayList = [[NSMutableArray alloc] init];
    }
   
    NSString*skey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,[NSNumber numberWithInt:_currentPage],[NSNumber numberWithInteger:!_selectBtn?1: _selectBtn.tag],user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/receive/missoinList" params:@{@"phoneNumber":user.phoneNumber,@"sKey":skey,@"type":[NSNumber numberWithInteger:!_selectBtn?1: _selectBtn.tag],@"currentPage":[NSNumber numberWithInt:_currentPage]} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (_currentPage==0) {
            [_arrayList removeAllObjects];
        }
        NSLog(@"任务广场 %@",resultJson);
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            NSArray *arrayResult = [resultJson objectForKey:@"content"];
            for (NSDictionary *dictionary in arrayResult) {
                HXTaskOrder *oneOrder = [[HXTaskOrder alloc] init];
                oneOrder.publisherLogo = [HXHttpUtils whetherNil:[dictionary objectForKey:@"publisherLogo"]];
                NSLog(@"任务广场0000  %@",dictionary);
                oneOrder.orderNo = [HXHttpUtils whetherNil:[dictionary objectForKey:@"orderNo"]];
                oneOrder.source = [HXHttpUtils whetherNil:[dictionary objectForKey:@"source"]];
                oneOrder.target = [HXHttpUtils whetherNil:[dictionary objectForKey:@"target"]];
                oneOrder.deadLine=[[HXHttpUtils whetherNil:[dictionary objectForKey:@"deadLine"]] isEqualToString:@""]?nil:[NSDate dateWithTimeInMsSince1970:[[dictionary objectForKey:@"deadLine"]longLongValue]];
                oneOrder.createTime=[[HXHttpUtils whetherNil:[dictionary objectForKey:@"createTime"]] isEqualToString:@""]?nil:[NSDate dateWithTimeInMsSince1970:[[dictionary objectForKey:@"createTime"]longLongValue]];
                oneOrder.remark = [HXHttpUtils whetherNil:[dictionary objectForKey:@"remark"]];
                oneOrder.fee = [[HXHttpUtils whetherNil:[dictionary objectForKey:@"fee"]] floatValue];
                oneOrder.weightType = [[HXHttpUtils whetherNil:[dictionary objectForKey:@"weightType"]] intValue];
                [_arrayList addObject:oneOrder];
            }
        }
        [_table reloadData];
        [_table.mj_header endRefreshing];
        [_table.mj_footer endRefreshing];
        [self updateUI:_arrayList.count>0?YES:NO];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrayList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *strCell = @"cell";
    HXTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell){
        cell = [[HXTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    HXTaskOrder *oneOrder = [_arrayList objectAtIndex:indexPath.section];
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:oneOrder.publisherLogo] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    cell.feeLabel.text = [NSString stringWithFormat:@"%.2f元",oneOrder.fee];
    cell.weightLabel.text =HXWeightTypeStr(oneOrder.weightType);
    cell.sourceLabel.text = oneOrder.source;//取件地
    cell.targetLabel.text = oneOrder.target;//送件地
    cell.remainingTimeLabel.text=oneOrder.remainingTime;
    cell.remarkLabel.text = oneOrder.remark;
    UITapGestureRecognizer*tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    cell.labelTask.userInteractionEnabled = YES;
    [cell.labelTask addGestureRecognizer:tapGesture];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35*7 + 10;
}

-(void)tapGesture:(UITapGestureRecognizer *)gesture {
    HXLoginUser *user = [NSUserDefaultsUtil getLoginUser];
    if (user.studentVerificationStatus != HXVerifyStatusSuccessed){
        [HXAlertViewEx showInTitle:nil Message:@"请去个人中心——信息认证中进行师哥认证!" ViewController:self];
        return;
    }else{
        CGPoint point=[gesture locationInView:self.table];
        NSIndexPath *indexPath=[self.table indexPathForRowAtPoint:point];
        _selectOrder=[_arrayList objectAtIndex:indexPath.section];
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"确定接受任务？" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        HXLoginUser *user = [NSUserDefaultsUtil getLoginUser];
        NSString*skey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,[NSNumber numberWithInt:HXTaskStatusAccept],_selectOrder.orderNo,user.token]];
        [HXHttpUtils requestJsonPostWithUrlStr:@"/user/receive/changgeMissionStatus" params:@{@"phoneNumber":user.phoneNumber,@"sKey":skey,@"status":[NSNumber numberWithInt:HXTaskStatusAccept],@"orderNo":_selectOrder.orderNo} onComplete:^(NSError *error, NSDictionary *resultJson) {
            if (error) {
                [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
            }else{
                [HXAlertViewEx showInTitle:nil Message:@"接受任务成功" ViewController:self];
                [_arrayList removeObject:_selectOrder];
                [_table reloadData];
            }
            
        }];
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
