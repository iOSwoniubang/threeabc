//
//  HXMyTaskViewController.m
//  BaiMi
//
//  Created by 王放 on 16/7/12.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXMyTaskViewController.h"
#import "HXMyTaskCell.h"
#import "HXTaskOrder.h"
#import "MJRefresh.h"
#import "UIImage+Resize.h"
#import "HXTaskDetailViewController.h"

@interface HXMyTaskViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UIView*headView;
@property(strong,nonatomic)UIView*bgView;
@property(strong,nonatomic)UITableView *table;
@property(strong,nonatomic)NSMutableArray *arrayList;
@property(assign,nonatomic)int currentPage;
@property(assign,nonatomic)BOOL isHelpView;
@property(strong,nonatomic)UIImageView *imageTriangle;//小三角
@property(strong,nonatomic)UIView*noneView;
@property(strong,nonatomic)UIView*line;

@end

@implementation HXMyTaskViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
    _currentPage = 0;
    [self pullParcelsHttp];
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=BackGroundColor;
    //发布的任务被接受
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:HXNTFTaskAcceptedNotice object:nil];
    _isHelpView=NO;
    _currentPage = 0;

    [self resetNavBar];
    [self createTitUI];
    [self resetHeadView];
    [self resetTabel];
    
}


-(void)resetNavBar{
   UIView * barView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    barView.backgroundColor=LightBlueColor;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 13, 20)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"btnBack.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:backBtn];
    
    UILabel*titleLab=[[UILabel alloc] initWithFrame:CGRectMake(80, 30, SCREEN_WIDTH-80*2, 20)];
    titleLab.text=@"我的任务";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    titleLab.font=[UIFont boldSystemFontOfSize:20.0];
    [barView addSubview:titleLab];
    [self.view addSubview:barView];
}
-(void)backBtnClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createTitUI{
     [self.navigationController.navigationBar setBackgroundColor:LightBlueColor];
    UIView *titleBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 30)];
    titleBgview.backgroundColor = LightBlueColor;
    [self.view addSubview:titleBgview];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    [button setTitle:@"帮助" forState:UIControlStateSelected];
    [button setTitle:@"发布" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.selected = NO;
    button.titleLabel.font=[UIFont systemFontOfSize:15.f];
    [button addTarget:self action:@selector(clickState:) forControlEvents:UIControlEventTouchUpInside];
    [titleBgview addSubview:button];
    _imageTriangle = [[UIImageView alloc]init];
    _imageTriangle.image = [UIImage imageNamed:@"ico_lef.png"];
    _imageTriangle.transform = CGAffineTransformMakeRotation(M_PI);
    _imageTriangle.frame = CGRectMake(SCREEN_WIDTH/2.0+60-10,10, 10, 10);
    [titleBgview addSubview:_imageTriangle];
}
-(void)clickState:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        _isHelpView = YES;//帮助页面
        _imageTriangle.transform = CGAffineTransformMakeRotation(2 * M_PI);
        _imageTriangle.frame = CGRectMake(SCREEN_WIDTH/2.0-60,10, 10, 10);
    }else{
        _isHelpView = NO;//发布页面
        _imageTriangle.transform = CGAffineTransformMakeRotation(M_PI);
        _imageTriangle.frame = CGRectMake(SCREEN_WIDTH/2.0+60-10,10, 10, 10);
    }
    _currentPage = 0;
    [self pullParcelsHttp];
}
-(void)resetHeadView{
    _orderSegment=HXOrderSegmentDoing;
    _headView=[[UIView alloc] initWithFrame:CGRectMake(0,64 + 30, self.view.frame.size.width,40)];
    _headView.backgroundColor=[UIColor whiteColor];
    _line=[[UIView alloc] initWithFrame:CGRectMake(0,ViewFrame_H(_headView)-0.5, _headView.frame.size.width, 0.5)];
    _line.backgroundColor=BolderColor;
    [_headView addSubview:_line];

    int width=(_headView.frame.size.width)/2;
    NSArray*titles=@[@"进行中",@"已完成"];
    for(int i=0;i<2;i++){
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
    if (_orderSegment==btn.tag)
        return;
    
    btn.selected=YES;
    _orderSegment=btn.tag;
    for(UIView*view in _headView.subviews){
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton*button=(UIButton*)view;
            if (button.tag!=btn.tag)
                button.selected=NO;
        }
    }
    _currentPage = 0;
    [self pullParcelsHttp];
}

