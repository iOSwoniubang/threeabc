//
//  HXFastPayViewController.m
//  BaiMi
//
//  Created by licl on 16/7/5.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXFastPayViewController.h"
#import "HXConsumeListViewController.h"
#import "HXScanViewController.h"
#import "HXMachine.h"
#import "HXPackage.h"
#import "HXMachineInfoViewController.h"
#import "HXNumberTextField.h"

@interface HXFastPayViewController ()<HXScanDelegate>
@property(strong,nonatomic)HXNumberTextField*machineCodeTF;
@property(strong,nonatomic)UIButton*finishBtn;
@property(strong,nonatomic)HXMachine*machine;

@end

@implementation HXFastPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=BackGroundColor;
    self.title=@"智能支付";
    [self createUI];
}

-(void)createUI{
    int Btn_Width=90;
    UIView*leftView=[[UIView alloc] initWithFrame:CGRectMake(10, 35, SCREEN_WIDTH-15-Btn_Width-20, 44)];
    leftView.backgroundColor=[UIColor clearColor];
    leftView.layer.borderColor=BolderColor.CGColor;
    leftView.layer.cornerRadius=leftView.frame.size.height/2;
    leftView.layer.borderWidth=1;
    _machineCodeTF=[[HXNumberTextField alloc] initWithFrame:CGRectMake(20, 0, leftView.frame.size.width-20, leftView.frame.size.height) Type:UIKeyboardTypeDecimalPad];
    _machineCodeTF.attributedPlaceholder=[[NSAttributedString alloc] initWithString:@"请输入机器码" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    _machineCodeTF.backgroundColor=[UIColor clearColor];
    [leftView addSubview:_machineCodeTF];
    [self.view addSubview:leftView];
    
    _finishBtn=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-Btn_Width, 35, Btn_Width,44)];
    _finishBtn.layer.borderColor=BolderColor.CGColor;
    _finishBtn.layer.cornerRadius=_finishBtn.frame.size.height/2;
    _finishBtn.layer.borderWidth=1;
    [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_finishBtn addTarget:self action:@selector(finishBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_finishBtn];
    
    UIView*line=[[UIView alloc] initWithFrame:CGRectMake(5, ViewFrameY_H(_finishBtn)+35, SCREEN_WIDTH-10, 0.5)];
    line.backgroundColor=BolderColor;
    [self.view addSubview:line];
    
    UIButton*scanBtn=[[UIButton alloc] initWithFrame:CGRectMake(60, ViewFrameY_H(line)+45, SCREEN_WIDTH-120, 40)];
    scanBtn.backgroundColor=LightBlueColor;
    [scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scanBtn setTitle:@"点此扫一扫" forState:UIControlStateNormal];
    scanBtn.titleLabel.font=[UIFont systemFontOfSize:15.f];
    [scanBtn setImage:[UIImage imageNamed:@"icon_pay.png"] forState:UIControlStateNormal];
    [scanBtn setImageEdgeInsets:UIEdgeInsetsMake(5, -20, 5, 0)];
    scanBtn.layer.cornerRadius=scanBtn.frame.size.height/2;
    [scanBtn addTarget:self action:@selector(scanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:scanBtn];
    
    UIButton*bottomBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-104, SCREEN_WIDTH, 40)];
    [bottomBtn setTitle:@"浏览历史消费记录" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bottomBtn.titleLabel.font=[UIFont systemFontOfSize:16.f];
    bottomBtn.layer.shadowOffset=CGSizeMake(1, 1);
    bottomBtn.layer.shadowOpacity=0.9;
    bottomBtn.layer.shadowColor=RGBA(209, 209, 209,1).CGColor;
    bottomBtn.backgroundColor=[UIColor whiteColor];
    [bottomBtn setImage:[UIImage imageNamed:@"icon_record.png"] forState:UIControlStateNormal];
    [bottomBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-(SCREEN_WIDTH/2-10) , 0, 0)];
    [bottomBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -(SCREEN_WIDTH/2-40), 0, 0)];
    [bottomBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [bottomBtn addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
}

//完成按钮点击
-(void)finishBtnClicked:(id)sender{
    [_machineCodeTF resignFirstResponder];
    if (!_machineCodeTF.text.length) {
        [HXAlertViewEx showInTitle:nil Message:@"请先输入机器码或扫一扫" ViewController:self];
        return;
    }
    if (_finishBtn.enabled)
    [self getDeviceInfoHttp];
}



//获取机器信息
-(void)getDeviceInfoHttp{
    _finishBtn.enabled=NO;
    HXLoginUser*user=[NSUserDefaultsUtil getLoginUser];
    NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,_machineCodeTF.text,user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/intelligent/getDeviceInfo" params:@{@"phoneNumber":user.phoneNumber,@"sKey":sKey,@"no":_machineCodeTF.text} onComplete:^(NSError *error, NSDictionary *resultJson) {
        _finishBtn.enabled=YES;
        if (error) {
              [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            NSDictionary*content=[resultJson objectForKey:@"content"];
            if([content isKindOfClass:[NSDictionary class]]){
                _machine=[HXMachine new];
                _machine.no=_machineCodeTF.text;
                _machine.sign=[content objectForKey:@"sign"];
                _machine.sn=[content objectForKey:@"sn"];
                _machine.tradeNo=[content objectForKey:@"partner_trade_no"];
                _machine.name=[content objectForKey:@"name"];
                _machine.position=[content objectForKey:@"position"];
                _machine.pointName=[content objectForKey:@"pointName"];
                _machine.packageArray=[NSMutableArray array];
                NSArray*packageList=[content objectForKey:@"packageList"];
                for (NSDictionary*dic in packageList) {
                    HXPackage*package=[HXPackage new];
                    package.no=[dic objectForKey:@"no"];
                    package.name=[dic objectForKey:@"name"];
                    package.fee=[[dic objectForKey:@"fee"] floatValue];
                    package.pulse=[[dic objectForKey:@"pulse"] intValue];
                    [_machine.packageArray addObject:package];
                }
                HXMachineInfoViewController*desVC=[[HXMachineInfoViewController alloc] init];
                desVC.machine=_machine;
                [self.navigationController pushViewController:desVC animated:YES];
            }else{
                [HXAlertViewEx showInTitle:nil Message:@"该设备不存在" ViewController:self];
                return ;
            }
        }
    }];
}



//扫一扫按钮点击
-(void)scanBtnClicked:(id)sender{
    HXScanViewController*desVC=[[HXScanViewController alloc] init];
    desVC.delegate=self;
    [self.navigationController pushViewController:desVC animated:YES];
}


#pragma mark --HXScanDelegate

-(void)scanResultStr:(NSString *)scanResult{
   _machineCodeTF.text=scanResult;
}


//浏览历史消费码
-(void)bottomBtnClicked:(id)sender{
    HXConsumeListViewController*desVC=[[HXConsumeListViewController alloc] init];
    [self.navigationController pushViewController:desVC animated:YES];
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
