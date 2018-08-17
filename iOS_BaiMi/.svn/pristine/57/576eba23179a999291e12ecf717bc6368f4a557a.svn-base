//
//  HXMoreAddressViewController.m
//  BaiMi
//
//  Created by HXMAC on 16/7/7.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXMoreAddressViewController.h"
#import "HXMoreAddressCell.h"
#import "Masonry.h"
#import "HXNewAddressViewController.h"
#import "MJRefresh.h"

@interface HXMoreAddressViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    int _currentPage;
    NSMutableArray *_dataArray;
    UITableView *_myTableView;
    UIView*_backView;
    HXConventionalAddModel*_selectModel;
}
@end

@implementation HXMoreAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"常用地址";
    self.view.backgroundColor = BackGroundColor;
    _dataArray = [NSMutableArray array];
    _currentPage = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"NEW_ADDRESS" object:nil];
    [self createUI];

    [self loadDataWithPage:_currentPage];
}
- (void)notification:(NSNotification *)noti{
    if ([noti.name isEqualToString:@"NEW_ADDRESS"]) {
        NSDictionary*info=noti.object;
        BOOL forAdd=[[info objectForKey:@"forAdd"] boolValue];
        HXConventionalAddModel*model=[info objectForKey:@"model"];
        if (forAdd) {
        //新增地址
            if (_dataArray.count>0)
                [_dataArray insertObject:model atIndex:1];
            else{
                model.isDefault=YES;
                [_dataArray addObject:model];
            }
        }else{
        //修改地址
            for(HXConventionalAddModel*address in _dataArray){
                if (address.idAddress ==model.idAddress) {
                    address.idAddress=model.idAddress;
                    address.hunamName=model.hunamName;
                    address.contactNumber=model.contactNumber;
                    address.province=model.province;
                    address.city=model.city;
                    address.area=model.area;
                    address.address=model.address;
                }
            }
        }
         [_myTableView reloadData];
    }
}
- (void)loadDataWithPage:(int)page{

    HXLoginUser *user = [NSUserDefaultsUtil getLoginUser];
    NSString*skey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,[NSNumber numberWithInt:page],user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/address/commonlyUseseAddressList" params:@{@"phoneNumber":user.phoneNumber,@"sKey":skey,@"currentPage":[NSNumber numberWithInt:page]} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            NSArray *content = [resultJson objectForKey:@"content"];
            NSMutableArray*array=[NSMutableArray array];
            for (NSDictionary *dict in content) {
                HXConventionalAddModel *model = [[HXConventionalAddModel alloc]init];
                model.hunamName = [dict objectForKey:@"humanName"];
                model.contactNumber = [dict objectForKey:@"contactNumber"];
                model.province = [dict objectForKey:@"province"];
                model.city = [dict objectForKey:@"city"];
                model.area = [dict objectForKey:@"area"];
                model.address = [dict objectForKey:@"address"];
                model.idAddress = [dict objectForKey:@"id"];
                model.isDefault = [[dict objectForKey:@"isDefault"] boolValue];
                [array addObject:model];
            }
            if (page==0)
                 _dataArray=[array mutableCopy];
            else
                [_dataArray addObjectsFromArray:array];
        }
        if(_dataArray.count>0){
            _myTableView.hidden=NO;
            _backView.hidden=YES;
        }
        else{
            _myTableView.hidden=YES;
            _backView.hidden=NO;
        }
        [_myTableView reloadData];
        [_myTableView.mj_header endRefreshing];
        [_myTableView.mj_footer endRefreshing];
    }];
}


- (void)fillClick{
    NSLog(@"马上填写");
    HXNewAddressViewController *newAddess = [[HXNewAddressViewController alloc]init];
    newAddess.newAddressType = NEWADD;
    [self.navigationController pushViewController:newAddess animated:YES];
}
- (void)createUI{
    [self showBackView];
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    _myTableView.delegate = self;
    _myTableView.dataSource =self;
    [self.view addSubview:_myTableView];

    //下拉刷新
    __unsafe_unretained UITableView*tableView=_myTableView;
    tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage=0;
        [self loadDataWithPage:_currentPage];
        
    }];
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉加载更多
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _currentPage++;
        [self loadDataWithPage:_currentPage];
    }];
}

