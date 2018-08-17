//
//  HXCreateSendOrderViewController.m
//  BaiMi
//
//  Created by licl on 16/7/18.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXCreateSendOrderViewController.h"
#import "HXExpress.h"
#import "HXSelectArticleTypeAlert.h"
#import "HXSelePointViewController.h"
#import "HXSelectCompanyViewController.h"
#import "HXSelectProCityAreaAlert.h"
#import "HXSelectServiceTimeAlert.h"
//#import "HXSelectAdditionServiceAlert.h"
#import "HXCalculateFreightViewController.h"
#import "HXSelectCouponViewController.h"
#import "HXAgreementViewController.h"
#import "HXNumberTextField.h"
#import <AMapSearchKit/AMapSearchKit.h>

//HXSelectAdditionServiceDelegate
@interface HXCreateSendOrderViewController ()<UITableViewDataSource,UITableViewDelegate,HXSelectArticleTypeDelegate,HXSelectPointDelegate,AMapSearchDelegate,HXSelectCompanyDelegate,HXSelectProvinceCityAreaDelegate,HXSelectServiceTimeDelegate,UITextFieldDelegate,HXSelectCouponDelegate>
@property(strong,nonatomic)HXLoginUser*user;
@property(strong,nonatomic)HXExpress*express;
@property(strong,nonatomic)UIFont*myFont;
@property(strong,nonatomic)AMapSearchAPI*searchAPI;

@property(strong,nonatomic)UILabel*pointLab;
@property(strong,nonatomic)UILabel*shiperProCityAreaLab; //寄件地址
@property(strong,nonatomic)UITextField*shiperNameTF;
@property(strong,nonatomic)HXNumberTextField*shiperPhoneTF;
@property(strong,nonatomic)UILabel*expressComLab; //快递公司
@property(strong,nonatomic)UILabel*shiperDetailAddressLab;//寄件人详细地址
@property(strong,nonatomic)UILabel*reciProCityAreaLab; //省市区
@property(strong,nonatomic)UITextField*reciDetailAddressTF; //收件人详细地址

@property(strong,nonatomic)UITextField*recipentNameTF;
@property(strong,nonatomic)HXNumberTextField*recipentPhoneTF;
@property(strong,nonatomic)UIButton*isIndoorBtn; //上门服务
@property(strong,nonatomic)UILabel*attachLab;//增值服务
@property(strong,nonatomic)UILabel*articleNameLab; //物品名称
@property(strong,nonatomic)HXNumberTextField*articleWeightTF;//物品重量
@property(strong,nonatomic)UITextField*remarkTF;//备注信息
@property(strong,nonatomic)UIButton*serviceTimeBtn;//服务时间
@property(strong,nonatomic)UIButton*confirmBtn;
@property(strong,nonatomic)UIButton*agreementBtn;
@property(strong,nonatomic)UIButton*agreeCheckBtn;
@property(strong,nonatomic)UILabel* couponLab;//优惠券
@property(assign,nonatomic)int couponNums;//优惠券数量
@property(strong,nonatomic)UIButton*isDeliveryPayBtn; //是否到付


@property(strong,nonatomic)UITableView*tableView;

@end

@implementation HXCreateSendOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"寄快递";
    self.view.backgroundColor=[UIColor whiteColor];
    [self resetRightBarItem];
    _user=[NSUserDefaultsUtil getLoginUser];
    _myFont=[UIFont systemFontOfSize:13.f];
    
     NSArray*array=[[HXArticleTypeDao new] fetchAllArticles];
    if (!array.count) {
         dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getArticleTypes];
         });
    }else{
        HXSelectArticleTypeAlert*alert=[[HXSelectArticleTypeAlert alloc] initWithFrame:CGRectMake(20, 150, SCREEN_WIDTH-40, 150)];
        alert.Cudelegate=self;
        [alert show];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getAvaliableCouponCountHttp];
    });
  }

-(void)loadData{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    
    if(!_express)
    _express=[HXExpress new];
    //网点地址
    if (_user.pointAddressJsonStr.length) {
        NSDictionary*pointAddressDic=[HXNSStringUtil getJsonArrayOrJsonDicFormJsonStr:_user.pointAddressJsonStr];
        HXPlace*shiperPlace=[HXPlace new];
        shiperPlace.province=[pointAddressDic objectForKey:@"province"];
        shiperPlace.city=[pointAddressDic objectForKey:@"city"];
        shiperPlace.area=[pointAddressDic objectForKey:@"area"];
        shiperPlace.detailAddress=[pointAddressDic objectForKey:@"address"];
        _express.shipperPlace=shiperPlace;
    }else{
      if(_user.pointNo.length)
          [self searchPointAddressFromMapCloud];
    }
}

