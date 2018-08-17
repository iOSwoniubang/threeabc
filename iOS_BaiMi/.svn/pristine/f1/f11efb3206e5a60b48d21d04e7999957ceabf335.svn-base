

//
//  HXNewAddressViewController.m
//  BaiMi
//
//  Created by HXMAC on 16/7/11.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXNewAddressViewController.h"
#import "Masonry.h"
#import "HXNewAddressCell.h"
#import "HXChooseCityViewController.h"
#import "HXChooseCityListViewController.h"
#import "HXNumberTextField.h"

@class HXMoreAddressViewController;
@interface HXNewAddressViewController ()<UITableViewDelegate,UITableViewDataSource,GOBACKDelegate,UITextFieldDelegate>
{
    NSArray *titleArray;
    NSMutableArray *placehoderArray;
    NSMutableArray *compArray;
    UITextField * _textFiled;
    BOOL _locked; //避免请求期间重复多次点击
    
}
@property (strong,nonatomic)UITableView *listTableView;

@end

@implementation HXNewAddressViewController
- (void)viewWillAppear:(BOOL)animated{
    _locked=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.newAddressType == NEWADD) {
        self.title = @"新增地址";
        
        placehoderArray = [NSMutableArray arrayWithObjects:@[@"请填写姓名",@"请填写联系电话"],@[@"点击选择",@"例如中山路889号"], nil];
        compArray = [NSMutableArray array];

    }else{
        self.title = @"修改地址";
        placehoderArray = [NSMutableArray arrayWithObjects:@[_model.hunamName,_model.contactNumber],@[[NSString stringWithFormat:@"%@ %@ %@",_model.province,_model.city,_model.area],_model.address], nil];
        compArray = [NSMutableArray arrayWithObjects:_model.province,_model.city,_model.area, nil];

    }
    
    self.view.backgroundColor = BackGroundColor;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 50, 30);
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rBar = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rBar ;
    titleArray = [NSArray arrayWithObjects:@[@"姓名:",@"电话:"],@[@"选择省市区:",@"详细地址:"], nil];
    
    [self createUI];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe];
}
- (void)hideKeyBoard{
    [_textFiled resignFirstResponder];
}

- (void)save{
    [_textFiled resignFirstResponder];
    NSLog(@"保存");
    NSArray *subArray1 = [placehoderArray objectAtIndex:0];
    NSArray *subArray2 = [placehoderArray objectAtIndex:1];
    NSString *nameString = [subArray1 objectAtIndex:0];
    NSString *phone = [subArray1 objectAtIndex:1];
    NSString *address = [subArray2 objectAtIndex:0];
    NSString *detailAddress = [subArray2 objectAtIndex:1];
    if ([nameString isEqualToString:@""] || [nameString isEqualToString:@"请填写姓名"]) {
        [HXAlertViewEx showInTitle:nil Message:@"请填写姓名" ViewController:self];
        return;
    }
    if ([phone isEqualToString:@""] || [phone isEqualToString:@"请填写联系电话"]) {
        [HXAlertViewEx showInTitle:nil Message:@"请填写联系电话" ViewController:self];
        return;
    }
    
    if ((![HXNSStringUtil isMobilePhoneNumber:phone])&& (![HXNSStringUtil isZPhoneNumber:phone])) {
        [HXAlertViewEx showInTitle:nil Message:@"电话格式不正确" ViewController:self];
        return;
    }
    if (!address.length || [address isEqualToString:@"点击选择"]) {
        [HXAlertViewEx showInTitle:nil Message:@"请选择省市区" ViewController:self];
        return;
    }
    if (!detailAddress.length || [detailAddress isEqualToString:@"例如中山路889号"]) {
        [HXAlertViewEx showInTitle:nil Message:@"请填写详细地址" ViewController:self];
        return;
    }
    if (!_locked)
        [self saveHttpByName:nameString Phone:phone DetailAddress:detailAddress];
}