-(void)showBackView{
    _backView = [[UIView alloc]initWithFrame:self.view.frame];
    _backView.backgroundColor = [UIColor whiteColor];
    UIImageView  *imageVire = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 80, _backView.center.y - 160, 160, 160)];
    [imageVire setImage:[UIImage imageNamed:@"ico_kongdizhi.png"]];
    [_backView addSubview:imageVire];
    
    UIButton *fillBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fillBtn.frame = CGRectMake(SCREEN_WIDTH/2 - 80, ViewFrameY_H(imageVire) + 10, 160, 40);
    [fillBtn setBackgroundColor:LightBlueColor];
    fillBtn.layer.cornerRadius = 20;
    [fillBtn setTitle:@"马上填写" forState:UIControlStateNormal];
    [fillBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fillBtn addTarget:self action:@selector(fillClick) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:fillBtn];
    [self.view addSubview:_backView];
    _backView.hidden=YES;
}



#pragma mark---UITableViewDatasource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else
        return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        if (indexPath.section == 0) {
            static NSString *cellIde = @"cellIdentifier";

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *addImageView = [[UIImageView alloc]init];
            [addImageView setImage:[UIImage imageNamed:@"ico_more.png"]];
            [cell addSubview:addImageView];
            [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell).with.offset(5);
                make.top.equalTo(cell).with.offset(10);
                make.size.mas_equalTo(CGSizeMake(30, 30));
            }];
            UILabel *label = [[UILabel alloc]init];
            label.text =@"新增地址";
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:14];
            [cell addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(addImageView.mas_right).with.offset(10);
                make.centerY.equalTo(cell);
                make.size.mas_equalTo(CGSizeMake(100, 30));
            }];

        }
            return cell;
    }else
    {
        static NSString *cellIde = @"cellIdent";

        HXMoreAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (cell == nil) {
            cell = [[HXMoreAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        HXConventionalAddModel *model = [_dataArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = model.hunamName;
        cell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@ %@",model.province,model.city,model.area,model.address];
        cell.phoneLabel.text = model.contactNumber;
        if(_forSelect){
            if ([_orginalAddress.address isEqualToString:model.address]&&[_orginalAddress.province isEqualToString:model.province]&&[_orginalAddress.city isEqualToString:model.city]&&[_orginalAddress.area isEqualToString:model.area]) {
                [cell.iconImageView setImage:[UIImage imageNamed:@"ico_xuan.png"]];
                _seleIndexPath=indexPath;
            }
        }else{
            if (model.isDefault)
                [cell.iconImageView setImage:[UIImage imageNamed:@"ico_xuan.png"]];
            else
                [cell.iconImageView setImage:[UIImage imageNamed:@"ico_weixuan.png"]];
        }
        cell.editImageView.tag = indexPath.row * 10;
        cell.deleteImageView.hidden = YES;
        cell.deleteImageView.tag = indexPath.row * 10 + 1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeCellState:)];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeCellState:)];
        [cell.editImageView addGestureRecognizer:tap1];
        [cell.deleteImageView addGestureRecognizer:tap];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSLog(@"新增地址");
        HXNewAddressViewController *newAddess = [[HXNewAddressViewController alloc]init];
        newAddess.newAddressType = NEWADD;
        [self.navigationController pushViewController:newAddess animated:YES];

    }else{
        HXConventionalAddModel *model = [_dataArray objectAtIndex:indexPath.row];
        if(_forSelect){
            int oldRow=_seleIndexPath?(int)_seleIndexPath.row:-1;
            int newRow=(int)indexPath.row;
            if (oldRow!=newRow) {
                HXMoreAddressCell*oldSeleCell=[tableView cellForRowAtIndexPath:_seleIndexPath];
                HXMoreAddressCell*cell=[tableView cellForRowAtIndexPath:indexPath];
                [oldSeleCell.iconImageView setImage:[UIImage imageNamed:@"ico_weixuan.png"]];
                  [cell.iconImageView setImage:[UIImage imageNamed:@"ico_xuan.png"]];
                _seleIndexPath=indexPath;
            }
            if ([_delegate respondsToSelector:@selector(selectAddressVC:selectAddress:)]) {
                [_delegate selectAddressVC:self selectAddress:model];
            }
            [self performSelector:@selector(popOut) withObject:nil afterDelay:0.3];

        }else{
            if (model.isDefault)
                return;
            //修改默认地址
            _selectModel=[_dataArray objectAtIndex:indexPath.row];
            UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:nil message:@"是否修改默认地址？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            showAlert.tag=10086;
            [showAlert show];
        }
    }
}

