//
//  HXSGCertificationViewController.m
//  BaiMi
//
//  Created by 王放 on 16/7/9.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXSGCertificationViewController.h"
#import "HXSGCertificationCell.h"
#import "HXSGEvaluationViewController.h"
#import "ContextUtil.h"
@interface HXSGCertificationViewController ()

@property(strong,nonatomic)UILabel *labelRealName;//姓名
@property(strong,nonatomic)UILabel *labelPhoneNumber;//电话
@property(strong,nonatomic)UILabel *labelStudentId;//学号
@property(strong,nonatomic)UILabel *labelStudentCardNo;//身份证号
@property(strong,nonatomic)UILabel *cerLabel;//是否认证认证
@property(strong,nonatomic)HXLoginUser *user;

@property(assign,nonatomic)BOOL weatherCertification;
@end

@implementation HXSGCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"师哥名片";
    self.view.backgroundColor = BackGroundColor;
    [self httpServiceGetMes];
    // Do any additional setup after loading the view.
}
-(void)createUI{
    if (_user.studentVerificationStatus != HXVerifyStatusSuccessed) {
        UILabel *imageView =[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 80)/2.0, 100, 80, 80)];
        imageView.text = @"!";
        imageView.layer.cornerRadius = 40;
        imageView.clipsToBounds = YES;
        imageView.textColor = [UIColor whiteColor];
        imageView.backgroundColor = [UIColor lightGrayColor];
        imageView.textAlignment = NSTextAlignmentCenter;
        imageView.font = [UIFont systemFontOfSize:40];
        [self.view addSubview:imageView];
        for (int i = 0; i<2; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 185 + i * 30, SCREEN_WIDTH, 40)];
            if (i==0) {
                label.text =  HXVerifyStr(_user.studentVerificationStatus);
            }else{
                if (_user.studentVerificationStatus==HXVerifyStatusUncommit)
                    label.text = @"请去个人中心——信息认证中进行师哥认证！";
                else if(_user.studentVerificationStatus==HXVerifyStatusFailed)
                    label.text = @"请去个人中心——信息认证中重新提交师哥认证信息！";
                else
                    label.text=@"";
            }
            label.textColor = [UIColor lightGrayColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14.];
            [self.view addSubview:label];
        }
        return;
    }
   NSArray *arrayTitle = [[NSArray alloc] initWithObjects:@"姓名",@"学号",@"联系方式",@"身份证号码",@"师哥评价", nil];
    for (int i = 0; i<arrayTitle.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 20 + i * 45, SCREEN_WIDTH, 44)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        if (i<arrayTitle.count-1) {
            NSString *title = [arrayTitle objectAtIndex:i];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, STRING_SIZE_FONT(200, title, 17.).width, 44)];
            label.text = title;
            label.textColor = RGBA(113, 114, 115, 1);
            [view addSubview:label];
            UILabel *labelShow = [[UILabel alloc]initWithFrame:CGRectMake(ViewFrame_X(label)+ViewFrame_W(label)+10, 0, SCREEN_WIDTH - (ViewFrame_X(label)+ViewFrame_W(label)+10), 44)];
            [view addSubview:labelShow];
            if (i==0) {
                labelShow.text = _user.realName;
                _labelRealName = labelShow;
                NSString *stringType = HXVerifyStr(_user.studentVerificationStatus);
                float stringLength = STRING_SIZE_FONT(200, stringType, 17).width;
                _cerLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - stringLength - 10, 0, stringLength, 44)];
                _cerLabel.text = stringType;
                _cerLabel.textAlignment = NSTextAlignmentRight;
                _cerLabel.textColor = RGBA(37, 168, 45, 1);
                [view addSubview:_cerLabel];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ViewFrame_X(_cerLabel)-25, 7, 23, 30)];
                imageView.image = [UIImage imageNamed:@"ico_ren"];
                [view addSubview:imageView];
                
            }else if (i==1){
                labelShow.text = _user.studentId;
                _labelStudentId = labelShow;
            }else if (i==2){
                labelShow.text = _user.phoneNumber;
                _labelPhoneNumber = labelShow;
            }else if (i==3){
                labelShow.text = _user.idCardNo;
                _labelStudentCardNo = labelShow;
            }
        }else{
            view.frame = CGRectMake(0, 20 + i * 45 + 20, SCREEN_WIDTH, 44);
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 40, 30)];
            imageView.image = [UIImage imageNamed:@"ico_mingpian"];
            [view addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(ViewFrame_X(imageView)+ViewFrame_W(imageView)+10, 0, 80, 44)];
            label.text = [arrayTitle objectAtIndex:i];
            [view addSubview:label];
            UIImageView *imageViewArrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20, 12, 10, 20)];
            imageViewArrow.image = [UIImage imageNamed:@"ico_youjiantou"];
            [view addSubview:imageViewArrow];
            UITapGestureRecognizer*tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
            [view addGestureRecognizer:tapGesture];
        }
    }
}

-(void)tapGesture:(UITapGestureRecognizer *)sender{
    //点击师哥名片
    if (_user.studentVerificationStatus != HXVerifyStatusSuccessed)return;
    [self.navigationController pushViewController:[[HXSGEvaluationViewController alloc] init] animated:YES];
}

-(void)httpServiceGetMes{
    _user = [NSUserDefaultsUtil getLoginUser];
    NSString*skey=[HXNSStringUtil getSkeyByParamInfo:@[_user.phoneNumber,_user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/studentVisitCard" params:@{@"phoneNumber":_user.phoneNumber,@"sKey":skey} onComplete:^(NSError *error, NSDictionary *resultJson) {
        NSLog(@"师哥信息 %@",resultJson);
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            NSDictionary *dicResult = [resultJson objectForKey:@"content"];
            if (![dicResult isEqual:[NSNull null]]) {
                _user.realName = [HXHttpUtils whetherNil:[dicResult objectForKey:@"realName"]];
                _user.studentId = [HXHttpUtils whetherNil:[dicResult objectForKey:@"studentNo"]];
                _user.idCardNo = [HXHttpUtils whetherNil:[dicResult objectForKey:@"idCardNo"]];
            }
            
            [self createUI];
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
