//
//  HXTaskDetailViewController.m
//  BaiMi
//
//  Created by 王放 on 16/7/8.
//  Copyright © 2016年 licl. All rights reserved.
//
#define TXTFONT [UIFont systemFontOfSize:14.]
#define INTERVAL 10
#define LABHIG 20
#import "HXTaskDetailViewController.h"
#import <MessageUI/MessageUI.h>
#import "HXParcelCodeViewController.h"
#import "HXCreateTaskViewController.h"
@interface HXTaskDetailViewController ()<MFMessageComposeViewControllerDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)UIView *firseBGView;
@property (nonatomic,strong)UIView *secondBGView;
@property (nonatomic,strong)UIScrollView *scrollerView;
@property (nonatomic,strong)UILabel *publisherNickNameLabel;
@property (nonatomic,strong)UILabel *publisherPhoneNumber;
@property (nonatomic,strong)UIImageView *publisherLogo;
@property (nonatomic,strong)UILabel *sourceLabel;//取件
@property (nonatomic,strong)UILabel *targetLabel;//收件
@property (nonatomic,strong)UILabel *remainingTimeLabel;//剩余时间
@property (nonatomic,strong)UILabel *feeLabel;//费用
@property (nonatomic,strong)UILabel *weightLabel;//重量
@property (nonatomic,strong)UILabel *remarkLabel;//备注
@property (nonatomic,strong)UIView *waterListView;

@property (nonatomic,strong)HXLoginUser *user;

@property (nonatomic,strong)UIButton *cancleBtn;//取消按钮
@end

