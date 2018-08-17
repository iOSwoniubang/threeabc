//
//  HXCertificationViewController.m
//  BaiMi
//
//  Created by HXMAC on 16/7/7.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXCertificationViewController.h"
#import "HXCertificationTableViewCell.h"
#import "Masonry.h"
#import "HXShowImageView.h"
#import "ContextUtil.h"
#import "HXGetSchoolViewController.h"
//支付类型
typedef NS_ENUM(NSInteger,HXStyleType){
    HXBothStyle=1,//同时认证
    HXRealNameStyle =2, //支付宝支付
    HXStudentStyle=3,//微信支付
};


@interface HXCertificationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIScrollViewDelegate>
{
    UITableView *_myTableView;
    UIImageView *_groupPhoto;//个人与身份正面合照
    UIImageView *_studentCard;//学生证照片
    NSArray *_iconArray;//标志图片
    NSArray *_titleArray;
    NSMutableArray *_placehodeArray;
    NSMutableDictionary *_dataDict;
    NSMutableDictionary *_submitDict;
    HXShowImageView *_showImageView;
    NSInteger currentShow;
//    NSArray *biaozhiArray;
    UITextField *_currentField;
    UILabel *_groupTitle;
    UILabel  *studentTitle;
    UILabel *resultLabel;
    UIButton *submitBt;
    BOOL isCard ;//实名认证
    BOOL isStudent  ;//师哥认证
}
@end

@implementation HXCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"信息认证";
    self.view.backgroundColor = BackGroundColor;
    _iconArray = [NSArray arrayWithObjects:@[[UIImage imageNamed:@"ico_name.png"]],@[[UIImage imageNamed:@"ico_zhengjian.png"]],@[[UIImage imageNamed:@"ico_yourschool.png"],[UIImage imageNamed:@"ico_xuehao.png"]], nil];
    _titleArray = [NSArray arrayWithObjects:@[@"真实姓名"],@[@"身份证号码"],@[@"所在学校",@"学号"], nil];
    _placehodeArray = [NSMutableArray arrayWithObjects:@[@"请填写姓名"],@[@"请填写您的身份证号码"],@[@"请填写学校名称",@"请填写您的学号"], nil];
