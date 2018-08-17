//
//  HXSendOrderDetailViewController.m
//  BaiMi
//
//  Created by licl on 16/7/18.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXSendOrderDetailViewController.h"

@interface HXSendOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)UIFont*myFont;

@property(strong,nonatomic)UILabel*pointLab;
@property(strong,nonatomic)UILabel*shiperProCityAreaLab; //寄件地址
@property(strong,nonatomic)UILabel*shiperNameLab;
@property(strong,nonatomic)UILabel*shiperPhoneLab;
@property(strong,nonatomic)UILabel*expressComLab; //快递公司
@property(strong,nonatomic)UILabel*shiperDetailAddressLab; //寄件人详细地址
@property(strong,nonatomic)UILabel*reciProCityAreaLab; //省市区
@property(strong,nonatomic)UILabel*reciDetailAddressLab; //收件人详细地址

@property(strong,nonatomic)UILabel*recipentNameLab;
@property(strong,nonatomic)UILabel*recipentPhoneLab;
@property(strong,nonatomic)UILabel*attachLab;//增值服务
@property(strong,nonatomic)UILabel*articleNameLab; //物品名称
@property(strong,nonatomic)UILabel*articleWeightLab;//物品重量
@property(strong,nonatomic)UILabel*remarkLab;//备注信息
@property(strong,nonatomic)UILabel*serviceTimeLab;//服务时间
@property(assign,nonatomic)BOOL forShipper;
@property(strong,nonatomic)UIButton*confirmBtn;
@property(strong,nonatomic)UILabel* couponLab;//优惠券
@property(assign,nonatomic)int couponNums;//优惠券数量

@property(strong,nonatomic)UITableView*tableView;
@end

@implementation HXSendOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"寄件详情";
    self.view.backgroundColor=BackGroundColor;
    _myFont=[UIFont systemFontOfSize:13.f];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    [self pullSendOrderDetailHttp];
}


//寄件单详情
-(void)pullSendOrderDetailHttp{
    HXLoginUser*user=[NSUserDefaultsUtil getLoginUser];
    NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,_express.orderId,user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/send/orderDetail" params:@{@"phoneNumber":user.phoneNumber,@"sKey":sKey,@"orderNo":_express.orderId} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            id dict=[resultJson objectForKey:@"content"];
            if([dict isKindOfClass:[NSDictionary class]]){
                //出发地网点名称
                _express.pointName=[HXHttpUtils whetherNil:[dict objectForKey:@"pointName"]];
                //寄件人姓名电话
                _express.shipperNickName=[dict objectForKey:@"shipperNickName"];
                _express.shipperPhone=[dict objectForKey:@"shipperContactNumber"];
                //寄件人地址
                _express.shipperPlace=[HXPlace new];
                _express.shipperPlace.province=[dict objectForKey:@"shipperAddressProvince"];
                _express.shipperPlace.city=[dict objectForKey:@"shipperAddressCity"];
                _express.shipperPlace.area=[HXHttpUtils whetherNil:[dict objectForKey:@"shipperAddressArea"]];
                _express.shipperPlace.detailAddress=[HXHttpUtils whetherNil:[dict objectForKey:@"shipperAddress"]];
                //收件人姓名电话
                _express.recipientName=[dict objectForKey:@"recipientName"];
                _express.recipientPhone=[dict objectForKey:@"recipientPhoneNumber"];
                //收件人地址
                _express.recivePlace=[HXPlace new];
                _express.recivePlace.province=[dict objectForKey:@"recipientAddressProvince"];
                _express.recivePlace.city=[dict objectForKey:@"recipientAddressCity"];
                _express.recivePlace.area=[HXHttpUtils whetherNil:[dict objectForKey:@"recipientAddressArea"]];
                _express.recivePlace.detailAddress=[HXHttpUtils whetherNil:[dict objectForKey:@"recipientAddress"]];
                
                //意向快递名称
                _express.companyName=[HXHttpUtils whetherNil:[dict objectForKey:@"expressName"]];
        
               //是否上门及服务时间
                _express.isIndoor=[[HXHttpUtils whetherNil:[dict objectForKey:@"isDoorService"]] intValue];
                if (_express.isIndoor)
                    _express.serviceTimeStr=[HXHttpUtils whetherNil:[dict objectForKey:@"pickupTimeDes"]];
               //增值服务
//                _express.addition=[HXAdditonService new];
//                _express.addition.descriptin=[HXHttpUtils whetherNil:[dict objectForKey:@"additionDescription"]];
               //物品类型名称
                _express.articleType=[HXArticleType new];
                _express.articleType.name=[HXHttpUtils whetherNil:[dict objectForKey:@"stdmodeName"]];
                
                //物品重量
                _express.weight=[[dict objectForKey:@"weight"] floatValue];
                //使用的优惠券
                _express.coupon=[HXCouponModel new];
//                _express.coupon.couponNo=[HXHttpUtils whetherNil:[dict objectForKey:@"couponNo"]];
                _express.coupon.faceValue=[HXHttpUtils whetherNil:[dict objectForKey:@"couponFaceValue"]];
//                _express.coupon.type=[[HXHttpUtils whetherNil:[dict objectForKey:@"type"]] intValue];
                //备注
                _express.remark=[HXHttpUtils whetherNil:[dict objectForKey:@"remark"]];
                int type=[[dict objectForKey:@"type"] intValue];
                //type 1预付  2到付
                if (type==2)
                    _express.isDeliveryPay=1;
                else
                    _express.isDeliveryPay=0;
            [self.tableView reloadData];
        }
        }
    }];
}



