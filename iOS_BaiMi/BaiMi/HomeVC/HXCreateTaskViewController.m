//
//  HXCreateTaskViewController.m
//  BaiMi
//
//  Created by licl on 16/7/15.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXCreateTaskViewController.h"
#import "HXTaskOrder.h"
#import "HXSelectDateAlert.h"
#import "HXPayResultOfTaskViewController.h"
#import "AppDelegate.h"
#import "HXPayHelper.h"
#import "HXNumberTextField.h"

@interface HXCreateTaskViewController ()<UITextFieldDelegate,HXSelectDateAlertDelegate,HXPayHelperDelegate,UIActionSheetDelegate>

@property(strong,nonatomic)UIScrollView*scrollView;
@property(strong,nonatomic)UIButton*weightBtn;
@property(strong,nonatomic)HXNumberTextField*costTF;
@property(strong,nonatomic)UIButton*placeBtn;
@property(strong,nonatomic)UIButton*deadTimeBtn;
@property(strong,nonatomic)UITextField*remarkTF;
@property(strong,nonatomic)UIButton*createBtn;

@property(strong,nonatomic)HXLoginUser*user;
@property(strong,nonatomic)NSString*adress;
@property(strong,nonatomic)HXTaskOrder*task;

@property(strong,nonatomic)UILabel *labelFee;

@property(strong,nonatomic)UIImageView*selPayTypeImageView;
@property(assign,nonatomic)HXPayType payType;

@property(strong,nonatomic)HXPayHelper *payHelper;
@end

@implementation HXCreateTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"发布任务";
    
    _task=[HXTaskOrder new];
    _task.expressNo=_express.expressNo;
    _task.expressCompanyName=_express.companyName;
    _task.orderNo=_express.orderId;
    _task.source=_express.location;
    _task.deliverCode = _express.deliverCode;
    
    _user=[NSUserDefaultsUtil getLoginUser];
    _task.publisherPhoneNumber=_user.phoneNumber;
    _task.publisherPointNo=_user.pointNo;
    _adress=@"";
    if (_user.collegeNo.length){
        _task.publisherCollegeNo=_user.collegeNo;
        _adress=[_adress stringByAppendingString:_user.collegeName];
    }
    if (_user.areaNo.length){
        _adress=[_adress stringByAppendingString:_user.areaName];
    }
    if (_user.dormitoryHouseNo.length){
        _task.publisherHouseNo=_user.dormitoryHouseNo;
        _adress=[_adress stringByAppendingString:_user.dormitoryDes];
    }
    if (_user.dormitoryNo.length) {
        _adress=[_adress stringByAppendingString:_user.dormitoryNo];
    }
    _task.target=_adress;
    [self createUI];
}

