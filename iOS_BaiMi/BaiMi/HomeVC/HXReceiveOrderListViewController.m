//
//  HXReceiveOrderListViewController.m
//  BaiMi
//
//  Created by licl on 16/7/13.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXReceiveOrderListViewController.h"
#import "UIImage+Resize.h"
#import "HXExpress.h"
#import "HXOrderCell.h"
#import "MJRefresh.h"
#import "HXReceiveOrderDetailViewController.h"

@interface HXReceiveOrderListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UIView*headView;
@property(strong,nonatomic)UITableView*tableView;
@property(strong,nonatomic)UIView*noneView;

@property(strong,nonatomic)NSMutableArray*listArray;
@property(assign,nonatomic)int currentPage;
@property(assign,nonatomic)BOOL hasMore;

@end

@implementation HXReceiveOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"收件箱";
    self.view.backgroundColor=BackGroundColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:HXNTFNewRecieveOrderNotice object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:HXNTFReceiveOrderSharedRefresh object:nil];
    _orderSegment=HXOrderSegmentUndeal;
    [self createUI];
     _listArray=[NSMutableArray array];
    _currentPage=0;
    _hasMore=YES;
    [self pullParcelsHttp];
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

-(void)onNotification:(NSNotification*)notification{
    if ([notification.name isEqualToString:HXNTFNewRecieveOrderNotice]) {
        //增加新包裹通知即时更新
        if (_orderSegment==HXOrderSegmentUndeal){
            _currentPage=0;
            _hasMore=YES;
            [self pullParcelsHttp];
            }
        return;
    }else if ([notification.name isEqualToString:HXNTFReceiveOrderSharedRefresh]){
      if (_orderSegment==HXOrderSegmentUndeal){
          HXExpress*shareExpress=notification.object;
          for(HXExpress*express in _listArray){
              if ([express.orderId isEqualToString:shareExpress.orderId]) {
                  express.shareStatus=HXReceiveOrderShared;
                  break;
              }
          }
      }
        return;
    }
}


-(void)createUI{
    [self resetHeadView];
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,ViewFrameY_H(_headView), SCREEN_WIDTH, SCREEN_HEIGHT-_headView.frame.size.height-64) style:UITableViewStyleGrouped];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.view addSubview:self.tableView];
    
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

-(void)resetHeadView{
    _headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,40)];
    _headView.backgroundColor=[UIColor whiteColor];
    UIView*line=[[UIView alloc] initWithFrame:CGRectMake(0,ViewFrame_H(_headView)-0.5, _headView.frame.size.width, 0.5)];
    line.backgroundColor=BolderColor;
    [_headView addSubview:line];
    int width=(_headView.frame.size.width)/3;
    NSArray*titles=@[@"未收件",@"已收件",@"已退件"];
    
    for(int i=0;i<3;i++){
        UIButton*btn=[[UIButton alloc] initWithFrame:CGRectMake(i*width,0,width, _headView.frame.size.height-0.5)];
        btn.tag=i+1;
        [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:LightBlueColor forState:UIControlStateSelected];
        btn.titleLabel.font=[UIFont systemFontOfSize:15.f];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[[UIImage imageNamed:@"blueLine.png"] scaleImageToSize:CGSizeMake(width, 2)] forState:UIControlStateSelected];
        [btn setImage:[[UIImage imageNamed:@"clearImage.png"] scaleImageToSize:CGSizeMake(width, 2)] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(40, 0, 2, 0)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0,-width,5,0)];
        [_headView addSubview:btn];
        
        if (btn.tag==_orderSegment)
            btn.selected=YES;
        else
            btn.selected=NO;
    }
    [self.view addSubview:_headView];
}


-(void)btnClicked:(id)sender{
    UIButton*btn=(UIButton*)sender;
    btn.selected=YES;
    _orderSegment=btn.tag;
    for(UIView*view in _headView.subviews){
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton*button=(UIButton*)view;
            if (button.tag!=btn.tag)
                button.selected=NO;
        }
    }
    
   //更新列表
    _currentPage=0;
    _hasMore=YES;
    [self pullParcelsHttp];
}

-(void)pullParcelsHttp{
    HXLoginUser*user=[NSUserDefaultsUtil getLoginUser];
    NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,[NSNumber numberWithInt:_orderSegment],user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/receive/orderList" params:@{@"phoneNumber":user.phoneNumber,@"sKey":sKey,@"status":[NSNumber numberWithInt:_orderSegment],@"currentPage":[NSNumber numberWithInt:_currentPage]} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if(error){
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
            if (_currentPage==0)
                [_listArray removeAllObjects];
            
        }else{
            NSArray*content=[resultJson objectForKey:@"content"];
            NSMutableArray*array=[NSMutableArray array];
            for(NSDictionary*dic in content){
                HXExpress*express=[HXExpress new];
                express.companyLogoUrl=[dic objectForKey:@"expressLogo"];
                express.companyName=[dic objectForKey:@"expressName"];
                express.companyNo=[dic objectForKey:@"expressNo"];
                express.expressNo=[dic objectForKey:@"expressNumber"];
                express.orderId=[dic objectForKey:@"orderNo"];
                express.status=[[dic objectForKey:@"status"] intValue];
                express.paymentType=[[dic objectForKey:@"paymentType"] intValue]; //未收件中（已付款 、未付款到付的）
                express.pointName=[dic objectForKey:@"pointName"];
                express.location=[dic objectForKey:@"location"];
                express.deliverCode=[HXHttpUtils whetherNil:[dic objectForKey:@"deliverCode"]];
                express.shareStatus=[[dic objectForKey:@"shareStatus"] intValue];
                [array addObject:express];
            }
            if (_currentPage==0)
                _listArray=[array mutableCopy];
            else
                [_listArray addObjectsFromArray:array];
            
            if (array.count)
                _hasMore=YES;
            else
                _hasMore=NO;
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self updateUI:_listArray.count>0?YES:NO];
    }];
}


#pragma mark--UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_orderSegment==HXOrderSegmentUndeal)
        return 110;
    else
        return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXExpress*express=[_listArray objectAtIndex:indexPath.row];
    static NSString*cellIdentifier=@"cell";
    HXOrderCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        if (_orderSegment==HXOrderSegmentUndeal)
            cell=[[HXOrderCell alloc] initWithCellType:HXCellTypeThreeLines];
        else
            cell=[[HXOrderCell alloc] initWithCellType:HXCellTypeTwoLines];
    }
    [cell.iconImgView setImageWithURL:[NSURL URLWithString:express.companyLogoUrl] placeholderImage:HXDefaultImg];
    cell.titleLab.text=express.companyName;
    cell.subtitleLab.text=express.expressNo;
    cell.timeLab.text=[express.modifyTime toStringByChineseDateTimeLine];
    if(express.paymentType==HXPaymentTypeUnpayed)
        cell.stateLab.text=@"未付款";
    else{
        if((express.status<HXReceiveOrderTake) && (express.shareStatus>HXReceiveOrderUnShared))
            cell.stateLab.text=HXReceiveOrderSharedStateStr(express.shareStatus);
        else
            cell.stateLab.text=HXReceiveOrderStateStr(express.status);
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HXExpress*express=[_listArray objectAtIndex:indexPath.row];
    HXReceiveOrderDetailViewController*desVC=[[HXReceiveOrderDetailViewController alloc] init];
    desVC.express=express;
    if (_orderSegment==HXOrderSegmentUndeal && express.paymentType==HXPaymentTypePayed)
        desVC.canShare=YES;
    [self.navigationController pushViewController:desVC animated:YES];
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
