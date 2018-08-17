//
//  HXExpressDetailViewController.m
//  BaiMi
//
//  Created by licl on 16/7/12.
//  Copyright © 2016年 licl. All rights reserved.
//
#import "HXExpressDetailViewController.h"
#import "HXLogisticTraceCell.h"
#import "MJRefresh.h"
#import "AFNetworking.h"

@interface HXExpressDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView*tableView;
@end

@implementation HXExpressDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=@"快件详情";
    [self createUI];
    if(!_hasTrace)
    [self pullTracesHttp];
    
    __unsafe_unretained UITableView*tableView=self.tableView;
    tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
      [self pullTracesHttp];
    }];
    tableView.mj_header.automaticallyChangeAlpha = YES;

}


-(void)createUI{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,SCREEN_HEIGHT-64)style:UITableViewStyleGrouped];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor=[UIColor whiteColor];
}

-(void)pullTracesHttp{
    [HXHttpUtils requestJsonPostOfKdniaoTrackQueryAPIWithShipperCode:_express.companyNo LogisticCode:_express.expressNo onComplete:^(NSString *errorReason, NSDictionary *resultJson) {
        if (errorReason) {
            [HXAlertViewEx showInTitle:nil Message:errorReason ViewController:self];
        }else{
            NSArray*traces=[resultJson objectForKey:@"Traces"];
            _express.traceArray=[NSMutableArray array];
            for(NSDictionary*dic in traces){
                HXLogisticTrace*trace=[HXLogisticTrace new];
                trace.acceptStation=[dic objectForKey:@"AcceptStation"];
                trace.acceptTimeStr=[dic objectForKey:@"AcceptTime"];
                [_express.traceArray addObject:trace];
            }
            _express.traceArray=[[[_express.traceArray reverseObjectEnumerator] allObjects] mutableCopy];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}


#pragma mark--UITableViewDataSource & UITableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190)];
    UIImageView*headImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    headImgView.image=[UIImage imageNamed:@"bg_wuliu.png"];
    [bgView addSubview:headImgView];
    UIImageView*logoImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, headImgView.frame.size.height/2-60/2, 60, 60)];
    logoImgView.layer.cornerRadius=logoImgView.frame.size.width/2;
    logoImgView.clipsToBounds=YES;
    [logoImgView setImageWithURL:[NSURL URLWithString:_express.companyLogoUrl] placeholderImage:HXDefaultImg];
    [headImgView addSubview:logoImgView];
    UILabel*titleLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(logoImgView)+10,headImgView.frame.size.height/2-10, headImgView.frame.size.width-10*2-logoImgView.frame.size.width, 21)];
    titleLab.text=[NSString stringWithFormat:@"%@: %@",_express.companyName,_express.expressNo];
    titleLab.font=[UIFont systemFontOfSize:17.f];
    titleLab.textColor=[UIColor whiteColor];
    [headImgView addSubview:titleLab];
    
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(10, ViewFrameY_H(headImgView)+15, 100, 21)];
    label.text=@"物流信息";
    label.font=[UIFont systemFontOfSize:17.f];
    [bgView addSubview:label];
    UIView*line=[[UIView alloc] initWithFrame:CGRectMake(0, ViewFrameY_H(label)+5, bgView.frame.size.width, 1)];
    line.backgroundColor=BolderColor;
    [bgView addSubview:line];
    return bgView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 190;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_express.traceArray.count==0)
       return 1;
    else
       return _express.traceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_express.traceArray.count==0)
    return 77;
    else{
        HXLogisticTrace*trace=[_express.traceArray objectAtIndex:indexPath.row];
        int width=self.tableView.frame.size.width-20;
        int height=  STRING_SIZE_FONT(width,trace.acceptStation,14).height+21+20;
        return height;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXLogisticTrace*trace=nil;
    if (_express.traceArray.count==0) {
        trace=[HXLogisticTrace new];
        trace.acceptStation=@"暂无";
    }else
    trace= [_express.traceArray objectAtIndex:indexPath.row];
    static NSString*cellIdentifier=@"cell";
    HXLogisticTraceCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[HXLogisticTraceCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width,77) Trace:trace];
    }
    CGRect lineRect=cell.volumnline.frame;
    if (_express.traceArray.count==0){
         cell.stationLab.textColor=LightBlueColor;
        CGRect rect=cell.stationLab.frame;
        rect.origin.y=cell.frame.size.height/2-21/2;
        cell.stationLab.frame=rect;
    }else{
        if (indexPath.row==0){
            lineRect.origin.y=cell.frame.size.height/2;
            lineRect.size.height=cell.frame.size.height/2;
            cell.stationLab.textColor=LightBlueColor;
            cell.timeLab.textColor=LightBlueColor;
        }else if (indexPath.row==_express.traceArray.count-1)
        lineRect.size.height=cell.frame.size.height/2;
        cell.volumnline.frame=lineRect;
        cell.timeLab.text=trace.acceptTimeStr;
    }
    cell.stationLab.text=trace.acceptStation;
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
