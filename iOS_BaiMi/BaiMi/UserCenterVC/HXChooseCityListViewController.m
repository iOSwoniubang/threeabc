//
//  HXChooseCityListViewController.m
//  BaiMi
//
//  Created by HXMAC on 16/7/22.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXChooseCityListViewController.h"
#import "HXNewAddressViewController.h"
@interface HXChooseCityListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArray;
    UITableView *_myTableView;
}
@end

@implementation HXChooseCityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择地区";
    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"]];
    NSMutableArray *firstArray = [[dataDict allKeys] mutableCopy];
    NSMutableArray *secondArray = [NSMutableArray array];
    NSMutableArray *thirdArray = [NSMutableArray array];
    for (NSString *str in firstArray) {
        NSArray *MyArray = [dataDict objectForKey:str];
        NSMutableArray *secArray = [NSMutableArray array];
        NSMutableArray *thArray = [NSMutableArray array];
        for (NSDictionary *mDict in MyArray) {
            for (NSString *key in mDict) {
                [secArray addObject:key];
                [thArray addObject:[mDict objectForKey:key]];
            }
        }
        [secondArray addObject:secArray];
        [thirdArray addObject:thArray];
    }
    if (_chooseType == 1) {
        _dataArray = firstArray;
    }else if (_chooseType == 2){
        _dataArray = [secondArray objectAtIndex:[[_chooseIndexArray objectAtIndex:0] intValue]];
    }else if (_chooseType == 3){
        _dataArray = [[thirdArray objectAtIndex:[[_chooseIndexArray objectAtIndex:0] intValue]] objectAtIndex:[[_chooseIndexArray objectAtIndex:1] intValue]];
    }
    [self createTableView];
}
- (void)createTableView{
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    _myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIde = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_chooseType == 1) {
        HXChooseCityListViewController *cityList = [[HXChooseCityListViewController alloc]init];
        cityList.chooseType = 2;
        if (_resultArray) {
            [_resultArray replaceObjectAtIndex:0 withObject:[_dataArray objectAtIndex:indexPath.row]];
        }else
        cityList.resultArray = [NSMutableArray arrayWithObjects:[_dataArray objectAtIndex:indexPath.row], nil];
        cityList.chooseIndexArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",(int)indexPath.row], nil];
        cityList.delegate = _delegate;
        [self.navigationController pushViewController:cityList animated:YES];
    }else if (_chooseType == 2){
        HXChooseCityListViewController *cityList = [[HXChooseCityListViewController alloc]init];
        cityList.chooseType = 3;
        if (_resultArray.count >= 2) {
        [_resultArray replaceObjectAtIndex:1 withObject:[_dataArray objectAtIndex:indexPath.row]];
        }else
            [_resultArray addObject:[_dataArray objectAtIndex:indexPath.row]];
        cityList.resultArray = [NSMutableArray arrayWithArray:_resultArray];
        cityList.delegate = _delegate;
        cityList.chooseIndexArray = [NSArray arrayWithObjects:[_chooseIndexArray objectAtIndex:0],[NSString stringWithFormat:@"%d",(int)indexPath.row], nil];
        [self.navigationController pushViewController:cityList animated:YES];

    }else if (_chooseType == 3){
        if (_resultArray.count >= 3) {
        [_resultArray replaceObjectAtIndex:2 withObject:[_dataArray objectAtIndex:indexPath.row]];
        }
        else
         [_resultArray addObject:[_dataArray objectAtIndex:indexPath.row]];
        
        if ([self.delegate respondsToSelector:@selector(goBack:)]) {
            [self.delegate goBack:_resultArray];
            [self.navigationController popToViewController:(UIViewController *)self.delegate animated:YES];
        }
       
        return;
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
