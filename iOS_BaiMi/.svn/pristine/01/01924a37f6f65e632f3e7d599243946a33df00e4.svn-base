//
//  HXGuideViewController.m
//  BaiMi
//
//  Created by licl on 16/6/29.
//  Copyright © 2016年 licl. All rights reserved.
//引导页面

#import "HXGuideViewController.h"
#import "HXLoginViewController.h"
#import "AppDelegate.h"
#define PageNums   3

@interface HXGuideViewController()<UIScrollViewDelegate>
@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) UIPageControl *pageControl;
@end

@implementation HXGuideViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showGuideView];
}

#pragma mark---引导页

//显示引导页
-(void)showGuideView{
    _scrollView=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.contentSize=CGSizeMake(SCREEN_WIDTH*PageNums,SCREEN_HEIGHT);
    _scrollView.pagingEnabled=YES;
    _scrollView.bounces=NO;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.delegate=self;
    _scrollView.tag=10010;
    
    [self.view addSubview:_scrollView];
    NSString*afterStr=@"";
    NSLog(@"%@",NSStringFromCGRect([UIScreen mainScreen].bounds));
    if ([UIScreen mainScreen].bounds.size.height>=568)
        afterStr=@"-568h";
    
    for(int i=0;i<PageNums;i++){
        UIImageView*imageView=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        NSString*name=[NSString stringWithFormat:@"guide%d%@.png",i+1,afterStr];
        UIImage*image=[UIImage imageNamed:name];
        imageView.image=image;
        imageView.backgroundColor=[UIColor greenColor];
        if (i==PageNums-1) {
            UIButton*btn=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-45, SCREEN_HEIGHT-75, 90, 30)];
            [btn addTarget:self action:@selector(startBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:@"开始大师哥" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont systemFontOfSize:15.f];
            btn.backgroundColor=RGBA(253, 117, 65, 1);
            btn.layer.cornerRadius=3.f;
            imageView.userInteractionEnabled=YES;
            [imageView addSubview:btn];
        }
        [_scrollView addSubview:imageView];
    }
    _pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-25,[UIScreen mainScreen].bounds.size.height-50, 50, 40)];
    _pageControl.numberOfPages=PageNums;
    [_pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithRed:41.0/255 green:180.0/255 blue:227.0/255 alpha:1]];
    [_pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
    
    [self.view addSubview:_pageControl];
}


//开始按钮点击
-(void)startBtnClicked:(id)sender{
    [NSUserDefaultsUtil setFirstRunBundleVersion];
    HXLoginViewController*loginVC=[[HXLoginViewController alloc] init];
    [AppDelegate appDelegate].window.rootViewController=loginVC;
}

//滚动引导页
#pragma mark -ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView  isKindOfClass:[UITableView class]]) {
        int currentPage=fabs(scrollView.contentOffset.x)/scrollView.frame.size.width;
        [self.pageControl setCurrentPage:currentPage];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