-(void)pullParcelsHttp{
    HXLoginUser *user = [NSUserDefaultsUtil getLoginUser];
    if (!_arrayList) {
        _arrayList = [[NSMutableArray alloc] init];
    }
    NSString*skey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,_isHelpView?@"2":@"1",[NSNumber numberWithInt:_currentPage],[NSNumber numberWithInt:_orderSegment],user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/receive/myMissoinList" params:@{@"phoneNumber":user.phoneNumber,@"sKey":skey,@"type":_isHelpView?@"2":@"1",@"status":[NSNumber numberWithInt:_orderSegment],@"currentPage":[NSNumber numberWithInt:_currentPage]} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (_currentPage==0) {
            [_arrayList removeAllObjects];
        }
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            NSArray *arrayResult = [resultJson objectForKey:@"content"];
            for (NSDictionary *dictionary in arrayResult) {
                // [NSString stringWithFormat:@"%@ %@",_order.expressCompanyName,_order.expressNo];
                NSLog(@"xxxxxxxxx   %@",dictionary);
                HXTaskOrder *oneOrder = [[HXTaskOrder alloc] init];
                oneOrder.orderNo = [HXHttpUtils whetherNil:[dictionary objectForKey:@"orderNo"]];
                oneOrder.expressCompanyName = [HXHttpUtils whetherNil:[dictionary objectForKey:@"expressName"]];
                oneOrder.expressNo = [HXHttpUtils whetherNil:[dictionary objectForKey:@"expressNumber"]];
                oneOrder.deliverCode = [HXHttpUtils whetherNil:[dictionary objectForKey:@"deliverCode"]];
                oneOrder.publisherPhoneNumber = [HXHttpUtils whetherNil:[dictionary objectForKey:@"publishPhoneNumber"]];
                oneOrder.publisherNickName = [HXHttpUtils whetherNil:[dictionary objectForKey:@"publisherNickName"]];
                oneOrder.publisherLogo = [HXHttpUtils whetherNil:[dictionary objectForKey:@"publisherLogo"]];
                oneOrder.fetcherLogo = [HXHttpUtils whetherNil:[dictionary objectForKey:@"fetcherLogo"]];
                oneOrder.fetcherPhoneNumber = [HXHttpUtils whetherNil:[dictionary objectForKey:@"fetcherPhoneNumer"]];
                oneOrder.fetcherNickName = [HXHttpUtils whetherNil:[dictionary objectForKey:@"fetcherNickName"]];
                oneOrder.status = [[HXHttpUtils whetherNil:[dictionary objectForKey:@"status"]] intValue];
                
                oneOrder.position = [HXHttpUtils whetherNil:[dictionary objectForKey:@"position"]];
                oneOrder.source = [HXHttpUtils whetherNil:[dictionary objectForKey:@"source"]];
                oneOrder.target = [HXHttpUtils whetherNil:[dictionary objectForKey:@"target"]];
                oneOrder.deadLine=[[HXHttpUtils whetherNil:[dictionary objectForKey:@"deadLine"]] isEqualToString:@""]?nil:[NSDate dateWithTimeInMsSince1970:[[dictionary objectForKey:@"deadLine"]  longLongValue]];
                oneOrder.createTime=[[HXHttpUtils whetherNil:[dictionary objectForKey:@"createTime"]] isEqualToString:@""]?nil:[NSDate dateWithTimeInMsSince1970:[[dictionary objectForKey:@"createTime"]  longLongValue]];
                if (oneOrder.status == HXTaskStatusAccept) {
                    oneOrder.acceptTime=[[HXHttpUtils whetherNil:[dictionary objectForKey:@"acceptTime"]] isEqualToString:@""]?nil:[NSDate dateWithTimeInMsSince1970:[[dictionary objectForKey:@"acceptTime"]  longLongValue]];
                }else if (oneOrder.status == HXTaskStatusPickup){
                    oneOrder.acceptTime=[[HXHttpUtils whetherNil:[dictionary objectForKey:@"acceptTime"]] isEqualToString:@""]?nil:[NSDate dateWithTimeInMsSince1970:[[dictionary objectForKey:@"acceptTime"]  longLongValue]];
                    oneOrder.pickupTime=[[HXHttpUtils whetherNil:[dictionary objectForKey:@"pickUpTime"]] isEqualToString:@""]?nil:[NSDate dateWithTimeInMsSince1970:[[dictionary objectForKey:@"pickUpTime"]  longLongValue]];
                }else if (oneOrder.status == HXTaskStatusComplete){
                    oneOrder.acceptTime=[[HXHttpUtils whetherNil:[dictionary objectForKey:@"acceptTime"]] isEqualToString:@""]?nil:[NSDate dateWithTimeInMsSince1970:[[dictionary objectForKey:@"acceptTime"]  longLongValue]];
                    oneOrder.pickupTime=[[HXHttpUtils whetherNil:[dictionary objectForKey:@"pickUpTime"]] isEqualToString:@""]?nil:[NSDate dateWithTimeInMsSince1970:[[dictionary objectForKey:@"pickUpTime"]  longLongValue]];
                    oneOrder.arriveTime=[[HXHttpUtils whetherNil:[dictionary objectForKey:@"arriveTime"]] isEqualToString:@""]?nil:[NSDate dateWithTimeInMsSince1970:[[dictionary objectForKey:@"arriveTime"]  longLongValue]];
                }else if (oneOrder.status == HXTaskStatusGetGoods){
                    oneOrder.acceptTime=[[HXHttpUtils whetherNil:[dictionary objectForKey:@"acceptTime"]] isEqualToString:@""]?nil:[NSDate dateWithTimeInMsSince1970:[[dictionary objectForKey:@"acceptTime"]  longLongValue]];
                    oneOrder.pickupTime=[[HXHttpUtils whetherNil:[dictionary objectForKey:@"pickUpTime"]] isEqualToString:@""]?nil:[NSDate dateWithTimeInMsSince1970:[[dictionary objectForKey:@"pickUpTime"]  longLongValue]];
                    oneOrder.arriveTime=[[HXHttpUtils whetherNil:[dictionary objectForKey:@"arriveTime"]] isEqualToString:@""]?nil:[NSDate dateWithTimeInMsSince1970:[[dictionary objectForKey:@"arriveTime"]  longLongValue]];
                    oneOrder.completeTime=[[HXHttpUtils whetherNil:[dictionary objectForKey:@"completeTime"]] isEqualToString:@""]?nil:[NSDate dateWithTimeInMsSince1970:[[dictionary objectForKey:@"completeTime"]  longLongValue]];
                }
                oneOrder.deliverCode=[HXHttpUtils whetherNil:[dictionary objectForKey:@"deliverCode"]];
                oneOrder.remark = [HXHttpUtils whetherNil:[dictionary objectForKey:@"remark"]];
                oneOrder.fee = [[HXHttpUtils whetherNil:[dictionary objectForKey:@"fee"]] floatValue];
                oneOrder.weightType = [[HXHttpUtils whetherNil:[dictionary objectForKey:@"weightType"]] intValue];
                
                oneOrder.appraiseStatus = [[HXHttpUtils whetherNil:[dictionary objectForKey:@"appraiseStatus"]] intValue];
                [_arrayList addObject:oneOrder];
            }
        }
        [_table reloadData];
        [_table.mj_header endRefreshing];
        [_table.mj_footer endRefreshing];
        [self updateUI:_arrayList.count>0?YES:NO];
    }];
}