-(void)createUI{
    _scrollView=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor=[UIColor whiteColor];
     [self.view addSubview:_scrollView];
    NSArray *arrayTitle = [[NSArray alloc] initWithObjects:@"余额支付",@"支付宝支付",@"微信支付", nil];
    int origonX=10+25+10;
    int origonY=10;
    UIFont*myFont=[UIFont systemFontOfSize:16.f];
    NSArray*imageNames=@[@"icon_weight.png",@"icon_cost.png",@"icon_place.png",@"icon_time.png",@"icon_note.png",@"ico_balance_big.png",@"ico_alipay_big.png",@"ico_wechat_big.png"];
    for (int i=0; i<8; i++) {
        UIImageView*iconImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, origonY+50*i+12, 26, 26)];
        iconImgView.image=[UIImage imageNamed:[imageNames objectAtIndex:i]];
        [_scrollView addSubview:iconImgView];
        UIView*line=[[UIView alloc] initWithFrame:CGRectMake(5, origonY+50*(i+1), SCREEN_WIDTH-10, 1)];
        line.backgroundColor=RGBA(230, 233, 232, 1);
        [_scrollView addSubview:line];
        
        if (i>4) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(origonX, origonY+50*i, SCREEN_WIDTH-45-10, 49)];
            label.text = [arrayTitle objectAtIndex:i-5];
            label.textColor = PlaceHolderColor;
            label.font = myFont;
            [_scrollView addSubview:label];
            UIImageView *rigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10 - 26, origonY+50*i+12, 26, 26)];
            rigImageView.userInteractionEnabled=YES;
            rigImageView.tag = i+1;
            [_scrollView addSubview:rigImageView];
            
            UITapGestureRecognizer*tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
            [rigImageView addGestureRecognizer:tapGesture];
            if (i==5) {
                rigImageView.image = [UIImage imageNamed:@"icon_check.png"];
                _payType=HXPayTypeBalance;
                _labelFee = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10 - 30 - 150, origonY+50*i+10, 150, 30)];
                _labelFee.text=[NSString stringWithFormat:@"大师哥余额%.2f元",_user.balance];
                _labelFee.font = [UIFont systemFontOfSize:12.];
                _labelFee.textColor = LightBlueColor;
                _labelFee.textAlignment = NSTextAlignmentRight;
                [_scrollView addSubview:_labelFee];
                _selPayTypeImageView = rigImageView;
            }else{
                rigImageView.image = [UIImage imageNamed:@"icon_uncheck.png"];
            }
        }
    }
    
    _weightBtn=[[UIButton alloc] initWithFrame:CGRectMake(origonX, origonY, SCREEN_WIDTH-origonX-10, 50)];
    [_weightBtn setTitle:@"点击选择快件重量" forState:UIControlStateNormal];
    [_weightBtn setTitleColor:PlaceHolderColor forState:UIControlStateNormal];
    [_weightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    _weightBtn.titleLabel.font=myFont;
    [_weightBtn addTarget:self action:@selector(weightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_weightBtn];
    
    _costTF=[[HXNumberTextField alloc] initWithFrame:CGRectMake(origonX,origonY+50*1, _weightBtn.frame.size.width, 50) Type:UIKeyboardTypeDecimalPad];
    _costTF.placeholder=@"建议1.00元";
    _costTF.font=myFont;
    [_scrollView addSubview:_costTF];
    
    _placeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _placeBtn.frame = CGRectMake(origonX, origonY+50*2, _weightBtn.frame.size.width, 50);
    [_placeBtn setTitle:_adress forState:UIControlStateNormal];
    _placeBtn.titleLabel.font=myFont;
    [_placeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _placeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_placeBtn addTarget:self action:@selector(placeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_placeBtn];
    
    _deadTimeBtn=[[UIButton alloc] initWithFrame:CGRectMake(origonX, origonY+50*3, _weightBtn.frame.size.width, 50)];
    [_deadTimeBtn setTitleColor:PlaceHolderColor forState:UIControlStateNormal];
    [_deadTimeBtn setTitle:@"选择任务截止时间" forState:UIControlStateNormal];
    [_deadTimeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    _deadTimeBtn.titleLabel.font=myFont;
    [_deadTimeBtn addTarget:self action:@selector(deadTimeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_deadTimeBtn];
    
    _remarkTF=[[UITextField alloc] initWithFrame:CGRectMake(origonX, origonY+50*4, _weightBtn.frame.size.width, 50)];
    _remarkTF.placeholder=@"备注留言";
    _remarkTF.font=myFont;
    _remarkTF.returnKeyType=UIReturnKeyDone;
    _remarkTF.delegate=self;
    [_scrollView addSubview:_remarkTF];
    
    _createBtn=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2- (SCREEN_WIDTH *0.7)/2,origonY+50*8+30, SCREEN_WIDTH*0.7, 40)];
    [_createBtn setTitle:@"发布任务" forState:UIControlStateNormal];
    [_createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_createBtn setBackgroundColor:LightBlueColor];
    _createBtn.layer.cornerRadius=_createBtn.frame.size.height/2;
    _createBtn.titleLabel.font=[UIFont systemFontOfSize:17.f];
    [_createBtn addTarget:self action:@selector(createBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:_createBtn];
    _scrollView.scrollEnabled=YES;
    _scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, ViewFrameY_H(_createBtn)+40+64);
    _scrollView.showsVerticalScrollIndicator=YES;
}


//选择快件重量
-(void)weightBtnClicked:(id)sender{
    [self hideKeyBoard];
    
    UIActionSheet*actionSheet=[[UIActionSheet alloc] initWithTitle:@"选择快件重量" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"2kg以下",@"2-5kg",@"5-10kg",@"10-20kg",@"20kg以上", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d",(int)buttonIndex);
    if (buttonIndex<5) {
        _task.weightType=buttonIndex+1;
        [_weightBtn setTitle:HXWeightTypeStr(_task.weightType) forState:UIControlStateNormal];
        [_weightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

//地址点击
-(void)placeBtnClicked:(id)sender{
    [self hideKeyBoard];
    if (!_adress.length) {
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请去个人中心——修改信息中完善学校楼栋寝室信息" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
    }
}


//任务截止时间
-(void)deadTimeBtnClicked:(id)sender{
    [self hideKeyBoard];
    HXSelectDateAlert*selectDateAlert=[[HXSelectDateAlert alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH-20 ,240)  selectDateStr:[_task.deadLine toStringByChineseDateTimeLine]];
    selectDateAlert.Cudelegate=self;
    [selectDateAlert show];

}

#pragma mark-HXSelectDatePickerDelegate
-(void)selectDateStr:(NSString *)dateStr Date:(NSDate *)seldate{
    NSLog(@"1111  %@",dateStr);
//    _task.deadLine= [NSString stringWithFormat:@"%@",dateStr];
    _task.deadLine=seldate;
    [_deadTimeBtn setTitle:[_task.deadLine toStringByChineseDateTimeLine] forState:UIControlStateNormal];
    [_deadTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
-(void)tapGesture:(UITapGestureRecognizer *)sender {
    NSLog(@"点击接受任务");
    UIImageView *imageView = (UIImageView *)sender.view;
    if (imageView.tag!=_selPayTypeImageView.tag) {
        _selPayTypeImageView.image = [UIImage imageNamed:@"icon_uncheck.png"];
        _selPayTypeImageView = imageView;
        _selPayTypeImageView.image = [UIImage imageNamed:@"icon_check.png"];
    }
    switch (_selPayTypeImageView.tag) {
        case 6:_payType=HXPayTypeBalance;break;
        case 7:_payType=HXPayTypeAlipay;break;
        case 8:_payType=HXPayTypeWeChat;break;
        default:
            break;
    }
}

//发布任务
-(void)createBtnClicked:(id)sender{
    if (_task.weightType==0) {
        [HXAlertViewEx showInTitle:nil Message:@"请选择快件重量" ViewController:self];
        return;
    }
    if (!_costTF.text.length) {
        [HXAlertViewEx showInTitle:nil Message:@"请输入费用" ViewController:self];
        return;
    }
    if (!_task.target.length) {
        [HXAlertViewEx showInTitle:nil Message:@"请去个人中心——修改信息中完善学校楼栋寝室信息" ViewController:self];
        return;
    }
    if (!_task.deadLine) {
        [HXAlertViewEx showInTitle:nil Message:@"请选择截止时间" ViewController:self];
        return;
    }
  
    _task.fee=_costTF.text.floatValue;
    _task.remark=_remarkTF.text;
    if (_createBtn.enabled)
        [self createTaskHttp];
}


#pragma mark--UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField==_remarkTF && SCREEN_HEIGHT<iPhone6) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==_remarkTF && SCREEN_HEIGHT<iPhone6) {
        [_scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
    }
    return YES;
}


-(void)hideKeyBoard{
    [[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//发布任务接口
-(void)createTaskHttp{
    NSLog(@"%@",_task);
    _createBtn.enabled=NO;
    NSString*feeStr=[NSString stringWithFormat:@"%.2f",_task.fee];
    NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[_user.phoneNumber,_task.publisherCollegeNo,_task.publisherHouseNo,_task.orderNo,feeStr,[NSNumber numberWithInt:_task.weightType],_task.deliverCode,_user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/receive/publishMission" params:@{@"phoneNumber":_user.phoneNumber,@"sKey":sKey,@"orderNo":_task.orderNo,@"publisherPhoneNumber":_task.publisherPhoneNumber,@"publisherCollegeNo":_task.publisherCollegeNo,@"publisherHouseNo":_task.publisherHouseNo,@"publisherPointNo":_task.publisherPointNo,@"expressName":_task.expressCompanyName,@"expressNumber":_task.expressNo,@"weightType":[NSNumber numberWithInt:_task.weightType],@"fee":feeStr,@"target":_task.target,@"source":_task.source,@"deadline":_task.deadLine,@"remark":_task.remark,@"deliverCode":_task.deliverCode} onComplete:^(NSError *error, NSDictionary *resultJson) {
        _createBtn.enabled=YES;

        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
           //开始支付
            HXPayHelper*payHelper=[HXPayHelper sharePayHelper];
            payHelper.delegate=self;
            [payHelper payDealOfPayType:_payType payFee:_task.fee businessType:HXBillTypePublishTask businessNo:_task.orderNo payVC:self];
        }
    }];
}

#pragma mark--HXPayHelperDelegate

-(void)payResult:(HXPayResult *)payResult{
      HXPayResultOfTaskViewController*desVC=[[HXPayResultOfTaskViewController alloc] init];
    if (payResult.errCode==1) {
        //支付失败
        desVC.paySuccess=NO;
        desVC.isMyTaskCome=_isMyTaskCome;
    }else{
        //支付成功
        if (_payType==HXPayTypeBalance) {
            _user=[NSUserDefaultsUtil getLoginUser];
            _labelFee.text=[NSString stringWithFormat:@"大师哥余额%.2f元",_user.balance];
        }
        desVC.paySuccess=YES;
        desVC.isMyTaskCome=_isMyTaskCome;
    }
    [self.navigationController pushViewController:desVC animated:YES];
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
