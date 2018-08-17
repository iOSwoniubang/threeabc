//
//  HXChooseCityViewController.m
//  BaiMi
//
//  Created by HXMAC on 16/7/14.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXChooseCityViewController.h"
#import "HXCityHeadView.h"
@interface HXChooseCityViewController ()<UITableViewDataSource,UITableViewDelegate,HXCityHeadViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray  * _firstArray;
    NSMutableArray  * _secondArray;
    NSMutableArray  * _thirdArray;
    NSMutableArray  * _showData;//第二列数据源
    NSInteger         _selectedSection;//选中的section
    BOOL    _isSelected;
    NSIndexPath     * _selectedIndexPath;//选中的cell的indexpath
    BOOL    _isThreeShow;//判断是否展示第三列数据
    BOOL    _isSecondShow;//判断是否显示第三列数据
    NSMutableArray  * _showMoreData;//第三列数据源
}

@end

@implementation HXChooseCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _firstArray = [[NSMutableArray alloc]init];
    _secondArray = [[NSMutableArray alloc]init];
    _thirdArray = [[NSMutableArray alloc]init];
    _showData = [[NSMutableArray alloc]init];
    _showMoreData = [[NSMutableArray alloc]init];
    
    _selectedSection = 1000;
    _isSelected = NO;
    _isThreeShow = NO;
    _isSecondShow = NO;
    //数据源。这里是根据我自己写的plist数据源处理的数据。如果数据源不同，那么下面赋值的方法不同，根据自己的数据源更改
