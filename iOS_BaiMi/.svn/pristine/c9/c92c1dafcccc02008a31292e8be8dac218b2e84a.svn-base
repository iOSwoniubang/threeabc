//
//  HXHelpOrticklingViewController.m
//  BaiMi
//
//  Created by HXMAC on 16/7/11.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXHelpOrticklingViewController.h"
#import "HXAgreementViewController.h"
#import "HXFeedbackViewController.h"
@interface HXHelpOrticklingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_myTableView;
    NSArray * _titleArray;
}
@end

@implementation HXHelpOrticklingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"帮助与反馈";
    self.view.backgroundColor = BackGroundColor;
    _titleArray = [NSArray arrayWithObjects:@"功能介绍",@"意见反馈",@"隐私说明", nil];
    [self createUI];
}
- (void)createUI{
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    [self.view addSubview:_myTableView];
    UIView *footView =[[ UIView alloc]initWithFrame:CGRectZero];
    [_myTableView setTableFooterView:footView];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44
    ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIde = @"cellIdentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
//        HXSubtoolViewController *subTool = [[HXSubtoolViewController alloc]init];
//        subTool.type = 1;
//        [self.navigationController pushViewController:subTool animated:YES];
        
        HXAgreementViewController*desVC=[[HXAgreementViewController alloc] init];
        desVC.agreementType=HXAgreementTypeIntroduction;
        [self.navigationController pushViewController:desVC animated:YES];
    }
    else if (indexPath.row == 1){
        HXFeedbackViewController *feedBack = [[HXFeedbackViewController alloc]init];
        [self.navigationController pushViewController:feedBack animated:YES];
    }
    else if (indexPath.row == 2){
//        HXAdvertisingViewController *advertising = [[HXAdvertisingViewController alloc]init];
//        advertising.type = 2;
//        [self.navigationController pushViewController:advertising animated:YES];
        
        HXAgreementViewController*desVC=[[HXAgreementViewController alloc] init];
        desVC.agreementType=HXAgreementTypePrivacy;
        [self.navigationController pushViewController:desVC animated:YES];
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
