//
//  HXMyinformationViewController.m
//  BaiMi
//
//  Created by HXMAC on 16/7/11.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXMyinformationViewController.h"
#import "Masonry.h"
#import "HXCertificationTableViewCell.h"
#import "ContextUtil.h"
#import "HXGetSchoolViewController.h"
#import "HXGetAreaViewController.h"
#import "HXEditImageViewController.h"
#import "PECropViewController.h"
#import "HXChooseCityListViewController.h"
#import "UIImage+Resize.h"

@interface HXMyinformationViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate,HXEditImageDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate>
{
    UITableView *_myTableView;
    UIImageView *_iconImageView;
    NSArray *_iconarray;
    NSArray *_titleArray;
    NSArray *_placeHolderArray;
    NSMutableArray *_contentArray;
    NSArray*_contentKeys;
    HXLoginUser *_userModel;
    NSMutableDictionary *_subDict;
    UITextField *_currentField;
}
@end

@implementation HXMyinformationViewController
//自定义navigationBar时
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidHideNotification object:nil];
    self.navigationController.navigationBarHidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BackGroundColor;
    _userModel = [NSUserDefaultsUtil getLoginUser];

    _iconarray = [NSArray arrayWithObjects:[UIImage imageNamed:@"ico_data_name.png"],[UIImage imageNamed:@"ico_phone.png"],[UIImage imageNamed:@"ico_data_school.png"],[UIImage imageNamed:@"ico_data_school"],[UIImage imageNamed:@"ico_data_school.png"],[UIImage imageNamed:@"ico_data_school"],[UIImage imageNamed:@"ico_number.png"], nil];
    
    _titleArray = [NSArray arrayWithObjects:@"姓名",@"电话",@"学校",@"区域",@"楼栋",@"寝室",@"个人推荐码",@"", nil];
    
    _placeHolderArray=@[@"请输入姓名",@"请输入电话",@"请选择",@"请选择",@"请选择",@"请输入寝室号",@"请输入个人推荐码",@"请填写推荐人推荐码"];
    
    _contentKeys=@[@"nickName",@"phoneNumber",@"collegeName",@"areaName",@"dormitoryDes",@"dormitoryNo",@"inviteCode",@"refererCode"];
    
    _subDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:_userModel.nickName,@"nickName",_userModel.phoneNumber,@"phoneNumber",_userModel.collegeName,@"collegeName",_userModel.collegeNo,@"collegeNo",_userModel.areaNo,@"areaNo",_userModel.areaName,@"areaName",_userModel.dormitoryDes,@"dormitoryDes",_userModel.dormitoryHouseNo,@"dormitoryHouseNo",_userModel.dormitoryNo,@"dormitoryNo",_userModel.inviteCode,@"inviteCode",_userModel.refererCode,@"refererCode", nil];
    
    [self resetNavBar];
    [self createTableView];
}
-(void)resetNavBar{
    UIView*barView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    barView.backgroundColor=LightBlueColor;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 13, 20)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"btnBack.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:backBtn];
    
    UILabel*titleLab=[[UILabel alloc] initWithFrame:CGRectMake(80, 30, SCREEN_WIDTH-80*2, 20)];
    titleLab.text=@"个人资料";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    titleLab.font=[UIFont boldSystemFontOfSize:20.0];
    [barView addSubview:titleLab];
    [self.view addSubview:barView];
}


- (void)createTableView{
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.backgroundColor =BackGroundColor;
    [self.view addSubview:_myTableView];
    [_myTableView setSeparatorInset:(UIEdgeInsetsMake(0, 60, 0, 0))];

    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    footView.backgroundColor = BackGroundColor;
    UIButton* saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setBackgroundColor:RGBA(250, 100, 96, 1.0)];
    saveBtn.layer.cornerRadius = 20;
    [saveBtn setTitle:@"保存修改" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:saveBtn];
    
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footView).with.offset(20);
        make.centerX.equalTo(footView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 100, 40));
    }];
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [footView addSubview:lineLabel];

    [_myTableView setTableFooterView:footView];

    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    _iconImageView = [[UIImageView alloc]init];
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = 35;
    _iconImageView.userInteractionEnabled = YES;
    if (_userModel.logoUrl) {
        [_iconImageView setImageWithURL:[NSURL URLWithString:_userModel.logoUrl] placeholderImage:HXDefaultLogoImg];
        [_subDict setObject:_iconImageView.image forKey:@"icon"];
    }else{
        [_subDict setObject:@"" forKey:@"icon"];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoPhoto)];
    [_iconImageView addGestureRecognizer:tap];
    [headView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.center.equalTo(headView);
    }];
    [_myTableView setTableHeaderView:headView];
    _myTableView.tableHeaderView.backgroundColor = LightBlueColor;
    
    UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [control addTarget:self action:@selector(hidekeyBoard) forControlEvents:UIControlEventTouchUpInside];
    control.hidden = YES;
    [self.view addSubview:control];

    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe];
}
- (void)hideKeyBoard{
    [_currentField resignFirstResponder];
}


