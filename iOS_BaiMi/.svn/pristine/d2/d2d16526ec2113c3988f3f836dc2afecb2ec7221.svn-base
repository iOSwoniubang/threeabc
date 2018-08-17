//
//  HXMachineInfoViewController.m
//  BaiMi
//
//  Created by licl on 16/7/8.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXMachineInfoViewController.h"
#import "HXPackage.h"
#import "HXPackageCell.h"
#import "AFNetworking.h"
#import "HXMachinePayViewController.h"



@interface HXMachineInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView*tableView;
@property(strong,nonatomic)UIButton*nextBtn;
@property(strong,nonatomic)HXLoginUser *user;
@property(strong,nonatomic)HXPackage*selectPackage; //选择的套餐

@end


/*智能支付流程:
 1. 第三方支付：支付按钮点击---创建订单---支付宝/微信（支付参数接口---支付sdk）---获取支付成功与否反馈结果（推送反馈或手动请求）,若支付成功---微支付协议获取激活码
 2.余额支付：支付按钮点击---创建订单--余额支付，若支付成功---微支付协议获取激活码
 */
@implementation HXMachineInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=BackGroundColor;
    self.title=@"智能支付";

    [self resetNaviBar];
    
     _user = [NSUserDefaultsUtil getLoginUser];
    _selectPackage=[_machine.packageArray firstObject];
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, self.view.frame.size.height-64-64) style:UITableViewStyleGrouped];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.view addSubview:self.tableView];
    [self createBottomView];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}
//
-(void)resetNaviBar{
    UIView*barView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    barView.backgroundColor=LightBlueColor;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 13, 20)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"btnBack.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:backBtn];
    
    UILabel*titleLab=[[UILabel alloc] initWithFrame:CGRectMake(80, 30, SCREEN_WIDTH-80*2, 20)];
    titleLab.text=@"智能支付";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    titleLab.font=[UIFont boldSystemFontOfSize:20.0];
    [barView addSubview:titleLab];
    [self.view addSubview:barView];
}


-(void)backBtnClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createBottomView{
    UIView*bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, ViewFrameY_H(self.tableView), SCREEN_WIDTH, 64)];
    bottomView.backgroundColor=[UIColor clearColor];
    _nextBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 44)];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBtn.backgroundColor=LightBlueColor;
    _nextBtn.layer.cornerRadius=_nextBtn.frame.size.height/2;
    _nextBtn.layer.borderColor=LightBlueColor.CGColor;
    _nextBtn.layer.borderWidth=1;
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_nextBtn];
    [self.view addSubview:bottomView];
}


/*智能支付流程:
1. 第三方支付：创建订单---付款：支付宝/微信（支付参数接口---支付sdk）---获取支付成功与否反馈结果（推送反馈或手动请求）,若支付成功---微支付协议获取激活码
2.余额支付：创建订单--余额支付，若支付成功---微支付协议获取激活码
 */
//支付按钮点击
-(void)nextBtnClicked:(id)sender{
    if(!_selectPackage)
        return;
       //创建订单
    if(_nextBtn.enabled)
    [self createOrderHttp];
}