@implementation HXTaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务详情";
     _user = [NSUserDefaultsUtil getLoginUser];
    if (_order.status <= HXTaskStatusPickup && _order.deliverCode.length) {
        if (_isHelpView) {
            if (_order.status > HXTaskStatusPublish)
                [self createRightBtn];
        }else
            [self createRightBtn];
    }
    [self createTaskDetailUI];
}
-(void)createRightBtn{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 44);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2, 20, 20)];
    imageView.image = [UIImage imageNamed:@"ico_ma"];
    [rightBtn addSubview:imageView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, 40, 20)];
    label.textColor = [UIColor whiteColor];
    label.text = @"取件码";
    label.font = [UIFont systemFontOfSize:11];
    label.textAlignment = NSTextAlignmentCenter;
    [rightBtn addSubview:label];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightButton;
}
-(void)rightBtnClick{
    HXParcelCodeViewController *parceCode = [[HXParcelCodeViewController alloc] init];
    parceCode.code = _order.deliverCode;
    [self.navigationController pushViewController:parceCode animated:YES];
}
-(void)createTaskDetailUI{
    self.view.backgroundColor = BackGroundColor;
    float headViewHigh = 0;
    if (_order.status>=HXTaskStatusAccept){
        headViewHigh = 70+20;
        [self createHeadView];
    }

    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, headViewHigh, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - headViewHigh)];
    _scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, LABHIG * 4 + 80.0 * (_order.status - 1) + LABHIG * 4 + LABHIG * 8 + LABHIG);
    _scrollerView.backgroundColor = BackGroundColor;
    _scrollerView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollerView];
    [self createCenterUI];
    [self createEndUI];
}
-(void)createHeadView{
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:downView];
    _publisherLogo = [[UIImageView alloc] initWithFrame:CGRectMake(INTERVAL/2.0, 15, 40, 40)];
    _publisherLogo.layer.masksToBounds = YES;
    _publisherLogo.layer.cornerRadius = 20;
    [_publisherLogo setImageWithURL:[NSURL URLWithString:_isHelpView?_order.publisherLogo:_order.fetcherLogo] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    [downView addSubview:_publisherLogo];
    for (int i = 0; i<2; i++) {
        UILabel *label = [[UILabel alloc] init];
        [downView addSubview:label];
        label.frame = CGRectMake(INTERVAL  + 40, ViewFrame_Y(_publisherLogo) + i * 20, SCREEN_WIDTH - 110 - 30 - INTERVAL , 20);
        if (i==0) {
            
            label.text = _isHelpView?_order.publisherNickName:_order.fetcherNickName;
            _publisherNickNameLabel = label;
        }else{
            label.font = TXTFONT;
            label.text = _isHelpView?_order.publisherPhoneNumber:_order.fetcherPhoneNumber;
            _publisherPhoneNumber = label;
        }
    }
    UIView *viewSend = [self backImageViewWithImageName:@"ico_lianxi1.png" isFirst:YES];
    viewSend.tag = 1;
    UITapGestureRecognizer*tapGestureSend=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [viewSend addGestureRecognizer:tapGestureSend];
    [downView addSubview:viewSend];
    UIView *viewMSG = [self backImageViewWithImageName:@"ico_mail.png" isFirst:NO];
    viewMSG.tag = 2;
    UITapGestureRecognizer*tapGestureMSG=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [viewMSG addGestureRecognizer:tapGestureMSG];
    [downView addSubview:viewMSG];
}
-(UIView *)backImageViewWithImageName:(NSString *)imageName isFirst:(BOOL)isfirst{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - (isfirst?80:40),  0 , 40, 70)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(isfirst?10:0, 25,isfirst?20:30,isfirst?20:30)];
    imageView.image = [UIImage imageNamed:imageName];
    [view addSubview:imageView];
    return view;
}
-(void)createCenterUI{
     NSMutableArray *arrayTitle = [[NSMutableArray alloc] initWithObjects:@"取件码",@"取件地址：",@"收件地址：",@"剩余时间：",@"留言：", nil];
    _firseBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LABHIG * 4 + LABHIG * 10 + LABHIG)];
    _firseBGView.backgroundColor = [UIColor whiteColor];
    [_scrollerView addSubview:_firseBGView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(INTERVAL, LABHIG-2.5, LABHIG+5, LABHIG+5)];
    imageView.image = [UIImage imageNamed:@"ico_qian"];
    [_firseBGView addSubview:imageView];
    if (_order.status>=HXTaskStatusGetGoods) {
        [arrayTitle removeObject:@"剩余时间："];
    }
    for (int i = 0; i<arrayTitle.count+2; i++) {
        UILabel *label = [[UILabel alloc] init];
        [_firseBGView addSubview:label];
        if (i<2) {
            label.frame = CGRectMake(INTERVAL * 2.0 + LABHIG, LABHIG + i * (LABHIG+2.5), SCREEN_WIDTH-(INTERVAL * 2.0 + LABHIG), LABHIG);
            if (i==0) {
                label.text = [NSString stringWithFormat:@"%.2f元",_order.fee];
                label.font = [UIFont systemFontOfSize:25];
                label.textColor = RGBA(216, 95, 32, 1);
                _feeLabel = label;
            }else{
                label.text =[NSString stringWithFormat:@"重量约%@",HXWeightTypeStr(_order.weightType)];
                label.textColor = [UIColor orangeColor];
                label.font = TXTFONT;
                _weightLabel = label;
            }
        }else{
            if (i==2) {
//添加物流公司 快递单号
                label.text = [NSString stringWithFormat:@"%@    %@",_order.expressCompanyName,_order.expressNo];
                label.frame = CGRectMake(INTERVAL,LABHIG * 5 + 2 * LABHIG * (i - 2), STRING_SIZE_FONT(200, label.text, 14.).width, LABHIG);
            }else{
                label.text = [arrayTitle objectAtIndex:i-2];
                label.frame = CGRectMake(INTERVAL,LABHIG * 5 + 2 * LABHIG * (i - 2), STRING_SIZE_FONT(200, [arrayTitle objectAtIndex:i-2], 14.).width, LABHIG);
            }
            
            
            label.font = TXTFONT;
            
            UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(INTERVAL + ViewFrame_W(label),LABHIG * 5 + 2 * LABHIG * (i - 2) - LABHIG /2.0, SCREEN_WIDTH - INTERVAL - ViewFrame_W(label)-10, LABHIG * 2)];
            msgLabel.font = TXTFONT;
            msgLabel.numberOfLines = 0;
            [_firseBGView addSubview:msgLabel];
            if (i==3){
                if (_order.position.length)
                     msgLabel.text = [NSString stringWithFormat:@"%@(%@)",_order.source,_order.position];
                else
                    msgLabel.text=_order.source;
                _sourceLabel = msgLabel;
            }else if (i==4){ 
                msgLabel.text = _order.target;
                _targetLabel = msgLabel;
            }else if (i==5) {
                if (arrayTitle.count==4) {
                    msgLabel.text = _order.remark;
                    _remarkLabel = msgLabel;
                }else{
                    msgLabel.text=_order.remainingTime;
                    label.textColor = RGBA(247, 66, 73, 1);
                    msgLabel.textColor = RGBA(247, 66, 73, 1);
                    _remainingTimeLabel = msgLabel;
                }
            }else if (i==6){
                msgLabel.text = _order.remark;
                _remarkLabel = msgLabel;
            }
        }
    }
    UILabel *labelState = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 110, LABHIG + LABHIG / 2.0, 100, LABHIG)];
    if (_order.status<HXTaskStatusGetGoods) {
        labelState.text = @"-- 进行中 --";
    }else if (_order.status<HXTaskStatusCancel){
        labelState.text = @"-- 已完成 --";
    }
    labelState.font = TXTFONT;
    labelState.textAlignment = NSTextAlignmentRight;
    
    labelState.textColor = RGBA(216, 95, 32, 1);
    [_firseBGView addSubview:labelState];
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(10, LABHIG * 4.0 - 1, SCREEN_WIDTH - 20, 2)];
    [_firseBGView addSubview:viewLine];
    [self drawDashLine:viewLine lineLength:3 lineSpacing:5 lineColor:[UIColor lightGrayColor]];
}
-(void)createEndUI{
    _secondBGView = [[UIView alloc] initWithFrame:CGRectMake(0, ViewFrame_H(_firseBGView) + 20, SCREEN_WIDTH, LABHIG + 80.0 * (_order.status - 1))];
    _secondBGView.backgroundColor = [UIColor whiteColor];
    [_scrollerView addSubview:_secondBGView];
    if (_order.status>=HXTaskStatusAccept) {//有人接受任务

        _waterListView  = [HXTaskOrder taskWater:_order withHigh:80.0 * (_order.status - 1)];
        _waterListView.frame = CGRectMake(0, LABHIG, SCREEN_WIDTH, 80.0 * (_order.status - 1));
        [_secondBGView addSubview:_waterListView];
      
        if (_isHelpView) {
            if (_order.status==HXTaskStatusPickup) {
                [self createOneOperationBtnWithType:HXTaskButtonTypeArrive withTitle:@"顺利送达"];
            }
        }else{
            if (_order.status==HXTaskStatusComplete) {
                [self createOneOperationBtnWithType:HXTaskButtonTypePay withTitle:@"确认支付"];//确认支付
            }
        }
    }else{//还没人接受任务
        _waterListView  = [HXTaskOrder taskWater:_order withHigh:80.0 * (_order.status - 1)];
        _waterListView.frame = CGRectMake(0, LABHIG, SCREEN_WIDTH, 80.0 * (_order.status - 1));
        [_secondBGView addSubview:_waterListView];
        if (_isHelpView) {
            //这个意思是师哥看的 目前已取消在广场看详情
            [self createOneOperationBtnWithType:HXTaskButtonTypeAccept withTitle:@"接受任务"];//取消任务
        }else{
            [self createOneOperationBtnWithType:HXTaskButtonTypeCancel withTitle:@"取消任务"];//取消任务
        }
    }
}
-(void)createOneOperationBtnWithType:(int)type withTitle:(NSString *)title{
    UIButton *acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    acceptBtn.backgroundColor = LightBlueColor;
    acceptBtn.frame = CGRectMake(10, SCREEN_HEIGHT-64-30-5, SCREEN_WIDTH - 20, 30);
    acceptBtn.tag = type;
    [acceptBtn setTitle:title forState:UIControlStateNormal];
    acceptBtn.titleLabel.textColor = [UIColor whiteColor];
    acceptBtn.layer.cornerRadius = 15;

    [acceptBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:acceptBtn];
}