-(void)resetTabel{
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, ViewFrameY_H(_headView), SCREEN_WIDTH, SCREEN_HEIGHT - ViewFrameY_H(_headView)) style:UITableViewStyleGrouped];
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
        [self pullParcelsHttp];
    }];
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉加载更多
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _currentPage++;
        [self pullParcelsHttp];
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrayList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *strCell = @"cell";
    HXMyTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell){
        cell = [[HXMyTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    HXTaskOrder *order = [_arrayList objectAtIndex:indexPath.section];
    cell.weatherClean.text = @"";
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:order.publisherLogo] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    cell.feeLabel.text = [NSString stringWithFormat:@"酬劳：%.2f元",order.fee];
    cell.weightLabel.text = [NSString stringWithFormat:@"重量：%@",HXWeightTypeStr(order.weightType)];
    cell.acceptTimeLabel.text =order.status<HXTaskStatusAccept?@"待接受":[NSString stringWithFormat:@"%@ 接受任务",[order.acceptTime toStringByChineseDateTimeLine]];
    NSLog(@"00001111%@",cell.acceptTimeLabel.text);
    if (order.position.length)
         cell.sourceLabel.text = [NSString stringWithFormat:@"%@(%@)",order.source,order.position];
    else
        cell.sourceLabel.text=order.source;
    cell.targetLabel.text = order.target;
    if (_isHelpView) {//帮助
        if (_orderSegment==HXOrderSegmentDoing) {//进行中
            cell.completeTimeLabel.text = @"未完成任务";
            cell.completeTimeLabel.textColor = RGBA(91, 197, 115, 1);
            cell.remarkLabel.text = order.remark;
        }else if (_orderSegment==HXOrderSegmentFinish){//已完成
            cell.completeTimeLabel.text = [NSString stringWithFormat:@"%@ 完成任务",[order.completeTime toStringByChineseDateTimeLine]];
            cell.completeTimeLabel.textColor = LightBlueColor;
            
            cell.remarkLabel.text = order.remark;
        }else{//已终止
            cell.completeTimeLabel.text = @"已停止任务";
            cell.completeTimeLabel.textColor = RGBA(247, 66, 73, 1);
            cell.terminationLabel.text = order.cancelRemark;
        }
    }else{//发布
        if (_orderSegment==HXOrderSegmentDoing) {//进行中
            cell.completeTimeLabel.text = @"未完成任务";
            cell.completeTimeLabel.textColor = RGBA(91, 197, 115, 1);
            cell.remarkLabel.text = order.remark;
        }else if (_orderSegment==HXOrderSegmentFinish){//已完成
            cell.completeTimeLabel.text = [NSString stringWithFormat:@"%@ 完成任务",[order.completeTime toStringByChineseDateTimeLine]];
            cell.completeTimeLabel.textColor = LightBlueColor;
            
            cell.remarkLabel.text = order.remark;
            
            
        }else{//已终止
            cell.completeTimeLabel.text = @"已停止任务";
            cell.completeTimeLabel.textColor = RGBA(247, 66, 73, 1);
            cell.terminationLabel.text = order.cancelRemark;
        }
    }
   
    if (_orderSegment==HXOrderSegmentFinish){
        
        if (order.appraiseStatus==2) {//赞
            cell.praiseView.frame = CGRectMake(SCREEN_WIDTH-75, 120, 50, 40);
        }else if (order.appraiseStatus==3){//踩
            cell.contemptView.frame = CGRectMake(SCREEN_WIDTH-75, 120, 50, 40);
        }else{
            if (!_isHelpView) {
                UITapGestureRecognizer*tapGestureOne=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureOne:)];
                cell.praiseView.frame = CGRectMake(SCREEN_WIDTH-100, 120, 50, 40);
                cell.praiseView.userInteractionEnabled = !_isHelpView;
                cell.praiseView.tag = indexPath.section;
                [cell.praiseView addGestureRecognizer:tapGestureOne];
                
                UITapGestureRecognizer*tapGestureTwo=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureTwo:)];
                cell.contentView.frame = CGRectMake(SCREEN_WIDTH-50, 120, 50, 40);
                cell.contemptView.tag = indexPath.section;
                cell.contemptView.userInteractionEnabled = !_isHelpView;
                [cell.contemptView addGestureRecognizer:tapGestureTwo];
            }
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return .1;
    }else
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 160;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HXTaskDetailViewController *taskDetail = [[HXTaskDetailViewController alloc]init];
    taskDetail.hidesBottomBarWhenPushed = YES;
    HXTaskOrder *oneOrder = [_arrayList objectAtIndex:indexPath.section];
    taskDetail.order=oneOrder;
    taskDetail.isHelpView = _isHelpView;
    [self.navigationController pushViewController:taskDetail animated:YES];
}
   