#pragma mark--UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:return 1;break;
        case 1:return 3;break;
        case 2:return 8;break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:return 1;break;
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
        UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(5, 12, 100, 21)];
        label.font=[UIFont systemFontOfSize:14.f];
            if (section==1)
                label.text=@"寄件人信息";
            else if(section==2)
                label.text=@"收件人信息";
            [view addSubview:label];
        return view;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell*cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:{
            UIImageView*iconImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 18, 24)];
            iconImgView.image=[UIImage imageNamed:@"icon_grayPlace.png"];
            [cell addSubview:iconImgView];
            _pointLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(iconImgView)+5, 12, cell.frame.size.width-ViewFrameX_W(iconImgView)-30, 21)];
            _pointLab.text=_express.pointName.length?[NSString stringWithFormat:@"出发地:%@",_express.pointName]:@"出发地:";
            _pointLab.font=_myFont;
            [cell addSubview:_pointLab];
        };break;
        case 1:{
            if (indexPath.row==0) {
                UILabel*sendAddressPreLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 60, 21)];
                sendAddressPreLab.text=@"寄件地址:";
                sendAddressPreLab.font=_myFont;
                sendAddressPreLab.textColor=[UIColor grayColor];
                [cell addSubview:sendAddressPreLab];
                    _shiperProCityAreaLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(sendAddressPreLab), 12, cell.frame.size.width-ViewFrameX_W(sendAddressPreLab)-30, 21)];
                    if (_express.shipperPlace.province.length)
                        _shiperProCityAreaLab.text=[NSString stringWithFormat:@"%@%@%@",_express.shipperPlace.province,_express.shipperPlace.city,_express.shipperPlace.area];
                else
                    _shiperProCityAreaLab.text=@"";
                _shiperProCityAreaLab.font=_myFont;
                [cell addSubview:_shiperProCityAreaLab];
                
            }else if(indexPath.row==1){
                UILabel*detailAddressPreLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 60, 21)];
                detailAddressPreLab.text=@"详细地址:";
                detailAddressPreLab.font=_myFont;
                detailAddressPreLab.textColor=[UIColor grayColor];
                [cell addSubview:detailAddressPreLab];
                    _shiperDetailAddressLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(detailAddressPreLab), 7, cell.frame.size.width-ViewFrameX_W(detailAddressPreLab)-10, 30)];
                    if(_express.shipperPlace.detailAddress.length)
                        _shiperDetailAddressLab.text=_express.shipperPlace.detailAddress;
                else
                    _shiperDetailAddressLab.text=@"";
                _shiperDetailAddressLab.font=_myFont;
                [cell addSubview:_shiperDetailAddressLab];
                
            }else if (indexPath.row==2){
                UILabel*shiperNamePreLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 50, 21)];
                shiperNamePreLab.text=@"寄件人:";
                shiperNamePreLab.font=_myFont;
                shiperNamePreLab.textColor=[UIColor grayColor];
                [cell addSubview:shiperNamePreLab];
                    _shiperNameLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(shiperNamePreLab), 7, 100, 30)];
                _shiperNameLab.text=_express.shipperNickName.length?_express.shipperNickName:@"";
                _shiperNameLab.font=_myFont;
                [cell addSubview:_shiperNameLab];
                UILabel*shiperPhonePreLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(_shiperNameLab)+5, 12, 40, 21)];
                shiperPhonePreLab.text=@"电话:";
                shiperPhonePreLab.font=_myFont;
                shiperPhonePreLab.textColor=[UIColor grayColor];
                [cell addSubview:shiperPhonePreLab];
                    _shiperPhoneLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(shiperPhonePreLab), 7, 100, 30)];
                _shiperPhoneLab.text=_express.shipperPhone.length?_express.shipperPhone:@"";
                _shiperPhoneLab.font=_myFont;
                [cell addSubview:_shiperPhoneLab];
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
                        _expressComLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(expressComPreLab), 12,cell.frame.size.width-ViewFrameX_W(expressComPreLab)-30, 21)];
                    _expressComLab.text=_express.companyName.length?_express.companyName:@"";
                    _expressComLab.font=_myFont;
                    [cell addSubview:_expressComLab];
                };break;
                case 1:{
                    UILabel*recipentAddressPreLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 60, 21)];
                    recipentAddressPreLab.text=@"收件地址:";
                    recipentAddressPreLab.font=_myFont;
                    recipentAddressPreLab.textColor=[UIColor grayColor];
                    [cell addSubview:recipentAddressPreLab];
                        _reciProCityAreaLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(recipentAddressPreLab), 12, cell.frame.size.width-ViewFrameX_W(recipentAddressPreLab)-30, 21)];
                    _reciProCityAreaLab.font=_myFont;
                    if (_express.recivePlace.province.length) {
                        _reciProCityAreaLab.text=[NSString stringWithFormat:@"%@%@%@",_express.recivePlace.province,_express.recivePlace.city,_express.recivePlace.area];
                    }else
                        _reciProCityAreaLab.text=@"";
                    [cell addSubview:_reciProCityAreaLab];
                };break;
                case 2:{
                    UILabel*detailAddressPreLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 60, 21)];
                    detailAddressPreLab.text=@"详细地址:";
                    detailAddressPreLab.font=_myFont;
                    detailAddressPreLab.textColor=[UIColor grayColor];
                    [cell addSubview:detailAddressPreLab];
                        _reciDetailAddressLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(detailAddressPreLab), 7, cell.frame.size.width-ViewFrameX_W(detailAddressPreLab), 30)];
                    _reciDetailAddressLab.text=_express.recivePlace.detailAddress.length?_express.recivePlace.detailAddress:@"";
                    _reciDetailAddressLab.font=_myFont;
                    [cell addSubview:_reciDetailAddressLab];
                };break;
                case 3:{
                    UILabel*recipentNameLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 50, 21)];
                    recipentNameLab.text=@"收件人:";
                    recipentNameLab.font=_myFont;
                    recipentNameLab.textColor=[UIColor grayColor];
                    [cell addSubview:recipentNameLab];
                    _recipentNameLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(recipentNameLab), 7, 100, 30)];
                    _recipentNameLab.text=_express.recipientName.length?_express.recipientName:@"";
                    _recipentNameLab.font=_myFont;
                    [cell addSubview:_recipentNameLab];
                    UILabel*shiperPhoneLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(_recipentNameLab)+5, 12, 40, 21)];
                    shiperPhoneLab.text=@"电话:";
                    shiperPhoneLab.font=_myFont;
                    shiperPhoneLab.textColor=[UIColor grayColor];
                    [cell addSubview:shiperPhoneLab];
                        _recipentPhoneLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(shiperPhoneLab), 7, 100, 30)];
                    _recipentPhoneLab.text=_express.recipientPhone.length?_express.recipientPhone:@"";
                    _recipentPhoneLab.font=_myFont;
                    [cell addSubview:_recipentPhoneLab];
                    
                };break;
                case 4:{
                    UILabel*indoorPreLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 60, 21)];
                    indoorPreLab.text=@"是否上门:";
                    indoorPreLab.font=_myFont;
                    indoorPreLab.textColor=[UIColor grayColor];
                    [cell addSubview:indoorPreLab];
                    
                    UILabel*indoorLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(indoorPreLab), 12, 60, 21)];
                    indoorLab.font=_myFont;
                    [cell addSubview:indoorLab];
                    if (_express.isIndoor) {
                        indoorLab.text=@"是";
                        UILabel*indoorTimeLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(indoorLab)+35, 12, 60, 21)];
                        indoorTimeLab.text=@"服务时间:";
                        indoorTimeLab.font=_myFont;
                        indoorTimeLab.textColor=[UIColor grayColor];
                        [cell addSubview:indoorTimeLab];
                        _serviceTimeLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(indoorTimeLab), 2, SCREEN_WIDTH-ViewFrameX_W(indoorTimeLab)-10, 40)];
                        _serviceTimeLab.font=_myFont;
                        _serviceTimeLab.text=_express.serviceTimeStr;
                        [cell addSubview:_serviceTimeLab];
                    }else{
                        indoorLab.text=@"否";
                    }
                };break;