-(void)clickButton:(UIButton *)button{
    // type 1 确认支付 2取消任务 3顺利送达
    NSString *title = @"";
    if (button.tag==HXTaskButtonTypePay) {
        title = @"确认支付？";
    }else if (button.tag==HXTaskButtonTypeCancel){
        title = @"取消任务？";
        _cancleBtn = button;
    }else if (button.tag==HXTaskButtonTypeArrive){
        title = @"确认到达？";
    }else if (button.tag==HXTaskButtonTypeAccept){
        if (_user.studentVerificationStatus != HXVerifyStatusSuccessed){
            [HXAlertViewEx showInTitle:nil Message:@"请到实名认证中心进行师哥认证!" ViewController:self];
            return;
        }
        title = @"接受任务?";
    }
    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"确定", nil];
    alertView.tag = button.tag;
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==10086) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    if (buttonIndex==0)return;
    // type 1 确认支付 2取消任务 3顺利送达
    int orderStats = 0;
    NSString *showMsg = @"";
    if (alertView.tag==HXTaskButtonTypePay) {
        showMsg = @"确认支付";
        orderStats = HXTaskStatusGetGoods;
    }else if(alertView.tag==HXTaskButtonTypeCancel){
        showMsg = @"取消任务";
        orderStats = HXTaskStatusCancel;
    }else if (alertView.tag==HXTaskButtonTypeArrive){
        showMsg = @"确认到达";
        orderStats = HXTaskStatusComplete;
    }else if (alertView.tag==HXTaskButtonTypeAccept){
        showMsg = @"接受任务";
        orderStats = HXTaskStatusAccept;
    }
    [self modifyStateHttp:orderStats showMsg:showMsg];
    }
}



