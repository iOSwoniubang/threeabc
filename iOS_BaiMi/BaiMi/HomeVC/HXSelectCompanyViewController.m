//
//  HXSelectCompanyViewController.m
//  BaiMi
//
//  Created by licl on 16/7/11.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXSelectCompanyViewController.h"
#import "MJRefresh.h"
#import "HXCompany.h"
#import "HXPackageCell.h"

@interface HXSelectCompanyViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView*tableView;
@property(strong,nonatomic)NSMutableArray*companys;
@end

@implementation HXSelectCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"选择快递";
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_tableView];
    _companys=[NSMutableArray array];

    [self pullCompanysHttp];
    
    __unsafe_unretained UITableView*tableView=self.tableView;
    tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
         [self pullCompanysHttp];
    }];
        tableView.mj_header.automaticallyChangeAlpha = YES;
}

// 获取可选快递公司列表接口
-(void)pullCompanysHttp{
    [HXHttpUtils requestJsonPostWithUrlStr:@"/common/expressList" params:@{@"pointNo":@""} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
           _companys=[NSMutableArray array];
            NSDictionary*content=[resultJson objectForKey:@"content"];
            for(NSDictionary*dic in content){
                HXCompany*c =[HXCompany new];
                c.no=[dic objectForKey:@"no"];
                c.name=[dic objectForKey:@"name"];
                c.logoUrl=[dic objectForKey:@"logo"];
                c.isDefault=[[dic objectForKey:@"isDefault"] boolValue];
                [_companys addObject:c];
            }
        }
        [_tableView reloadData];
        [_tableView.mj_header endRefreshing];
    }];
}


#pragma mark --UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _companys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXCompany*company=[_companys objectAtIndex:indexPath.row];
    static NSString*cellIdentifier=@"cell";
    HXPackageCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[HXPackageCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) Style:HXStylePay];
    }
    cell.imgView.layer.cornerRadius=cell.imgView.frame.size.height/2;
    cell.imgView.clipsToBounds=YES;
    [cell.imgView setImageWithURL:[NSURL URLWithString:company.logoUrl] placeholderImage:HXDefaultImg];
    cell.titleLab.text=company.name;
    cell.selImgView.hidden=YES;
    if ([company.no isEqualToString:_originalCompany.no]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        _seleIndexPath=indexPath;
    }else
        cell.accessoryType=UITableViewCellAccessoryNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HXCompany*company=[_companys objectAtIndex:indexPath.row];
    int oldRow=_seleIndexPath?(int)_seleIndexPath.row:-1;
    int newRow=(int)indexPath.row;
    if (oldRow!=newRow) {
        UITableViewCell*oldSeleCell=[tableView cellForRowAtIndexPath:_seleIndexPath];
        UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
        oldSeleCell.accessoryType=UITableViewCellAccessoryNone;
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        _seleIndexPath=indexPath;
    }
    if ([_delegate respondsToSelector:@selector(selectCompanyVC:selectCompany:)]) {
        [_delegate selectCompanyVC:self selectCompany:company];
    }
    [self performSelector:@selector(popOut) withObject:nil afterDelay:0.3];
}

-(void)popOut{
    [self.navigationController popViewControllerAnimated:YES];
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