-(void)resetRightBarItem{
//    UIBarButtonItem* rightBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"运费" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBtnClicked:)];
//    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    UIButton*btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    [btn setTitle:@"运费" forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:12.f];
    btn.layer.borderColor=[UIColor whiteColor].CGColor;
    btn.layer.cornerRadius=btn.frame.size.height/2;
    btn.layer.borderWidth=1.f;
    [btn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*publishBtnItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = publishBtnItem;

}

-(void)rightBtnClicked:(id)sender{
    HXCalculateFreightViewController*desVC=[[HXCalculateFreightViewController alloc] init];
    [self.navigationController pushViewController:desVC animated:YES];
}

//寄件物品类型
-(void)getArticleTypes{
    [HXHttpUtils requestJsonGetWithUrlStr:@"/user/send/stdmodeList" params:nil onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            NSString*erMsg=@"物品类型获取失败,请返回后重试";
            if (error.code==1 | error.code==2)
                erMsg=HXCodeString(error.code);
            [HXAlertViewEx showInTitle:nil Message:erMsg ViewController:self];
            return ;
        }else{
            NSArray*content=[resultJson objectForKey:@"content"];
            NSMutableArray*array=[NSMutableArray array];
            for(NSDictionary*dic in content){
                HXArticleType*articleType=[HXArticleType new];
                articleType.no=[dic objectForKey:@"no"];
                articleType.name=[dic objectForKey:@"stdmodeName"];
                [array addObject:articleType];
            }
                [[HXArticleTypeDao new] insertUpdateArticles:array];
                HXSelectArticleTypeAlert*alert=[[HXSelectArticleTypeAlert alloc] initWithFrame:CGRectMake(20, 150, SCREEN_WIDTH-40, 150)];
                alert.Cudelegate=self;
                [alert show];
        }
    }];
}

//可用优惠券
-(void)getAvaliableCouponCountHttp{
    [HXLoadingImageView showLoadingView:self.view];
    NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[_user.phoneNumber,[NSNumber numberWithInt:HXBusinessTypeSendParcel],_user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/availableCouponCount" params:@{@"phoneNumber":_user.phoneNumber,@"sKey":sKey,@"businessType":[NSNumber numberWithInt:HXBusinessTypeSendParcel]} onComplete:^(NSError *error, NSDictionary *resultJson) {
        [HXLoadingImageView hideViewForView:self.view];
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:@"优惠券信息获取失败" ViewController:self];
        }else{
            NSDictionary*content=[resultJson objectForKey:@"content"];
            _couponNums=[[content objectForKey:@"count"] intValue];
        }
        [self loadData];
    }];
}


//有网点pointNo和pointName没有网点地址时，根据网点名称搜索网点所在地址信息
-(void)searchPointAddressFromMapCloud{
    //配置用户Key
//[AMapServices sharedServices].apiKey = GD_Map_Key;

    //初始化检索对象
    _searchAPI = [[AMapSearchAPI alloc] init];
    _searchAPI.delegate = self;
    
//    云图本地查询请求
    AMapCloudPOILocalSearchRequest*request=[[AMapCloudPOILocalSearchRequest alloc] init];
    request.tableID = GD_MapCloud_TableId;//在数据管理台中取得
    request.keywords=_user.pointName;
    request.city=@"全国";
    [_searchAPI AMapCloudPOILocalSearch:request];
}



//实现云检索对应的回调函数
- (void)onCloudSearchDone:(AMapCloudSearchBaseRequest *)request response:(AMapCloudPOISearchResponse *)response
{
    if(response.POIs.count == 0){
        [HXAlertViewEx showInTitle:@"" Message:@"寄件地址获取失败,请返回重试" ViewController:self];
        return;
    }
    //获取云图数据并显示
    NSMutableArray*cloudPOIs=[response.POIs mutableCopy];
    NSArray *sortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES]];
    [cloudPOIs sortUsingDescriptors:sortDescriptors];
    
    BOOL hasFound=NO;
    for(AMapCloudPOI*poi in cloudPOIs){
        if ([[poi.customFields objectForKey:@"code"] isEqualToString:_user.pointNo]) {
            hasFound=YES;
            HXPlace*pointPlace=[HXPlace  new];
            pointPlace.province=[poi.customFields objectForKey:@"_province"];
            pointPlace.city=[poi.customFields objectForKey:@"_city"];
            pointPlace.area=[poi.customFields objectForKey:@"_district"];
            
            NSString*subStr=[poi.address stringByReplacingOccurrencesOfString:pointPlace.province withString:@""];
            subStr=[subStr stringByReplacingOccurrencesOfString:pointPlace.city withString:@""];
            subStr=[subStr stringByReplacingOccurrencesOfString:pointPlace.area withString:@""];
            pointPlace.detailAddress=subStr;
            
            NSDictionary*pointPlaceDic=@{@"province":pointPlace.province,@"city":pointPlace.city,@"area":pointPlace.area,@"address":pointPlace.detailAddress};
            _user.pointAddressJsonStr=[HXNSStringUtil getJsonStringFromDicOrArray:pointPlaceDic];
            
            [NSUserDefaultsUtil setLoginUser:_user];
            _express.shipperPlace=pointPlace;
            //出发地址省市区及详细地址刷新
            NSIndexPath*indexPath1=[NSIndexPath indexPathForRow:0 inSection:1];
            NSIndexPath*indexPath2=[NSIndexPath indexPathForRow:1 inSection:1];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath1,indexPath2] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
    if (!hasFound)
         [HXAlertViewEx showInTitle:@"" Message:@"寄件地址获取失败,请返回重试" ViewController:self];
}


- (void)cloudRequest:(id)cloudSearchRequest error:(NSError *)error
{
    NSLog(@"CloudRequestError:{Code: %ld; Description: %@}", (long)error.code, error.localizedDescription);
}