-(void)tapGestureOne:(UITapGestureRecognizer *)sender {
    //点赞
    [self httpEvaluationWeather:sender.view.tag andIsPraiseView:YES];
}
-(void)tapGestureTwo:(UITapGestureRecognizer *)sender {
    //踩
    [self httpEvaluationWeather:sender.view.tag andIsPraiseView:NO];
}
-(void)httpEvaluationWeather:(NSInteger)number andIsPraiseView:(BOOL)ispraiseView{
    HXTaskOrder *oneOrder = [_arrayList objectAtIndex:number];
    HXLoginUser *user = [NSUserDefaultsUtil getLoginUser];
    NSString*skey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,oneOrder.fetcherPhoneNumber,ispraiseView?@"2":@"3",oneOrder.orderNo,user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/receive/appraiseFetcher" params:@{@"phoneNumber":user.phoneNumber,@"sKey":skey,@"fetcherPhoneNumber":oneOrder.fetcherPhoneNumber,@"orderNo":oneOrder.orderNo,@"appraiseStatus":ispraiseView?@"2":@"3"} onComplete:^(NSError *error, NSDictionary *resultJson) {
        NSLog(@"%@",resultJson);
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            HXMyTaskCell *cell = [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:number]];
            if (ispraiseView) {//赞
                cell.praiseView.frame = CGRectMake(SCREEN_WIDTH-75, 120, 50, 40);
                cell.contemptView.hidden = YES;
                cell.praiseView.userInteractionEnabled = NO;
            }else{//踩
                cell.contemptView.frame = CGRectMake(SCREEN_WIDTH-75, 120, 50, 40);
                cell.contemptView.userInteractionEnabled = NO;
                cell.praiseView.hidden = YES;
            }
            [HXAlertViewEx showInTitle:nil Message:[NSString stringWithFormat:@"%@成功",ispraiseView?@"点赞":@"点踩"] ViewController:self];
            if (ispraiseView) {//赞
                cell.praiseView.frame = CGRectMake(SCREEN_WIDTH-75, 120, 50, 40);
                cell.contemptView.hidden = YES;
                cell.praiseView.userInteractionEnabled = NO;
            }else{//踩
                cell.contemptView.frame = CGRectMake(SCREEN_WIDTH-75, 120, 50, 40);
                cell.contemptView.userInteractionEnabled = NO;
                cell.praiseView.hidden = YES;
            }
        }
    }];
}


//我的任务被接受通知即时更改任务状态
-(void)onNotification:(NSNotification*)notification{
    if ([notification.name isEqualToString:HXNTFTaskAcceptedNotice]) {
        if(!_isHelpView){
           _currentPage = 0;
            [self pullParcelsHttp];
        }
        return;
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
