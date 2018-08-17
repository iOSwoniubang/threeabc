//
//  HXCalculateFreightViewController.m
//  BaiMi
//
//  Created by licl on 16/7/26.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXCalculateFreightViewController.h"
#import "HXSelectCompanyViewController.h"
#import "HXSelectProvinceCityAlert.h"
#import "HXNumberTextField.h"

@interface HXCalculateFreightViewController ()<UITableViewDataSource,UITableViewDelegate,HXSelectProvinceCityDelegate,HXSelectCompanyDelegate,UITextFieldDelegate>
@property(strong,nonatomic)UITableView*tableView;
@property(strong,nonatomic)UILabel*startLab;
@property(strong,nonatomic)UILabel*endProLab;
@property(strong,nonatomic)UILabel*companyNameLab;
@property(strong,nonatomic)HXNumberTextField*weightTF;
@property(strong,nonatomic)UIFont *myFont;
@property(strong,nonatomic)HXPlace*endPlace;
@property(strong,nonatomic)HXCompany*selectCompany;
@property(strong,nonatomic)UILabel*feeLab;
@property(strong,nonatomic)UIButton*caculateBtn;
@property(strong,nonatomic)HXLoginUser*user;
@end

@implementation HXCalculateFreightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=BackGroundColor;
    self.title=@"运费";
    _user=[NSUserDefaultsUtil getLoginUser];
    if (!_user.pointNo.length) {
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请返回先选择出发地网点" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        alert.tag=10010;
        alert.delegate=self;
        [alert show];
    }
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44*5) style:UITableViewStyleGrouped];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.scrollEnabled=NO;
    [self.view addSubview:self.tableView];
    
    _feeLab=[[UILabel alloc] initWithFrame:CGRectMake(10, ViewFrameY_H(self.tableView)+20, SCREEN_WIDTH-20,42)];
    _feeLab.textAlignment=NSTextAlignmentCenter;
    _feeLab.font=[UIFont systemFontOfSize:14.f];
    [self.view addSubview:_feeLab];
    
    _myFont=[UIFont systemFontOfSize:16.f];
    _caculateBtn=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-(SCREEN_WIDTH*0.8)/2,ViewFrameY_H(self.tableView)+80, SCREEN_WIDTH*0.8, 40)];
    [_caculateBtn setTitle:@"计算" forState:UIControlStateNormal];
    [_caculateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _caculateBtn.titleLabel.font=_myFont;
    _caculateBtn.backgroundColor=LightBlueColor;
    _caculateBtn.layer.cornerRadius=_caculateBtn.frame.size.height/2;
    [_caculateBtn addTarget:self action:@selector(caculateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_caculateBtn];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==10010)
        [self.navigationController popViewControllerAnimated:YES];
}

//计算运费按钮点击
-(void)caculateBtnClicked:(id)sender{
    [self hideKeyBoard];
    if (!_endPlace.province.length) {
        [HXAlertViewEx showInTitle:nil Message:@"请选择目的地" ViewController:self];
        return;
    }
    if (!_selectCompany.no.length) {
        [HXAlertViewEx showInTitle:nil Message:@"请选择快递公司" ViewController:self];
        return;
    }
    if (!_weightTF.text.length) {
        [HXAlertViewEx showInTitle:nil Message:@"请输入寄件重量" ViewController:self];
        return;
    }
    if (_caculateBtn.enabled)
      [self caculateHttp];
}



-(void)caculateHttp{
    _caculateBtn.enabled=NO;
    NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[_user.phoneNumber,_selectCompany.no,_weightTF.text,_user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/send/estimate" params:@{@"phoneNumber":_user.phoneNumber,@"sKey":sKey,@"destinationProvince":_endPlace.province,@"destinationCity":_endPlace.city,@"weight":_weightTF.text,@"expressNo":_selectCompany.no,@"pointNo":_user.pointNo} onComplete:^(NSError *error, NSDictionary *resultJson) {
        _caculateBtn.enabled=YES;
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
            return ;
        }else{
            //计算成功
            NSDictionary*content=[resultJson objectForKey:@"content"];
            NSString*fee=[content objectForKey:@"fee"];
            NSString*feeStr=[NSString stringWithFormat:@"%@元",fee];
            NSMutableAttributedString*atr=[[NSMutableAttributedString alloc] initWithString:feeStr];
            NSRange range=[feeStr rangeOfString:@"元"];
            [atr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:20.f]}  range:NSMakeRange(0,range.location)];
            _feeLab.attributedText=atr;
        }
    }];
}



#pragma mark--UITableViewDataSource & UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[[UITableViewCell alloc] init];
    cell.textLabel.font=_myFont;
    switch (indexPath.row) {
        case 0:{
        cell.textLabel.text=@"出发地:";
            if (!_startLab)
            _startLab=[[UILabel alloc] initWithFrame:CGRectMake(100, 12,cell.frame.size.width-100-30, 21)];
            _startLab.font=_myFont;
            _startLab.text=_user.pointName;
            [cell addSubview:_startLab];
        };break;
        case 1:{
        cell.textLabel.text=@"收件地:";
            if (!_endProLab)
            _endProLab=[[UILabel alloc] initWithFrame:CGRectMake(100, 12,cell.frame.size.width-100-30, 21)];
            _endProLab.font=_myFont;
            [cell addSubview:_endProLab];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        };break;
        case 2:{
        cell.textLabel.text=@"快递公司:";
            if (!_companyNameLab)
            _companyNameLab=[[UILabel alloc] initWithFrame:CGRectMake(100, 12,cell.frame.size.width-100-30, 21)];
            _companyNameLab.font=_myFont;
            [cell addSubview:_companyNameLab];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        };break;
        case 3:{
        cell.textLabel.text=@"重量:";
            if (!_weightTF)
            _weightTF=[[HXNumberTextField alloc] initWithFrame:CGRectMake(100, 12,cell.frame.size.width-100-30, 21) Type:UIKeyboardTypeDecimalPad];
            _weightTF.font=_myFont;
            _weightTF.placeholder=@"请输入寄件重量";
            [cell addSubview:_weightTF];
            
            UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 12, 30, 21)];
            label.text=@"(kg)";
            label.textColor=LightBlueColor;
            label.font=_myFont;
            [cell addSubview:label];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        };break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hideKeyBoard];
    switch (indexPath.row) {
        case 1:{
            HXSelectProvinceCityAlert*alert=[[HXSelectProvinceCityAlert alloc] initWithPlace:_endPlace];
            alert.Cudelegate=self;
            [alert show];
        };break;
        case 2:{
            HXSelectCompanyViewController*desVC=[[HXSelectCompanyViewController alloc] init];
            desVC.originalCompany=_selectCompany;
            desVC.delegate=self;
            [self.navigationController pushViewController:desVC animated:YES];
        };break;
        default:
            break;
    }
}


#pragma mark--HXSelectProvinceDelegate
-(void)alertView:(HXSelectProvinceCityAlert *)alertView selectPlace:(HXPlace *)place{
    _endPlace=place;
    _endProLab.text=[NSString stringWithFormat:@"%@%@",_endPlace.province,_endPlace.city];
}

#pragma mark--HXSelectCompanyDelegate
-(void)selectCompanyVC:(HXSelectCompanyViewController *)selectVC selectCompany:(HXCompany *)company{
    _selectCompany=company;
    _companyNameLab.text=company.name;
}

-(void)hideKeyBoard{
    [[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
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