- (void)gotoPhoto{
    NSLog(@"进入相册");
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择本地图片",@"拍照", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
//    if (buttonIndex == 0) {
//        if ([_userModel.logoUrl isEqualToString:@""]) {
//            [HXAlertViewEx showInTitle:nil Message:@"请先选择照片" ViewController:self];
//            return;
//        }else{
//        HXEditImageViewController *editImageVC  = [[HXEditImageViewController alloc]init];
//        editImageVC.editImage = _iconImageView.image;
//        editImageVC.hidesBottomBarWhenPushed = YES;
//        editImageVC.delegate = self;
//        [self.navigationController pushViewController:editImageVC animated:YES];
//        }
//    }else
        if (buttonIndex == 0){
        [ContextUtil selectPhoto:self];
    }else if (buttonIndex == 1){
       [ContextUtil takePhoto:self];
    }
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        PECropViewController *controller = [[PECropViewController alloc] init];
        controller.height_width_scale=1;
        controller.delegate = self;
        controller.image = image;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:navigationController animated:YES completion:nil];
    }];
}

#pragma mark cropDelegate
- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    CGSize newSize = [UIImage resizeOfSize:CGSizeMake(croppedImage.size.width, croppedImage.size.height) LimitByMaxWidth:80 MaxHeight:80];
    croppedImage=[croppedImage scaleImageToSize:newSize];
    [_iconImageView  setImage: croppedImage];
    [_subDict setValue:croppedImage forKey:@"icon"];

    [controller dismissViewControllerAnimated:YES completion:nil];
}
- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    
//    HXEditImageViewController *editImageVC  = [[HXEditImageViewController alloc]init];
//    editImageVC.editImage = image;
//    editImageVC.hidesBottomBarWhenPushed = YES;
//    editImageVC.picker = picker;
//    editImageVC.delegate = self;
//    [picker pushViewController:editImageVC animated:YES];
//}
- (void)getPhotoByEdit:(UIImage *)image{
    [_iconImageView setImage:image];
    [_subDict setValue:image forKey:@"icon"];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
        return 60;
//    }else{
//        return 80;
//    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0) {
        return _titleArray.count;
//    }else
//        return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
        static NSString *cellIde = @"cellidentifier";

        HXCertificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (cell == nil) {
            cell = [[HXCertificationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row == 5 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 7) {
            cell.iconImageView.image = nil;
        }else
            [cell.iconImageView setImage:[_iconarray objectAtIndex:indexPath.row]];
        cell.titleLabel.text = [_titleArray objectAtIndex:indexPath.row];
        cell.contentTF.text=[_subDict objectForKey:[_contentKeys objectAtIndex:indexPath.row]];
        cell.contentTF.placeholder=[_placeHolderArray objectAtIndex:indexPath.row];
        cell.contentTF.delegate = self;
        cell.contentTF.returnKeyType=UIReturnKeyDone;
        cell.contentTF.tag = 100 + indexPath.row;
        cell.contentTF.userInteractionEnabled = YES;
        if (indexPath.row == 2 ||indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 1 || indexPath.row == 6) {
            cell.contentTF.userInteractionEnabled = NO;
        }
        if (indexPath.row == 2 || indexPath.row ==3 || indexPath.row == 4) {
            [cell.biaozhiImageView setImage:[UIImage imageNamed:@"ico_choose.png"]];
        }else if (indexPath.row==0 || indexPath.row==5){
            [cell.biaozhiImageView setImage:[UIImage imageNamed:@"ico_xiugai.png"]];
        }else if (indexPath.row == 7) {
            if ([_userModel.refererCode isEqualToString:@""] || [_userModel.refererCode isKindOfClass:[NSNull class]]) {
                cell.contentTF.userInteractionEnabled = YES;
                [cell.biaozhiImageView setImage:[UIImage imageNamed:@"ico_xiugai.png"]];
            }else
                cell.contentTF.userInteractionEnabled = NO;;
        }
        return cell;
//        
//    }else
//    {
//        static NSString *cellidemtifier = @"cellidentifier";
//
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidemtifier];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidemtifier];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.backgroundColor = BackGroundColor;
//        }
//        __weak typeof (UITableViewCell *)weakCell = cell;
//        UIButton *loginOut = [UIButton buttonWithType:UIButtonTypeCustom];
//        [loginOut setBackgroundColor:RGBA(250, 100, 96, 1.0)];
//        loginOut.layer.cornerRadius = 20;
//        [loginOut setTitle:@"保存修改" forState:UIControlStateNormal];
//        [loginOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [loginOut addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
//        [cell addSubview:loginOut];
//        
//        [loginOut mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(weakCell).with.offset(20);
//            make.centerX.equalTo(weakCell);
//            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 100, 40));
//        }];
//        
//        return cell;
//
//    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag - 100 == 5) {
        if ([_subDict objectForKey:@"dormitoryHouseNo"] == nil || [[_subDict objectForKey:@"dormitoryHouseNo"] isEqualToString:@""]) {
            [HXAlertViewEx showInTitle:nil Message:@"请选择学校区域和楼栋信息"  ViewController:self];
            [textField resignFirstResponder];
            return;
        }
    }
    _currentField = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    _currentField = nil;
    switch (textField.tag - 100) {
        case 0:
        {
            [_subDict setValue:textField.text forKey:@"nickName"];
        }
            break;
        case 5:{
            //寝室号
            [_subDict setValue:textField.text forKey:@"dormitoryNo"];
        }
            break;
        case 7:
        {
            //邀请人邀请码
            [_subDict setValue:textField.text forKey:@"refererCode"];
        }
            break;
        default:
            break;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    _currentField = nil;
    switch (textField.tag - 100) {
        case 0:
        {
            [_subDict setValue:textField.text forKey:@"nickName"];
        }
            break;
        case 5:{
            //寝室号
            [_subDict setValue:textField.text forKey:@"dormitoryNo"];
        }
            break;
        case 7:
        {
            //邀请人邀请码
            [_subDict setValue:textField.text forKey:@"refererCode"];
        }
            break;
        default:
            break;
    }
    return YES;
}
- (void)hidekeyBoard{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification object:nil];
}
- (void)save{
    NSString*nickName=[_subDict objectForKey:@"nickName"];
    NSString*dormitoryHouseNo=[_subDict objectForKey:@"dormitoryHouseNo"];
    NSString*dormitoryNo=[_subDict objectForKey:@"dormitoryNo"];
    if (!nickName.length) {
        [HXAlertViewEx showInTitle:nil Message:@"请输入姓名" ViewController:self];
        return;
    }
    if (!dormitoryHouseNo.length) {
        [HXAlertViewEx showInTitle:nil Message:@"请选择学校区域和楼栋信息" ViewController:self];
        return;
    }
    if (!dormitoryNo.length) {
        [HXAlertViewEx showInTitle:nil Message:@"请输入寝室号" ViewController:self];
        return;
    }
    [self saveHttp];
}