-(void)modifyStateHttp:(HXTaskStatus)orderStats showMsg:(NSString*)showMsg{
    NSString*skey=[HXNSStringUtil getSkeyByParamInfo:@[_user.phoneNumber,[NSNumber numberWithInt:orderStats],_order.orderNo,_user.token]];
    NSDictionary *dicUpload=@{@"phoneNumber":_user.phoneNumber,@"sKey":skey,@"orderNo":_order.orderNo,@"status":[NSNumber numberWithInt:orderStats]};
    
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/receive/changgeMissionStatus" params:dicUpload onComplete:^(NSError *error, NSDictionary *resultJson) {
        NSLog(@"修过师哥任务状态%@ %@",dicUpload,resultJson);
        
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            if (orderStats==HXTaskStatusCancel) {
                [self updateBalanceHttp];
            }
            UIAlertView*alert=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@成功",showMsg] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alert.tag=10086;
            [alert show];
        }
    }];

}

//刷新余额
-(void)updateBalanceHttp{
    HXLoginUser*user=[NSUserDefaultsUtil getLoginUser];
    NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,user.token]];

    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/payment/balance/getBalance" params:@{@"phoneNumber":user.phoneNumber,@"sKey":sKey} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            NSLog(@"余额更新失败");
        }else{
            
            NSDictionary*content=[resultJson objectForKey:@"content"];
            user.balance=[[content objectForKey:@"balance"] floatValue];
            [NSUserDefaultsUtil setLoginUser:user];
//            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}


-(UIView *)backImageTitleViewOfImageName:(NSString *)imageName andTitleName:(NSString *)title type:(int)type{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 55 - (type==1?65:0),  0 , type==1?60:50, 70)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, type==1?30:20, type==1?30:20)];
    imageView.image = [UIImage imageNamed:imageName];
    [view addSubview:imageView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(type==1?32.5:22.5, 0, 30, 70)];
    label.font = [UIFont systemFontOfSize:12];
    label.text = title;
    label.textColor = type==1?RGBA(240, 123, 73, 1):RGBA(83, 171, 93, 1);
    [view addSubview:label];
    return view;
}
-(void)tapGesture:(UITapGestureRecognizer *)sender {
    if (sender.view.tag==1) {
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_isHelpView?_order.publisherPhoneNumber:_order.fetcherPhoneNumber]];
        UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
        [self.view addSubview:phoneCallWebView];
    }else{
        NSLog(@"发送短信");
        [self showMessageView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)showMessageView {
    if( [MFMessageComposeViewController canSendText] ){
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init];
        controller.recipients = [NSArray arrayWithObject:_isHelpView?[HXHttpUtils whetherNil:_order.publisherPhoneNumber]:[HXHttpUtils whetherNil:_order.fetcherPhoneNumber]];
        controller.body = @"测试发短信";
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:^{
            [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"测试短信"];//修改短信界面标题
        }];
        
    }else{
        [self alertWithTitle:@"提示信息" msg:@"设备没有短信功能"];
    }
}


//MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:NO completion:^{
        switch ( result ) {
                
            case MessageComposeResultCancelled:
                
                [self alertWithTitle:@"提示信息" msg:@"发送取消"];
                break;
            case MessageComposeResultFailed:// send failed
                [self alertWithTitle:@"提示信息" msg:@"发送失败"];
                break;
            case MessageComposeResultSent:
                [self alertWithTitle:@"提示信息" msg:@"发送成功"];
                break;
            default:
                break;
        }
    }];
}


- (void) alertWithTitle:(NSString *)title msg:(NSString *)msg {
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
    
    [alert show];  
    
}
@end
