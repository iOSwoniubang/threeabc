//
//  HXMyTaskCell.m
//  BaiMi
//
//  Created by 王放 on 16/7/16.
//  Copyright © 2016年 licl. All rights reserved.
//

#define TXTFONT [UIFont systemFontOfSize:12.]

#import "HXMyTaskCell.h"

@implementation HXMyTaskCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        _iconImageView.clipsToBounds = YES;
        _iconImageView.backgroundColor = [UIColor yellowColor];
        _iconImageView.layer.cornerRadius = 20.;
        [self addSubview:_iconImageView];
        
        _feeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60,10,SCREEN_WIDTH/2.0-60+12,20)];
        _feeLabel.textColor = RGBA(216, 95, 32, 1);
        NSLog(@"2222  %f  %f",STRING_SIZE_FONT(200, @"重量约20kg以上", 12).width,STRING_SIZE_FONT(200, @"收件地址：", 12).width);
        _feeLabel.font = [UIFont systemFontOfSize:15.];
        [self addSubview:_feeLabel];
        
        _weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(60,30,SCREEN_WIDTH/2.0-60+12,20)];
        _weightLabel.font = TXTFONT;
        _weightLabel.textColor = LightBlueColor;
        [self addSubview:_weightLabel];
        
        UILabel *verticalLine = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0+13, 17, 2, 25)];
        verticalLine.backgroundColor = BackGroundColor;
        [self addSubview:verticalLine];
        
        _acceptTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0+15, 10, SCREEN_WIDTH/2.0-25,20)];
        _acceptTimeLabel.font = [UIFont systemFontOfSize:10];
        _acceptTimeLabel.textColor = LightBlueColor;
        _acceptTimeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_acceptTimeLabel];
        
        _completeTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake( SCREEN_WIDTH/2.0+15, 10+20,  SCREEN_WIDTH/2.0-25,20)];
        _completeTimeLabel.font = [UIFont systemFontOfSize:10];
        _completeTimeLabel.textColor = LightBlueColor;
        _completeTimeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_completeTimeLabel];
        
        UIView *crossLine = [[UIView alloc] initWithFrame:CGRectMake(10,58, SCREEN_WIDTH - 20, 2)];
        [self addSubview:crossLine];
        [self drawDashLine:crossLine lineLength:3 lineSpacing:5 lineColor:BackGroundColor];
        float labelTitleWid = STRING_SIZE_FONT(200, @"取件地址：", 12.).width;
        UILabel *sourceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, labelTitleWid, 20)];
        sourceTitleLabel.font = TXTFONT;
        sourceTitleLabel.text = @"取件地址：";
        [self addSubview:sourceTitleLabel];
        _sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+labelTitleWid, 70, SCREEN_WIDTH-20-labelTitleWid, 20)];
        _sourceLabel.font = TXTFONT;
        [self addSubview:_sourceLabel];
        
        UILabel *targetTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, labelTitleWid, 20)];
        targetTitleLabel.text = @"收件地址：";
        targetTitleLabel.font = TXTFONT;
        [self addSubview:targetTitleLabel];
        _targetLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+labelTitleWid, 100, SCREEN_WIDTH-20-labelTitleWid, 20)];
        _targetLabel.font = TXTFONT;
        [self addSubview:_targetLabel];
        
        
        _changeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, 50, 20)];
        _changeTitleLabel.font = TXTFONT;
        
        [self addSubview:_changeTitleLabel];
    }
    return self;
}
-(UILabel *)fetcherNickNameLabel{
    if (!_fetcherNickNameLabel) {
        _fetcherNickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 130, SCREEN_WIDTH-70, 20)];
        _fetcherNickNameLabel.font = TXTFONT;
        _changeTitleLabel.frame = CGRectMake(10, 130, 50, 20);
        _changeTitleLabel.text = @"发布人：";
        _fetcherNickNameLabel.textColor = LightBlueColor;
        _changeTitleLabel.textColor = LightBlueColor;
        [self addSubview:_fetcherNickNameLabel];
//        [_terminationLabel removeFromSuperview];
//        [_remarkLabel removeFromSuperview];
//        _remarkLabel = nil;
//        _terminationLabel = nil;
    }
    return _fetcherNickNameLabel;
}
-(UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 130, SCREEN_WIDTH-60, 20)];
        _remarkLabel.font = TXTFONT;
        _changeTitleLabel.frame = CGRectMake(10, 130, 40, 20);
        _changeTitleLabel.text = @"留言：";
        _remarkLabel.textColor = LightBlueColor;
        _changeTitleLabel.textColor = LightBlueColor;
        [self addSubview:_remarkLabel];
       
        
        
       
        
    }
    return _remarkLabel;
}
-(UIView *)praiseView{
    if (!_praiseView) {
        _praiseView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 120, 50, 40)];
        [self addSubview:_praiseView];
        UIImageView *praiseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
        praiseImageView.image = [UIImage imageNamed:@"ico_zan"];
        [_praiseView addSubview:praiseImageView];
    }
    return _praiseView;
}
-(UIView *)contemptView{
    if (!_contemptView) {
        _contemptView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50, 120, 50, 40)];
        [self addSubview:_contemptView];
        
        UIImageView *contemptImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
        contemptImageView.image = [UIImage imageNamed:@"ico_cai"];
        [_contemptView addSubview:contemptImageView];
    }
    return _contemptView;
}
-(UILabel *)terminationLabel{
    if (!_terminationLabel) {
        _terminationLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 130, SCREEN_WIDTH-80, 20)];
        _terminationLabel.font = TXTFONT;
        _changeTitleLabel.frame = CGRectMake(10, 130, 60, 20);
        _changeTitleLabel.text = @"终止原因：";
        _terminationLabel.textColor = RGBA(247, 66, 73, 1);
        _changeTitleLabel.textColor = RGBA(247, 66, 73, 1);
        [self addSubview:_terminationLabel];