//    biaozhiArray = [NSArray arrayWithObjects:@"*必填",@"*实名必填",@"*师哥必填",@"*师哥必填", nil];
    _submitDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"realName",@"",@"idCardNo",@"",@"collegeName",@"",@"studentId",nil,@"studentCardPicture",nil,@"idCardPicture", nil];
    isCard = NO;
    isStudent = NO;
    [self reloadData];
    [self createUI];
    
}
- (void)addData{
    if (_dataDict != nil && ![_dataDict isKindOfClass:[NSNull class]])  {
        if (![[_dataDict objectForKey:@"idCardUrl"] isKindOfClass:[NSNull class]] && [_dataDict objectForKey:@"idCardUrl"] != nil ){
                [_groupPhoto setImageWithURL:[NSURL URLWithString:[_dataDict objectForKey:@"idCardUrl"]] placeholderImage:HXDefaultImg];
            }else{
                if (isCard) {
                    _groupPhoto.userInteractionEnabled = NO;
                    [_dataDict setObject:[NSString stringWithFormat:@"%d",(int)HXVerifyStatusCommited] forKey:@"verificationStatus"];
                    _dataDict =_submitDict;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:1];
                    [_myTableView reloadRowsAtIndexPaths:@[indexPath,indexPath1] withRowAnimation:UITableViewRowAnimationNone];
                }else
                [_groupPhoto setImage:[UIImage imageNamed:@"ico_load.png"]];
            }
        if ([_dataDict objectForKey:@"verificationStatus"] != nil && ![[_dataDict objectForKey:@"verificationStatus"] isKindOfClass:[NSNull class]]){
            switch ([[_dataDict objectForKey:@"verificationStatus"] intValue]) {
                case HXVerifyStatusFailed://认证失败
                {
                    _groupPhoto.userInteractionEnabled = YES;
                    _groupTitle.text = @"实名认证审核失败,请重新上传";
                }
                    break;
                case HXVerifyStatusSuccessed://认证成功
                {
                    _groupTitle.text = @"实名认证成功";
                    _groupPhoto.userInteractionEnabled = NO;
                }
                    break;
                case HXVerifyStatusUncommit://未提交
                {
                    _groupPhoto.userInteractionEnabled = YES;
                    _groupTitle.text = @"(上传个人与身份证正面合照)";
                }
                    break;
                case HXVerifyStatusCommited://认证已提交
                {
                    _groupTitle.text = @"已上传身份证照片,正在认证中,请耐心等待";
                    _groupPhoto.userInteractionEnabled = NO;

                }
                    break;
                default:
                    break;
            }
        }else if (isCard){
            _groupTitle.text = @"已上传身份证照片,正在认证中,请耐心等待";
            _groupPhoto.userInteractionEnabled = NO;
            
        }
        
        if (![[_dataDict objectForKey:@"studentCardUrl"] isKindOfClass:[NSNull class]] && [_dataDict objectForKey:@"studentCardUrl"] != nil) {
            [_studentCard setImageWithURL:[NSURL URLWithString:[_dataDict objectForKey:@"studentCardUrl"]] placeholderImage:HXDefaultImg];
        }
        else{
            if (isStudent) {
                _studentCard.userInteractionEnabled = NO;
                [_dataDict setObject:[NSString stringWithFormat:@"%d",(int)HXVerifyStatusCommited] forKey:@"studentVerificationStatus"];
                _dataDict =_submitDict;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
                NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:2];
                [_myTableView reloadRowsAtIndexPaths:@[indexPath,indexPath1] withRowAnimation:UITableViewRowAnimationNone];
            }else
            [_studentCard setImage:[UIImage imageNamed:@"ico_load.png"]];
        }

        if ([_dataDict objectForKey:@"studentVerificationStatus"] != nil && ![[_dataDict objectForKey:@"studentVerificationStatus"] isKindOfClass:[NSNull class]]) {
            switch ([[_dataDict objectForKey:@"studentVerificationStatus"] intValue]) {
                case HXVerifyStatusFailed://认证失败
                {
                    studentTitle.text = @"师哥认证审核失败,请重新上传";
                    _studentCard.userInteractionEnabled = YES;

                }
                    break;
                case HXVerifyStatusSuccessed://认证成功
                {
                    studentTitle.text = @"师哥认证成功";
                    _studentCard.userInteractionEnabled = NO;
                }
                    break;
                case HXVerifyStatusUncommit://未提交
                {
                    studentTitle.text = @"(上传学生证照片)";
                    _studentCard.userInteractionEnabled = YES;
                }
                    break;
                case HXVerifyStatusCommited://认证已提交
                {
                    studentTitle.text = @"已上传学生证照片,正在认证中,请耐心等待";
                    _studentCard.userInteractionEnabled = NO;
                }
                    break;
                default:
                    break;
            }
            
        }else if (isStudent){
            studentTitle.text = @"已上传学生证照片,正在认证中,请耐心等待";
            _studentCard.userInteractionEnabled = NO;

        }
        NSString*remarkStr=[HXHttpUtils whetherNil:[_dataDict objectForKey:@"remark"]];
        resultLabel.hidden=YES;
    
        int studentStatus=[[_dataDict objectForKey:@"studentVerificationStatus"]intValue] ;
        int verificationStatus=[[_dataDict objectForKey:@"verificationStatus"]intValue];
        
        if (studentStatus == HXVerifyStatusSuccessed && verificationStatus == HXVerifyStatusSuccessed) {
            [submitBt setBackgroundColor:[UIColor grayColor]];
            [submitBt setTitle:@"已完成认证" forState:UIControlStateNormal];
            submitBt.userInteractionEnabled = NO;
        }else if ((studentStatus == HXVerifyStatusCommited && (verificationStatus== HXVerifyStatusCommited | verificationStatus==HXVerifyStatusSuccessed)) || (studentStatus==HXVerifyStatusSuccessed && verificationStatus==HXVerifyStatusCommited)){
            [submitBt setBackgroundColor:[UIColor grayColor]];
            [submitBt setTitle:@"正在认证中……" forState:UIControlStateNormal];
            submitBt.userInteractionEnabled = NO;
        }else{
            submitBt.userInteractionEnabled = YES;
            [submitBt setBackgroundColor:RGBA(1, 171, 253, 1.0)];
            [submitBt setTitle:@"提交" forState:UIControlStateNormal];
            resultLabel.hidden=NO;

            if(studentStatus==HXVerifyStatusUncommit && verificationStatus==HXVerifyStatusUncommit)
                 resultLabel.text=@"你还没有信息认证,请认证";
            else if (studentStatus==HXVerifyStatusUncommit && (verificationStatus==HXVerifyStatusCommited | verificationStatus==HXVerifyStatusSuccessed))
                resultLabel.text=@"你还没有师哥认证,请认证";
            else if(verificationStatus==HXVerifyStatusUncommit && (studentStatus==HXVerifyStatusCommited | studentStatus==HXVerifyStatusSuccessed))
                resultLabel.text=@"你还没有实名认证，请认证";
            else{
                if (remarkStr.length)
                    resultLabel.text=[NSString stringWithFormat:@"%@,请重新认证",remarkStr];
                else
                    resultLabel.hidden=YES;
            }
        }
    }else{
            if (isCard) {
                _dataDict = _submitDict;
                if (isStudent) {
                    _groupPhoto.userInteractionEnabled = NO;
                    _studentCard.userInteractionEnabled = NO;
                    [_dataDict setObject:[NSString stringWithFormat:@"%d",(int)HXVerifyStatusCommited] forKey:@"verificationStatus"];
                    [_dataDict setObject:[NSString stringWithFormat:@"%d",(int)HXVerifyStatusCommited] forKey:@"studentVerificationStatus"];
                    [submitBt setBackgroundColor:[UIColor grayColor]];
                    [submitBt setTitle:@"正在认证中……" forState:UIControlStateNormal];
                    submitBt.userInteractionEnabled = NO;
                    resultLabel.hidden=YES;
                }else{
                    _groupPhoto.userInteractionEnabled = NO;
                    _studentCard.userInteractionEnabled = YES;
                    [_dataDict setObject:[NSString stringWithFormat:@"%d",(int)HXVerifyStatusCommited] forKey:@"verificationStatus"];
                    [_dataDict setObject:[NSString stringWithFormat:@"%d",(int)HXVerifyStatusUncommit] forKey:@"studentVerificationStatus"];
                    submitBt.userInteractionEnabled = YES;
                    [submitBt setBackgroundColor:RGBA(1, 171, 253, 1.0)];
                    [submitBt setTitle:@"提交" forState:UIControlStateNormal];
                    resultLabel.hidden=NO;
                    resultLabel.text=@"你还没有师哥认证,请认证";
                }
                [_myTableView reloadData];
                return;
            }else if(isStudent){
                _dataDict = _submitDict;
                _groupPhoto.userInteractionEnabled = YES;
                _studentCard.userInteractionEnabled = NO;
                [_dataDict setObject:[NSString stringWithFormat:@"%d",(int)HXVerifyStatusUncommit] forKey:@"verificationStatus"];
                [_dataDict setObject:[NSString stringWithFormat:@"%d",(int)HXVerifyStatusCommited] forKey:@"studentVerificationStatus"];
                submitBt.userInteractionEnabled = YES;
                [submitBt setBackgroundColor:RGBA(1, 171, 253, 1.0)];
                [submitBt setTitle:@"提交" forState:UIControlStateNormal];
                resultLabel.hidden=NO;
                resultLabel.text=@"你还没有实名认证，请认证";
                [_myTableView reloadData];
            }else{
            _groupPhoto.userInteractionEnabled = YES;
            _studentCard.userInteractionEnabled = YES;
            submitBt.userInteractionEnabled = YES;
            [submitBt setBackgroundColor:RGBA(1, 171, 253, 1.0)];
            [submitBt setTitle:@"提交" forState:UIControlStateNormal];
            [_groupPhoto setImage:[UIImage imageNamed:@"ico_load.png"]];
            [_studentCard setImage:[UIImage imageNamed:@"ico_load.png"]];
            resultLabel.hidden = NO;
            resultLabel.text=@"你还没有信息认证,请认证";
            }
    }
    
}
- (void)reloadData{
    HXLoginUser *user = [NSUserDefaultsUtil getLoginUser];
    NSString*skey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/getVerification" params:@{@"phoneNumber":user.phoneNumber,@"sKey":skey} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            _dataDict = [resultJson objectForKey:@"content"];
            if (_dataDict !=nil && ![_dataDict isKindOfClass:[NSNull class]]) {
                _submitDict = _dataDict;
                user.verifyStatus = [[_dataDict objectForKey:@"verificationStatus"] intValue];
                
                user.studentVerificationStatus = [[_dataDict objectForKey:@"studentVerificationStatus"] intValue];
                [NSUserDefaultsUtil setLoginUser:user];
                if (![[_dataDict objectForKey:@"realName"] isEqualToString:@""] && [_dataDict objectForKey:@"realName"] != nil && ![[_dataDict objectForKey:@"realName"] isKindOfClass:[NSNull class]]) {
                    [_placehodeArray replaceObjectAtIndex:0 withObject:@[[_dataDict objectForKey:@"realName"]]];
                }
                if (![[_dataDict objectForKey:@"idCardNo"] isEqualToString:@""] && [_dataDict objectForKey:@"idCardNo"] != nil && ![[_dataDict objectForKey:@"idCardNo"] isKindOfClass:[NSNull class]]) {
                    [_placehodeArray replaceObjectAtIndex:1 withObject:@[[_dataDict objectForKey:@"idCardNo"]]];

                }
                if (![[_dataDict objectForKey:@"collegeName"] isEqualToString:@""] && [_dataDict objectForKey:@"collegeName"] != nil && ![[_dataDict objectForKey:@"collegeName"] isKindOfClass:[NSNull class]] && ![[_dataDict objectForKey:@"studentId"] isEqualToString:@""] && [_dataDict objectForKey:@"studentId"] != nil && ![[_dataDict objectForKey:@"studentId"] isKindOfClass:[NSNull class]]) {
                    [_placehodeArray replaceObjectAtIndex:2 withObject:@[[_dataDict objectForKey:@"collegeName"],[_dataDict objectForKey:@"studentId"]]];
                }
            }
            if (_dataDict == nil || [_dataDict isKindOfClass:[NSNull class]]) {
                [_submitDict setObject:[NSNumber numberWithInt:HXVerifyStatusUncommit] forKey:@"verificationStatus"];
                [_submitDict setObject:[NSNumber numberWithInt:HXVerifyStatusUncommit] forKey:@"studentVerificationStatus"];
            }

            [_myTableView reloadData];
            [self addData];
        }
    }];
}
- (void)createUI{
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 999)];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [footView addSubview:lineLabel];
    
    UILabel *shimingLabel = [[UILabel alloc]init];
    shimingLabel.text = @"*实名必填";
    shimingLabel.textColor = LightBlueColor;
    shimingLabel.textAlignment = NSTextAlignmentLeft;
    shimingLabel.font = [UIFont systemFontOfSize:12];
    [footView addSubview:shimingLabel];
    [shimingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footView).with.offset(5);
        make.left.equalTo(footView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 40)/2, 15));
    }];
    
    UILabel *shigeLabel = [[UILabel alloc]init];
    shigeLabel.text = @"*师哥必填";
    shigeLabel.textColor = LightBlueColor;
    shigeLabel.textAlignment = NSTextAlignmentLeft;
    shigeLabel.font = [UIFont systemFontOfSize:12];
    [footView addSubview:shigeLabel];
    [shigeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footView).with.offset(5);
        make.right.equalTo(footView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 40)/2, 15));
    }];

    
    
    _groupPhoto = [[UIImageView alloc]init];
    _groupPhoto.tag = 100;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPic:)];
    [_groupPhoto addGestureRecognizer:tap];
    [footView addSubview:_groupPhoto];
    [_groupPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footView).with.offset(23);
        make.left.equalTo(footView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 40)/2, 100));
    }];
    
    _studentCard = [[UIImageView alloc]init];
    _studentCard.tag = 101;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPic:)];
    [_studentCard addGestureRecognizer:tap1];
    [footView addSubview:_studentCard];
    [_studentCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footView).with.offset(23);
        make.right.equalTo(footView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 40)/2, 100));
    }];

    _groupTitle = [[UILabel alloc]init];
    _groupTitle.font = [UIFont systemFontOfSize:10];
    _groupTitle.textAlignment = NSTextAlignmentLeft;