-(void)saveHttp{
    [HXLoadingImageView showLoadingView:self.view];
    NSLog(@"保存修改");
    [_currentField resignFirstResponder];
    NSString*skey=[HXNSStringUtil getSkeyByParamInfo:@[_userModel.phoneNumber,_userModel.token]];
    NSDictionary *dict =@{@"phoneNumber":_userModel.phoneNumber,@"sKey":skey,@"nickName":[_subDict objectForKey:@"nickName"],@"collegeNo":[_subDict objectForKey:@"collegeNo"],@"areaNo":[_subDict objectForKey:@"areaNo"],@"dormitoryHouseNo":[_subDict objectForKey:@"dormitoryHouseNo"],@"dormitoryNo":[_subDict objectForKey:@"dormitoryNo"],@"refererCode":[_subDict objectForKey:@"refererCode"]};
    [HXHttpUtils requestJsonFormDataPostWithUrlStr:@"/user/editInfo" params:dict ImgDataParams:@{@"logoPicture":UIImagePNGRepresentation([_subDict objectForKey:@"icon"])} showHud:YES onComplete:^(NSError *error, NSDictionary *resultJson) {
        [HXLoadingImageView hideViewForView:self.view];
        NSLog(@"参数  %@,%@",dict,resultJson);
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            [HXAlertViewEx showInTitle:nil Message:@"保存成功" ViewController:self];
            id content=[resultJson objectForKey:@"content"];
            if ([content isKindOfClass:[NSDictionary class]])
                _userModel.logoUrl=[HXHttpUtils whetherNil:[content objectForKey:@"logoPictureUrl"]];
            
            _userModel.nickName = [_subDict objectForKey:@"nickName"];
            _userModel.collegeNo = [_subDict objectForKey:@"collegeNo"];
            _userModel.areaNo = [_subDict objectForKey:@"areaNo"];
            _userModel.dormitoryHouseNo = [_subDict objectForKey:@"dormitoryHouseNo"];
            _userModel.dormitoryNo = [_subDict objectForKey:@"dormitoryNo"];
            _userModel.collegeName = [_subDict objectForKey:@"collegeName"];
            _userModel.areaName = [_subDict objectForKey:@"areaName"];
            _userModel.dormitoryDes = [_subDict objectForKey:@"dormitoryDes"];
            _userModel.refererCode = [_subDict objectForKey:@"refererCode"];
            [NSUserDefaultsUtil setLoginUser:_userModel];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"EDIT_SUCCEED" object:@[[_subDict objectForKey:@"nickName"],_iconImageView.image]];
        }
    }];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"USER_SCHOOL" object:nil];
            HXGetSchoolViewController *getSchool = [[HXGetSchoolViewController alloc]init];
            [self.navigationController pushViewController:getSchool animated:YES];
        }
