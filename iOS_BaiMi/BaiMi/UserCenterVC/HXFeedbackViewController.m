//
//  HXFeedbackViewController.m
//  BaiMi
//
//  Created by HXMAC on 16/7/12.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXFeedbackViewController.h"
#import "Masonry.h"
@interface HXFeedbackViewController ()<UITextViewDelegate,UIAlertViewDelegate>

{
    UITextView *_textView;
    UILabel *_numLabel;
}
@end

@implementation HXFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    self.view.backgroundColor = BackGroundColor;
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 30);
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
    [self createUI];
}
- (void)submit{
    [_textView resignFirstResponder];
    NSLog(@"提交");
    if (_textView.text == nil || [_textView.text isEqualToString:@""]) {
        [HXAlertViewEx showInTitle:nil Message:@"请输入文字" ViewController:self];
        return;
    }else if(_textView.text.length > 250){
        [HXAlertViewEx showInTitle:nil Message:@"文字长度不能超过250个字" ViewController:self];
        return;
    }
    HXLoginUser *user = [NSUserDefaultsUtil getLoginUser];
    NSString *content = _textView.text;
    NSString*skey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/common/feedBack" params:@{@"content":content,@"sKey":skey,@"phoneNumber":user.phoneNumber} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
        }else{
            [HXAlertViewEx showInTitle:nil Message:@"发送成功" ViewController:self];
            _textView.text = @"";
            _numLabel.text = [NSString stringWithFormat:@"字数:0/250"];
        }
    }];
}
- (void)createUI{
    __weak typeof (self)weakSelf = self;
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"反馈内容:";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).with.offset(10);
        make.left.equalTo(weakSelf.view).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    _textView = [[UITextView alloc]init];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 5;
    _textView.layer.borderColor = LightBlueColor.CGColor;
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).with.offset(5);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 10, 150));
    }];
    
    UILabel *servicePhone = [[UILabel alloc]init];
    servicePhone.textColor = [UIColor blackColor];
    servicePhone.font = [UIFont systemFontOfSize:16];
    servicePhone.userInteractionEnabled = YES;
    servicePhone.textAlignment = NSTextAlignmentLeft;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callPhone)];
    [servicePhone addGestureRecognizer:tap];
    NSString *servicePhoneStr = [NSString stringWithFormat:@"客服电话:%@",HX_ServicePhone];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:servicePhoneStr];
    NSRange redRange = NSMakeRange(5, noteStr.length-[[noteStr string] rangeOfString:@":"].location - 1);
    [noteStr addAttribute:NSForegroundColorAttributeName value:LightBlueColor range:redRange];
    [servicePhone setAttributedText:noteStr] ;
    [self.view addSubview:servicePhone];
    CGSize size = [servicePhoneStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:servicePhone.font,NSFontAttributeName, nil]];
    [servicePhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).with.offset(5);
        make.top.equalTo(_textView.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(size.width + 5, 30));
    }];
    
    _numLabel = [[UILabel alloc]init];
    _numLabel.font = [UIFont systemFontOfSize:16];
    _numLabel.text = [NSString stringWithFormat:@"字数:0/250"];
    _numLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_numLabel];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).with.offset(-5);
        make.top.equalTo(_textView.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe];
}
- (void)hideKeyBoard{
    [_textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length <= 250) {
        _numLabel.textColor = [UIColor blackColor];
        _numLabel.text = [NSString stringWithFormat:@"字数:%lu/250",(unsigned long)textView.text.length];
    }else{
        _numLabel.textColor = [UIColor redColor];
        _numLabel.text = [NSString stringWithFormat:@"字数:%lu/250",(unsigned long)textView.text.length];
    }
}
- (void)callPhone{
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:HX_ServicePhone message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alter show];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",HX_ServicePhone]] options:[NSDictionary dictionary] completionHandler:^(BOOL success) {
            NSLog(@"openSuccess:%d",success);
        }];
        }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",HX_ServicePhone]]];
        }
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