//    HXVerifyStatusSuccessed=1,//认证成功
//    HXVerifyStatusFailed =2, //认证失败
//    HXVerifyStatusUncommit=5, //未提交认证
//    HXVerifyStatusCommited=4, //认证已提交
      _groupTitle.textColor = [UIColor lightGrayColor];
    [footView addSubview:_groupTitle];
    [_groupTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_groupPhoto.mas_bottom).with.offset(0);
        make.left.equalTo(footView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 40)/2, 20));
    }];
    
    
    studentTitle = [[UILabel alloc]init];
    studentTitle.font = [UIFont systemFontOfSize:10];
    studentTitle.textAlignment = NSTextAlignmentLeft;


    studentTitle.textColor = [UIColor lightGrayColor];
    [footView addSubview:studentTitle];
    [studentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_studentCard.mas_bottom).with.offset(0);
        make.left.equalTo(_groupPhoto.mas_right).with.offset(20);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 40)/2, 20));
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor redColor];
    titleLabel.text = @"温馨提示:";
    [footView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_groupTitle.mas_bottom).with.offset(15);
        make.left.equalTo(footView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    UILabel *infoLabel = [[UILabel alloc]init];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.textColor = [UIColor grayColor];
    infoLabel.numberOfLines = 0;
    infoLabel.font = [UIFont systemFontOfSize:12];
    infoLabel.text = @"1.为确保成功认证,请上传真实有效的身份信息;\n2.中国大陆居民:居民身份证或临时居民身份证;\n3.港澳居民:持港澳居民来往内地通行证(回乡证)到线下网店认证;\n4.台湾居民:持台湾居民来往大陆通行证(台胞证)到线下网店认证;\n5.外国公民:持护照到线下网店认证;";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:infoLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [infoLabel.text length])];
    infoLabel.attributedText = attributedString;
    
    CGSize size=[infoLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, 250) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    [footView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(0);
        make.left.equalTo(footView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 20, size.height+45));
    }];
    

    resultLabel = [[UILabel alloc]init];
    resultLabel.layer.masksToBounds = YES;
    resultLabel.layer.cornerRadius = 20;
    resultLabel.textAlignment = NSTextAlignmentCenter;
    resultLabel.backgroundColor = [UIColor grayColor];
    resultLabel.textColor = [UIColor whiteColor];
    [footView addSubview:resultLabel];
    
    [resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoLabel.mas_bottom).with.offset(20);
        make.centerX.equalTo(footView);
        make.size.mas_equalTo (CGSizeMake(SCREEN_WIDTH - 60, 40));
    }];
    
    submitBt = [UIButton buttonWithType:UIButtonTypeCustom];