#pragma mark--UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:return 1;break;
        case 1:return 3;break;
        case 2:return 8;break;
        case 3:return 1;break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==3 & indexPath.row==0)
        return 80;
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:return 1;break;
        case 3:return 30;break;
        default:return 44;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section>0) {
    UIView*view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    view.backgroundColor=RGBA(247, 247, 247, 1);
        if (section==3) {
            _agreeCheckBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
            _agreeCheckBtn.selected=YES;
            [_agreeCheckBtn setBackgroundImage:[UIImage imageNamed:@"ico_check_yuan.png"] forState:UIControlStateSelected];
            [_agreeCheckBtn setBackgroundImage:[UIImage imageNamed:@"ico_uncheck_yuan.png"] forState:UIControlStateNormal];
            [_agreeCheckBtn addTarget:self  action:@selector(agreeCheckBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:_agreeCheckBtn];
            _agreementBtn=[[UIButton alloc] initWithFrame:CGRectMake(ViewFrameX_W(_agreeCheckBtn)+10, 0, 250, 30)];
            [_agreementBtn addTarget:self  action:@selector(agreementBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            NSString*str=@"我已阅读并同意《服务协议》";
            NSMutableAttributedString*atr=[[NSMutableAttributedString alloc] initWithString:str];
            NSRange range=[str rangeOfString:@"《"];
            [atr addAttributes:@{NSForegroundColorAttributeName:LightBlueColor}  range:NSMakeRange(range.location,str.length-range.location)];
            _agreementBtn.titleLabel.font=[UIFont systemFontOfSize:12.f];
            [_agreementBtn setAttributedTitle:atr forState:UIControlStateNormal];
            [_agreementBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [view addSubview:_agreementBtn];
        }else{
            UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(5, 12, 100, 21)];
            label.font=[UIFont systemFontOfSize:14.f];
            if (section==1){
                label.text=@"寄件人信息";
//                UIButton*addressbtn=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-80, 2, 80, 40)];
//                addressbtn.titleLabel.font=[UIFont systemFontOfSize:14.f];
//                [addressbtn setTitle:@"常用地址" forState:UIControlStateNormal];
//                [addressbtn setTitleColor:LightBlueColor forState:UIControlStateNormal];
//                [addressbtn addTarget:self action:@selector(addressbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//                [view addSubview:addressbtn];
            }
            else if(section==2)
                label.text=@"收件人信息";
            [view addSubview:label];
        }
    return view;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell*cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    switch (indexPath.section) {
        case 0:{
            UIImageView*iconImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 18, 24)];
            iconImgView.image=[UIImage imageNamed:@"icon_grayPlace.png"];
            [cell addSubview:iconImgView];
            _pointLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(iconImgView)+5, 12, cell.frame.size.width-ViewFrameX_W(iconImgView)-30, 21)];
            _pointLab.text=[NSString stringWithFormat:@"出发地: %@",_user.pointName];
            _pointLab.font=_myFont;
            [cell addSubview:_pointLab];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        };break;
        case 1:{
            if (indexPath.row==0) {
                UILabel*sendAddressPreLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 60, 21)];
                sendAddressPreLab.text=@"寄件地址:";
                sendAddressPreLab.font=_myFont;
                sendAddressPreLab.textColor=[UIColor grayColor];
                [cell addSubview:sendAddressPreLab];
                if (!_shiperProCityAreaLab)
                  _shiperProCityAreaLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(sendAddressPreLab), 12, cell.frame.size.width-ViewFrameX_W(sendAddressPreLab)-30, 21)];
                if (_express.shipperPlace.province.length)
                    _shiperProCityAreaLab.text=[NSString stringWithFormat:@"%@%@%@",_express.shipperPlace.province,_express.shipperPlace.city,_express.shipperPlace.area];
                _shiperProCityAreaLab.font=_myFont;
                [cell addSubview:_shiperProCityAreaLab];

            }else if(indexPath.row==1){
                UILabel*detailAddressPreLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 60, 21)];
                detailAddressPreLab.text=@"详细地址:";
                detailAddressPreLab.font=_myFont;
                detailAddressPreLab.textColor=[UIColor grayColor];
                [cell addSubview:detailAddressPreLab];
                if (!_shiperDetailAddressLab)
                 _shiperDetailAddressLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(detailAddressPreLab), 7, cell.frame.size.width-ViewFrameX_W(detailAddressPreLab)-10, 30)];
                if(_express.shipperPlace.detailAddress.length)
                    _shiperDetailAddressLab.text=_express.shipperPlace.detailAddress;
                _shiperDetailAddressLab.font=_myFont;
                [cell addSubview:_shiperDetailAddressLab];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;

            }else if (indexPath.row==2){
                UILabel*shiperNameLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 50, 21)];
                shiperNameLab.text=@"寄件人:";
                shiperNameLab.font=_myFont;
                shiperNameLab.textColor=[UIColor grayColor];
                [cell addSubview:shiperNameLab];
                if(!_shiperNameTF){
                    _shiperNameTF=[[UITextField alloc] initWithFrame:CGRectMake(ViewFrameX_W(shiperNameLab), 7, 100, 30)];
                    _shiperNameTF.text=_user.realName.length?_user.realName:_user.nickName;
                }
                _shiperNameTF.font=_myFont;
                _shiperNameTF.returnKeyType=UIReturnKeyDone;
                _shiperNameTF.delegate=self;
                [cell addSubview:_shiperNameTF];
                UILabel*shiperPhoneLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(_shiperNameTF)+5, 12, 40, 21)];
                shiperPhoneLab.text=@"电话:";
                shiperPhoneLab.font=_myFont;
                shiperPhoneLab.textColor=[UIColor grayColor];
                [cell addSubview:shiperPhoneLab];
                if (!_shiperPhoneTF){
                _shiperPhoneTF=[[HXNumberTextField alloc] initWithFrame:CGRectMake(ViewFrameX_W(shiperPhoneLab), 7, 100, 30) Type:UIKeyboardTypePhonePad];
                _shiperPhoneTF.text=_user.phoneNumber;
                }
                _shiperPhoneTF.font=_myFont;
                [cell addSubview:_shiperPhoneTF];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
        };break;
        case 2:{
            switch (indexPath.row) {
                case 0:{
                    UILabel*expressComPreLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 60, 21)];
                    expressComPreLab.text=@"意向快递:";
                    expressComPreLab.font=_myFont;
                    expressComPreLab.textColor=[UIColor grayColor];
                    [cell addSubview:expressComPreLab];
                    if (!_expressComLab)
                    _expressComLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(expressComPreLab), 12,cell.frame.size.width-ViewFrameX_W(expressComPreLab)-30, 21)];
                    _expressComLab.font=_myFont;
                    [cell addSubview:_expressComLab];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                };break;
                case 1:{
                    UILabel*recipentAddressPreLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 60, 21)];
                    recipentAddressPreLab.text=@"收件地址:";
                    recipentAddressPreLab.font=_myFont;
                    recipentAddressPreLab.textColor=[UIColor grayColor];
                    [cell addSubview:recipentAddressPreLab];
                    if (!_reciProCityAreaLab)
                    _reciProCityAreaLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(recipentAddressPreLab), 12, cell.frame.size.width-ViewFrameX_W(recipentAddressPreLab)-30, 21)];
                    _reciProCityAreaLab.font=_myFont;
                    [cell addSubview:_reciProCityAreaLab];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                };break;
                case 2:{
                    UILabel*detailAddressPreLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 60, 21)];
                    detailAddressPreLab.text=@"详细地址:";
                    detailAddressPreLab.font=_myFont;
                    detailAddressPreLab.textColor=[UIColor grayColor];
                    [cell addSubview:detailAddressPreLab];
                    if (!_reciDetailAddressTF)
                    _reciDetailAddressTF=[[UITextField alloc] initWithFrame:CGRectMake(ViewFrameX_W(detailAddressPreLab), 7, cell.frame.size.width-ViewFrameX_W(detailAddressPreLab), 30)];
                    _reciDetailAddressTF.font=_myFont;
                    _reciDetailAddressTF.returnKeyType=UIReturnKeyDone;
                    _reciDetailAddressTF.delegate=self;
                    [cell addSubview:_reciDetailAddressTF];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                };break;
                case 3:{
                    UILabel*recipentNameLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 50, 21)];
                    recipentNameLab.text=@"收件人:";
                    recipentNameLab.font=_myFont;
                    recipentNameLab.textColor=[UIColor grayColor];
                    [cell addSubview:recipentNameLab];
                    if (!_recipentNameTF)
                    _recipentNameTF=[[UITextField alloc] initWithFrame:CGRectMake(ViewFrameX_W(recipentNameLab), 7, 100, 30)];
                    _recipentNameTF.font=_myFont;
                    _recipentNameTF.returnKeyType=UIReturnKeyDone;
                    _recipentNameTF.delegate=self;
                    [cell addSubview:_recipentNameTF];
                    UILabel*shiperPhoneLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(_recipentNameTF)+5, 12, 40, 21)];
                    shiperPhoneLab.text=@"电话:";
                    shiperPhoneLab.font=_myFont;
                    shiperPhoneLab.textColor=[UIColor grayColor];
                    [cell addSubview:shiperPhoneLab];
                    if (!_recipentPhoneTF)
                    _recipentPhoneTF=[[HXNumberTextField alloc] initWithFrame:CGRectMake(ViewFrameX_W(shiperPhoneLab), 7, 100, 30) Type:UIKeyboardTypePhonePad];
                    _recipentPhoneTF.font=_myFont;
                    [cell addSubview:_recipentPhoneTF];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;

                };break;
                case 4:{
                    UILabel*indoorLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 60, 21)];
                    indoorLab.text=@"是否上门:";
                    indoorLab.font=_myFont;
                    indoorLab.textColor=[UIColor grayColor];
                    [cell addSubview:indoorLab];
                    if (!_isIndoorBtn)
                    _isIndoorBtn=[[UIButton alloc] initWithFrame:CGRectMake(ViewFrameX_W(indoorLab), 12, 20, 20)];
                    [_isIndoorBtn setBackgroundImage:[UIImage imageNamed:@"ico_uncheck_fang.png"] forState:UIControlStateNormal];
                    [_isIndoorBtn setBackgroundImage:[UIImage imageNamed:@"ico_check_fang.png"] forState:UIControlStateSelected];
                    [_isIndoorBtn addTarget:self action:@selector(isIndoorBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:_isIndoorBtn];
                    UILabel*indoorTimeLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(_isIndoorBtn)+60, 12, 60, 21)];
                    indoorTimeLab.text=@"服务时间:";
                    indoorTimeLab.font=_myFont;
                    indoorTimeLab.textColor=[UIColor grayColor];
                    [cell addSubview:indoorTimeLab];
                    if (!_serviceTimeBtn)
                    _serviceTimeBtn=[[UIButton alloc] initWithFrame:CGRectMake(ViewFrameX_W(indoorTimeLab), 2, SCREEN_WIDTH-ViewFrameX_W(indoorTimeLab)-10, 40)];
                    [_serviceTimeBtn addTarget:self action:@selector(serviceTimeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [_serviceTimeBtn setTitleColor:LightBlueColor forState:UIControlStateNormal];
                    [_serviceTimeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                    _serviceTimeBtn.titleLabel.font=_myFont;
                    [cell addSubview:_serviceTimeBtn];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                };break;
//                case 5:{
//                    UILabel*attachPreLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 60, 21)];
//                    attachPreLab.text=@"增值服务:";
//                    attachPreLab.font=_myFont;
//                    attachPreLab.textColor=[UIColor grayColor];
//                    [cell addSubview:attachPreLab];
//                    if (!_attachLab){
//                    _attachLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(attachPreLab)+10, 12,cell.frame.size.width-ViewFrameX_W(attachPreLab)-30, 21)];
//                    if (_express.addition.descriptin.length)
//                        _attachLab.text=_express.addition.descriptin;
//                     else
//                         _attachLab.text=@"请点击选择增值服务";
//                    }
//                    _attachLab.font=_myFont;
//                    _attachLab.textColor=[UIColor grayColor];
//                    [cell addSubview:_attachLab];
//                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//                };break;
                case 5:{
                    UILabel*articleNameLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 60, 21)];
                    articleNameLab.text=@"物品名称:";
                    articleNameLab.font=_myFont;
                    articleNameLab.textColor=[UIColor grayColor];
                    [cell addSubview:articleNameLab];
                    if (!_articleNameLab){
                    _articleNameLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(articleNameLab), 7, 100, 30)];
                        if (_express.articleType.name.length)
                            _articleNameLab.text=_express.articleType.name;
                    }
                    _articleNameLab.font=_myFont;
                    [cell addSubview:_articleNameLab];
                    UILabel*articleWeightLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(_articleNameLab)+2, 12, 90, 21)];
                    articleWeightLab.text=@"物品重量(kg):";
                    articleWeightLab.font=_myFont;
                    articleWeightLab.textColor=[UIColor grayColor];
                    [cell addSubview:articleWeightLab];
                    if (!_articleWeightTF)
                    _articleWeightTF=[[HXNumberTextField alloc] initWithFrame:CGRectMake(ViewFrameX_W(articleWeightLab), 7, 100, 30) Type:UIKeyboardTypeDecimalPad];
                    _articleWeightTF.font=_myFont;
                    [cell addSubview:_articleWeightTF];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                };break;
                case 6:{
                    UILabel*deliveryPayLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 60, 21)];
                    deliveryPayLab.text=@"是否到付:";
                    deliveryPayLab.font=_myFont;
                    deliveryPayLab.textColor=[UIColor grayColor];
                    [cell addSubview:deliveryPayLab];
                    if (!_isDeliveryPayBtn)
                        _isDeliveryPayBtn=[[UIButton alloc] initWithFrame:CGRectMake(ViewFrameX_W(deliveryPayLab), 12, 20, 20)];
                    [_isDeliveryPayBtn setBackgroundImage:[UIImage imageNamed:@"ico_uncheck_fang.png"] forState:UIControlStateNormal];
                    [_isDeliveryPayBtn setBackgroundImage:[UIImage imageNamed:@"ico_check_fang.png"] forState:UIControlStateSelected];
                    [_isDeliveryPayBtn addTarget:self action:@selector(isDeliveryPayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:_isDeliveryPayBtn];
                    
                    UILabel*couponPreLab=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-135-50, 12, 50, 21)];
                    couponPreLab.text=@"优惠券:";
                    couponPreLab.font=_myFont;
                    couponPreLab.textColor=[UIColor grayColor];
                    [cell addSubview:couponPreLab];
                    if (!_couponLab) {
                        _couponLab=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-135, 12, 105, 21)];
                        CGRect rect=_couponLab.frame;
                        if(_couponNums>0){
                         _couponLab.text=@"请选择";
                         _couponLab.textColor=[UIColor grayColor];
                         rect.origin.x=SCREEN_WIDTH-135;
                            UITapGestureRecognizer*gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCouponGesture:)];
                            [_couponLab addGestureRecognizer:gesture];
                        }
                        else{
                         _couponLab.text=@"无可用";
                         _couponLab.textColor=[UIColor blackColor];
                         rect.origin.x=SCREEN_WIDTH-135;
                        }
                        _couponLab.frame=rect;
                    }
                    if (_couponNums>0) {
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                        _couponLab.userInteractionEnabled=YES;
                    }else{
                        cell.accessoryType= UITableViewCellAccessoryNone;
                        _couponLab.userInteractionEnabled=NO;
                    }
                    _couponLab.font=_myFont;
                    [cell addSubview:_couponLab];
                    
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                };break;
                case 7:{
                    UILabel*remarkLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 60, 21)];
                    remarkLab.text=@"备注信息:";
                    remarkLab.font=_myFont;
                    remarkLab.textColor=[UIColor grayColor];
                    [cell addSubview:remarkLab];
                    if (!_remarkTF)
                    _remarkTF=[[UITextField alloc] initWithFrame:CGRectMake(ViewFrameX_W(remarkLab), 7, SCREEN_WIDTH-ViewFrameX_W(remarkLab)-10, 30)];
                    _remarkTF.font=_myFont;
                    _remarkTF.placeholder=@"可输入备注信息";
                    _remarkTF.returnKeyType=UIReturnKeyDone;
                    _remarkTF.delegate=self;
                    [cell addSubview:_remarkTF];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;

                };break;
                default:
                    break;
            }
            
        };break;
        case 3:{
        //确认下单按钮
            _confirmBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 16, SCREEN_WIDTH-20, 44)];
            _confirmBtn.backgroundColor=[UIColor redColor];
            _confirmBtn.layer.cornerRadius=_confirmBtn.frame.size.height/2;
            [_confirmBtn setTitle:@"确认下单" forState:UIControlStateNormal];
            [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:_confirmBtn];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        };break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hideKeyBoard];
    if (indexPath.section==0 && indexPath.row==0) {
        HXSelePointViewController*desVC=[[HXSelePointViewController alloc] init];
        desVC.delegate=self;
        [self.navigationController pushViewController:desVC animated:YES];
    }else if (indexPath.section==2 & indexPath.row==0){
        HXSelectCompanyViewController*desVC=[[HXSelectCompanyViewController alloc] init];
        desVC.delegate=self;
        [self.navigationController pushViewController:desVC animated:YES];
    }else if (indexPath.section==2 & indexPath.row==1){
        HXSelectProCityAreaAlert*alert=[[HXSelectProCityAreaAlert alloc] initWithPlace:_express.recivePlace];
        alert.Cudelegate=self;
        [alert show];
    }