-(void)saveHttpByName:(NSString*)nameString Phone:(NSString*)phone DetailAddress:(NSString*)detailAddress {
    _locked=YES;
    [HXLoadingImageView showLoadingView:self.view];
    HXLoginUser *user = [NSUserDefaultsUtil getLoginUser];
    NSString*province=[compArray objectAtIndex:0];
    NSString*city=[compArray objectAtIndex:1];
    NSString*area=[compArray objectAtIndex:2];
    //新增地址
    if (self.newAddressType == NEWADD) {
        NSString*skey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,phone,user.token]];
        [HXHttpUtils requestJsonPostWithUrlStr:@"/user/address/newAddress" params:@{@"phoneNumber":user.phoneNumber,@"sKey":skey,@"humanName":nameString,@"contactNumber":phone,@"province":province,@"city":city,@"area":area,@"address":detailAddress} onComplete:^(NSError *error, NSDictionary *resultJson) {
            _locked=NO;
            [HXLoadingImageView hideViewForView:self.view];
            if (error) {
                [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
            }else{
                NSDictionary*content=[resultJson objectForKey:@"content"];
                _model=[HXConventionalAddModel new];
                _model.idAddress=[content objectForKey:@"id"];
                _model.hunamName=nameString;
                _model.contactNumber=phone;
                _model.province=province;
                _model.city=city;
                _model.area=area;
                _model.address=detailAddress;
                 NSDictionary*info=@{@"forAdd":@"1", @"model":_model};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NEW_ADDRESS" object:info];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
        }];
    }else{
    //修改地址
        NSString*skey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,phone,self.model.idAddress,user.token]];
        
        [HXHttpUtils requestJsonPostWithUrlStr:@"/user/address/modifyAddress" params:@{@"phoneNumber":user.phoneNumber,@"sKey":skey,@"id":self.model.idAddress,@"humanName":nameString,@"contactNumber":phone,@"province":province,@"city":city,@"area":area,@"address":detailAddress} onComplete:^(NSError *error, NSDictionary *resultJson) {
            _locked=NO;
            [HXLoadingImageView hideViewForView:self.view];
            if (error) {
                [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
            }else{
                _model.hunamName=nameString;
                _model.contactNumber=phone;
                _model.province=province;
                _model.city=city;
                _model.area=area;
                _model.address=detailAddress;
                 NSDictionary*info=@{@"forAdd":@"0", @"model":_model};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NEW_ADDRESS" object:info];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

- (void)createUI{
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,236) style:UITableViewStylePlain];
    _listTableView.delegate = self;
    _listTableView.scrollEnabled = NO;
    _listTableView.dataSource = self;
    [self.view addSubview:_listTableView];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
    if (section == 0) {
        label.text = @" 联系人";
    }else
        label.text = @" 常用地址";
    label.backgroundColor = BackGroundColor;
        return label;
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIde = @"cellIdentifier";
    HXNewAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell == nil) {
        cell = [[HXNewAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 1 && indexPath.row == 0)
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.titleLabel = [[UILabel alloc]init];
        cell.titleLabel.textAlignment = NSTextAlignmentLeft;
        cell.titleLabel.font = [UIFont systemFontOfSize:16];
        [cell addSubview:cell.titleLabel];
        NSString *titleString = [[titleArray objectAtIndex:indexPath.
                                  
                                  section] objectAtIndex:indexPath.row];
        CGSize size = [titleString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:cell.titleLabel.font,NSFontAttributeName, nil]];
        [cell.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).with.offset(5);
            make.top.equalTo(cell).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(size.width + 10, 24));
        }];
       
        if (indexPath.section == 0 && indexPath.row == 1)
            cell.editTextField=[[HXNumberTextField alloc] initWithFrame:CGRectZero Type:UIKeyboardTypePhonePad];
        else
            cell.editTextField = [[UITextField alloc]init];
        cell.editTextField.delegate = self;
        cell.editTextField.returnKeyType=UIReturnKeyDone;
        cell.editTextField.tag = 100 * indexPath.section + indexPath.row;
        cell.editTextField.font = [UIFont systemFontOfSize:14];
        [cell addSubview:cell.editTextField];
        [cell.editTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.titleLabel.mas_right).with.offset(5);
            make.centerY.equalTo(cell);
            make.right.equalTo(cell).with.offset(-15);
            make.height.equalTo(@24);
        }];

    }
    
    cell.titleLabel.text = [[titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.editTextField.placeholder = [[placehoderArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.editTextField.userInteractionEnabled = NO;
    }
    return cell;
}

#pragma mark--UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _textFiled = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textField.tag = %ld %@",(long)textField.tag,textField.text);
    [textField resignFirstResponder];
    switch (textField.tag / 100) {
        case 0:
        {
            switch (textField.tag % 100) {
                case 0:{
                    NSMutableArray *array1 = [NSMutableArray arrayWithArray:[placehoderArray objectAtIndex:0]];
                    NSString *str =textField.text;
                    [array1 replaceObjectAtIndex:0 withObject:[str mutableCopy]];
                    
                    [placehoderArray replaceObjectAtIndex:0 withObject:array1];
                };break;
                    
                case 1:{
                    NSMutableArray *array1 = [NSMutableArray arrayWithArray:[placehoderArray objectAtIndex:0]];
                    NSString *str =textField.text;
                    [array1 replaceObjectAtIndex:1 withObject:[str mutableCopy]];
                    
                    [placehoderArray replaceObjectAtIndex:0 withObject:array1];
                };break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:{
            if (textField.tag % 100 == 1) {
                NSMutableArray *array1 = [NSMutableArray arrayWithArray:[placehoderArray objectAtIndex:1]];
                NSString *str =textField.text;
                [array1 replaceObjectAtIndex:1 withObject:[str mutableCopy]];
                
                [placehoderArray replaceObjectAtIndex:1 withObject:array1];
            }
        };break;
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 0) {
        NSLog(@"选择省市区");
//        HXChooseCityViewController *chooseCity = [[HXChooseCityViewController alloc]init];
//        chooseCity.delegate = self;
//        [self.navigationController pushViewController:chooseCity animated:YES];
        
        HXChooseCityListViewController *cityList = [[HXChooseCityListViewController alloc]init];
        cityList.chooseType = HXProvinceType;
        cityList.delegate = self;
        [self.navigationController pushViewController:cityList animated:YES];
        
    }
}
- (void)goBack:(NSArray *)array{
    NSLog(@"array %@",array);
    if (array.count==3) {
    compArray=[array mutableCopy];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
    NSMutableArray *array1 = [NSMutableArray arrayWithArray:[placehoderArray objectAtIndex:1]];
    NSString *str =[NSString  stringWithFormat:@"%@ %@ %@",[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2]];
    [array1 replaceObjectAtIndex:0 withObject:[str mutableCopy]];
    
    [placehoderArray replaceObjectAtIndex:1 withObject:array1];
    HXNewAddressCell*cell=[_listTableView cellForRowAtIndexPath:indexPath];
    cell.editTextField.text=str;
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
