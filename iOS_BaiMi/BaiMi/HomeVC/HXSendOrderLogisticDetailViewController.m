
//
//  HXSendOrderLogisticDetailViewController.m
//  BaiMi
//
//  Created by licl on 16/8/4.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXSendOrderLogisticDetailViewController.h"
#import "HXLogisticTraceCell.h"
#import "AFNetworking.h"
#import "NSString+Encryption.h"


@interface HXSendOrderLogisticDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UIScrollView *scrollView;
@property(strong,nonatomic)UIView*logisticView;
@property(strong,nonatomic)UILabel*recipientNameLab;//收件人姓名
@property(strong,nonatomic)UILabel*recipientPhoneLab;//收件人联系电话
@property(strong,nonatomic)UILabel*weightLab;
@property(strong,nonatomic)UILabel*feeLab;

@property(strong,nonatomic)UITableView*tableView;

@property(assign,nonatomic)int totalHeadHeight;
@end

@implementation HXSendOrderLogisticDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"寄件详情";
    self.view.backgroundColor=BackGroundColor;
    [self createUI];
    _express.traceArray=[NSMutableArray array];
    
    dispatch_group_t group1 = dispatch_group_create();
    dispatch_group_async(group1, dispatch_queue_create("1", DISPATCH_QUEUE_CONCURRENT), ^{
        //寄件详情
        [self pullSendOrderDetailHttp];
    });
    if ((_express.expressNo.length) && (_express.companyNo.length)) {
        dispatch_group_async(group1, dispatch_queue_create("2", DISPATCH_QUEUE_CONCURRENT), ^{
            //物流信息
            [self pullLogisticTracesHttp];
        });
    }
}


-(void)createUI{
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    _scrollView.backgroundColor=BackGroundColor;
    [self.view addSubview:_scrollView];
    
    UIView*headView=[[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 100)];
    headView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:headView];
    int Width=headView.frame.size.width-20;
    UIFont*myFont =[UIFont systemFontOfSize:15.f];
    int recipientNameWidth=95;
    int iconOrigonX=0;
    if(SCREEN_HEIGHT>iPhone5){
        myFont=[UIFont systemFontOfSize:16.f];
        recipientNameWidth=110;
        iconOrigonX=5;
    }
    
    
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
    locationLab.text=[NSString stringWithFormat:@"收件地址: %@%@%@%@",_express.recivePlace.province,_express.recivePlace.city,_express.recivePlace.area,_express.recivePlace.detailAddress];
    locationLab.numberOfLines=0;
    float height=STRING_SIZE_FONT(Width, locationLab.text, 16.f).height;
    CGRect locationRect=locationLab.frame;
    locationRect.size.height=height;
    locationLab.frame=locationRect;
    [headView addSubview:locationLab];
    CGRect rect=headView.frame;
    rect.size.height=ViewFrameY_H(locationLab)+10;
    headView.frame=rect;
    
    _logisticView=[[UIView alloc] initWithFrame:CGRectMake(0, ViewFrameY_H(headView)+10, SCREEN_WIDTH, SCREEN_HEIGHT-ViewFrameY_H(headView)-10-64)];
    _logisticView.backgroundColor=[UIColor whiteColor];
    
    UILabel*reciveOrderInfoLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 10,70, 21)];
    reciveOrderInfoLab.font=myFont;
    reciveOrderInfoLab.text=@"收件信息:";
    [_logisticView addSubview:reciveOrderInfoLab];
    UIImageView*personImgView=[[UIImageView alloc] initWithFrame:CGRectMake(ViewFrameX_W(reciveOrderInfoLab)+iconOrigonX, ViewFrame_Y(reciveOrderInfoLab), 16, 18)];
    personImgView.image=[UIImage imageNamed:@"icon_smallPerson.png"];
    [_logisticView addSubview:personImgView];
    _recipientNameLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(personImgView)+2, ViewFrame_Y(reciveOrderInfoLab), recipientNameWidth, 21)];
    _recipientNameLab.font=[UIFont systemFontOfSize:13.f];
    _recipientNameLab.text=[NSString stringWithFormat:@"收件人:"];
    [_logisticView addSubview:_recipientNameLab];
    UIImageView*phoneImgView=[[UIImageView alloc] initWithFrame:CGRectMake(ViewFrameX_W(_recipientNameLab), ViewFrame_Y(reciveOrderInfoLab), 13, 18)];
    phoneImgView.image=[UIImage imageNamed:@"icon_smallPhone.png"];
    [_logisticView addSubview:phoneImgView];
    _recipientPhoneLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(phoneImgView)+2, ViewFrame_Y(reciveOrderInfoLab), 120, 21)];
    _recipientPhoneLab.font=[UIFont systemFontOfSize:13.F];
    _recipientPhoneLab.text=[NSString stringWithFormat:@"电话:"];
    [_logisticView addSubview:_recipientPhoneLab];
    
    UILabel*payInfoLab=[[UILabel alloc] initWithFrame:CGRectMake(10, ViewFrameY_H(reciveOrderInfoLab)+10, reciveOrderInfoLab.frame.size.width, 21)];
    payInfoLab.font=myFont;
    payInfoLab.text=@"支付信息:";
    [_logisticView addSubview:payInfoLab];
    _weightLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(payInfoLab)+iconOrigonX, ViewFrame_Y(payInfoLab), 120, 21)];
    _weightLab.font=[UIFont systemFontOfSize:13.f];
    _weightLab.text=[NSString stringWithFormat:@"重量:  kg"];
    [_logisticView addSubview:_weightLab];
    _feeLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrame_X(phoneImgView), ViewFrame_Y(payInfoLab), 100, 21)];
    _feeLab.font=[UIFont systemFontOfSize:13.f];
    _feeLab.text=@"费用:  元";
    [_logisticView addSubview:_feeLab];
    
    UILabel*logisticLab=[[UILabel alloc] initWithFrame:CGRectMake(10, ViewFrameY_H(payInfoLab)+10, 70, 21)];
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

-(void)updateDatas{
    _recipientNameLab.text=[NSString stringWithFormat:@"收件人:%@",_express.recipientName];
    _recipientPhoneLab.text=[NSString stringWithFormat:@"电话:%@",_express.recipientPhone];
    _weightLab.text=[NSString stringWithFormat:@"重量:%.1fkg",_express.weight];
    _feeLab.text=[NSString stringWithFormat:@"费用:%.1f元",_express.fee];
}


//寄件单详情
-(void)pullSendOrderDetailHttp{
    HXLoginUser*user=[NSUserDefaultsUtil getLoginUser];
    NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,_express.orderId,user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/send/orderDetail" params:@{@"phoneNumber":user.phoneNumber,@"sKey":sKey,@"orderNo":_express.orderId} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            NSDictionary*dict=[resultJson objectForKey:@"content"];
            _express.shipperNickName=[dict objectForKey:@"shipperNickName"];
            _express.shipperPhone=[dict objectForKey:@"shipperContactNumber"];
            _express.recipientName=[dict objectForKey:@"recipientName"];
            _express.recipientPhone=[dict objectForKey:@"recipientPhoneNumber"];
            _express.weight=[[dict objectForKey:@"weight"] floatValue];
            _express.fee=[[HXHttpUtils whetherNil:[dict objectForKey:@"fee"]] floatValue];
            //            _express.insurance=[[HXHttpUtils whetherNil:[dict objectForKey:@"insurance"] ] floatValue];
            [self updateDatas];
        }
    }];
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