//                case 5:{
//                    UILabel*attachPreLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 60, 21)];
//                    attachPreLab.text=@"增值服务:";
//                    attachPreLab.font=_myFont;
//                    attachPreLab.textColor=[UIColor grayColor];
//                    [cell addSubview:attachPreLab];
//                        _attachLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(attachPreLab)+10, 12,cell.frame.size.width-ViewFrameX_W(attachPreLab)-30, 21)];
//                    if (_express.addition.descriptin.length)
//                            _attachLab.text=_express.addition.descriptin;
//                        else
//                            _attachLab.text=@"";
//                    _attachLab.font=_myFont;
//                    [cell addSubview:_attachLab];
//                };break;
                case 5:{
                    UILabel*articleNameLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 60, 21)];
                    articleNameLab.text=@"物品名称:";
                    articleNameLab.font=_myFont;
                    articleNameLab.textColor=[UIColor grayColor];
                    [cell addSubview:articleNameLab];
                    _articleNameLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(articleNameLab), 7, 100, 30)];
                    _articleNameLab.font=_myFont;
                    _articleNameLab.text=_express.articleType.name.length?_express.articleType.name:@"";
                    [cell addSubview:_articleNameLab];
                    UILabel*articleWeightLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(_articleNameLab)+2, 12, 90, 21)];
                    articleWeightLab.text=@"物品重量(kg):";
                    articleWeightLab.font=_myFont;
                    articleWeightLab.textColor=[UIColor grayColor];
                    [cell addSubview:articleWeightLab];
                    _articleWeightLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(articleWeightLab), 7, 100, 30)];
                    _articleWeightLab.font=_myFont;
                    _articleWeightLab.text=[NSString stringWithFormat:@"%.2f",_express.weight];
                    [cell addSubview:_articleWeightLab];
                };break;
                case 6:{
                    
                    UILabel*deliveryPayPreLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 60, 21)];
                    deliveryPayPreLab.text=@"是否到付:";
                    deliveryPayPreLab.font=_myFont;
                    deliveryPayPreLab.textColor=[UIColor grayColor];
                    [cell addSubview:deliveryPayPreLab];
                    
                    UILabel*deliveryPayLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(deliveryPayPreLab), 12, 60, 21)];
                    deliveryPayLab.font=_myFont;
                    [cell addSubview:deliveryPayLab];
                    if (_express.isDeliveryPay) {
                        deliveryPayLab.text=@"是";
                    }else{
                        deliveryPayLab.text=@"否";
                        UILabel*couponPreLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(deliveryPayLab)+35, 12, 60, 21)];
                        couponPreLab.text=@"优惠券:";
                        couponPreLab.font=_myFont;
                        couponPreLab.textColor=[UIColor grayColor];
                        [cell addSubview:couponPreLab];
                        _couponLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(couponPreLab), 2, SCREEN_WIDTH-ViewFrameX_W(couponPreLab)-10, 40)];
                        _couponLab.font=_myFont;
                        NSString*str=@"";
                        if (_express.coupon.faceValue.length)
                            str=[NSString stringWithFormat:@"%@元%@",_express.coupon.faceValue,HXCouponTypeStr(_express.coupon.type)];
                        _couponLab.text=str;
                        [cell addSubview:_couponLab];
                    }
                };break;
                case 7:{
                    UILabel*remarkPreLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 1, 60, 42)];
                    remarkPreLab.text=@"备注信息:";
                    remarkPreLab.font=_myFont;
                    remarkPreLab.numberOfLines=2;
                    remarkPreLab.textColor=[UIColor grayColor];
                    [cell addSubview:remarkPreLab];
                    _remarkLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(remarkPreLab), 7, 100, 30)];
                    _remarkLab.text=_express.remark.length?_express.remark:@"";
                    _remarkLab.font=_myFont;
                    [cell addSubview:_remarkLab];
                };break;
                default:
                    break;
            }
            
        };break;
        default:
            break;
    }
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