//    if ([[_dataDict objectForKey:@"studentVerificationStatus"]intValue] == 1 && [[_dataDict objectForKey:@"verificationStatus"] intValue] == 1) {
//        [submitBt setBackgroundColor:[UIColor grayColor]];
//        [submitBt setTitle:@"已完成认证" forState:UIControlStateNormal];
//        submitBt.userInteractionEnabled = NO;
//    }else{
//        submitBt.userInteractionEnabled = YES;
//        [submitBt setBackgroundColor:RGBA(1, 171, 253, 1.0)];
//        [submitBt setTitle:@"提交" forState:UIControlStateNormal];
//    }
    submitBt.layer.cornerRadius = 20;
    [submitBt addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:submitBt];
    [submitBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(resultLabel.mas_bottom).with.offset(10);
        make.centerX.equalTo(footView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, 40));
    }];

    footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 420+size.height);
    _myTableView.tableFooterView = footView;
    
//    _showImageView  = [[HXShowImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    _showImageView.hidden = YES;
//    [_showImageView getButtonBlock:^(UIButton *button) {
//        [weakSelf gotoButtonClick:button];
//    }];
//    [_myTableView addSubview:_showImageView];
//    [_showImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_myTableView).with.offset(0);
//        make.top.equalTo(_myTableView).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
//    }];
//
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe];
    [self addData];
}
- (void)hideKeyBoard{
    [_currentField resignFirstResponder];
}

