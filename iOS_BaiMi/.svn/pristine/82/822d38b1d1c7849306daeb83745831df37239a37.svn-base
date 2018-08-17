//
//  HXAdressBookListViewController.m
//  BaiMi
//
//  Created by licl on 16/7/22.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXAdressBookListViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "HanyuPinyinOutputFormat.h"
#import "PinyinHelper.h"
#import "HXContactPerson.h"

@interface HXAdressBookListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,MFMessageComposeViewControllerDelegate>
@property (strong, nonatomic) NSArray* sections;
@property (strong, nonatomic) NSMutableDictionary* personsInSection;
@property (strong, nonatomic) NSArray* allPersons;
@property (strong, nonatomic) NSMutableArray* allPersonsSearched;
@property (nonatomic) BOOL isInSearchMode;

@property(strong,nonatomic)UITableView*tableView;
@property(strong,nonatomic)UISearchBar*searchBar;

@end

@implementation HXAdressBookListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self resetNaviBar];
     [self createUI];
    _allPersonsSearched = [[NSMutableArray alloc] init];
    _isInSearchMode = NO;
  }
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}

-(void)resetNaviBar{
    UIView*barView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    barView.backgroundColor=LightBlueColor;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 13, 20)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"btnBack.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:backBtn];
    
    UILabel*titleLab=[[UILabel alloc] initWithFrame:CGRectMake(80, 30, SCREEN_WIDTH-80*2, 20)];
    titleLab.text=@"所有联系人";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    titleLab.font=[UIFont boldSystemFontOfSize:20.0];
    [barView addSubview:titleLab];
    [self.view addSubview:barView];
}

-(void)createUI{
    UIView*bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
    bgView.backgroundColor=LightBlueColor;
    _searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(10,7, SCREEN_WIDTH - 10*2, 30)];
    [_searchBar setBackgroundImage:[UIImage new]];
    _searchBar.layer.cornerRadius=30/2;
    _searchBar.delegate=self;
    [bgView addSubview:_searchBar];
    [self.view addSubview:bgView];
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, ViewFrameY_H(bgView), SCREEN_WIDTH, self.view.frame.size.height-ViewFrameY_H(bgView))];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.view addSubview:self.tableView];
    self.view.backgroundColor=[UIColor redColor];
}


-(void)backBtnClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewDidAppear:(BOOL)animated{
    ABAddressBookRef addressBook = NULL;
    __block BOOL accessGranted = NO;
    
        ABAuthorizationStatus s = ABAddressBookGetAuthorizationStatus();
        if(s == kABAuthorizationStatusDenied || s==kABAuthorizationStatusRestricted){
            UIAlertView* a = [[UIAlertView alloc] initWithTitle:@"请打开允许访问通讯录的开关" message:@"请在设置-隐私-通讯录中打开允许访问通讯录的开关以允许应用访问你的通讯录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [a show];
        }
        else {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                accessGranted = granted;
                dispatch_semaphore_signal(sema);
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
            if (accessGranted) {
                [self reloadData];
            }
        }
}


-(void)reloadData{
    ABAddressBookRef _ab = ABAddressBookCreate();
    
    NSArray* array = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(_ab);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
        [outputFormat setToneType:ToneTypeWithoutTone];
        [outputFormat setVCharType:VCharTypeWithV];
        [outputFormat setCaseType:CaseTypeLowercase];
        
        NSMutableArray* personsArray = [[NSMutableArray alloc] initWithCapacity:array.count];
        NSMutableArray* sectionsArray = [[NSMutableArray alloc] init];
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:27];
        for(id o in array){
            CFTypeRef r = (__bridge CFTypeRef)o;
            NSString *name = ((__bridge NSString *)(ABRecordCopyValue(r, kABPersonFirstNameProperty)));//
            if (!name)
                name = @"";
            NSString *lastname = ((__bridge NSString *)(ABRecordCopyValue(r, kABPersonLastNameProperty)));
            if (!lastname)
                lastname = @"";
            name = [lastname stringByAppendingString:name];
            NSString* pinyin = [PinyinHelper toHanyuPinyinStringWithNSString:name withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
            NSString* firstpinyin = @"#";
            if(pinyin && pinyin.length > 0){
                firstpinyin = [[pinyin substringToIndex:1] uppercaseString];
            }
            
            ABMultiValueRef phones = (ABMultiValueRef) ABRecordCopyValue(r, kABPersonPhoneProperty);
            for(int i = 0 ;i < ABMultiValueGetCount(phones); i++){
                NSString *phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, i);
                phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
                phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
                phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
                phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
                phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
                phone = [phone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
                if(phone.length == 11){
                    [personsArray addObject:[[HXContactPerson alloc] initWithFirstPinyin:firstpinyin pinyin:pinyin name:name phone:phone]];
                }
            }
        }
        [personsArray sortUsingComparator:^NSComparisonResult(HXContactPerson *obj1, HXContactPerson *obj2) {
            return [obj1.pinyin compare:obj2.pinyin options:NSCaseInsensitiveSearch];
        }];
        for(HXContactPerson *p in personsArray){
            if(p.pinyin.length > 0){
                NSString *firstpinyin = [[p.pinyin substringToIndex:1] uppercaseString];
                if(![sectionsArray containsObject:firstpinyin]){
                    [sectionsArray addObject:firstpinyin];
                }
            }
        }
        [sectionsArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
        }];
        if([sectionsArray containsObject:@"#"]){
            [sectionsArray removeObject:@"#"];
            [sectionsArray addObject:@"#"];
        }
        for(HXContactPerson *o in personsArray){
            NSString *key = [o firstPinyin];
            NSMutableArray *array = [dict objectForKey:key];
            if(!array){
                array = [[NSMutableArray alloc] init];
                [dict setObject:array forKey:key];
            }
            [array addObject:o];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.sections = sectionsArray;
            self.personsInSection = dict;
            self.allPersons = personsArray;
            
            CFRelease(_ab);
            [self.tableView reloadData];
        });
    });
}

