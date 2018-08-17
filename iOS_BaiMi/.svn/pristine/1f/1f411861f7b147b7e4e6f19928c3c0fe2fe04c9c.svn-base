//
//  HXTaskCell.m
//  BaiMi
//
//  Created by 王放 on 16/7/8.
//  Copyright © 2016年 licl. All rights reserved.
//
#define CELLHIG 35
#define INTERVAL 15
#define TXTFONT [UIFont systemFontOfSize:14.]

//70
//#define FOURTXTHIH 72

//42
//#define TWOTXTHIG 43

//60
//#define BIGTXTHIG 62
#import "HXTaskCell.h"

@implementation HXTaskCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayTitle = [[NSArray alloc] initWithObjects:@"酬劳：",@"重量：",@"取件地址：",@"收件地址：",@"剩余时间：",@"留言：", nil];
        NSLog(@"000000 %f,%f",STRING_SIZE_FONT(1000,[arrayTitle objectAtIndex:0],20.).width,STRING_SIZE_FONT(1000,[arrayTitle objectAtIndex:1],14.).width);
        float bigTextHig = STRING_SIZE_FONT(200, [arrayTitle objectAtIndex:0], 20.).width;
        float twoTextHig = STRING_SIZE_FONT(200, [arrayTitle objectAtIndex:1], 14.).width;
        float fourTextHig = STRING_SIZE_FONT(200, [arrayTitle objectAtIndex:2], 14.).width;
        for (int i = 0; i<6; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.text = [arrayTitle objectAtIndex:i];
            [self addSubview:label];
            label.font = TXTFONT;
            if (i<2) {
                if (i==0) {
                    label.frame = CGRectMake(INTERVAL * 2.0 + CELLHIG * 2.0, CELLHIG/2.0 + i * CELLHIG, bigTextHig, CELLHIG);
                    label.font = [UIFont systemFontOfSize:20];
                    label.textColor = RGBA(216, 95, 32, 1);
                }else{
                    label.frame = CGRectMake(INTERVAL * 2.0 + CELLHIG * 2.0, CELLHIG/2.0 + i * CELLHIG, twoTextHig, CELLHIG);
                    label.textColor = RGBA(76, 168, 224, 1);
                }
            }else{
                label.frame = CGRectMake(INTERVAL, 5 + CELLHIG * (i + 1), fourTextHig, CELLHIG);
                if (i==4) {
                    label.textColor = RGBA(247, 66, 73, 1);
                }else if (i==5){
                    label.frame = CGRectMake(INTERVAL, 5 + CELLHIG * (i + 1), twoTextHig, CELLHIG);
                    label.textColor = RGBA(76, 150, 27, 1);
                }
            }
        }
        
        _feeLabel = [[UILabel alloc] initWithFrame:CGRectMake(INTERVAL * 2 + bigTextHig +CELLHIG * 2.0, CELLHIG / 2.0, SCREEN_WIDTH - (INTERVAL * 2 + bigTextHig +CELLHIG * 2.0), CELLHIG)];
        _feeLabel.font = [UIFont systemFontOfSize:20];
        _feeLabel.textColor = RGBA(216, 95, 32, 1);
        [self addSubview:_feeLabel];
        
        _weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(INTERVAL * 2 + twoTextHig +CELLHIG * 2.0, CELLHIG / 2.0 + CELLHIG, SCREEN_WIDTH - (INTERVAL * 2 + twoTextHig +CELLHIG * 2.0), CELLHIG)];
        _weightLabel.font = TXTFONT;
        _weightLabel.textColor = RGBA(76, 168, 224, 1);
        [self addSubview:_weightLabel];
        
        
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(10, CELLHIG * 3.0 - 1, SCREEN_WIDTH - 20, 2)];
        [self addSubview:viewLine];
        [self drawDashLine:viewLine lineLength:3 lineSpacing:5 lineColor:[UIColor lightGrayColor]];
        
        
        _sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(INTERVAL + fourTextHig,5 + CELLHIG * 3.0 , SCREEN_WIDTH - (INTERVAL + fourTextHig)-10, CELLHIG)];
        _sourceLabel.font = TXTFONT;
        _sourceLabel.numberOfLines = 2;
        [self addSubview:_sourceLabel];
        
        _targetLabel = [[UILabel alloc] initWithFrame:CGRectMake(INTERVAL + fourTextHig,5 + CELLHIG * 4.0, SCREEN_WIDTH - (INTERVAL + fourTextHig)-10, CELLHIG)];
        _targetLabel.font = TXTFONT;
        _targetLabel.numberOfLines = 2;
        [self addSubview:_targetLabel];
        
        _remainingTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(INTERVAL + fourTextHig,5 + CELLHIG * 5.0, SCREEN_WIDTH - (INTERVAL + fourTextHig)-10, CELLHIG)];
        _remainingTimeLabel.font = TXTFONT;
        _remainingTimeLabel.textColor = RGBA(247, 66, 73, 1);
        _remainingTimeLabel.numberOfLines = 2;
        [self addSubview:_remainingTimeLabel];
        
        _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(INTERVAL + twoTextHig,5 + CELLHIG * 6.0, SCREEN_WIDTH - (INTERVAL + twoTextHig) - 120, CELLHIG)];
        _remarkLabel.font = TXTFONT;
        _remarkLabel.numberOfLines = 2;
        _remarkLabel.textColor = RGBA(76, 150, 27, 1);
        [self addSubview:_remarkLabel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5 + CELLHIG * 6.0, SCREEN_WIDTH, CELLHIG+5)];
        imageView.image = [UIImage imageNamed:@"ico_huxian@3x.png"];
        [self addSubview:imageView];
        
        _labelTask = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/24.0*17.0, 5 + CELLHIG * 6.0, SCREEN_WIDTH/24.0*7.0, CELLHIG)];
        _labelTask.text = @"去接受任务";
        _labelTask.textAlignment = NSTextAlignmentCenter;
        _labelTask.textColor = [UIColor whiteColor];
        [self addSubview:_labelTask];

    }
    return self;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(INTERVAL, CELLHIG / 2.0, CELLHIG * 2, CELLHIG * 2)];
        _iconImageView.layer.cornerRadius = CELLHIG;
        _iconImageView.layer.masksToBounds = YES;
        [self addSubview:_iconImageView];
    }
    return _iconImageView;
}
/*
-(UILabel *)feeLabel{
    if (!_feeLabel) {
        _feeLabel = [[UILabel alloc] initWithFrame:CGRectMake(INTERVAL * 2 + BIGTXTHIG +CELLHIG * 2.0, CELLHIG / 2.0, SCREEN_WIDTH - (INTERVAL * 2 + BIGTXTHIG +CELLHIG * 2.0), CELLHIG)];
        _feeLabel.font = [UIFont systemFontOfSize:20];
        _feeLabel.textColor = RGBA(216, 95, 32, 1);
        [self addSubview:_feeLabel];
    }
    return _feeLabel;
}

-(UILabel *)weightLabel{
    if (!_weightLabel) {
        _weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(INTERVAL * 2 + TWOTXTHIG +CELLHIG * 2.0, CELLHIG / 2.0 + CELLHIG, SCREEN_WIDTH - (INTERVAL * 2 + TWOTXTHIG +CELLHIG * 2.0), CELLHIG)];
        _weightLabel.font = TXTFONT;
        _weightLabel.textColor = RGBA(76, 168, 224, 1);
        [self addSubview:_weightLabel];
    }
    return _weightLabel;
}
 
-(UILabel *)sourceLabel{
    if (!_sourceLabel) {
        _sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(INTERVAL + FOURTXTHIH,5 + CELLHIG * 3.0 , SCREEN_WIDTH - (INTERVAL + FOURTXTHIH)-10, CELLHIG)];
        _sourceLabel.font = TXTFONT;
        _sourceLabel.numberOfLines = 2;
        [self addSubview:_sourceLabel];
    }
    return _sourceLabel;
}
-(UILabel *)targetLabel{
    if (!_targetLabel) {
        _targetLabel = [[UILabel alloc] initWithFrame:CGRectMake(INTERVAL + FOURTXTHIH,5 + CELLHIG * 4.0, SCREEN_WIDTH - (INTERVAL + FOURTXTHIH)-10, CELLHIG)];
        _targetLabel.font = TXTFONT;
        _targetLabel.numberOfLines = 2;
        [self addSubview:_targetLabel];
    }
    return _targetLabel;
}
-(UILabel *)remainingTimeLabel{
    if (!_remainingTimeLabel) {
        _remainingTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(INTERVAL + FOURTXTHIH,5 + CELLHIG * 5.0, SCREEN_WIDTH - (INTERVAL + FOURTXTHIH)-10, CELLHIG)];
        _remainingTimeLabel.font = TXTFONT;
        _remainingTimeLabel.textColor = RGBA(247, 66, 73, 1);
        _remainingTimeLabel.numberOfLines = 2;
        [self addSubview:_remainingTimeLabel];
    }
    return _remainingTimeLabel;
}
-(UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(INTERVAL + TWOTXTHIG,5 + CELLHIG * 6.0, SCREEN_WIDTH - (INTERVAL + TWOTXTHIG) - 120, CELLHIG)];
        _remarkLabel.font = TXTFONT;
        _remarkLabel.numberOfLines = 2;
        _remarkLabel.textColor = RGBA(76, 150, 27, 1);
        [self addSubview:_remarkLabel];
    }
    return _remarkLabel;
}
 */
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