- (void)gotoButtonClick:(UIButton *)button{
    switch (button.tag - 100) {
        case 0:
        {
            [ContextUtil selectPhoto:self];
        }
            break;
        case 1:
        {
            [ContextUtil takePhoto:self];
        }
            break;
        case 2:
        {
            if (_showImageView.backImageView.image == nil) {
                break;
            }else
                [self savePhoto:_showImageView.backImageView.image];
        }
            break;
        case 3:
        {
            _showImageView.backImageView.image = nil;
            _showImageView.noLabel.hidden = YES;
            _showImageView.hidden = YES;
        }
            break;
        default:
            break;
    }
}
//保存图片到本地
-(void)savePhoto:(UIImage *)image{
    _showImageView.hidden = YES;
    if (currentShow == 0) {
        [_groupPhoto setImage:_showImageView.backImageView.image];
        [_submitDict setObject:_showImageView.backImageView.image forKey:@"idCard"];
    }else{
        [_studentCard setImage:_showImageView.backImageView.image];
        [_submitDict setObject:_showImageView.backImageView.image forKey:@"studentCard"];
    }
    
    return;
//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}
// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    _showImageView.noLabel.hidden = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
//    _showImageView.backImageView.hidden = NO;
//    [_showImageView.backImageView setImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    if (currentShow == 0) {
        [_groupPhoto setImage:image];
        [_submitDict setObject:image forKey:@"idCardPicture"];
    }else{
        [_studentCard setImage:image];
        [_submitDict setObject:image forKey:@"studentCardPicture"];
    }
    

}