#pragma mark tableView start
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HXContactPerson* p  = nil;
    if(self.isInSearchMode){
        p = [self.allPersonsSearched objectAtIndex:indexPath.row];
    }else{
        NSString* key = [self.sections objectAtIndex:indexPath.section];
        NSArray* array = (NSArray*)[self.personsInSection objectForKey:key];
        p = [array objectAtIndex:indexPath.row];
    }
    static NSString*cellIdentifier=@"cell";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text=p.name;
    cell.detailTextLabel.text=p.phone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.isInSearchMode){
        return self.allPersonsSearched.count;
    }
    NSString* key = [self.sections objectAtIndex:section];
    return ((NSArray*)[self.personsInSection objectForKey:key]).count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.isInSearchMode){
        return 1;
    }
    return self.sections.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(self.isInSearchMode){
        return @"";
    }
    return (NSString*)[self.sections objectAtIndex:section];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if(self.isInSearchMode){
        return nil;
    }
    return self.sections;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HXContactPerson*p=nil;
    if(self.isInSearchMode){
        p = [self.allPersonsSearched objectAtIndex:indexPath.row];
    }
    else{
        NSString* key = [self.sections objectAtIndex:indexPath.section];
        NSArray* array = (NSArray*)[self.personsInSection objectForKey:key];
        p = [array objectAtIndex:indexPath.row];
    }
   //短信内容格式 快递单号后4位+快递名称+取件码
    NSString*subExpressNoStr=_express.expressNo;
    if(_express.expressNo.length>4){
        NSRange range=NSMakeRange(_express.expressNo.length-4, 4);
        subExpressNoStr=[_express.expressNo substringWithRange:range];
    }
    NSString*msgStr=[NSString stringWithFormat:@"可以帮我取快递吗?尾号%@%@已存入%@",subExpressNoStr,_express.companyName,_express.location];
    if (_express.deliverCode.length){
        HXLoginUser*user=[NSUserDefaultsUtil getLoginUser];
        msgStr=[NSString stringWithFormat:@"%@,手机号码:%@,取件码:%@",msgStr,user.phoneNumber,_express.deliverCode];
    }
    [self sendSMS:msgStr recipientList:[NSArray arrayWithObject:p.phone]];
}

#pragma mark tableView end

#pragma mark searchBar delegate start
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [self.searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar setText:@""];
    [self searchBar:searchBar textDidChange:self.searchBar.text];
    [self.searchBar resignFirstResponder];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([searchText isEqualToString:@""]){
        self.isInSearchMode = NO;
    }
    else{
        self.isInSearchMode = YES;
        [self.allPersonsSearched removeAllObjects];
        
        for(HXContactPerson *p in self.allPersons){
            if([p.pinyin rangeOfString:searchText options:NSCaseInsensitiveSearch].location!=NSNotFound){
                [self.allPersonsSearched addObject:p];
            }
            else if([p.name rangeOfString:searchText options:NSCaseInsensitiveSearch].location !=NSNotFound){
                [self.allPersonsSearched addObject:p];
            }
            else if([p.phone rangeOfString:searchText options:NSCaseInsensitiveSearch].location!=NSNotFound){
                [self.allPersonsSearched addObject:p];
            }
        }
    }
    [self reloadData];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchBar:searchBar textDidChange:self.searchBar.text];
    [self.searchBar resignFirstResponder];
}
#pragma mark searchBar delegate end




#pragma mark send sms
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText]){
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    NSLog(@"%d",result);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled){
        NSLog(@"Message cancelled");
    }
    else if (result == MessageComposeResultSent){
        NSLog(@"Message sent");
        [self changeOrderShareStatusHttp];
    }
    else{
        NSLog(@"Message failed");
    }
}
//更改分享状态
-(void)changeOrderShareStatusHttp{
    HXLoginUser*user=[NSUserDefaultsUtil getLoginUser];
    NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,_express.orderId,[NSNumber numberWithInt:HXReceiveOrderShared],user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/receive/changeShareStatus" params:@{@"phoneNumber":user.phoneNumber,@"sKey":sKey,@"orderNo":_express.orderId,@"shareStatus":[NSNumber numberWithInt:HXReceiveOrderShared]} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            NSLog(@"%@",HXCodeString(error.code));
        }else{
            NSLog(@"修改单子状态为已分享");
            _express.shareStatus=HXReceiveOrderShared;
            [[NSNotificationCenter defaultCenter] postNotificationName:HXNTFReceiveOrderSharedRefresh object:_express];
        }
    }];
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
