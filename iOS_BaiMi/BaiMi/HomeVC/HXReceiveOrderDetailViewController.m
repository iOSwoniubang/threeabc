//
//  HXReceiveOrderDetailViewController.m
//  BaiMi
//
//  Created by licl on 16/7/13.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXReceiveOrderDetailViewController.h"
#import "HXParcelCodeViewController.h"
#import "HXLogisticTraceCell.h"
#import "AFNetworking.h"
#import "NSString+Encryption.h"
#import "HXCreateTaskViewController.h"
#import "HXOrderShareListViewController.h"

@interface HXReceiveOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property(strong,nonatomic)UIScrollView *scrollView;
@property(strong,nonatomic)UIView*logisticView;
@property(strong,nonatomic)UITableView*tableView;

@property(assign,nonatomic)int totalHeadHeight;
@end

@implementation HXReceiveOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"收件详情";
    self.view.backgroundColor=BackGroundColor;
//    if (_showCodeSign&&_express.shareStatus!=HXReceiveOrderInTaskSquare)
    if (_canShare)
    [self resetRightBarItem];
    [self createUI];
    _express.traceArray=[NSMutableArray array];
    [self pullLogisticTracesHttp];
}

-(void)resetRightBarItem{
//    UIBarButtonItem* publishBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBtnClicked:)];
//    self.navigationItem.rightBarButtonItem = publishBtnItem;
    
    UIButton*btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    [btn setTitle:@"分享" forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:12.f];
    btn.layer.borderColor=[UIColor whiteColor].CGColor;
    btn.layer.cornerRadius=btn.frame.size.height/2;
    btn.layer.borderWidth=1.f;
    [btn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*publishBtnItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = publishBtnItem;
}

 
-(void)rightBtnClicked:(id)sender{
  //分享
    HXOrderShareListViewController*desVC=[[HXOrderShareListViewController alloc] init];
    desVC.express=_express;
    [self.navigationController pushViewController:desVC animated:YES];
}


-(void)createUI{
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    _scrollView.backgroundColor=BackGroundColor;
    [self.view addSubview:_scrollView];
    
    UIView*headView=[[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 100)];
    headView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:headView];
    int Width=headView.frame.size.width-20;
    UIFont*myFont=[UIFont systemFontOfSize:16.f];
    UILabel*companyLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 10,Width, 21)];
    companyLab.font=myFont;
    companyLab.text=[NSString stringWithFormat:@"快递公司: %@",_express.companyName];
    [headView addSubview:companyLab];
    UILabel*expressNoLab=[[UILabel alloc] initWithFrame:CGRectMake(10, ViewFrameY_H(companyLab)+5, Width, 21)];
    expressNoLab.font=myFont;
    expressNoLab.text=[NSString stringWithFormat:@"快递单号: %@",_express.expressNo];
    [headView addSubview:expressNoLab];
    UILabel*locationLab=[[UILabel alloc] initWithFrame:CGRectMake(10, ViewFrameY_H(expressNoLab)+5, Width, 21)];
    locationLab.font=myFont;
    locationLab.text=[NSString stringWithFormat:@"收件地址: %@",_express.pointName];
    locationLab.numberOfLines=0;
    float height=STRING_SIZE_FONT(Width, locationLab.text, 16.f).height;
    CGRect locationRect=locationLab.frame;
    locationRect.size.height=height;
    locationLab.frame=locationRect;
    [headView addSubview:locationLab];
    CGRect rect=headView.frame;
    rect.size.height=ViewFrameY_H(locationLab)+10;
    headView.frame=rect;
    if (_canShare && _express.deliverCode.length) {
        CGRect rect=headView.frame;
        rect.size.height=ViewFrameY_H(locationLab)+5+10+30+10;
        headView.frame=rect;
        UIImageView*lineImgView=[[UIImageView alloc] initWithFrame:CGRectMake(5, ViewFrameY_H(locationLab)+5, SCREEN_WIDTH-10, 1)];
        lineImgView.image=[UIImage imageNamed:@"dottedLine.png"];
        [headView addSubview:lineImgView];
        UIButton*getCodeBtn=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-100, ViewFrameY_H(lineImgView)+10, 100, 30)];
        getCodeBtn.backgroundColor=LightBlueColor;
        [getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [getCodeBtn setTitle:@"查看取件码" forState:UIControlStateNormal];
        getCodeBtn.layer.cornerRadius=getCodeBtn.frame.size.height/2;
        getCodeBtn.titleLabel.font=[UIFont systemFontOfSize:15.f];
        [getCodeBtn addTarget:self action:@selector(getCodeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:getCodeBtn];
    }
    _logisticView=[[UIView alloc] initWithFrame:CGRectMake(0, ViewFrameY_H(headView)+10, SCREEN_WIDTH, SCREEN_HEIGHT-ViewFrameY_H(headView)-10-64)];
    _logisticView.backgroundColor=[UIColor whiteColor];
    UILabel*stateLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, _logisticView.frame.size.width-20, 21)];
    stateLab.font=myFont;
    NSString*stateStr=@"";
    if (_express.paymentType==HXPaymentTypeUnpayed)
        stateStr=@"未付款";
    else
        stateStr=HXReceiveOrderStateStr(_express.status);
    stateLab.text=[NSString stringWithFormat:@"快递状态: %@",stateStr];
    [_logisticView addSubview:stateLab];
    UILabel*pointLocationLab=[[UILabel alloc] initWithFrame:CGRectMake(10, ViewFrameY_H(stateLab)+10, stateLab.frame.size.width, 21)];
    pointLocationLab.font=myFont;
    pointLocationLab.text=[NSString stringWithFormat:@"取件地址: %@",_express.location];
    pointLocationLab.numberOfLines=0;
    float height1=STRING_SIZE_FONT(Width, pointLocationLab.text, 16.f).height;
    CGRect pointLocationRect=pointLocationLab.frame;
    pointLocationRect.size.height=height1;
    pointLocationLab.frame=pointLocationRect;
    [_logisticView addSubview:pointLocationLab];
   
    UILabel*logisticLab=[[UILabel alloc] initWithFrame:CGRectMake(10, ViewFrameY_H(pointLocationLab)+10, 70, 21)];
    logisticLab.font=myFont;
    logisticLab.text=@"物流信息:";
    [_logisticView addSubview:logisticLab];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(ViewFrameX_W(logisticLab), logisticLab.frame.origin.y,SCREEN_WIDTH- 80, _logisticView.frame.size.height-ViewFrameY_H(logisticLab)+21)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_logisticView addSubview:_tableView];
    [_scrollView addSubview:_logisticView];
    
    _scrollView.delegate=self;
    _scrollView.scrollEnabled=YES;
    _totalHeadHeight=ViewFrameY_H(headView);
    float heightTotal=_totalHeadHeight+self.tableView.contentSize.height+64+10;
    heightTotal=heightTotal>SCREEN_HEIGHT?heightTotal:SCREEN_HEIGHT;
    _scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,heightTotal);
    _scrollView.showsVerticalScrollIndicator=YES;

}