- (void)submit{
    [_currentField resignFirstResponder];
    NSMutableDictionary *imageDataDic = [NSMutableDictionary dictionary];
  
    if (_dataDict == nil || [_dataDict isKindOfClass:[NSNull class]]) {
        [_submitDict setObject:[NSNumber numberWithInt:HXVerifyStatusUncommit] forKey:@"verificationStatus"];
        [_submitDict setObject:[NSNumber numberWithInt:HXVerifyStatusUncommit] forKey:@"studentVerificationStatus"];
    }
    if ([[_submitDict objectForKey:@"verificationStatus"] intValue] == HXVerifyStatusFailed || [[_submitDict objectForKey:@"verificationStatus"] intValue] == HXVerifyStatusUncommit) {
    if ([_submitDict objectForKey:@"idCardPicture"] != nil || (![[_submitDict objectForKey:@"realName"] isEqualToString:@""] && [_submitDict objectForKey:@"realName"] != nil) || (![[_submitDict objectForKey:@"idCardNo"] isEqualToString:@""] && [_submitDict objectForKey:@"idCardNo"] != nil)) {
        if ([_submitDict objectForKey:@"idCardPicture"] == nil || ![[_submitDict objectForKey:@"idCardPicture"] isKindOfClass:[UIImage class]]) {
            [HXAlertViewEx showInTitle:nil Message:@"请选择实名认证照片" ViewController:self];
            return;
        }
        if (([[_submitDict objectForKey:@"realName"] isEqualToString:@""] || [_submitDict objectForKey:@"realName"] == nil)) {
                [HXAlertViewEx showInTitle:nil Message:@"请填写姓名" ViewController:self];
                return;
            }
        if ([[_submitDict objectForKey:@"idCardNo"] isEqualToString:@""] || [_submitDict objectForKey:@"idCardNo"] == nil){
                [HXAlertViewEx showInTitle:nil Message:@"请填写您的身份证号码" ViewController:self];
                return;
            }
        if (![HXNSStringUtil isIdCardNumber:[_submitDict objectForKey:@"idCardNo"]]){
            [HXAlertViewEx showInTitle:nil Message:@"身份证号码格式不合法，请重新填写" ViewController:self];
            return;
            }
        isCard = YES;
        [imageDataDic setObject:UIImagePNGRepresentation([_submitDict objectForKey:@"idCardPicture"]) forKey:@"idCardPicture"];

        }
            }
    if ([[_submitDict objectForKey:@"studentVerificationStatus"] intValue] ==HXVerifyStatusFailed || [[_submitDict objectForKey:@"studentVerificationStatus"] intValue] == HXVerifyStatusUncommit) {
        if ([_submitDict objectForKey:@"studentCardPicture"] != nil || (![[_submitDict objectForKey:@"collegeName"] isEqualToString:@""]&& [_submitDict objectForKey:@"collegeName"] != nil) || (![[_submitDict objectForKey:@"studentId"] isEqualToString:@""]&& [_submitDict objectForKey:@"studentId"] != nil))
    {
        if ([_submitDict objectForKey:@"studentCardPicture"] == nil || ![[_submitDict objectForKey:@"studentCardPicture"] isKindOfClass:[UIImage class]]) {
            [HXAlertViewEx showInTitle:nil Message:@"请选择师哥认证照片" ViewController:self];
            return;
        }
        if([[_submitDict objectForKey:@"realName"] isEqualToString:@""]|| [_submitDict objectForKey:@"realName"] == nil){
            [HXAlertViewEx showInTitle:nil Message:@"请填写姓名" ViewController:self];
            return;
        }else if ([[_submitDict objectForKey:@"collegeName"] isEqualToString:@""]|| [_submitDict objectForKey:@"collegeName"] == nil){
            [HXAlertViewEx showInTitle:nil Message:@"请填写学校名称" ViewController:self];
            return;
        }else if ([[_submitDict objectForKey:@"studentId"] isEqualToString:@""]|| [_submitDict objectForKey:@"studentId"] == nil){
            [HXAlertViewEx showInTitle:nil Message:@"请填写您的学号" ViewController:self];
            return;
        }
        isStudent = YES;
        [imageDataDic setObject:UIImagePNGRepresentation([_submitDict objectForKey:@"studentCardPicture"]) forKey:@"studentCardPicture"];

    }
            }
    if (!isCard && !isStudent){
        [HXAlertViewEx showInTitle:nil Message:@"请填写认证信息" ViewController:self];
        return;
    }
    [HXLoadingImageView showLoadingView:self.view];

    HXLoginUser *user = [NSUserDefaultsUtil getLoginUser];
    
    NSString*skey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,user.token]];
    NSDictionary *paramDict = [NSDictionary dictionary];
    int styleType=0;
    if (isCard) {
        if (isStudent) {
            //实名师哥同时认证
            styleType=HXBothStyle;
            paramDict = @{@"phoneNumber":user.phoneNumber,@"sKey":skey,@"realName":[_submitDict objectForKey:@"realName"],@"idCardNo":[_submitDict objectForKey:@"idCardNo"],@"collegeName":[_submitDict objectForKey:@"collegeName"],@"studentId":[_submitDict objectForKey:@"studentId"]};
        }else{
            //只实名
            styleType=HXRealNameStyle;
            paramDict = @{@"phoneNumber":user.phoneNumber,@"sKey":skey,@"realName":[_submitDict objectForKey:@"realName"],@"idCardNo":[_submitDict objectForKey:@"idCardNo"],@"collegeName":@"",@"studentId":@""};
            for (NSString *key in imageDataDic) {
                if ([key isEqualToString:@"studentCardPicture"]) {
                    [imageDataDic removeObjectForKey:@"studentCardPicture"];
                }
            }
        }
    }else if(isStudent){
        //只进行师哥认证
        styleType=HXStudentStyle;
        paramDict = @{@"phoneNumber":user.phoneNumber,@"sKey":skey,@"realName":[_submitDict objectForKey:@"realName"],@"idCardNo":@"",@"collegeName":[_submitDict objectForKey:@"collegeName"],@"studentId":[_submitDict objectForKey:@"studentId"]};
        for (NSString *key  in imageDataDic) {
            if ([key isEqualToString:@"idCardPicture"]) {
                [imageDataDic removeObjectForKey:@"idCardPicture"];
            }
        }
    }
    [HXHttpUtils requestJsonFormDataPostWithUrlStr:@"/user/submitVerification" params:paramDict ImgDataParams:imageDataDic showHud:YES onComplete:^(NSError *error, NSDictionary *resultJson) {
        [HXLoadingImageView hideViewForView:self.view];
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
//            _dataDict = [resultJson objectForKey:@"content"];
            [HXAlertViewEx showInTitle:nil Message:@"认证信息已提交" ViewController:self];
            _dataDict = _submitDict;
            switch (styleType) {
                case HXBothStyle:{
                    [_dataDict setObject:[NSNumber numberWithInt:HXVerifyStatusCommited] forKey:@"verificationStatus"];
                    [_dataDict setObject:[NSNumber numberWithInt:HXVerifyStatusCommited] forKey:@"studentVerificationStatus"];
                    user.verifyStatus=HXVerifyStatusCommited;
                    user.idCardNo=[_submitDict objectForKey:@"idCardNo"];
                    user.studentVerificationStatus=HXVerifyStatusCommited;
                    user.studentId=[_submitDict objectForKey:@"studentId"];
                };break;
                case HXRealNameStyle:{
                    [_dataDict setObject:[NSNumber numberWithInt:HXVerifyStatusCommited] forKey:@"verificationStatus"];
                    user.verifyStatus=HXVerifyStatusCommited;
                    user.idCardNo=[_submitDict objectForKey:@"idCardNo"];
                };break;
                case HXStudentStyle:{
                    [_dataDict setObject:[NSNumber numberWithInt:HXVerifyStatusCommited] forKey:@"studentVerificationStatus"];
                    user.studentVerificationStatus=HXVerifyStatusCommited;
                    user.studentId=[_submitDict objectForKey:@"studentId"];
                };break;
                default:
                    break;
            }
            [NSUserDefaultsUtil setLoginUser:user];
            [self addData];
        }
    }];
  
    NSLog(@"提交认证");
    
}
- (void)addPic:(UITapGestureRecognizer *)tap{
    if (_currentField) {
        [_currentField resignFirstResponder];
    }
    NSLog(@"进入相册");
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择本地图片",@"拍照", nil];
    actionSheet.tag  = tap.view.tag;
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];

}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        currentShow = 0;
    }else{
        currentShow = 1;
    }
    if (buttonIndex == 0){
        [ContextUtil selectPhoto:self];
    }else if (buttonIndex == 1){
        [ContextUtil takePhoto:self];
    }
}