//创建订单
-(void)createOrderHttp{
    _nextBtn.enabled=NO;
    NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[_user.phoneNumber,_machine.tradeNo,_machine.no,_selectPackage.no,[NSString stringWithFormat:@"%.2f",_selectPackage.fee],_user.token]];
    
    [HXHttpUtils requestJsonPostWithUrlStr:@"/intelligent/createOrder" params:@{@"phoneNumber":_user.phoneNumber,@"sKey":sKey,@"orderNo":_machine.tradeNo,@"machineNo":_machine.no,@"packageNo":_selectPackage.no,@"type":@"1",@"fee":[NSString stringWithFormat:@"%.2f",_selectPackage.fee],@"sn":_machine.sn,@"pulse":[NSNumber numberWithInt:_selectPackage.pulse],@"couponNo":@""} onComplete:^(NSError *error, NSDictionary *resultJson) {
        _nextBtn.enabled=YES;
        if (error) {
            if (error.code==10300) {
                UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"需要重新扫码才可以创建新订单" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                alert.delegate=self;
                [alert show];
                
            }else{
             NSString*erMsg=@"创建订单失败,请稍后重试";
            if (error.code==1 | error.code==2)
                erMsg=HXCodeString(error.code);
            [HXAlertViewEx showInTitle:nil Message:erMsg ViewController:self];
            }
        }else{
            HXMachinePayViewController*desVC=[[HXMachinePayViewController alloc] init];
            desVC.machine=_machine;
            desVC.selectPackage=_selectPackage;
            [self.navigationController pushViewController:desVC animated:YES];
        }
    }];
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark---UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _machine.packageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 100;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
    headView.backgroundColor=LightBlueColor;
    UIImageView*imgView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 40, 60)];
        imgView.image=[UIImage imageNamed:@"icon_washer.png"];
        [headView addSubview:imgView];
        UILabel*label=[[UILabel alloc] init];
        label.textColor=[UIColor whiteColor];
        label.textAlignment=NSTextAlignmentLeft;
        if (_machine){
            label.text=[NSString stringWithFormat:@"已检索到洗衣机信息"];
            label.frame=  CGRectMake(ViewFrameX_W(imgView)+20, 5, SCREEN_WIDTH-ViewFrameX_W(imgView)-20, 21);
            UIFont*infoFont=[UIFont systemFontOfSize:15.f];
            UILabel*tradeNoLab=[[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x,ViewFrameY_H(label)+5, label.frame.size.width, label.frame.size.height)];
            [self resetLab:tradeNoLab Font:infoFont Value:_machine.tradeNo];
            NSLog(@"%@",tradeNoLab.text);
            [headView addSubview:tradeNoLab];
            
            UILabel*machineNameLab=[[UILabel alloc] initWithFrame:CGRectMake(tradeNoLab.frame.origin.x, ViewFrameY_H(tradeNoLab), tradeNoLab.frame.size.width, tradeNoLab.frame.size.height)];
            [self resetLab:machineNameLab Font:infoFont Value:_machine.name];
            
            [headView addSubview:machineNameLab];
            
            UILabel*positionLab=[[UILabel alloc] initWithFrame:CGRectMake(machineNameLab.frame.origin.x, ViewFrameY_H(machineNameLab), machineNameLab.frame.size.width, machineNameLab.frame.size.height)];
            [self resetLab:positionLab Font:infoFont Value:_machine.position];
            [headView addSubview:positionLab];
        }
        else{
            label.text=[NSString stringWithFormat:@"没检索到设备信息"];
            label.frame=  CGRectMake(ViewFrameX_W(imgView)+20, imgView.frame.origin.y+imgView.frame.size.height/2-21/2, SCREEN_WIDTH-ViewFrameX_W(imgView)-20, 21);
        }
        label.font=[UIFont systemFontOfSize:16.f];
        [headView addSubview:label];
        
    return headView;
}


-(void)resetLab:(UILabel*)infoLabel Font:(UIFont*)infoFont Value:(NSString*)value{
    infoLabel.text=value;
    infoLabel.textColor=[UIColor whiteColor];
    infoLabel.font=infoFont;
    infoLabel.textAlignment=NSTextAlignmentLeft;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString*cellIdentifier=@"cell";
    HXPackageCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[HXPackageCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) Style:HXStylePackage];
    }
    if (indexPath.section==0) {
        HXPackage*package=[_machine.packageArray objectAtIndex:indexPath.row];
        cell.imgView.image=[UIImage imageNamed:@"icon_dot.png"];
        cell.titleLab.text=package.name;
        cell.feeLab.text=[NSString stringWithFormat:@"%.2f元/次",package.fee];
        if ([package.no isEqualToString:_selectPackage.no])
            cell.selImgView.image=[UIImage imageNamed:@"icon_check.png"];
        else
            cell.selImgView.image=[UIImage imageNamed:@"icon_uncheck.png"];
    }
 
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        HXPackage*package=[_machine.packageArray objectAtIndex:indexPath.row];
        _selectPackage=package;
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
