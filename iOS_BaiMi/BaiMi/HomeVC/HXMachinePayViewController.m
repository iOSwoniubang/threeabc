//
//  HXMachinePayViewController.m
//  BaiMi
//
//  Created by licl on 16/7/29.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXMachinePayViewController.h"
#import "HXPayResultOfFastPayViewController.h"
#import "HXPackageCell.h"
#import "HXPayHelper.h"

@interface HXMachinePayViewController ()<UITableViewDataSource,UITableViewDelegate,HXPayHelperDelegate>
@property(assign,nonatomic)HXPayType payType; //支付方式
@property(strong,nonatomic)HXLoginUser *user;
@end

@implementation HXMachinePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=BackGroundColor;
    self.title=@"付款";
    _user=[NSUserDefaultsUtil getLoginUser];
    _payType=HXPayTypeBalance;
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, self.view.frame.size.height-64-64) style:UITableViewStyleGrouped];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.view addSubview:self.tableView];
    
    [self createBottomView];

}



-(void)createBottomView{
    UIView*bottomView=[[UIView alloc] initWithFrame:CGRectMake(0,ViewFrameY_H(self.tableView), SCREEN_WIDTH, 64)];
    bottomView.backgroundColor=[UIColor clearColor];
    _payBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 44)];
    [_payBtn setTitle:@"付款" forState:UIControlStateNormal];
    _payBtn.backgroundColor=LightBlueColor;
    _payBtn.layer.cornerRadius=_payBtn.frame.size.height/2;
    _payBtn.layer.borderColor=LightBlueColor.CGColor;
    _payBtn.layer.borderWidth=1;
    [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_payBtn addTarget:self action:@selector(payBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_payBtn];
    [self.view addSubview:bottomView];
}


//付款按钮点击
-(void)payBtnClicked:(id)sender{
    if(_payBtn.enabled){
        _payBtn.enabled=NO;
    HXPayHelper*payHelper=[HXPayHelper sharePayHelper];
     payHelper.delegate=self;
    [payHelper payDealOfPayType:_payType payFee:_selectPackage.fee businessType:HXBillTypeWashClothes businessNo:_machine.tradeNo payVC:self];
    }
}

#pragma mark--HXPayHelperDelegate

-(void)payResult:(HXPayResult *)payResult{
    if (payResult.errCode==1) {
        //支付失败
        HXPayResultOfFastPayViewController*desVC=[[HXPayResultOfFastPayViewController alloc] init];
        desVC.paySuccess=NO;
        [self.navigationController pushViewController:desVC animated:YES];
         _payBtn.enabled=YES;
    }else{
        //获取激活码
        if (_payType==HXPayTypeBalance) {
            _user=[NSUserDefaultsUtil getLoginUser];
            [self.tableView reloadData];
        }
        //支付成功后的操作，获取激活码
        [self generateMachineCodeAppService];
    }
}

//调用微支付协议生成激活码
-(void)generateMachineCodeAppService{
    NSDictionary*params=@{@"sign":_machine.sign,@"sn":_machine.sn,@"currency":[NSNumber numberWithInt:_selectPackage.pulse],@"interfacetype":@"2",@"username":_user.nickName,@"sex":@"男",@"mobile":_user.phoneNumber,@"birthdays":@"1987-09-02",@"openid":@"",@"partner_trade_no":_machine.tradeNo};
    NSLog(@"paramms:%@",params);
    [HXHttpUtils requestJsonPostOfActiveCodeApiwithParams:params onComplete:^(NSString *errorReason, NSDictionary *resultJson) {
         _payBtn.enabled=YES;
        if (errorReason.length) {
            NSLog(@"激活码报错:%@",errorReason);
            [HXAlertViewEx showInTitle:nil Message:@"支付成功,但激活码获取失败" ViewController:self];
        }else{
            //激活码
            NSString*activateCode=[resultJson objectForKey:@"result"];
            //商户订单号
//            NSString*partner_trade_no=[resultJson objectForKey:@"partner_trade_no"];
            //将激活码回传至服务器
            [self uploadActivateCodeHttp:activateCode];
            //将激活码展示给用户使用
            HXPayResultOfFastPayViewController*desVC=[[HXPayResultOfFastPayViewController alloc] init];
            desVC.paySuccess=YES;
            desVC.activeCode=activateCode;
            desVC.selectPackage=_selectPackage;
            [self.navigationController pushViewController:desVC animated:YES];
        }
    }];
}


//将激活码回传给服务器
-(void)uploadActivateCodeHttp:(NSString*)activateCode{
    NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[_user.phoneNumber,_machine.tradeNo,activateCode,_user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/intelligent/uploadCdk" params:@{@"phoneNumber":_user.phoneNumber,@"sKey":sKey,@"orderNo":_machine.tradeNo,@"cdk":activateCode} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            NSLog(@"激活码回传至服务器失败");
        }else{
            NSLog(@"激活码回传至服务器成功");
        }
    }];
}


#pragma mark---UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   return 0.001;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString*cellIdentifier=@"cell";
    HXPackageCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[HXPackageCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) Style:HXStylePay];
    }
           if (indexPath.row==0) {
            cell.imgView.image=[UIImage imageNamed:@"ico_balance_small.png"];
            cell.titleLab.text=@"余额支付";
            cell.feeLab.text=[NSString stringWithFormat:@"大师哥余额%.2f元",_user.balance];
            cell.feeLab.frame=CGRectMake(cell.frame.size.width-40-150, cell.feeLab.frame.origin.y, 150, 21);
            cell.feeLab.font=[UIFont systemFontOfSize:13.f];
            cell.feeLab.textAlignment=NSTextAlignmentRight;
            cell.feeLab.textColor=LightBlueColor;
            if(_payType==HXPayTypeBalance)
                cell.selImgView.image=[UIImage imageNamed:@"icon_check.png"];
            else
                cell.selImgView.image=[UIImage imageNamed:@"icon_uncheck.png"];
        }else if(indexPath.row==1){
            cell.imgView.image=[UIImage imageNamed:@"ico_alipay_small.png"];
            cell.titleLab.text=@"支付宝支付";
            if(_payType==HXPayTypeAlipay)
                cell.selImgView.image=[UIImage imageNamed:@"icon_check.png"];
            else
                cell.selImgView.image=[UIImage imageNamed:@"icon_uncheck.png"];
        }else if (indexPath.row==2){
            cell.imgView.image=[UIImage imageNamed:@"ico_wechat_small.png"];
            cell.titleLab.text=@"微信支付";
            if(_payType==HXPayTypeWeChat)
                cell.selImgView.image=[UIImage imageNamed:@"icon_check.png"];
            else
                cell.selImgView.image=[UIImage imageNamed:@"icon_uncheck.png"];
        }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0)
        _payType=HXPayTypeBalance;
    else if (indexPath.row==1)
        _payType=HXPayTypeAlipay;
    else if(indexPath.row==2)
        _payType=HXPayTypeWeChat;
    [tableView reloadData];
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