//    else if(indexPath.section==2 & indexPath.row==5){
//        NSArray*additions=[[HXAdditonServiceDao new] fetchAllAdditions];
//        if (additions.count) {
//            HXSelectAdditionServiceAlert*alert=[[HXSelectAdditionServiceAlert alloc] initWithSelectAddition:_express.addition];
//            alert.CusDelegate=self;
//            [alert show];
//        }else{
//            [HXAlertViewEx showInTitle:nil Message:@"暂无可用的增值服务" ViewController:self];
//            return;
//        }
//    }
//    else if (indexPath.section==2 & indexPath.row==6){
//        if(_couponNums==0)
//            return;
//        else{
//            //选择可用优惠券
//            HXSelectCouponViewController*desVC=[[HXSelectCouponViewController alloc] init];
//            desVC.selectCoupon=_express.coupon;
//            desVC.delegate=self;
//            desVC.businessType=HXBusinessTypeSendParcel;
//            [self.navigationController pushViewController:desVC animated:YES];
//        }
//    }
}


////选择常用地址
//-(void)addressbtnClicked:(id)sender{
//    HXMoreAddressViewController*desVC=[[HXMoreAddressViewController alloc] init];
//    desVC.delegate=self;
//    desVC.forSelect=YES;
//    if (_express.shipperPlace) {
//        HXConventionalAddModel*addressModel=[HXConventionalAddModel new];
//        addressModel.province=_express.shipperPlace.province;
//        addressModel.city=_express.shipperPlace.city;
//        addressModel.area=_express.shipperPlace.area;
//        addressModel.address=_express.shipperPlace.detailAddress;
//        desVC.orginalAddress=addressModel;
//    }
//    [self.navigationController pushViewController:desVC animated:YES];
//}

