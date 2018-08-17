//
//  HXGetAreaViewController.m
//  BaiMi
//
//  Created by HXMAC on 16/7/19.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXGetAreaViewController.h"

@interface HXGetAreaViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}
@end

@implementation HXGetAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BackGroundColor;
    _dataArray = [NSMutableArray array];
    [self createTableView];
    [self loadData];
}
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}
- (void)loadData{
    if (_type == HXSearchTypeArea) {
        [HXHttpUtils requestJsonPostWithUrlStr:@"/common/dormitoryAreaList" params:@{@"collegeNo":_searchNum} onComplete:^(NSError *error, NSDictionary *resultJson) {
            if (error) {
                [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
            }
            else{
                _dataArray = [resultJson objectForKey:@"content"];
            }
            [_tableView reloadData];
        }];
    }else{
        [HXHttpUtils requestJsonPostWithUrlStr:@"/common/dormitoryHouseList" params:@{@"areaNo":_searchNum} onComplete:^(NSError *error, NSDictionary *resultJson) {
            if (error) {
                [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
            }
            else{
                _dataArray = [resultJson objectForKey:@"content"];
            }
            [_tableView reloadData];
        }];

      }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIde = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell == nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"name"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    if (_type == HXSearchTypeArea) {
        HXGetAreaViewController *getArea = [[HXGetAreaViewController alloc]init];
        getArea.searchNum = [dict objectForKey:@"no"];
        getArea.type = HXSearchTypeDormitory;
        [_sourceArray addObject:dict];
        getArea.sourceArray = _sourceArray;
        [self.navigationController pushViewController:getArea animated:YES];
    }else{
        [_sourceArray addObject:dict];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_SCHOOL" object:_sourceArray];
        NSArray *viewArrays = self.navigationController.viewControllers;
        UIViewController *viewController = [viewArrays objectAtIndex:1];
        [self.navigationController popToViewController:viewController animated:YES];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"GET_Dormitory" object:dict];
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