//查看取件码
-(void)getCodeBtnClicked:(id)sender{
    HXParcelCodeViewController*desVC=[[HXParcelCodeViewController alloc] init];
    desVC.code=_express.deliverCode;
    [self.navigationController pushViewController:desVC animated:YES];

}

-(void)pullLogisticTracesHttp{
    
    [HXHttpUtils requestJsonPostOfKdniaoTrackQueryAPIWithShipperCode:_express.companyNo LogisticCode:_express.expressNo onComplete:^(NSString *errorReason, NSDictionary *resultJson){
        if (errorReason) {
            [HXAlertViewEx showInTitle:nil Message:errorReason ViewController:self];
        }else{
            NSArray*traces=[resultJson objectForKey:@"Traces"];
            for(NSDictionary*dic in traces){
                HXLogisticTrace*trace=[HXLogisticTrace new];
                trace.acceptStation=[dic objectForKey:@"AcceptStation"];
                trace.acceptTimeStr=[dic objectForKey:@"AcceptTime"];
                [_express.traceArray addObject:trace];
            }
            _express.traceArray=[[[_express.traceArray reverseObjectEnumerator] allObjects] mutableCopy];
            [self updateUIHeight];
            [self.tableView reloadData];
        }
    }];
}

-(void)updateUIHeight{
    int width=self.tableView.frame.size.width-50;
    float HEIGHT=0;
    for(HXLogisticTrace*t in _express.traceArray){
        float height1=  STRING_SIZE_FONT(width,t.acceptStation,14.f).height;
        float height=height1>21?height1:21;
        HEIGHT=HEIGHT+height+20+21;
    }
    CGRect rect=self.tableView.frame;
    rect.size.height=HEIGHT;
    self.tableView.frame=rect;
    self.tableView.contentSize=CGSizeMake(width, HEIGHT);
    self.tableView.scrollEnabled=NO;
    float logistcHeight=ViewFrameY_H(_logisticView);
    float tableHeight=ViewFrameY_H(self.tableView);
    float bottomTotalHeigt=tableHeight>logistcHeight?tableHeight:logistcHeight;
    CGRect rect1=_logisticView.frame;
    rect1.size.height=bottomTotalHeigt+10;
    _logisticView.frame=rect1;
    float heightTotal=_totalHeadHeight+bottomTotalHeigt+64+10;
    heightTotal=heightTotal>SCREEN_HEIGHT?heightTotal:SCREEN_HEIGHT;
    _scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,heightTotal);

}


#pragma mark--UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _express.traceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HXLogisticTrace*trace=[_express.traceArray objectAtIndex:indexPath.row];
    int width=self.tableView.frame.size.width-50;
    float height1=STRING_SIZE_FONT(width,trace.acceptStation,14.f).height;
    float height=height1>21?height1:21;
    return height+21+20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXLogisticTrace*trace=[_express.traceArray objectAtIndex:indexPath.row];
    static NSString*cellIdentifier=@"cell";
    HXLogisticTraceCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[HXLogisticTraceCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width,62) Trace:trace];
    }
    CGRect lineRect=cell.volumnline.frame;
    if (indexPath.row==0){
        lineRect.origin.y=cell.frame.size.height/2;
        lineRect.size.height=cell.frame.size.height/2;
        cell.stationLab.textColor=LightBlueColor;
        cell.timeLab.textColor=LightBlueColor;
    }else if (indexPath.row==_express.traceArray.count-1)
    lineRect.size.height=cell.frame.size.height/2;
    cell.volumnline.frame=lineRect;
    cell.stationLab.text=trace.acceptStation;
    cell.timeLab.text=trace.acceptTimeStr;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