//        [_fetcherNickNameLabel removeFromSuperview];
//        [_remarkLabel removeFromSuperview];
//        _remarkLabel = nil;
//        _fetcherNickNameLabel = nil;
    }
    return _terminationLabel;
}
-(UILabel *)publisherPhoneLabel{
    if (!_publisherPhoneLabel) {
        _viewPhone = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 175, 130, 175, 20)];
        [self addSubview:_viewPhone];
//        viewPhone.backgroundColor = [UIColor redColor];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        imageView.image = [UIImage imageNamed:@"ico_bluetel"];
        [_viewPhone addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 20)];
        label.textColor = LightBlueColor;
        label.font = TXTFONT;
        label.text = @"联系方式：";
        [_viewPhone addSubview:label];
        
        _publisherPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 85, 20)];
       
        _publisherPhoneLabel.font = TXTFONT;
        _publisherPhoneLabel.textColor = LightBlueColor;
       
        [_viewPhone addSubview:_publisherPhoneLabel];
        
        UITapGestureRecognizer*tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
//        cell.labelTask.userInteractionEnabled = YES;
        [_viewPhone addGestureRecognizer:tapGesture];
         NSLog(@"11111 %f",STRING_SIZE_FONT(200, @"联系方式：", 12.).width);
    }
    return _publisherPhoneLabel;
}
-(void)tapGesture:(UITapGestureRecognizer *)sender {
    if ([HXHttpUtils whetherNil:_publisherPhoneLabel.text].length>0) {
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_publisherPhoneLabel.text]];
        UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
        [self addSubview:phoneCallWebView];
    }
    
}
//-(UILabel *)labelTask{
//    if (!_labelTask) {
//        if (!_viewShowBtn) {
//            _viewShowBtn = [[UIView alloc] initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH, 30)];
//            [self addSubview:_viewShowBtn];
//        }
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//        imageView.image = [UIImage imageNamed:@"ico_huxian@3x.png"];
//        [_viewShowBtn addSubview:imageView];
//        _labelTask = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/24.0*17.0 , 0, SCREEN_WIDTH/24.0*7.0, 25)];
//        _labelTask.text = @"取消任务";
//        _labelTask.font = TXTFONT;
//        _labelTask.textAlignment = NSTextAlignmentCenter;
//        _labelTask.textColor = [UIColor whiteColor];
//        [_viewShowBtn addSubview:_labelTask];
//    }
//    return _labelTask;
//}
//
//-(UIImageView *)cancelTask{
//    if (!_cancelTask) {
//        if (!_viewShowBtn) {
//            _viewShowBtn = [[UIView alloc] initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH, 30)];
//            [self addSubview:_viewShowBtn];
//        }
//        _cancelTask = [[UIImageView alloc] init];
//        _cancelTask.image = [UIImage imageNamed:@"ico_zuo"];
//        _cancelTask.frame = CGRectMake(0, 0, SCREEN_WIDTH / 2.0 + 20 * SCREEN_WIDTH / 320.0, 30);
//        [_viewShowBtn addSubview:_cancelTask];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2.0, 30)];
//        label.text = @"取消任务";
//        label.font = TXTFONT;
//        label.textColor = LightBlueColor;
//        label.textAlignment = NSTextAlignmentCenter;
//        [_viewShowBtn addSubview:label];
//    }
//    return _cancelTask;
//}
//-(UIImageView *)payTask{
//    if (!_payTask) {
//        if (!_viewShowBtn) {
//            _viewShowBtn = [[UIView alloc] initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH, 30)];
//            [self addSubview:_viewShowBtn];
//        }
//        _payTask = [[UIImageView alloc] init];
//        _payTask.frame = CGRectMake(SCREEN_WIDTH/2.0-20 * SCREEN_WIDTH / 320.0, 0, SCREEN_WIDTH / 2.0 + 20 * SCREEN_WIDTH / 320.0, 30);
//        _payTask.image = [UIImage imageNamed:@"ico_you"];
//        [_viewShowBtn addSubview:_payTask];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0, 0, SCREEN_WIDTH/2.0, 30)];
//        label.text = @"确认支付";
//        label.font = TXTFONT;
//        label.textAlignment = NSTextAlignmentCenter;
//        label.textColor = [UIColor whiteColor];
//        [_viewShowBtn addSubview:label];
//    }
//    return _payTask;
//}
//
-(UILabel *)weatherClean{
    [_fetcherNickNameLabel removeFromSuperview];
    [_remarkLabel removeFromSuperview];
    [_terminationLabel removeFromSuperview];
    [_publisherPhoneLabel removeFromSuperview];
    [_viewPhone removeFromSuperview];
    
//    [_labelTask removeFromSuperview];
//    [_cancelTask removeFromSuperview];
//    [_payTask removeFromSuperview];
//    [_viewShowBtn removeFromSuperview];
    
    
    [_praiseView removeFromSuperview];
    [_contemptView removeFromSuperview];
    _remarkLabel = nil;
    _fetcherNickNameLabel = nil;
    _terminationLabel = nil;
    _viewPhone = nil;
    _publisherPhoneLabel = nil;
    
//    _labelTask = nil;
//    _cancelTask = nil;
//    _payTask = nil;
//    _viewShowBtn = nil;
    
    _praiseView = nil;
    _contemptView = nil;
    if (!_weatherClean) {
        _weatherClean = [[UILabel alloc] init];
    }
    return _weatherClean;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}
@end
