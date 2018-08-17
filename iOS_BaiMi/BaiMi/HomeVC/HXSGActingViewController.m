//
//  HXSGActingViewController.m
//  BaiMi
//
//  Created by 王放 on 16/7/12.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXSGActingViewController.h"
#import "HXOrderCell.h"
#import "HXExpress.h"
#import "MJRefresh.h"
#import "HXCreateTaskViewController.h"
#import "HXReceiveOrderDetailViewController.h"


@interface HXSGActingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)UIView* noneView;
@property(strong,nonatomic)NSMutableArray *arrayList;
@property(assign,nonatomic)int currentPage;
@property(assign,nonatomic)BOOL hasMore;
@property(strong,nonatomic)HXExpress*selectExpress;

@end

@implementation HXSGActingViewController
-(void)viewWillAppear:(BOOL)animated{
    _currentPage = 0;
    _hasMore=YES;
    [self pullParcelsHttp];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"师哥代领";
    [self resetRightBarItem];
    [self createUI];
    _arrayList=[NSMutableArray array];
    [self refreshDeal];
}

-(void)refreshDeal{
    //下拉刷新
    __unsafe_unretained UITableView*tableView=self.tableView;
    tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage=0;
        _hasMore=YES;
        [self pullParcelsHttp];
        
    }];
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉加载更多
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (_hasMore) {
            _currentPage++;
            [self pullParcelsHttp];
        }else
            [self.tableView.mj_footer endRefreshing];
    }];
    
}

-(void)resetRightBarItem{
//    UIBarButtonItem* publishBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleBordered target:self action:@selector(publishBtnClicked:)];
//    self.navigationItem.rightBarButtonItem = publishBtnItem;
    
    UIButton*btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    [btn setTitle:@"发布" forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:12.f];
    btn.layer.borderColor=[UIColor whiteColor].CGColor;
    btn.layer.cornerRadius=btn.frame.size.height/2;
    btn.layer.borderWidth=1.f;
    [btn addTarget:self action:@selector(publishBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*publishBtnItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = publishBtnItem;
}


-(void)createUI{
    self.view.backgroundColor = BackGroundColor;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    _noneView=[[UIView alloc] initWithFrame:self.tableView.frame];
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
    
    self.tableView.hidden=YES;
    _noneView.hidden=YES;
}


-(void)updateUI:(BOOL)hasData{
    if (hasData) {
        self.tableView.hidden=NO;
        _noneView.hidden=YES;
    }else{
        self.tableView.hidden=YES;
        _noneView.hidden=NO;
    }
}

-(void)pullParcelsHttp{
    HXLoginUser *user = [NSUserDefaultsUtil getLoginUser];
    NSString*skey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,[NSNumber numberWithInt:_currentPage],user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/receive/orderListToPublish" params:@{@"phoneNumber":user.phoneNumber,@"sKey":skey,@"currentPage":[NSNumber numberWithInt:_currentPage]} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            NSArray*content=[resultJson objectForKey:@"content"];
            NSMutableArray*array=[NSMutableArray array];
            for(NSDictionary*dic in content){
                HXExpress*express=[HXExpress new];
                express.companyLogoUrl=[HXHttpUtils whetherNil:[dic objectForKey:@"expressLogo"]];
                express.companyName=[HXHttpUtils whetherNil:[dic objectForKey:@"expressName"]];
                express.expressNo=[HXHttpUtils whetherNil:[dic objectForKey:@"expressNumber"]];
                express.orderId=[HXHttpUtils whetherNil:[dic objectForKey:@"orderNo"]];
                express.deliverCode=[HXHttpUtils whetherNil:[dic objectForKey:@"deliverCode"]];
                express.pointName=[HXHttpUtils whetherNil:[dic objectForKey:@"pointName"]];
                express.location=[HXHttpUtils whetherNil:[dic objectForKey:@"location"]];
                express.deliverCode=[HXHttpUtils whetherNil:[dic objectForKey:@"deliverCode"]];
                [array addObject:express];
            }
            if (_currentPage==0){
                _arrayList=[array mutableCopy];
                if (_arrayList.count>0)
                    _selectExpress=[_arrayList firstObject];
            }else
                [_arrayList addObjectsFromArray:array];
            
            if (array.count)
                _hasMore=YES;
            else
                _hasMore=NO;
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self updateUI:_arrayList.count>0?YES:NO];
    }];
}


//发布按钮点击
-(void)publishBtnClicked:(id)sender{
    if (_arrayList.count>0) {
        if (!_selectExpress.expressNo.length) {
            [HXAlertViewEx showInTitle:nil Message:@"请选择要发布的快递" ViewController:self];
            return;
        }
        HXCreateTaskViewController *desVC = [[HXCreateTaskViewController alloc]init];
        desVC.express=_selectExpress;
        desVC.isMyTaskCome = NO;
        [self.navigationController pushViewController:desVC animated:YES];
    }else{
        [HXAlertViewEx showInTitle:nil Message:@"暂无任务可发布" ViewController:self];
        return;
    }
}



#pragma mark --UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayList.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXExpress*express=[_arrayList objectAtIndex:indexPath.row];
    static NSString *strCell = @"cell";
    HXOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell){
        cell = [[HXOrderCell alloc] initWithCellType:HXCellTypeSelectLines];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.iconImgView setImageWithURL:[NSURL URLWithString:express.companyLogoUrl] placeholderImage:HXDefaultImg];
    cell.checkImgView.userInteractionEnabled=YES;
    UITapGestureRecognizer*tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkGesture:)];
    [cell.checkImgView addGestureRecognizer:tapGesture];
    if ([express.orderId isEqualToString:_selectExpress.orderId])
        cell.checkImgView.image=[UIImage imageNamed:@"icon_check.png"];
    else
        cell.checkImgView.image=[UIImage imageNamed:@"icon_uncheck.png"];
    cell.titleLab.text=[NSString stringWithFormat:@"%@  %@",express.companyName,express.expressNo];
    cell.subtitleLab.text=[NSString stringWithFormat:@"取件:%@",express.location];
//    cell.timeLab.text=[express.modifyTime toStringByChineseDateTimeLine];
    cell.stateLab.text=@"待领取";
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    HXExpress*express=[_arrayList objectAtIndex:indexPath.row];
//    HXReceiveOrderDetailViewController*desVC=[[HXReceiveOrderDetailViewController alloc] init];
//    desVC.express=express;
//    [self.navigationController pushViewController:desVC animated:YES];
//}



-(void)checkGesture:(UIGestureRecognizer*)gesture{
    CGPoint point=[gesture locationInView:self.tableView];
    NSIndexPath *indexpath=[self.tableView indexPathForRowAtPoint:point];
    _selectExpress=[_arrayList objectAtIndex:indexpath.row];
    [self.tableView reloadData];
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
