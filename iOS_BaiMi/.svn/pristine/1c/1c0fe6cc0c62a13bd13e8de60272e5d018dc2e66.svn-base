//
//  HXParcelCodeListViewController.m
//  BaiMi
//
//  Created by licl on 16/7/12.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXParcelCodeListViewController.h"
#import "HXParcelCodeCell.h"
#import "UIImage+Resize.h"
#import "HXExpress.h"
#import "MJRefresh.h"

@interface HXParcelCodeListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView*tableView;
@property(strong,nonatomic)UIView*noneView;
@property(strong,nonatomic)NSMutableArray*listArray;
//@property(assign,nonatomic)int currentPage;

@end

@implementation HXParcelCodeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"一键取件";
    self.view.backgroundColor=BackGroundColor;
    [self createUI];
    _listArray=[NSMutableArray array];
    [self pullOrderNoListHttp];
    [self refreshDeal];
}

-(void)refreshDeal{
    __unsafe_unretained UITableView*tableView=self.tableView;
    tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pullOrderNoListHttp];
    }];
    tableView.mj_header.automaticallyChangeAlpha = YES;
}

-(void)createUI{
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
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



-(void)pullOrderNoListHttp{
    HXLoginUser*user=[NSUserDefaultsUtil getLoginUser];
     NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/receive/waitingPickupList" params:@{@"phoneNumber":user.phoneNumber,@"sKey":sKey} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            NSArray*content=[resultJson objectForKey:@"content"];
             NSMutableArray*array=[NSMutableArray array];
            for(NSDictionary*dic in content){
                HXExpress*express=[HXExpress new];
                express.orderId=[dic objectForKey:@"orderNo"];
                express.deliverCode=[dic objectForKey:@"deliverCode"];
                [array addObject:express];
            }
                _listArray=[array mutableCopy];
                if (_listArray.count>0) {
                    HXExpress*express=[_listArray firstObject];
                    express.expand=YES;
                }
        }
        [_tableView reloadData];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [self updateUI:_listArray.count>0?YES:NO];
    }];
}


#pragma mark--UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _listArray.count;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HXExpress*express=[_listArray objectAtIndex:section];
    UIView*bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 40)];
    bgView.backgroundColor=BackGroundColor;
    UIView*view=[[UIView alloc] initWithFrame:CGRectMake(10, 5, bgView.frame.size.width-20, bgView.frame.size.height-10)];
    view.backgroundColor=[UIColor whiteColor];
    view.layer.cornerRadius=view.frame.size.height/2;
    view.layer.borderColor=LightBlueColor.CGColor;
    view.layer.borderWidth=1;
    view.clipsToBounds=YES;
    UIImageView*arrowImgView=[[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width-20, 10, 10, 10)];
    if (express.expand)
          arrowImgView.image=[UIImage imageNamed:@"icon_arrowUp.png"];
    else
          arrowImgView.image=[UIImage imageNamed:@"icon_arrowDown.png"];

    [view addSubview:arrowImgView];
    UILabel*orderLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, view.frame.size.width-30, 30)];
    orderLab.backgroundColor=[UIColor clearColor];
    orderLab.text=[NSString stringWithFormat:@"订单号:%@",express.orderId];
    orderLab.textAlignment=NSTextAlignmentCenter;
    orderLab.textColor=LightBlueColor;
    [view addSubview:orderLab];
    [bgView addSubview:view];
    UIButton*btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height)];
    btn.tag=section;
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    return bgView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_listArray.count) {
        HXExpress*express=[_listArray objectAtIndex:section];
        if (express.expand)
            return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return 230;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        HXExpress*express=[_listArray objectAtIndex:indexPath.row];
            static NSString*cellIdentifier=@"cell";
            HXParcelCodeCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
                cell=[[HXParcelCodeCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 230)];
            UIImage*barImg=[UIImage generateBarCode:express.orderId width:cell.barCodeImgView.frame.size.width height:cell.barCodeImgView.frame.size.height];
            cell.barCodeImgView.image=barImg;
            cell.codeLab.text=express.deliverCode;
            UIImage*qrImg=[UIImage generateQRCode:express.deliverCode width:cell.qrCodeImgView.frame.size.width height:cell.qrCodeImgView.frame.size.height];
            cell.qrCodeImgView.image=qrImg;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//展合点击
-(void)btnClicked:(id)sender{
    UIButton*btn=(UIButton*)sender;
    HXExpress*express=[_listArray objectAtIndex:btn.tag];
    express.expand=!express.expand;
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