//        else if (indexPath.row == 3){
//            if ([_subDict objectForKey:@"collegeName"] == nil || [[_subDict objectForKey:@"collegeName"] isEqualToString:@""]) {
//                [HXAlertViewEx showInTitle:nil Message:@"请先选择学校" ViewController:self];
//            }else{
//                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"GET_AREA" object:nil];
//                HXGetAreaViewController *getArea = [[HXGetAreaViewController alloc]init];
//                getArea.searchNum = [_subDict objectForKey:@"collegeNo"];
//                getArea.type = HXSearchTypeArea;
//                [self.navigationController pushViewController:getArea animated:YES];
//            }
//        }else if (indexPath.row == 4){
//            if ([_subDict objectForKey:@"areaName"]==nil || [[_subDict objectForKey:@"areaName"] isEqualToString:@""]) {
//                [HXAlertViewEx showInTitle:nil Message:@"请先选择区域" ViewController:self];
//            }else{
//                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"GET_Dormitory" object:nil];
//                HXGetAreaViewController *getArea = [[HXGetAreaViewController alloc]init];
//                getArea.type = HXSearchTypeDormitory;
//                getArea.searchNum = [_subDict objectForKey:@"areaNo"];
//                [self.navigationController pushViewController:getArea animated:YES];
//
//            }
//        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_currentField != nil) {
        [_currentField resignFirstResponder];
        _currentField = nil;
    }
}
-(void)notification:(NSNotification *)noti{
    if ([noti.name isEqualToString:@"USER_SCHOOL"]) {
        NSArray *array = noti.object;
        AMapCloudPOI *poi = [array objectAtIndex:0];
        NSDictionary *schoolDict = poi.customFields;
        [_subDict setObject:[schoolDict objectForKey:@"code"] forKey:@"collegeNo"];
        [_subDict setObject:poi.name forKey:@"collegeName"];
        
        NSDictionary *areaDict = [array objectAtIndex:1];
        [_subDict setObject:[areaDict objectForKey:@"name"] forKey:@"areaName"];
        [_subDict setObject:[areaDict objectForKey:@"no"] forKey:@"areaNo"];
        
        NSDictionary *dormitoryDict = [array objectAtIndex:2];
        [_subDict setObject:[dormitoryDict objectForKey:@"no"] forKey:@"dormitoryHouseNo"];
        [_subDict setObject:[dormitoryDict objectForKey:@"name"] forKey:@"dormitoryDes"];
        
        NSIndexPath *indexPath0=[NSIndexPath indexPathForRow:2 inSection:0];
        NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:3 inSection:0];
        NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:4 inSection:0];
        NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:5 inSection:0];
        
        [_myTableView reloadRowsAtIndexPaths:@[indexPath0,indexPath1,indexPath2,indexPath3] withRowAnimation:UITableViewRowAnimationNone];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"USER_SCHOOL" object:nil];
    }
//    if ([noti.name isEqualToString:@"GET_AREA"]) {
//        NSDictionary *dict = noti.object;
//        [_subDict setObject:[dict objectForKey:@"name"] forKey:@"areaName"];
//        [_subDict setObject:[dict objectForKey:@"no"] forKey:@"areaNo"];
//        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
//        [_myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GET_AREA" object:nil];
//
//    }
//    if ([noti.name isEqualToString:@"GET_Dormitory"]) {
//        NSDictionary *dict = noti.object;
//        [_subDict setObject:[dict objectForKey:@"no"] forKey:@"dormitoryHouseNo"];
//        [_subDict setObject:[dict objectForKey:@"name"] forKey:@"dormitoryDes"];
//        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
//        [_myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GET_Dormitory" object:nil];
//    }
//    
}
- (void)backBtnClick:(UIButton *)btn{
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
