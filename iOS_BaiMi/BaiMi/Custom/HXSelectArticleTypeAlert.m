//
//  HXSelectArticleTypeAlert.m
//  BaiMi
//
//  Created by licl on 16/7/19.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXSelectArticleTypeAlert.h"
#import "AppDelegate.h"

#define BUTTON_WIDTH 90
#define BUTTON_HEIGHT 30

@interface HXSelectArticleTypeAlert()
@property(strong,nonatomic)UIControl *bgView;
@property(strong,nonatomic)HXArticleType*selectType;
@end
@implementation HXSelectArticleTypeAlert


- (id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.layer.cornerRadius=5;
        self.clipsToBounds=YES;
        self.frame=frame;
        UILabel*titleLab=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-80, 5, 160, 21)];
        titleLab.textAlignment=NSTextAlignmentCenter;
        titleLab.text=@"寄送物品类型";
        titleLab.font=[UIFont boldSystemFontOfSize:15.f];
        titleLab.textColor=[UIColor blackColor];
        [self addSubview:titleLab];
        UIImageView*lineImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, ViewFrameY_H(titleLab)+5, self.frame.size.width, 1)];
        lineImgView.image=[UIImage imageNamed:@"dottedLine.png"];
        [self addSubview:lineImgView];
        
        NSMutableArray*nameArray=[NSMutableArray array];
        NSArray*array=[[HXArticleTypeDao new] fetchAllArticles];
        for (HXArticleType*articleType in array) {
            [nameArray addObject:articleType.name];
        }
        
        long rows=0;
        if (array.count %3==0)
            rows=nameArray.count/3;
        else
            rows=nameArray.count/3+1;
        int rowSpace=5;
        int columnSpace=(self.frame.size.width-3*BUTTON_WIDTH)/4;
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, (rowSpace+BUTTON_HEIGHT)*rows+rowSpace+ViewFrameY_H(lineImgView)+60);
        for(int i=0;i<array.count;i++){
            HXArticleType*articleType=[array objectAtIndex:i];
            if (i==0)
                _selectType=articleType;
            int origonX=(i%3)*(columnSpace+BUTTON_WIDTH)+columnSpace;
            int origonY=(i/3)*(rowSpace+BUTTON_HEIGHT)+rowSpace+ViewFrameY_H(lineImgView)+5;
            UIButton*btn=[[UIButton alloc] init];
            NSString*str=articleType.name;
            [btn setTitle:str forState:UIControlStateNormal];
            if ([articleType.no isEqualToString:_selectType.no])
                btn.selected=YES;
            else
                btn.selected=NO;
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btn setTitleColor:LightBlueColor forState:UIControlStateSelected];
            btn.titleLabel.font=[UIFont systemFontOfSize:13.f];
            btn.tag=i;
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame=CGRectMake(origonX, origonY, BUTTON_WIDTH, BUTTON_HEIGHT);
            [self addSubview:btn];
        }
        
        
        UIImageView*lineImgView2=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-10-30-10, self.frame.size.width, 1)];
        lineImgView2.image=[UIImage imageNamed:@"dottedLine.png"];
        [self addSubview:lineImgView2];

        
        UIButton*confirmBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-(self.frame.size.width*0.5)/2,self.frame.size.height-10-30, self.frame.size.width*0.5, 30)];
        confirmBtn.backgroundColor=LightBlueColor;
        [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        confirmBtn.titleLabel.font=[UIFont systemFontOfSize:15.f];
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        confirmBtn.layer.cornerRadius=confirmBtn.frame.size.height/2;
        [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirmBtn];
    }
    return self;
}


-(void)show{
    AppDelegate*appDelegate=[AppDelegate appDelegate];
    _bgView=[[UIControl alloc] initWithFrame:CGRectMake(appDelegate.window.frame.origin.x, appDelegate.window.frame.origin.y, appDelegate.window.frame.size.width, appDelegate.window.frame.size.height)];
    _bgView.backgroundColor=[UIColor lightGrayColor];
    _bgView.alpha=0.8;
    
    self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [appDelegate.window addSubview:_bgView];
    [appDelegate.window addSubview:self];
    [_bgView addTarget:self action:@selector(alertRemoveFromSuperview) forControlEvents:UIControlEventTouchUpInside];
}
-(void)alertRemoveFromSuperview
{
    if ([_Cudelegate respondsToSelector:@selector(alertView:selectArticleType:)]) {
        [_Cudelegate alertView:self selectArticleType:_selectType];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.alpha=0;
    _bgView.alpha=0;
    [UIView commitAnimations];
    [_bgView removeFromSuperview];
    [self removeFromSuperview];
}


-(void)btnClicked:(id)sender{
    UIButton*btn=(UIButton*)sender;
    
    for(UIView*view in self.subviews){
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton*button=(UIButton*)view;
            button.selected=NO;
        }
    }
    btn.selected=YES;
    NSArray*array=[[HXArticleTypeDao new] fetchAllArticles];
    _selectType=[array objectAtIndex:btn.tag];
  }


-(void)confirmBtnClicked:(id)sender{
    [self alertRemoveFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
