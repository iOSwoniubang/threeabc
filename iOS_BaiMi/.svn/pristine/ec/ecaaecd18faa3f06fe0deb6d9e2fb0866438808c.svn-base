//
//  HXSendOrderListViewController.m
//  BaiMi
//
//  Created by licl on 16/7/18.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXSendOrderListViewController.h"
#import "UIImage+Resize.h"
#import "HXExpress.h"
#import "HXOrderCell.h"
#import "MJRefresh.h"
#import "HXCreateSendOrderViewController.h"
#import "HXSendOrderDetailViewController.h"
#import "HXSendOrderLogisticDetailViewController.h"

@interface HXSendOrderListViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(strong,nonatomic)UIView*headView;
@property(strong,nonatomic)UITableView*tableView;
@property(strong,nonatomic)UIView*noneView;

@property(strong,nonatomic)NSMutableArray*listArray;
@property(assign,nonatomic)int currentPage;
@property(assign,nonatomic)BOOL hasMore;
@property(strong,nonatomic)HXLoginUser*user;
@property(strong,nonatomic)HXExpress*delExpress;
@end

@implementation HXSendOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"寄件箱";
    [self resetRightBarItem];
    self.view.backgroundColor=BackGroundColor;
    _user=[NSUserDefaultsUtil getLoginUser];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:HXNTFDoingSendOrderListRefresh object:nil];
    
    _orderSegment=HXOrderSegmentDoing;
    [self createUI];
    _listArray=[NSMutableArray array];
    _currentPage=0;
    _hasMore=YES;
    [self pullParcelsHttp];
    [self refreshDeal];
}


-(void)resetRightBarItem{
    UIButton*btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [btn setTitle:@"寄快递" forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:12.f];
    [btn setImage:[UIImage imageNamed:@"icon_sendExpress.png"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-20, 10, 0, 0)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(20, -20, 0, 0)];

    [btn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*publishBtnItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = publishBtnItem;
}


-(void)rightBtnClicked:(id)sender{
    HXCreateSendOrderViewController*desVC=[[HXCreateSendOrderViewController alloc] init];
    [self.navigationController pushViewController:desVC animated:YES];

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
    if ([notification.name isEqualToString:HXNTFDoingSendOrderListRefresh]) {
        _orderSegment=HXOrderSegmentDoing;
        _currentPage=0;
        _hasMore=YES;
        [self pullParcelsHttp];
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
    NSArray*titles=@[@"进行中",@"已完成",@"已终止"];
    
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
    _currentPage=0;
    _hasMore=YES;
    //更新列表
    [self pullParcelsHttp];
}


-(void)pullParcelsHttp{
    NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[_user.phoneNumber,[NSNumber numberWithInt:_currentPage],[NSNumber numberWithInt:_orderSegment],_user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/send/orderList" params:@{@"phoneNumber":_user.phoneNumber,@"sKey":sKey,@"status":[NSNumber numberWithInt:_orderSegment],@"currentPage":[NSNumber numberWithInt:_currentPage]} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if(error){
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
            if (_currentPage==0)
                [_listArray removeAllObjects];
        }else{
            NSArray*content=[resultJson objectForKey:@"content"];
            NSMutableArray*array=[NSMutableArray array];
            for(NSDictionary*dic in content){
                HXExpress*express=[HXExpress new];
                express.companyLogoUrl=[HXHttpUtils whetherNil:[dic objectForKey:@"expressLogo"]];
                express.companyName=[HXHttpUtils whetherNil:[dic objectForKey:@"expressName"]];
                express.companyNo=[HXHttpUtils whetherNil:[dic objectForKey:@"expressNo"]];
                express.expressNo=[HXHttpUtils whetherNil:[dic objectForKey:@"expressNumber"]];
                express.orderId=[dic objectForKey:@"orderNo"];
                express.createTime=[NSDate dateWithTimeInMsSince1970:[[dic objectForKey:@"createTime"] longLongValue]];
                express.recivePlace=[HXPlace new];
                express.recivePlace.province=[dic objectForKey:@"recipientAddressProvince"];
                express.recivePlace.city=[dic objectForKey:@"recipientAddressCity"];
                express.recivePlace.area=[dic objectForKey:@"recipientAddressArea"];
                express.recivePlace.detailAddress=[dic objectForKey:@"recipientAddress"];
                express.sendStatus=[[dic objectForKey:@"status"] intValue];
                [array addObject:express];
            }
            
            if (_currentPage==0)
                _listArray=[array mutableCopy];
            else
                [_listArray addObjectsFromArray:array];
            
            if(array.count>0)
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
        return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXExpress*express=[_listArray objectAtIndex:indexPath.row];
    static NSString*cellIdentifier=@"cell";
    HXOrderCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
            cell=[[HXOrderCell alloc] initWithCellType:HXCellTypeThreeLines];
    }
    [cell.iconImgView setImageWithURL:[NSURL URLWithString:express.companyLogoUrl] placeholderImage:[UIImage imageNamed:@"icon_company.png"]];
    if (_orderSegment==HXOrderSegmentDoing) {
        cell.titleLab.text=[express.createTime toStringByChineseDateTimeLine];
        cell.titleLab.textColor=[UIColor lightGrayColor];
        cell.titleLab.font=[UIFont systemFontOfSize:14.f];
        CGRect rect=cell.titleLab.frame;
        rect.size.width=140;
        cell.titleLab.frame=rect;
        cell.timeLab.hidden=YES;
    }else{
       cell.titleLab.text=express.companyName;
       cell.timeLab.text=[express.createTime toStringByChineseDateTimeLine];
    }
    cell.subtitleLab.text=[NSString stringWithFormat:@"寄往:%@%@%@%@",express.recivePlace.province,express.recivePlace.city,express.recivePlace.area,express.recivePlace.detailAddress];
    cell.stateLab.text=HXSendOrderStateStr(express.sendStatus);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HXExpress*express=[_listArray objectAtIndex:indexPath.row];
    if (_orderSegment==HXOrderSegmentDoing) {
        HXSendOrderDetailViewController*desVC=[[HXSendOrderDetailViewController alloc] init];
        desVC.express=express;
        [self.navigationController pushViewController:desVC animated:YES];
    }else{
        HXSendOrderLogisticDetailViewController*desVC=[[HXSendOrderLogisticDetailViewController alloc] init];
        desVC.express=express;
        [self.navigationController pushViewController:desVC animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_orderSegment==HXOrderSegmentDoing)
        return YES;
    else
        return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _delExpress=[_listArray objectAtIndex:indexPath.row];
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:nil message:@"确定取消?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1)
         [self cancelSendOrderHttp];
    else{
        self.tableView.editing=NO;
        return;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"取消";
}



//取消未付款的寄件订单接口
-(void)cancelSendOrderHttp{
    NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[_user.phoneNumber,_delExpress.orderId,_user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/send/cancelOrder" params:@{@"phoneNumber":_user.phoneNumber,@"sKey":sKey,@"orderNo":_delExpress.orderId} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error){
            [HXAlertViewEx showInTitle:nil Message:@"取消失败" ViewController:self];
        }else{
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[_listArray indexOfObject:_delExpress] inSection:0];
            [_listArray removeObject:_delExpress];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
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