//#pragma mark--HXSelectAddressDelegate
//-(void)selectAddressVC:(HXMoreAddressViewController *)moreAddressVC selectAddress:(HXConventionalAddModel *)address{
//    _express.shipperPlace=[HXPlace new];
//    _express.shipperPlace.province=address.province;
//    _express.shipperPlace.city=address.city;
//    _express.shipperPlace.area=address.area;
//    _express.shipperPlace.detailAddress=address.address;
//    
//    _shiperProCityAreaLab.text=[NSString stringWithFormat:@"%@%@%@",address.province,address.city,address.area];
//    _shiperDetailAddressLab.text=address.address;
//}


//服务协议勾选按钮
-(void)agreeCheckBtnClicked:(id)sender{
    _agreeCheckBtn.selected=!_agreeCheckBtn.selected;
}

//服务协议按钮
-(void)agreementBtnClicked:(id)sender{
    HXAgreementViewController*desVC=[[HXAgreementViewController alloc] init];
    desVC.agreementType=HXAgreementTypeService;
    [self.navigationController pushViewController:desVC animated:YES];
}


#pragma mark--HXSelectArticleTypeDelegate
-(void)alertView:(HXSelectArticleTypeAlert*)alertView selectArticleType:(HXArticleType*)articleType{
    NSLog(@"%@",articleType.name);
    if(!_express)
        _express=[HXExpress new];
    _express.articleType=articleType;
    if (_articleNameLab)
    _articleNameLab.text=_express.articleType.name;
}


