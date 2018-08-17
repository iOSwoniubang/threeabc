//
//  HXSearchExpressViewController.m
//  BaiMi
//
//  Created by licl on 16/6/30.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXSearchExpressViewController.h"
#import "HXExpressSearchDao.h"
#import "HXScanViewController.h"
#import "HXSelectCompanyViewController.h"
#import "HXExpressDetailViewController.h"
#import "HXLogisticTrace.h"
#import "HXNumberTextField.h"

@interface HXSearchExpressViewController ()<UITableViewDataSource,UITableViewDelegate,HXScanDelegate,HXSelectCompanyDelegate,UIAlertViewDelegate>
@property(strong,nonatomic)UIView*line1;
@property(strong,nonatomic)HXNumberTextField*expressNoTF;
@property(strong,nonatomic)UIButton*companyBtn;
@property(strong,nonatomic)UIButton*searchExpressBtn;

@property(strong,nonatomic)UITableView*tableView;
@property(strong,nonatomic)NSMutableArray*historyArray;
@property(strong,nonatomic)HXCompany*seleCompany;
@property(strong,nonatomic)HXLoginUser*user;
@property(strong,nonatomic)HXExpress*delSearchExpress;
@end

@implementation HXSearchExpressViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"查询快件";
    self.view.backgroundColor=[UIColor whiteColor];
    [self createUI];
    _user=[NSUserDefaultsUtil getLoginUser];
    [self updateHistory];
    }

-(void)updateHistory{
    _historyArray=[[[HXExpressSearchDao new] findRecentExpressSearchListByOwnerId:_user.phoneNumber] mutableCopy];
    if (_historyArray.count>0)
        _line1.hidden=YES;
    else
        _line1.hidden=NO;
    [self.tableView reloadData];
}

-(void)createUI{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH - 10 *2.0, 109)];
    bgView.layer.cornerRadius = 5.f;
    bgView.layer.borderWidth = 0.5;
    bgView.layer.borderColor = BolderColor.CGColor;
    [self.view addSubview:bgView];
    
    UIFont*myFont=[UIFont systemFontOfSize:16.f];
       
    UIButton*scanBtn=[[UIButton alloc] initWithFrame:CGRectMake(bgView.frame.size.width-10-30, 12, 30, 30)];
    [scanBtn setBackgroundImage:[UIImage imageNamed:@"icon_scan.png"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(scanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:scanBtn];

    _expressNoTF=[[HXNumberTextField alloc] initWithFrame:CGRectMake(10, 15, bgView.frame.size.width-100, 21) Type:UIKeyboardTypeNumberPad];
    _expressNoTF.font=myFont;
    _expressNoTF.placeholder=@"请输入或扫描快递单号";
    [bgView addSubview:_expressNoTF];
    
    UIView*line=[[UIView alloc] initWithFrame:CGRectMake(5, 54, bgView.frame.size.width-10, 1)];
    line.backgroundColor=BolderColor;
    [bgView addSubview:line];
    
    _companyBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, ViewFrameY_H(line)+5, bgView.frame.size.width-120, 44)];
    _companyBtn.titleLabel.font=myFont;
    [_companyBtn setTitleColor:RGBA(190, 190, 196, 1) forState:UIControlStateNormal];
    [_companyBtn setTitle:@"请选择快递公司" forState:UIControlStateNormal];
    _companyBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
    [_companyBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_companyBtn addTarget:self action:@selector(selectCompanyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_companyBtn];
    
   _searchExpressBtn=[[UIButton alloc] initWithFrame:CGRectMake(bgView.frame.size.width-100, ViewFrameY_H(line)+12, 90, 30)];
    [_searchExpressBtn setTitle:@"查询快件" forState:UIControlStateNormal];
    [_searchExpressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _searchExpressBtn.backgroundColor=LightBlueColor;
    _searchExpressBtn.layer.cornerRadius=_searchExpressBtn.frame.size.height/2;
    [_searchExpressBtn addTarget:self action:@selector(searchExpressBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _searchExpressBtn.titleLabel.font=myFont;
    [bgView addSubview:_searchExpressBtn];
    
    UILabel*historyLab=[[UILabel alloc] initWithFrame:CGRectMake(15, ViewFrameY_H(bgView)+20, 100, 21)];
    historyLab.text=@"历史记录";
    historyLab.font=myFont;
    [self.view addSubview:historyLab];
    
    _line1=[[UIView alloc] initWithFrame:CGRectMake(0, ViewFrameY_H(historyLab)+2, self.view.frame.size.width, 1)];
    _line1.backgroundColor=BolderColor;
    [self.view addSubview:_line1];

    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, ViewFrameY_H(historyLab)+5, self.view.frame.size.width, 44*3) style:UITableViewStyleGrouped];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_tableView];
}

