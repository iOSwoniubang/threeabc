//
//  HXOrderShareListViewController.m
//  BaiMi
//
//  Created by licl on 16/7/21.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXOrderShareListViewController.h"
#import "HXPackageCell.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "HXAdressBookListViewController.h"

@interface HXOrderShareListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView*tableView;
@property(strong,nonatomic)NSArray*listArray;
@end

@implementation HXOrderShareListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"分享";
    self.view.backgroundColor=BackGroundColor;
    self.tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.view addSubview:self.tableView];
    _listArray=@[@{@"QQ":@"ico_qq.png"},@{@"短信":@"icon_msg.png"},@{@"微信":@"ico_weixin.png"}];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 63)];
    label.text=@"大师哥郑重提示: 请勿分享至qq群、微信群,以防您的取件信息外泄，造成快递丢失,且分享后,不能发布师哥代领任务!";
    label.numberOfLines=3;
    label.font=[UIFont systemFontOfSize:13.f];
    label.textColor=[UIColor redColor];
    [view addSubview:label];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString*cellIdentifier=@"cell";
    HXPackageCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[HXPackageCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) Style:HXStylePay];
    }
    NSDictionary*dic=[_listArray objectAtIndex:indexPath.row];
    NSString*key=[[dic allKeys] firstObject];
    cell.titleLab.text=key;
    cell.imgView.image=[UIImage imageNamed:[dic objectForKey:key]];
    cell.selImgView.hidden=YES;
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            //qq分享
            [self shareService:UMShareToQQ];
        };break;
        case 1:{
            //短信分享
            HXAdressBookListViewController*desVC=[[HXAdressBookListViewController alloc] init];
            desVC.express=_express;
            [self.navigationController pushViewController:desVC animated:YES];
        };break;
        case 2:{
            //朋友圈
            [self shareService:UMShareToWechatSession];
        };break;
        default:
            break;
    }
}

-(void)shareService:(NSString*)snsName{
//分享内容格式：快递单号后4位+快递名称+取件码
    [UMSocialData defaultData].extConfig.title=@"佰米大师哥,校园好帮手";
    NSString*subExpressNoStr=_express.expressNo;
    if(_express.expressNo.length>4){
        NSRange range=NSMakeRange(_express.expressNo.length-4, 4);
        subExpressNoStr=[_express.expressNo substringWithRange:range];
    }
    NSString*shareText=[NSString stringWithFormat:@"可以帮我取快递吗?尾号%@%@已存入%@",subExpressNoStr,_express.companyName,_express.location];
    if (_express.deliverCode.length){
        HXLoginUser*user=[NSUserDefaultsUtil getLoginUser];
        shareText=[NSString stringWithFormat:@"%@,手机号码:%@,取件码:%@",shareText,user.phoneNumber,_express.deliverCode];
    }
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[snsName] content:shareText image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity * response){
        NSLog(@"%@  %d",response,response.responseCode);
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
//            [alertView show];
//        } else if(response.responseCode != UMSResponseCodeCancel) {
//            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
//            [alertView show];
//        }
    }];
    //只要点过就当成已分享了，不等回调（因为如果用户选择留在QQ或留在微信就不会走回调）
    [self changeOrderShareStatusHttp];
}

//更改分享状态
-(void)changeOrderShareStatusHttp{
    HXLoginUser*user=[NSUserDefaultsUtil getLoginUser];
    NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,_express.orderId,[NSNumber numberWithInt:HXReceiveOrderShared],user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/receive/changeShareStatus" params:@{@"phoneNumber":user.phoneNumber,@"sKey":sKey,@"orderNo":_express.orderId,@"shareStatus":[NSNumber numberWithInt:HXReceiveOrderShared]} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            NSLog(@"%@",HXCodeString(error.code));
        }else{
            NSLog(@"修改单子状态为已分享");
            _express.shareStatus=HXReceiveOrderShared;
            [[NSNotificationCenter defaultCenter] postNotificationName:HXNTFReceiveOrderSharedRefresh object:_express];
        }
    }];
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
