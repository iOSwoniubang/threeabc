//
//  HXSGEvaluationViewController.m
//  BaiMi
//
//  Created by 王放 on 16/7/9.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXSGEvaluationViewController.h"
#import "HXSGEvaluationCell.h"
#import "MJRefresh.h"
#import "HXSGEvaluation.h"
@interface HXSGEvaluationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *table;
@property(strong,nonatomic)NSMutableArray *arrayList;
@property(assign,nonatomic)int currentPage;
@property(strong,nonatomic)UIImageView *iconImageView;
@property(strong,nonatomic)UILabel *nickNameLabel;
@property(strong,nonatomic)UILabel *phoneNumberLabel;
@property(strong,nonatomic)UILabel *topLabel;
@property(strong,nonatomic)UILabel *stepLabel;
@property(strong,nonatomic)HXLoginUser *user;
@property(strong,nonatomic)UIImageView *topImageView;
@property(strong,nonatomic)UIImageView *stepImageView;
@end

@implementation HXSGEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableUI];
    [self httpService];
    // Do any additional setup after loading the view.
}
-(void)createTableUI{
    self.title = @"师哥评价";
    self.view.backgroundColor = BackGroundColor;
    _user = [NSUserDefaultsUtil getLoginUser];
    _arrayList = [[NSMutableArray alloc] init];
    _currentPage = 0;
    UIView *viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    viewHead.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewHead];
    _iconImageView = [[UIImageView alloc]init];
    _iconImageView.frame = CGRectMake(10, 10, 60, 60);
    _iconImageView.clipsToBounds = YES;
    _iconImageView.layer.cornerRadius = (80 - 10*2) / 2.0;
    [_iconImageView setImageWithURL:[NSURL URLWithString:_user.logoUrl] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
//    _iconImageView.image = [UIImage imageNamed:@"defaultImg"];
    [viewHead addSubview:_iconImageView];
    _nickNameLabel = [[UILabel alloc] init];
    _nickNameLabel.frame = CGRectMake(20 + 80 - 10*2, 10, 150, 80/4.0);
    _nickNameLabel.text  = _user.nickName;
    _nickNameLabel.font = [UIFont systemFontOfSize:16.];
    [viewHead addSubview:_nickNameLabel];
    
    _phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + 80 - 10*2, 10 + (80 - 10*2)/2.0, 150, (80 - 10*2)/2.0)];
    _phoneNumberLabel.text = _user.phoneNumber;
    _phoneNumberLabel.font = [UIFont systemFontOfSize:14.];
    [viewHead addSubview:_phoneNumberLabel];
    
    NSString *stepTitle = [NSString stringWithFormat:@"%lld",_user.despiseCount];
    float stepLength = STRING_SIZE_FONT(200, stepTitle, 12.).width;
    _stepLabel = [[UILabel alloc] init];
    _stepLabel.textColor = RGBA(100, 148, 169, 1);
    _stepLabel.textAlignment = NSTextAlignmentCenter;
    _stepLabel.frame = CGRectMake(SCREEN_WIDTH - (stepLength+10), 0, stepLength+10, 80);
    _stepLabel.text = stepTitle;
    _stepLabel.font = [UIFont systemFontOfSize:12.];
    [viewHead addSubview:_stepLabel];
    _stepImageView = [[UIImageView alloc]init];
    _stepImageView.frame = CGRectMake(ViewFrame_X(_stepLabel) - 25, (80 - (80 / 4.0))/2.0 - 2.5, 25, 25);
    _stepImageView.image = [UIImage imageNamed:@"ico_cai"];
    [viewHead addSubview:_stepImageView];
    
    NSString *topTitle = [NSString stringWithFormat:@"%lld",_user.praiseCount];
    float topLength = STRING_SIZE_FONT(200, topTitle, 12.).width;
    _topLabel = [[UILabel alloc] init];
    _topLabel.textAlignment = NSTextAlignmentCenter;
    _topLabel.textColor = RGBA(235, 102, 102, 1);
    _topLabel.frame = CGRectMake(ViewFrame_X(_stepImageView)-(topLength+10), 0, topLength+10, 80);
    _topLabel.text = topTitle;
    _topLabel.font = [UIFont systemFontOfSize:12.];
    [viewHead addSubview:_topLabel];
   _topImageView = [[UIImageView alloc]init];
    _topImageView.frame = CGRectMake(ViewFrame_X(_topLabel)-25, (80 - (80 / 4.0))/2.0 - 2.5, 25, 25);
    _topImageView.image = [UIImage imageNamed:@"ico_zan"];
    [viewHead addSubview:_topImageView];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, ViewFrame_H(viewHead)+10, SCREEN_WIDTH, SCREEN_HEIGHT-64 - ViewFrame_H(viewHead) - 10) style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.dataSource = self;
    _table.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_table];
    [self refreshDeal];
}
-(void)refreshDeal{
    //下拉刷新
    __unsafe_unretained UITableView*tableView=self.table;
    tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 0;
        [self httpService];
    }];
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉加载更多
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _currentPage++;
        [self httpService];
    }];
}
-(void)httpService{
    NSString*skey=[HXNSStringUtil getSkeyByParamInfo:@[_user.phoneNumber,[NSNumber numberWithInt:_currentPage],_user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/appraiseList" params:@{@"phoneNumber":_user.phoneNumber,@"sKey":skey,@"currentPage":[NSNumber numberWithInt:_currentPage]} onComplete:^(NSError *error, NSDictionary *resultJson) {
        NSLog(@"师哥评价 %@",resultJson);
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            if (_currentPage == 0) {
                [_arrayList removeAllObjects];
            }
            NSDictionary *dicResult = [resultJson objectForKey:@"content"];
            NSString *stepTitle = [NSString stringWithFormat:@"%@",[dicResult objectForKey:@"despiseCount"]];
            float stepLength = STRING_SIZE_FONT(200, stepTitle, 12.).width;
            _stepLabel.frame = CGRectMake(SCREEN_WIDTH - (stepLength+10), 0, stepLength+10, 80);
            _stepLabel.text = stepTitle;
            _stepImageView.frame = CGRectMake(ViewFrame_X(_stepLabel) - 25, (80 - (80 / 4.0))/2.0 - 2.5, 25, 25);
            
            NSString *topTitle = [NSString stringWithFormat:@"%@",[dicResult objectForKey:@"praiseCount"]];
            float topLength = STRING_SIZE_FONT(200, topTitle, 12.).width;
            _topLabel.frame = CGRectMake(ViewFrame_X(_stepImageView)-(topLength+10), 0, topLength+10, 80);
            _topLabel.text = topTitle;
            _topImageView.frame = CGRectMake(ViewFrame_X(_topLabel)-25, (80 - (80 / 4.0))/2.0 - 2.5, 25, 25);
            
            
            NSArray *arrayOrder = [[resultJson objectForKey:@"content"] objectForKey:@"list"];
            for (int i = 0; i<arrayOrder.count; i++) {
                NSDictionary *dicResult = [arrayOrder objectAtIndex:i];
                HXSGEvaluation *oneEv = [[HXSGEvaluation alloc] init];
                oneEv.appraiserLogo = [HXHttpUtils whetherNil:[dicResult objectForKey:@"appraiserLogo"]];
                oneEv.appraiserNickName = [HXHttpUtils whetherNil:[dicResult objectForKey:@"appraiserNickName"]];
                oneEv.acceptTime = [[HXHttpUtils whetherNil:[dicResult objectForKey:@"acceptTime"]] isEqualToString:@""]?nil:[NSDate dateWithTimeInMsSince1970:[[dicResult objectForKey:@"acceptTime"]  longLongValue]];
                oneEv.appraiseStatus = [[HXHttpUtils whetherNil:[dicResult objectForKey:@"appraiseStatus"]] intValue];
                [_arrayList addObject:oneEv];
                
            }
            [_table reloadData];
        }
        [_table.mj_header endRefreshing];
        [_table.mj_footer endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayList.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *strCell = @"cell";
    HXSGEvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell){
        cell = [[HXSGEvaluationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    HXSGEvaluation *oneEv = [_arrayList objectAtIndex:indexPath.row];
    cell.evaluationTimeLabel.text = [oneEv.acceptTime toStringByChineseDateTimeLine];
//    cell.remarkLabel.text = oneEv.acceptTime;
    
    if (oneEv.appraiseStatus == 3) {
        cell.topImageView.image = [UIImage imageNamed:@"ico_cai"];
    }else
        cell.stepImageView.image = [UIImage imageNamed:@"ico_zan"];
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:oneEv.appraiserLogo] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    cell.sGNameLabel.text = oneEv.appraiserNickName;;
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return .1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
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
