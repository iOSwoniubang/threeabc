//
//  HXConsumeListViewController.m
//  BaiMi
//
//  Created by licl on 16/7/6.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXConsumeListViewController.h"
#import "HXConsume.h"
#import "HXConsumeCell.h"
#import "MJRefresh.h"

@interface HXConsumeListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView*tableView;
@property(strong,nonatomic)UIView*noneView;
@property(strong,nonatomic)NSMutableArray*listArray;
@property(assign,nonatomic)int currentPage;
@property(assign,nonatomic)BOOL hasMore;
@end

@implementation HXConsumeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=BackGroundColor;
    self.title=@"消费记录";
    [self createUI];
    _listArray=[NSMutableArray array];
    _currentPage=0;
    _hasMore=YES;
    [self pullConsumListHttp];
    [self refreshDeal];
}



-(void)refreshDeal{
    //下拉刷新
    __unsafe_unretained UITableView*tableView=self.tableView;
    tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage=0;
        _hasMore=YES;
        [self pullConsumListHttp];
    }];
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉加载更多
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (_hasMore) {
            _currentPage++;
            [self pullConsumListHttp];
        }else
            [self.tableView.mj_footer endRefreshing];
     
    }];
    
}

-(void)createUI{
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.view addSubview:self.tableView];
    
    _noneView=[[UIView alloc] initWithFrame:self.tableView.frame];
    _noneView.backgroundColor=[UIColor whiteColor];
    UIImageView*emptyImgView=[[UIImageView alloc] initWithFrame:CGRectMake(_noneView.frame.size.width/2-150/2,_noneView.frame.size.height*0.2 , 150, 150)];
    emptyImgView.image=[UIImage imageNamed:@"empty.png"];
    [_noneView addSubview:emptyImgView];
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(30, ViewFrameY_H(emptyImgView)+20, _noneView.frame.size.width-60, 42)];
    label.numberOfLines=2;
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:16.f];
    label.textColor=[UIColor darkGrayColor];
    label.text=@"你来到了一片荒芜之地，空空如也，什么都没有，实在太冷清了~(>_<)~";
    [_noneView addSubview:label];
    [self.view addSubview:_noneView];
    
    self.tableView.hidden=YES;
    _noneView.hidden=YES;
}

-(void)updateUI:(BOOL)hasData{
    if (hasData) {
        self.tableView.hidden=NO;
        _noneView.hidden=YES;
    }else{
        self.tableView.hidden=YES;
        _noneView.hidden=NO;
    }
}



//使用过的智能服务列表
-(void)pullConsumListHttp{
    HXLoginUser*user=[NSUserDefaultsUtil getLoginUser];
    NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,[NSNumber numberWithInt:_currentPage],user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/intelligent/orderList" params:@{@"phoneNumber":user.phoneNumber,@"sKey":sKey,@"currentPage":[NSNumber numberWithInt:_currentPage]} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            NSArray*content=[resultJson objectForKey:@"content"];
            NSMutableArray*array=[NSMutableArray array];
            for(NSDictionary*dic in content){
                HXConsume*consume=[HXConsume new];
                consume.orderId=[dic objectForKey:@"orderNo"];
                consume.machineName=[dic objectForKey:@"machineName"];
                consume.pointName=[dic objectForKey:@"pointName"];
                consume.position=[dic objectForKey:@"position"];
                consume.createTime=[NSDate dateWithTimeInMsSince1970:[[dic objectForKey:@"createTime"] longLongValue]];
                consume.feeStr=[dic objectForKey:@"fee"];
                consume.type=[[dic objectForKey:@"type"] intValue];
                consume.packageName=[dic objectForKey:@"packageName"];
                consume.sn=[dic objectForKey:@"sn"];
                consume.sign=[dic objectForKey:@"sign"];
                consume.pulse=[[dic objectForKey:@"pulse"] intValue];
                consume.activeCode=[HXHttpUtils whetherNil:[dic objectForKey:@"cdk"]];
                [array addObject:consume];
            }
            if (_currentPage==0)
                _listArray=[array mutableCopy];
            else
                [_listArray addObjectsFromArray:array];
            
            if (array.count)
                _hasMore=YES;
            else
                _hasMore=NO;
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self updateUI:_listArray.count>0?YES:NO];
    }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (SCREEN_HEIGHT==iPhone4)
        return 93;
    return 72;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXConsume*consume=[_listArray objectAtIndex:indexPath.row];
    static NSString*cellIdentifier=@"cell";
    HXConsumeCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[HXConsumeCell alloc]init];
    }
   
    cell.packageNameLab.text=consume.packageName;
    cell.positionLab.text=consume.position;
    cell.timeLab.text=[consume.createTime toStringByChineseDateLine];
    NSString*str=[NSString stringWithFormat:@"%@元",consume.feeStr];
    NSMutableAttributedString*atr=[[NSMutableAttributedString alloc] initWithString:str];
    NSRange range=[str rangeOfString:@"元"];
    [atr addAttributes:@{NSForegroundColorAttributeName:LightBlueColor,NSFontAttributeName:[UIFont systemFontOfSize:20.f]}  range:NSMakeRange(0,range.location)];
    cell.feeLab.attributedText=atr;
    if (consume.activeCode.length)
        cell.noLab.text=consume.activeCode;
    else
        cell.noLab.hidden=YES;
    
//    cell.noLab.userInteractionEnabled=YES;
//    UITapGestureRecognizer*tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activityCodeGesture:)];
//    [cell.noLab addGestureRecognizer:tapGesture];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}



//-(void)activityCodeGesture:(UITapGestureRecognizer*)gesture{
//    CGPoint point=[gesture locationInView:self.tableView];
//    NSIndexPath *indexpath=[self.tableView indexPathForRowAtPoint:point];
//    [self getActivityCodeHttp:indexpath];
//}

//-(void)getActivityCodeHttp:(NSIndexPath*)indexPath{
//    HXConsume*consume=[_listArray objectAtIndex:indexPath.row];
//    [HXLoadingImageView showLoadingView:self.view];
//    HXLoginUser*user=[NSUserDefaultsUtil getLoginUser];
//    NSDictionary*params=@{@"sign":consume.sign,@"sn":consume.sn,@"currency":[NSNumber numberWithInt:consume.pulse],@"interfacetype":@"2",@"username":user.nickName,@"sex":@"男",@"mobile":user.phoneNumber,@"birthdays":@"1987-09-02",@"openid":@"",@"partner_trade_no":consume.orderId};
//    NSLog(@"paramms:%@",params);
//    [HXHttpUtils requestJsonPostOfActiveCodeApiwithParams:params onComplete:^(NSString *errorReason, NSDictionary *resultJson) {
//        [HXLoadingImageView hideViewForView:self.view];
//        if (errorReason.length) {
//            NSLog(@"激活码报错:%@",errorReason);
//            [HXAlertViewEx showInTitle:nil Message:@"激活码获取失败,请稍后重试" ViewController:self];
//        }else{
//            //激活码
//            NSString*activateCode=[resultJson objectForKey:@"result"];
//            consume.activeCode=activateCode;
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        }
//    }];
//}


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