//- (void)addPic:(UITapGestureRecognizer *)tap{
//    [_currentField resignFirstResponder];
//    NSLog(@"添加图片 %ld",tap.view.tag);
//    if (tap.view.tag == 100) {
//        currentShow = 0;
//        [_showImageView bringSubviewToFront:self.view];
//        _showImageView.hidden = NO;
//        if (_dataDict == nil) {
//            if ([_submitDict objectForKey:@"idCardPicture"] == nil) {
//                _showImageView.backImageView.hidden = YES;
//                _showImageView.noLabel.hidden = NO;
//            }else
//                [_showImageView.backImageView setImage:[UIImage imageNamed:[_submitDict objectForKey:@"idCardPicture"]]];
//        }else{
//            [_showImageView.backImageView setImageWithURL:[NSURL URLWithString:[_dataDict objectForKey:@"idCardPicture"]] placeholderImage:HXDefaultImg];;
//        }
//    }else if (tap.view.tag == 101){
//        currentShow = 1;
//        [_showImageView bringSubviewToFront:self.view];
//        _showImageView.hidden = NO;
//        if (_dataDict == nil) {
//            if ([_submitDict objectForKey:@"studentCardPicture"] == nil) {
//                _showImageView.backImageView.hidden = YES;
//                _showImageView.noLabel.hidden = NO;
//            }else
//                [_showImageView.backImageView setImage:[UIImage imageNamed:[_submitDict objectForKey:@"studentCardPicture"]]];
//        }else{
//            [_showImageView.backImageView setImageWithURL:[NSURL URLWithString:[_dataDict objectForKey:@"studentCardPicture"]] placeholderImage:HXDefaultImg];;
//        }
//
//    }
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_titleArray objectAtIndex:section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIde = @"cellIde";
    HXCertificationTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell == nil) {
        cell = [[HXCertificationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentTF.delegate = self;
        cell.contentTF.returnKeyType=UIReturnKeyDone;
    }
    [cell.iconImageView setImage:[[_iconArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    cell.titleLabel.text = [[_titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    
    cell.contentTF.tag = 100 * indexPath.section +indexPath.row;
//    cell.biaozhiLabel.text = [biaozhiArray objectAtIndex:indexPath.row];
    if (_dataDict == nil || [_dataDict isKindOfClass:[NSNull class]]) {
        cell.contentTF.placeholder = [[_placehodeArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }else if ([[_dataDict objectForKey:@"verificationStatus"] isKindOfClass:[NSNull class]] || [_dataDict objectForKey:@"verificationStatus"]==nil){
        cell.contentTF.placeholder = [[_placehodeArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }else if ([[_dataDict objectForKey:@"studentVerificationStatus"] isKindOfClass:[NSNull class]] || [_dataDict objectForKey:@"studentVerificationStatus"]==nil)
    {
        cell.contentTF.placeholder = [[_placehodeArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    else
    {
        switch (indexPath.section) {
            case 0:
            {
                if ([[_dataDict objectForKey:@"verificationStatus"] intValue] == 1 || [[_dataDict objectForKey:@"verificationStatus"] intValue] == 4 || [[_dataDict objectForKey:@"studentVerificationStatus"] intValue] == 1 || [[_dataDict objectForKey:@"studentVerificationStatus"] intValue] == 4) {
                    cell.contentTF.userInteractionEnabled = NO;
                }else
                    cell.contentTF.userInteractionEnabled = YES;
                cell.contentTF.text = [_dataDict objectForKey:@"realName"];
            }
                break;
            case 1:
            {
                if ([[_dataDict objectForKey:@"verificationStatus"] intValue] == 1 || [[_dataDict objectForKey:@"verificationStatus"] intValue] == 4) {
                    cell.contentTF.userInteractionEnabled = NO;
                }else
                    cell.contentTF.userInteractionEnabled = YES;

                cell.contentTF.text = [_dataDict objectForKey:@"idCardNo"];
            }
                break;
            case 2://studentVerificationStatus
            {
                if (indexPath.row == 0) {
                    cell.contentTF.text = [_dataDict objectForKey:@"collegeName"];

                    if ([[_dataDict objectForKey:@"studentVerificationStatus"] intValue] == 1 || [[_dataDict objectForKey:@"studentVerificationStatus"] intValue] == 4) {
                        cell.contentTF.userInteractionEnabled = NO;
                    }else{
                    cell.contentTF.userInteractionEnabled = YES;
                    }
                }else{
                    if ([[_dataDict objectForKey:@"studentVerificationStatus"] intValue] == 1 || [[_dataDict objectForKey:@"studentVerificationStatus"] intValue] == 4) {
                        cell.contentTF.userInteractionEnabled = NO;
                    }else
                        cell.contentTF.userInteractionEnabled = YES;
                    cell.contentTF.text = [_dataDict objectForKey:@"studentId"];
                    cell.contentTF.keyboardType = UIKeyboardTypeNumberPad;
                }
            }
                break;
                default:
                break;
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else{
        return 20;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return nil;
    }else if (section == 1){
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        headView.backgroundColor = BackGroundColor;
        UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 10, 20)];
        headLabel.text = @"实名认证必填";
        headLabel.font = [UIFont systemFontOfSize:14];
        headLabel.textColor = [UIColor grayColor];
        headLabel.textAlignment = NSTextAlignmentLeft;
        [headView addSubview:headLabel];
        return headView;
    }else{
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        headView.backgroundColor = BackGroundColor;
        UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 10, 20)];
        headLabel.text = @"大师哥认证必填";
        headLabel.font = [UIFont systemFontOfSize:14];
        headLabel.textColor = [UIColor grayColor];
        headLabel.textAlignment = NSTextAlignmentLeft;
        [headView addSubview:headLabel];
        return headView;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 2) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"USER_SCHOOL" object:nil];
//        HXGetSchoolViewController *getSchool = [[HXGetSchoolViewController alloc]init];
//        [self.navigationController pushViewController:getSchool animated:YES];
//    }
}
-(void)notification:(NSNotification *)noti{
    if ([noti.name isEqualToString:@"USER_SCHOOL"]) {
        AMapPOI *poi = noti.object;
        [_dataDict setObject:poi.uid forKey:@"collegeNo"];
        [_dataDict setObject:poi.name forKey:@"collegeName"];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
        [_myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"USER_SCHOOL" object:nil];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    _currentField = nil;
    switch (textField.tag /100) {
        case 0:
            [_submitDict setObject:textField.text forKey:@"realName"];
            break;
        case 1:
            [_submitDict setObject:textField.text forKey:@"idCardNo"];
            break;
        case 2:
            if (textField.tag % 100 == 0) {
            [_submitDict setObject:textField.text forKey:@"collegeName"];
            }else{
                [_submitDict setObject:textField.text forKey:@"studentId"];
            }
            break;
        default:
            break;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _currentField  = textField;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    _currentField = nil;
    switch (textField.tag / 100) {
        case 0:
            [_submitDict setObject:textField.text forKey:@"realName"];
            break;
        case 1:
            [_submitDict setObject:textField.text forKey:@"idCardNo"];
            break;
        case 2:
            if (textField.tag % 100 == 0) {
                [_submitDict setObject:textField.text forKey:@"collegeName"];
            }else{
                [_submitDict setObject:textField.text forKey:@"studentId"];
            }
            break;
        default:
            break;
    }
    [textField resignFirstResponder];
        return YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_currentField != nil) {
        [_currentField resignFirstResponder];
        _currentField = nil;
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