//扫描按钮点击
-(void)scanBtnClicked:(id)sender{
    HXScanViewController*desVC=[[HXScanViewController alloc] init];
    desVC.delegate=self;
    [self.navigationController pushViewController:desVC animated:YES];
}


#pragma mark--HXScanDelegate
-(void)scanResultStr:(NSString *)scanResult{
    _expressNoTF.text=scanResult;
}

//选择快递公司
-(void)selectCompanyBtnClicked:(id)sender{
    [_expressNoTF resignFirstResponder];
    HXSelectCompanyViewController*desVC=[[HXSelectCompanyViewController alloc] init];
    desVC.originalCompany=_seleCompany;
    desVC.delegate=self;
    [self.navigationController pushViewController:desVC animated:YES];
}
#pragma mark--HXSelectCompanyDelegate
-(void)selectCompanyVC:(HXSelectCompanyViewController *)selectVC selectCompany:(HXCompany *)company{
    NSLog(@"%@ %@",company.no,company.name);
    _seleCompany=company;
    [_companyBtn setTitle:company.name forState:UIControlStateNormal];
    [_companyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

//查询快件按钮点击
-(void)searchExpressBtnClicked:(id)sender{
    [_expressNoTF resignFirstResponder];
    if (!_expressNoTF.text.length) {
        [HXAlertViewEx showInTitle:nil Message:@"请输入或扫描快递单号" ViewController:self];
        return;
    }
    if (!_seleCompany) {
        [HXAlertViewEx showInTitle:nil Message:@"请选择快递公司" ViewController:self];
        return;
    }
    if (_searchExpressBtn.enabled)
        [self pullExpressDetailHttp];
   }

//快递鸟查询快递详情
-(void)pullExpressDetailHttp{
    _searchExpressBtn.enabled=NO;
    [HXLoadingImageView showLoadingView:self.view];
    [HXHttpUtils requestJsonPostOfKdniaoTrackQueryAPIWithShipperCode:_seleCompany.no LogisticCode:_expressNoTF.text onComplete:^(NSString *errorReason, NSDictionary *resultJson) {
        _searchExpressBtn.enabled=YES;
        [HXLoadingImageView hideViewForView:self.view];
        if (errorReason) {
            [HXAlertViewEx showInTitle:nil Message:errorReason ViewController:self];
        }else{
            NSArray*traces=[resultJson objectForKey:@"Traces"];
              HXExpress*express=[HXExpress new];
            express.traceArray=[NSMutableArray array];
            for(NSDictionary*dic in traces){
                HXLogisticTrace*trace=[HXLogisticTrace new];
                trace.acceptStation=[dic objectForKey:@"AcceptStation"];
                trace.acceptTimeStr=[dic objectForKey:@"AcceptTime"];
                [express.traceArray addObject:trace];
            }
            express.traceArray=[[[express.traceArray reverseObjectEnumerator] allObjects] mutableCopy];
            express.expressNo=_expressNoTF.text;
            express.companyNo=_seleCompany.no;
            express.companyName=_seleCompany.name;
            express.companyLogoUrl=_seleCompany.logoUrl;
            express.ownerId=_user.phoneNumber;
            express.searchTime=[NSDate date];
            //查询历史处理
            [[HXExpressSearchDao new] addUpdateOneExpress:express];
            [self updateHistory];
            //跳转详情页
            HXExpressDetailViewController*desVC=[[HXExpressDetailViewController alloc] init];
            desVC.express=express;
            desVC.hasTrace=YES;
            [self.navigationController pushViewController:desVC animated:YES];
        }
    }];
}


#pragma mark --UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _historyArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXExpress*express=[_historyArray objectAtIndex:indexPath.row];
    static NSString*cellIdentifier=@"cell";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text=express.expressNo;
    cell.detailTextLabel.text=express.companyName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HXExpress*express=[_historyArray objectAtIndex:indexPath.row];
    HXExpressDetailViewController*desVC=[[HXExpressDetailViewController alloc] init];
    desVC.express=express;
    [self.navigationController pushViewController:desVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _delSearchExpress=[_historyArray objectAtIndex:indexPath.row];
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:nil message:@"确定删除"  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSIndexPath*indexPath=[NSIndexPath indexPathForRow:[_historyArray indexOfObject:_delSearchExpress] inSection:0];
        [[HXExpressSearchDao new] deleteOneExpressByOwnerId:_user.phoneNumber ExpressNo:_delSearchExpress.expressNo];
        [_historyArray  removeObject:_delSearchExpress];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        self.tableView.editing=NO;
        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