#pragma mark--HXSelectPointDelegate
-(void)selectVC:(HXSelePointViewController *)selectVC NewPoint:(AMapCloudPOI *)poi pointPlace:(HXPlace *)pointPlace{
    _user=[NSUserDefaultsUtil getLoginUser];
    _pointLab.text=[NSString stringWithFormat:@"出发地: %@",_user.pointName];
    _express.pointNo=_user.pointNo;
    _express.pointName=_user.pointName;
    _express.shipperPlace=pointPlace;
    //出发地址省市区及详细地址刷新
    NSIndexPath*indexPath1=[NSIndexPath indexPathForRow:0 inSection:1];
    NSIndexPath*indexPath2=[NSIndexPath indexPathForRow:1 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath1,indexPath2] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark--HXSelectCompanyDelegate
-(void)selectCompanyVC:(HXSelectCompanyViewController *)selectVC selectCompany:(HXCompany *)company{
    _expressComLab.text=company.name;
    _express.companyNo=company.no;
    _express.companyName=company.name;
    _express.companyLogoUrl=company.logoUrl;
    _expressComLab.text=_express.companyName;
}

#pragma mark--HXSelectProvinceCityAreaDelegate
-(void)alertView:(HXSelectProCityAreaAlert*)alertView selectPlace:(HXPlace*)place{
       _express.recivePlace=place;
       _reciProCityAreaLab.text=[NSString stringWithFormat:@"%@%@%@",_express.recivePlace.province,_express.recivePlace.city,_express.recivePlace.area];
}

//是否上门
-(void)isIndoorBtnClicked:(id)sender{
    [self hideKeyBoard];
    UIButton*btn=(UIButton*)sender;
    btn.selected=!btn.selected;
    _express.isIndoor=btn.selected;
}


//上门服务时间
-(void)serviceTimeBtnClicked:(id)sender{
    [self hideKeyBoard];
    HXSelectServiceTimeAlert*alert=[[HXSelectServiceTimeAlert alloc] initWithSelectServiceTimeStr:_express.serviceTimeStr];
    alert.CusDelegate=self;
    [alert show];
}

#pragma mark--HXSelectServiceTimeDelegate
-(void)alertView:(HXSelectServiceTimeAlert *)alertView selectServiceTime:(NSString *)serviceTime{
    _express.serviceTimeStr=serviceTime;
    [_serviceTimeBtn setTitle:_express.serviceTimeStr forState:UIControlStateNormal];
}

////增值服务
//#pragma mark--HXSelectAdditionServiceDelegate
//
//-(void)alertView:(HXSelectAdditionServiceAlert *)alertView addition:(HXAdditonService *)addition{
//        _express.addition=addition;
//    if (_express.addition){
//        _attachLab.textColor=[UIColor blackColor];
//        _attachLab.text=_express.addition.descriptin;
//    }else{
//        _attachLab.textColor=[UIColor grayColor];
//        _attachLab.text=@"请点击选择增值服务";
//    }
//}

//是否到付
-(void)isDeliveryPayBtnClicked:(id)sender{
    [self hideKeyBoard];
    UIButton*btn=(UIButton*)sender;
    btn.selected=!btn.selected;
    _express.isDeliveryPay=btn.selected;

    if (_couponNums>0) {
        if (_express.isDeliveryPay) {
            _couponLab.text=@"不可用";
            _couponLab.userInteractionEnabled=NO;
            _couponLab.textColor=[UIColor grayColor];
        }else{
             _couponLab.userInteractionEnabled=YES;
            if (_express.coupon) {
                _couponLab.text=[NSString stringWithFormat:@"%@元%@",_express.coupon.faceValue,HXCouponTypeStr(_express.coupon.type)];
                _couponLab.textColor=[UIColor blackColor];
            }else{
                _couponLab.text=@"请选择";
                _couponLab.textColor=[UIColor grayColor];
            }
        }
    }
}


//选择优惠券手势点击
-(void)selectCouponGesture:(UIGestureRecognizer*)gesture{
    if(_couponNums==0)
        return;
    else{
        //选择可用优惠券
        HXSelectCouponViewController*desVC=[[HXSelectCouponViewController alloc] init];
        desVC.selectCoupon=_express.coupon;
        desVC.delegate=self;
        desVC.businessType=HXBusinessTypeSendParcel;
        [self.navigationController pushViewController:desVC animated:YES];
    }
}



//选择可用优惠券
#pragma mark--HXSelectCouponDelegate
-(void)selectCouponVC:(HXSelectCouponViewController *)selectVC selectCoupon:(HXCouponModel *)coupon{
    _express.coupon=coupon;
    if (_express.coupon) {
        _couponLab.textColor=[UIColor blackColor];
        _couponLab.text=[NSString stringWithFormat:@"%@元%@",_express.coupon.faceValue,HXCouponTypeStr(coupon.type)];
    }else{
        _couponLab.textColor=[UIColor grayColor];
        _couponLab.text=@"请选择";
    }
}


#pragma mark--UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)hideKeyBoard{
    [[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self hideKeyBoard];
}

//确认下单
-(void)confirmBtnClicked:(id)sender{
    if (!_user.pointNo.length) {
        [HXAlertViewEx showInTitle:nil Message:@"请选择出发地网点" ViewController:self];
        return;
    }
    
    if (!_shiperProCityAreaLab.text.length | (!_shiperDetailAddressLab.text.length)) {
        [HXAlertViewEx showInTitle:nil Message:@"寄件人地址获取失败,请返回重试" ViewController:self];
        return;
    }
    if (!_shiperNameTF.text.length) {
        [HXAlertViewEx showInTitle:nil Message:@"请输入寄件人名称" ViewController:self];
        return;
    }
    if (!_shiperPhoneTF.text.length) {
        [HXAlertViewEx showInTitle:nil Message:@"请输入寄件人电话" ViewController:self];
        return;
    }
    if (!_express.recivePlace) {
        [HXAlertViewEx showInTitle:nil Message:@"请选择收件地址" ViewController:self];
        return;
    }
    if (!_reciDetailAddressTF.text.length) {
        [HXAlertViewEx showInTitle:nil Message:@"请输入收件人详细地址" ViewController:self];
        return;
    }
    if (!_recipentNameTF.text.length) {
        [HXAlertViewEx showInTitle:nil Message:@"请输入收件人名称" ViewController:self];
        return;
    }
    if (!_recipentPhoneTF.text.length) {
        [HXAlertViewEx showInTitle:nil Message:@"请输入收件人电话" ViewController:self];
        return;
    }
    if (_express.isIndoor &&(!_express.serviceTimeStr.length)) {
        [HXAlertViewEx showInTitle:nil Message:@"请选择服务时间" ViewController:self];
        return;
    }

    if (!_articleWeightTF.text.length) {
        [HXAlertViewEx showInTitle:nil Message:@"请输入物品重量" ViewController:self];
        return;
    }
    if(!_articleNameLab.text.length){
        [HXAlertViewEx showInTitle:nil Message:@"获取物品类型名称失败，请返回后重新寄件" ViewController:self];
        return;
    }
    
    if ((![HXNSStringUtil isMobilePhoneNumber:_shiperPhoneTF.text])&& (![HXNSStringUtil isZPhoneNumber:_shiperPhoneTF.text])) {
        [HXAlertViewEx showInTitle:nil Message:@"寄件人电话格式不正确" ViewController:self];
        return;
    }
    if((![HXNSStringUtil isMobilePhoneNumber:_recipentPhoneTF.text]) && (![HXNSStringUtil isZPhoneNumber:_recipentPhoneTF.text])){
        [HXAlertViewEx showInTitle:nil Message:@"收件人电话格式不正确" ViewController:self];
        return;
    }
    
    if([_articleWeightTF.text floatValue]>9999){
        [HXAlertViewEx showInTitle:nil Message:@"物品重量超限(9999kg),请重新输入" ViewController:self];
        return;
    }
    
    if(!_agreeCheckBtn.selected){
        [HXAlertViewEx showInTitle:nil Message:@"请先阅读并同意《服务协议》" ViewController:self];
        return;
    }

    _express.shipperNickName=_shiperNameTF.text;
    _express.shipperPhone=_shiperPhoneTF.text;
    _express.recivePlace.detailAddress=_reciDetailAddressTF.text;
    _express.recipientName=_recipentNameTF.text;
    _express.recipientPhone=_recipentPhoneTF.text;
    _express.weight=[_articleWeightTF.text floatValue];
    _express.remark=_remarkTF.text;
    if(!_express.companyNo){
        _express.companyLogoUrl=@"";
        _express.companyNo=@"";
        _express.companyName=@"";
    }
    if(!_express.isIndoor)
        _express.serviceTimeStr=@"";
    
    if(_express.isDeliveryPay)
        _express.coupon=nil;
    if (_confirmBtn.enabled)
        [self createSendOrderHttp];
}


-(void)createSendOrderHttp{
    _confirmBtn.enabled=NO;
//    NSString*additionNo=_express.addition?_express.addition.no:@"";
//    NSString*additionDes=_express.addition?_express.addition.descriptin:@"";
//    NSString*additionFee=_express.addition?_express.addition.feeStr:@"0";
    NSString*couponNo=_express.coupon?_express.coupon.couponNo:@"";
    NSString*paymentTypeStr=_express.isDeliveryPay?@"2":@"1"; //1预付 2到付
    
    NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[_user.phoneNumber,_user.pointNo,_express.articleType.no,[NSNumber numberWithBool:_express.isIndoor],_express.recipientPhone,_express.shipperPhone,@"0",_user.token]];
    
    NSDictionary*paramsDic=@{@"phoneNumber":_user.phoneNumber,@"sKey":sKey,@"pointNo":_user.pointNo,@"expressNo":_express.companyNo,@"expressLogo":_express.companyLogoUrl,@"expressName":_express.companyName,@"stdmodeNo":_express.articleType.no,@"stdmodeName":_express.articleType.name,@"shipAddressProvince":_express.shipperPlace.province,@"shipAddressCity":_express.shipperPlace.city,@"shipAddressArea":_express.shipperPlace.area,@"shipAddress":_express.shipperPlace.detailAddress,@"shipperNickName":_express.shipperNickName,@"shipperContactNumber":_express.shipperPhone,@"recipientProvince":_express.recivePlace.province,@"recipientCity":_express.recivePlace.city,@"recipientArea":_express.recivePlace.area,@"recipientAddress":_express.recivePlace.detailAddress,@"recipientName":_express.recipientName,@"recipientPhoneNumber":_express.recipientPhone,@"isDoorService":[NSNumber numberWithBool:_express.isIndoor],@"pickupTimeDes":_express.serviceTimeStr,@"additionNo":@"",@"additionDescription":@"",@"additionFee":@"0",@"couponNo":couponNo,@"remark":_express.remark,@"weight":[NSNumber numberWithFloat:_express.weight],@"type":paymentTypeStr};
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/send/createOrder" params:paramsDic onComplete:^(NSError *error, NSDictionary *resultJson) {
        _confirmBtn.enabled=YES;
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:@"创建失败" ViewController:self];
        }else{
            NSString*msgStr=@"下单成功，请带好您的快递和身份证，到网点扫码付费，完成订单。";
            if (_express.isIndoor)
              msgStr=@"下单成功,请耐心等待店员上门服务";
            else{
                if (_express.isDeliveryPay)
                    msgStr=@"下单成功，请带好您的快递和身份证，到网点完成订单。";
            }
            UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msgStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [alert show];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HXNTFDoingSendOrderListRefresh object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