//    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CountryNumbers" ofType:@"plist"]];
//    NSDictionary  * dataSecondDict = [dataDict objectForKey:@"provinces"];
//    for (NSDictionary *mDict in dataSecondDict) {
//        [_firstArray addObject:mDict];
//        [_secondArray addObject:[(NSDictionary *)[dataSecondDict objectForKey:mDict] allKeys]];
//        [_thirdArray addObject:[(NSDictionary *)[dataSecondDict objectForKey:mDict] allValues]];
//    }
    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"]];
    _firstArray = (NSMutableArray *)[dataDict allKeys];
    for (NSString *str in _firstArray) {
        NSArray *MyArray = [dataDict objectForKey:str];
        NSMutableArray *secArray = [NSMutableArray array];
        NSMutableArray *thArray = [NSMutableArray array];
        for (NSDictionary *mDict in MyArray) {
            for (NSString *key in mDict) {
                [secArray addObject:key];
                [thArray addObject:[mDict objectForKey:key]];
            }
        }
        [_secondArray addObject:secArray];
        [_thirdArray addObject:thArray];
    }
    [self createTableView];
}
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource= self;
    
    [self.view addSubview:_tableView];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == _selectedSection && _showData != nil && _isSecondShow) {
        if (_isThreeShow == YES) {
            return [(NSArray *)_showMoreData count] + _showData.count;
        }
        else
            return _showData.count;
    }
    else
        return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdent = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //效果图中的缩进效果
    if (_isThreeShow) {
        if (indexPath.row > _selectedIndexPath.row && indexPath.row <= _selectedIndexPath.row +  [(NSArray *)_showMoreData count]) {
            
            cell.indentationLevel = 2;//缩进级别
            cell.indentationWidth = 20;//每个缩进级别的距离
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[(NSArray *)_showMoreData objectAtIndex:indexPath.row - _selectedIndexPath.row - 1]];
        }
        else if(indexPath.row <= _selectedIndexPath.row){
            cell.indentationLevel = 1; // 缩进级别
            cell.indentationWidth = 20.f; // 每个缩进级别的距离
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[_showData objectAtIndex:indexPath.row]];
        }
        else{
            cell.indentationLevel = 1; // 缩进级别
            cell.indentationWidth = 20.f; // 每个缩进级别的距离
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[_showData objectAtIndex:indexPath.row - [(NSArray *)_showMoreData count]]];
        }
    }
    
    else{
        cell.indentationLevel = 1; // 缩进级别
        cell.indentationWidth = 20.f; // 每个缩进级别的距离
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[_showData objectAtIndex:indexPath.row]];
    }
    
    return cell;
    
}
- (void)backRoot:(NSArray *)array{
//    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(goBack:)]) {
//        [self.delegate performSelector:@selector(goBack:) withObject:array];
//    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _selectedSection = indexPath.section;
    //当选中第三级列表数据时开始读取选中的数据进行下面的操作
    if (indexPath.row > _selectedIndexPath.row && indexPath.row <= _selectedIndexPath.row +  [(NSArray *)_showMoreData count]) {
        
//        NSLog(@"%@,%@,{%@,%@}",[_firstArray objectAtIndex:_selectedSection],[_showData objectAtIndex:_selectedIndexPath.row],[(NSArray *)_showMoreData objectAtIndex:indexPath.row - _selectedIndexPath.row - 1],[(NSArray *)[(NSDictionary *)_showMoreData allValues] objectAtIndex:indexPath.row - _selectedIndexPath.row - 1]);
        
        [self backRoot:[NSArray arrayWithObjects:[_firstArray objectAtIndex:_selectedSection],[_showData objectAtIndex:_selectedIndexPath.row],[(NSArray *)_showMoreData objectAtIndex:indexPath.row - _selectedIndexPath.row - 1], nil]];
        
        return;
    }
    //选中的是二级列表时，判断是否选中的是上次选中的cell。这里就是为什么要在选择section时对_selectedIndexPath进行初始化
    if (_selectedIndexPath == indexPath && _selectedSection == indexPath.section) {
        _isThreeShow = !_isThreeShow;
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:_selectedSection] withRowAnimation:UITableViewRowAnimationFade];
    }
    else{
        _isSecondShow = YES;
        //是否展示过三级列表，如果展示过就把上次展示的三级列表关掉。这里我选的是reloadsections：方法，你也可以选其他方法试试
        if (_isThreeShow) {
            _isThreeShow = NO;
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:_selectedSection] withRowAnimation:UITableViewRowAnimationFade];
        }
        if (_selectedSection == indexPath.section) {
            //赋值这一部分，分成两部分。画图就知道了，当我们把上次展示的三级列表关掉的时候，_selectedIndexPath下面的部分的row都会－三级列表数据个数，所以必须这么做
            if (_selectedIndexPath.row >= indexPath.row) {
                _selectedIndexPath = indexPath;
                _showMoreData = [[_thirdArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            }
            else{
                _selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row - [(NSArray *)_showMoreData count] inSection:indexPath.section];
                _showMoreData = [[_thirdArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row - [(NSArray *)_showMoreData count]];
            }
            _isThreeShow = YES;
            NSMutableArray *indexPathArray = [NSMutableArray array];
            for (int i = 1; i <= [(NSArray *)_showMoreData count]; i ++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(i + _selectedIndexPath.row) inSection:_selectedSection];
                [indexPathArray addObject:indexPath];
            }
            [_tableView beginUpdates];
            [_tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
            [_tableView endUpdates];
        }
        else{
            NSLog(@"不同的section");
        }
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消cell选中之后的效果
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _firstArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //可以根据自己的需要
    HXCityHeadView *headView = [[HXCityHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40) andTag:section];
    headView.delegate = self;
    headView.headLabel.text = [NSString stringWithFormat:@"%@",[_firstArray objectAtIndex:section]];
    headView.headLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.f];
    headView.headLabel.backgroundColor = [UIColor clearColor];
    return headView;
}
//显示section中的内容
- (void)showFirstListCell:(UITapGestureRecognizer *)tap{
    //只要点击了section，必须将_selectedIndexPath重置
    _selectedIndexPath = [NSIndexPath indexPathForRow:1000 inSection:1000];
    
    if ((_selectedSection == tap.view.tag - 10000 && _isSecondShow)) {
        _isSecondShow = !_isSecondShow;
        _showData = nil;
        _isSecondShow = NO;
        _isSelected = NO;
        _isThreeShow = NO;
        //这里不可采用delected方法  不然会造成崩溃。因为section删除最后一个元素时会自动将该section删除
        //采用这个方法后注意section的headview
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:_selectedSection] withRowAnimation:UITableViewRowAnimationFade];
    }
    else{
        if (_isSelected) {
            //如果开始选择，第一次不需要执行。再次点击其他的section时，将上一次展开的section关掉
            _showData = nil;
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:_selectedSection] withRowAnimation:UITableViewRowAnimationFade];
        }
        _isSecondShow = YES;
        _isSelected = YES;
        _isThreeShow = NO;
        _selectedSection = tap.view.tag - 10000;
        //提取分区的数据源
        _showData = [_secondArray objectAtIndex:tap.view.tag - 10000];
        NSMutableArray *indexPathArray = [NSMutableArray array];
        for (int i = 0; i < _showData.count; i ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:_selectedSection];
            [indexPathArray addObject:indexPath];
        }
        //采用- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;插入数据。
        [_tableView beginUpdates];
        [_tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
        [_tableView endUpdates];
    }
    
}
//关闭滑动删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
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