-(void)popOut{
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return NO;
    }else
        return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectModel=[_dataArray objectAtIndex:indexPath.row];
    UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:nil message:@"确定删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    showAlert.tag=10087;
    [showAlert show];

}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void )alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10086) {
       if (buttonIndex==1)
            [self setDefaultHttp];
       return;
    }else if(alertView.tag==10087){
      if (buttonIndex==1)
            [self deleteAddressHttp];
      else{
          _myTableView.editing=NO;
          return;
      }
    }
}


- (void)setDefaultHttp{
    HXLoginUser *user = [NSUserDefaultsUtil getLoginUser];
    NSString *key = [HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,_selectModel.idAddress,user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/address/setDefault" params:@{@"phoneNumber":user.phoneNumber,@"sKey":key,@"id":_selectModel.idAddress}  onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            for(HXConventionalAddModel*model in _dataArray){
                model.isDefault=NO;
            }
            _selectModel.isDefault=YES;
            [_dataArray removeObject:_selectModel];
            [_dataArray insertObject:_selectModel atIndex:0];
            [_myTableView reloadData];
            
        //更新user默认地址
        NSDictionary*placeDic=@{@"id":_selectModel.idAddress,@"province":_selectModel.province,@"city":_selectModel.city,@"area":_selectModel.area,@"address":_selectModel.address,@"humanName":_selectModel.hunamName,@"contactNumber":_selectModel.contactNumber};
            user.defaultAddressJsonStr=[HXNSStringUtil getJsonStringFromDicOrArray:placeDic];
            [NSUserDefaultsUtil setLoginUser:user];
        }
    }];

}

- (void)deleteAddressHttp{
    [HXLoadingImageView showLoadingView:self.view];
    HXLoginUser *user = [NSUserDefaultsUtil getLoginUser];
    NSString*skey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,_selectModel.idAddress,user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/address/deleteAddress" params:@{@"phoneNumber":user.phoneNumber,@"sKey":skey,@"id":_selectModel.idAddress} onComplete:^(NSError *error, NSDictionary *resultJson) {
        [HXLoadingImageView hideViewForView:self.view];
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[_dataArray indexOfObject:_selectModel] inSection:1];

            [_dataArray  removeObject:_selectModel];
            //如果删除的是默认地址，自动设置新的默认地址
            if (_selectModel.isDefault) {
                if (_dataArray.count>0) {
                    _selectModel=[_dataArray firstObject];
                    [self setDefaultHttp];                }
            }
            [_myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
}


- (void)changeCellState:(UITapGestureRecognizer *)tap{
    HXConventionalAddModel *model = [_dataArray objectAtIndex:tap.view.tag / 10];

    if (tap.view.tag%10 == 0) {
        HXNewAddressViewController *newAddess = [[HXNewAddressViewController alloc]init];
        newAddess.newAddressType = REVISE;
        newAddess.model = model;
        [self.navigationController pushViewController:newAddess animated:YES];
    }else{
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
