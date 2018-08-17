//
//  HXHomeViewController.m
//  BaiMi
//
//  Created by licl on 16/6/23.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXHomeViewController.h"
#import "HXBanner.h"
#import "HXSearchExpressViewController.h"
#import "HXFastPayViewController.h"
#import "HXParcelCodeListViewController.h"
#import "HXSGActingViewController.h"
#import "HXReceiveOrderListViewController.h"
#import "HXUserLocation.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "HXSelePointViewController.h"
#import "HXSendOrderListViewController.h"



@interface HXHomeViewController ()<UIScrollViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate,HXSelectPointDelegate>

@property(strong,nonatomic)UIView*navBackView;
@property(strong,nonatomic)UINavigationBar *bar;
@property(strong,nonatomic)UIScrollView*bannerScrollView;
@property(strong,nonatomic)UIPageControl *pageControl;
@property(strong,nonatomic)UILabel*tipLab; //广播消息

@property(strong,nonatomic)NSTimer*timer;
@property(assign,nonatomic) NSInteger currentPage;
@property(strong,nonatomic)NSMutableArray*bannerArray;

@property(strong,nonatomic)AMapLocationManager*locationManager;
@property(strong,nonatomic)AMapSearchAPI*searchAPI;
@property(strong,nonatomic)HXLoginUser*user;
@property(assign,nonatomic)BOOL hasLocation;
@property(strong,nonatomic)UIButton*pointBtn; //选择网点
@property(strong,nonatomic)AMapCloudPOI*poi;
@property(strong,nonatomic)NSMutableArray*nearList;

@end

@implementation HXHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:HXNTFNetWorkBannerRefresh object:nil];
    _user=[NSUserDefaultsUtil getLoginUser];
    [self resetNaviBar];
    [self createMainUI];
    //定位
    if (!_user.pointName.length)
        [self configLocationManager];

    dispatch_group_t group1 = dispatch_group_create();
    dispatch_group_async(group1, dispatch_queue_create("1", DISPATCH_QUEUE_CONCURRENT), ^{
        //广告条
        [self pullBannerListHttp];
    });
    dispatch_group_async(group1, dispatch_queue_create("2", DISPATCH_QUEUE_CONCURRENT), ^{
        //本楼代领数量
        if (_user.dormitoryHouseNo.length)
            [self pullHouseTaskCountHttp];
    });

}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
    [self pullHouseTaskCountHttp];
   }
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
 }


-(void)resetNaviBar{
    _bar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT*0.4)];
    [self.view addSubview:_bar];
    [self createBarSubViews];
}

-(void)createBarSubViews{
    UIView*pointView=[[UIView alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-20*2, 20)];
    pointView.backgroundColor=[UIColor clearColor];
    _pointBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 0, pointView.frame.size.width-10*2-10, pointView.frame.size.height)];
    [_pointBtn setImage:[UIImage imageNamed:@"ico_whiteding.png"] forState:UIControlStateNormal];
    [_pointBtn setTitle:_user.pointName?_user.pointName:@"点击选择网点" forState:UIControlStateNormal];
     _pointBtn.titleLabel.font=[UIFont systemFontOfSize:14.f];
    [_pointBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_pointBtn addTarget:self action:@selector(pointBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [pointView addSubview:_pointBtn];
    UIImageView*arrowImgView=[[UIImageView alloc] initWithFrame:CGRectMake(ViewFrameX_W(_pointBtn), ViewFrame_Y(_pointBtn)+5, 10, 5)];
    arrowImgView.image=[UIImage imageNamed:@"icon_triangle.png"];
    [pointView addSubview:arrowImgView];
    [_bar addSubview:pointView];

    _navBackView = [[UIView alloc]initWithFrame:CGRectMake(20,45, SCREEN_WIDTH - 20*2, 26)];
    _navBackView.backgroundColor = [UIColor whiteColor];
    _navBackView.layer.cornerRadius = _navBackView.frame.size.height/2;
    UIImageView*searchImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 16, 16)];
    searchImgView.image=[UIImage imageNamed:@"search_gray.png"];
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(searchImgView)+10, ViewFrame_Y(searchImgView), 100, 16)];
    label.text=@"快递查询";
    label.textAlignment=NSTextAlignmentLeft;
    label.textColor=[UIColor grayColor];
    label.font=[UIFont systemFontOfSize:13.f];
    [_navBackView addSubview:searchImgView];
    [_navBackView addSubview:label];
    UIButton*searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame= CGRectMake(0, 0, ViewFrame_W(_navBackView), ViewFrame_H(_navBackView));
    [searchBtn addTarget:self action:@selector(searchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_navBackView addSubview:searchBtn];
    [_bar addSubview:_navBackView];
    
    int origonY=ViewFrameY_H(_navBackView)+5;
    _bannerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,origonY,SCREEN_WIDTH,_bar.frame.size.height-origonY-21)];
    [_bar addSubview:_bannerScrollView];
    
    UIView*tipView=[[UIView alloc] initWithFrame:CGRectMake(0, ViewFrameY_H(_bannerScrollView), _bar.frame.size.width, 21)];
    tipView.backgroundColor=[UIColor whiteColor];
    UIImageView*loudspeakerImgView=[[UIImageView  alloc] initWithFrame:CGRectMake(10, 5, 14, 10)];
    loudspeakerImgView.image=[UIImage imageNamed:@"loudspeaker.png"];
    [tipView addSubview:loudspeakerImgView];
    _tipLab=[[UILabel alloc] initWithFrame:CGRectMake(ViewFrameX_W(loudspeakerImgView), 0, tipView.frame.size.width-ViewFrameX_W(loudspeakerImgView), 21)];
    [tipView addSubview:_tipLab];
    _tipLab.textColor=LightBlueColor;
    _tipLab.textAlignment=NSTextAlignmentLeft;
    _tipLab.font=[UIFont systemFontOfSize:12.f];
    tipView.userInteractionEnabled=YES;
    UITapGestureRecognizer*tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tipViewGesture:)];
    [tipView addGestureRecognizer:tapGesture];
    [_bar addSubview:tipView];
    _tipLab.text=[NSString stringWithFormat:@"您所在的楼层有0个代领包裹，帮领有钱赚哦~"];
}


//本楼可代领任务数量
-(void)pullHouseTaskCountHttp{
    HXLoginUser*user=[NSUserDefaultsUtil getLoginUser];
    NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[user.phoneNumber,user.dormitoryHouseNo,user.token]];
    [HXHttpUtils requestJsonPostWithUrlStr:@"/user/receive/localMissionCount" params:@{@"phoneNumber":user.phoneNumber,@"sKey":sKey,@"dormitoryHouseNo":user.dormitoryHouseNo} onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            NSLog(@"%@",HXCodeString(error.code));
        }else{
            NSDictionary*content=[resultJson objectForKey:@"content"];
            int helpParcelNum=[[content objectForKey:@"count"] intValue];
            _tipLab.text=[NSString stringWithFormat:@"您所在的楼层有%d个代领包裹，帮领有钱赚哦~",helpParcelNum];
        }
    }];
}


-(void)tipViewGesture:(UITapGestureRecognizer*)gesture{
    //跳转到任务广场代领任务
    [[NSNotificationCenter defaultCenter] postNotificationName:HXNTFHouseTaskRefresh object:nil];
    self.tabBarController.selectedIndex=1;
}

//快递查询点击
-(void)searchBtnClicked:(id)sender{
    HXSearchExpressViewController*desVC=[[HXSearchExpressViewController alloc] init];
    desVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:desVC animated:YES];
}



-(void)onNotification:(NSNotification*)notification{
    if ([notification.name isEqualToString:HXNTFNetWorkBannerRefresh]){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self pullBannerListHttp];
        });
        return;
    }
}



-(void)pullBannerListHttp{
    _bannerArray=[NSMutableArray array];
    [HXHttpUtils requestJsonGetWithUrlStr:@"/common/bannerList" params:nil onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            [HXAlertViewEx showInTitle:nil Message:HXCodeString(error.code) ViewController:self];
            [NSUserDefaultsUtil setBannerListState:NO];
        }else{
            [NSUserDefaultsUtil setBannerListState:YES];
            NSArray *content = [resultJson objectForKey:@"content"];
            for (NSDictionary *dict in content) {
                HXBanner*banner=[HXBanner new];
                banner.name=[dict objectForKey:@"name"];
                banner.picUrl=[dict objectForKey:@"pictureUrl"];
                banner.linkUrl=[dict objectForKey:@"linkUrl"];
                banner.type=[[dict objectForKey:@"type"] intValue];
                banner.sort=[[dict objectForKey:@"sort"] intValue];
                [_bannerArray addObject:banner];
            }
        }
        [self createBannerUI];
    }];
}

-(void)createBannerUI{
    for (int i = 0; i < _bannerArray.count; i ++) {
        HXBanner *banner = [_bannerArray objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, ViewFrame_H(_bannerScrollView))];
        [imageView setImageWithURL:[NSURL URLWithString:banner.picUrl] placeholderImage:[UIImage imageNamed:@"defautBanner.jpg"]];
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor=[UIColor whiteColor];
        imageView.tag = 100 + i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goPicDetail:)];
        [imageView addGestureRecognizer:tap];
        [_bannerScrollView addSubview:imageView];
    }
    _bannerScrollView.delegate = self;
    _bannerScrollView.contentSize = CGSizeMake(_bannerArray.count * SCREEN_WIDTH, ViewFrame_H(_bannerScrollView));
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, ViewFrameY_H(_bannerScrollView) - 20, SCREEN_WIDTH,20)];
    _pageControl.numberOfPages = _bannerArray.count;
    _pageControl.currentPage = 0;
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.currentPageIndicatorTintColor=LightBlueColor;
    _pageControl.pageIndicatorTintColor=RGBA(174, 228, 255, 1);
    _pageControl.alpha = 0.8;
    _currentPage = 0;
    [_bar addSubview:_pageControl];
    
    [self timerOn];
}

- (void)timerOn{
    _timer=[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(imgPlay) userInfo:nil repeats:YES];
    //为了防止单线程的弊端，可以保证用户在使用其他控件的时候系统照样可以让定时器运转
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)imgPlay{
    int i=(int)_pageControl.currentPage;
    if (i==_bannerArray.count-1)
        i=0;
    else
        i++;
    [_bannerScrollView setContentOffset:CGPointMake(i*_bannerScrollView.frame.size.width, 0) animated:YES];
    _currentPage = _pageControl.currentPage;
}

- (void)goPicDetail:(UITapGestureRecognizer *)tap{
    HXBanner *banner = [_bannerArray objectAtIndex:(tap.view.tag - 100)];
    NSLog(@"进入%d图片详情",banner.sort);
}
//当用户准备拖拽的时候，关闭定时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self timerOff];
}
//当用户停止拖拽的时候，添加一个定时器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_bannerScrollView setContentOffset:CGPointMake(_pageControl.currentPage *ViewFrame_W(_bannerScrollView), 0) animated:YES];
    [self timerOn];
}
//关闭定时器，并且把定时器设置为nil，这是习惯
-(void)timerOff{
    [_timer invalidate];
    _timer=nil;
}
//这个需要在总宽度上加上半个scrollView的宽度，是为了保证拖拽到一半时候左右的效果
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _pageControl.currentPage=(_bannerScrollView.frame.size.width*0.5+_bannerScrollView.contentOffset.x)/_bannerScrollView.frame.size.width;
}


#pragma mark ---- main UI----

-(void)createMainUI{
    self.view.backgroundColor=BackGroundColor;
    int origonY=_bar.frame.origin.y+_bar.frame.size.height;
    UIView*mainView=[[UIView alloc] initWithFrame:CGRectMake(0, origonY, SCREEN_WIDTH, self.view.frame.size.height-origonY-55)];
    mainView.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:mainView];
    
    int Width1=mainView.frame.size.width*0.4;
    int HeightTotal=mainView.frame.size.height;
    CGRect rect1=CGRectMake(10, 12, Width1,(HeightTotal-25)*0.5);
    CGRect rect2=CGRectMake(10, rect1.origin.y+rect1.size.height+8, rect1.size.width, rect1.size.height);
    
    int origonX2=rect1.origin.x+rect1.size.width+10;
    int Width2=mainView.frame.size.width*0.6-30;
    CGRect rect3=CGRectMake(origonX2, 12, Width2,(HeightTotal-30)*0.28);
    CGRect rect4=CGRectMake(origonX2, rect3.origin.y+rect3.size.height+5, Width2, (HeightTotal-30)*0.37);
    CGRect rect5=CGRectMake(origonX2, rect4.origin.y+rect4.size.height+8, Width2, (HeightTotal-30)*0.35);
    
    NSArray*rectArray=@[[NSValue valueWithCGRect:rect1],[NSValue valueWithCGRect:rect2],[NSValue valueWithCGRect:rect3],[NSValue valueWithCGRect:rect4],[NSValue valueWithCGRect:rect5]];
    NSArray*images=@[[UIImage imageNamed:@"fastReceive.png"],[UIImage imageNamed:@"helpReceive.png"],[UIImage imageNamed:@"fastPay.png"],[UIImage imageNamed:@"parcelReceive.png"],[UIImage imageNamed:@"parcelSend.png"]];
    NSArray*colors=@[RGBA(135, 188, 72, 1),RGBA(60, 169, 210, 1),[UIColor clearColor],RGBA(252, 186, 63, 1),RGBA(157, 111, 224, 1)];
    NSArray*titles=@[@"一键取件",@"师哥代领",@"智能支付",@"我的包裹",@"我的寄件"];
    int imgWidth=65;
    int seperateY=30;
    UIFont*titleFont=[UIFont boldSystemFontOfSize:18.f];
    UIFont*subtitleFont=[UIFont systemFontOfSize:14.f];
    NSLog(@"%f",SCREEN_HEIGHT);
    AppleType iPhoneHeight=SCREEN_HEIGHT;
    switch (iPhoneHeight) {
        case iPhone4:{imgWidth=45;seperateY=15,titleFont=[UIFont boldSystemFontOfSize:14.f];subtitleFont=[UIFont systemFontOfSize:11.f];};break;
        case iPhone5:{imgWidth=50;seperateY=15,titleFont=[UIFont boldSystemFontOfSize:15.f],subtitleFont=[UIFont systemFontOfSize:13.f];};break;
        case iPhone6:{imgWidth=55;seperateY=20;titleFont=[UIFont boldSystemFontOfSize:18.f];subtitleFont=[UIFont systemFontOfSize:14.f];};break;
        case iPhone6Plus:{imgWidth=65;seperateY=30;titleFont=[UIFont boldSystemFontOfSize:18.f];subtitleFont=[UIFont systemFontOfSize:14.f];};break;
        case iPad:{imgWidth=90,seperateY=40;titleFont=[UIFont boldSystemFontOfSize:18.f];subtitleFont=[UIFont systemFontOfSize:15.f];};break;
        default:
            break;
    }
    
    for(int i=0;i<5;i++){
        UIView*view=[[UIView alloc] initWithFrame:[[rectArray objectAtIndex:i] CGRectValue]];
        view.backgroundColor=[colors objectAtIndex:i];
        UILabel*titleLab=[[UILabel alloc] init];
        titleLab.font=titleFont;
        titleLab.textColor=[UIColor whiteColor];
        titleLab.text=[titles objectAtIndex:i];
        [view addSubview:titleLab];
        UIImageView*imgView=[[UIImageView alloc] init];
        imgView.image=[images objectAtIndex:i];
        [view addSubview:imgView];
        if (i<2) {
            titleLab.frame=CGRectMake(15,seperateY, 100, 21);
            UILabel*subtitleLab=[[UILabel alloc] initWithFrame:CGRectMake(15, ViewFrameY_H(titleLab), 100, 21)];
            titleLab.textAlignment=NSTextAlignmentLeft;
            subtitleLab.textAlignment=NSTextAlignmentLeft;
            subtitleLab.font=subtitleFont;
            [view addSubview:subtitleLab];
            imgView.frame=CGRectMake(view.frame.size.width-15-imgWidth, view.frame.size.height-seperateY-imgWidth, imgWidth, imgWidth);
            if (i==0) {
                subtitleLab.text=@"轻松便捷";
                subtitleLab.textColor=RGBA(62, 109, 5, 1);
            }else{
                subtitleLab.text=@"省时省心";
                subtitleLab.textColor=RGBA(20, 96, 135, 1);
            }
        }else{
            imgView.frame=CGRectMake(view.frame.size.width/2-imgWidth-5, (view.frame.size.height-imgWidth)/2, imgWidth, imgWidth);
            titleLab.frame=CGRectMake(view.frame.size.width/2, (view.frame.size.height-21)/2, 100, 21);
            if (i==2) {
                titleLab.textColor=RGBA(17, 137, 248, 1);
                UIImageView*bgImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
                bgImgView.image=[UIImage imageNamed:@"payBg.png"];
                bgImgView.backgroundColor=[UIColor clearColor];
                [view insertSubview:bgImgView atIndex:0];
            }
        }
        UIButton*btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        btn.tag=100+i;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        [mainView addSubview:view];
    }

}


//点击
-(void)btnClicked:(id)sender{
    UIButton*button=(UIButton*)sender;
    switch (button.tag) {
        case 100:{
        //一键取货
            HXParcelCodeListViewController*desVC=[[HXParcelCodeListViewController alloc] init];
            desVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:desVC animated:YES];
        };break;
        case 101:{
        //师哥代领
            HXSGActingViewController*desVC=[[HXSGActingViewController alloc] init];
            desVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:desVC animated:YES];
        };break;
        case 102:{
        //智能支付
            HXFastPayViewController*desVC=[[HXFastPayViewController alloc] init];
            desVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:desVC animated:YES];
        };break;
        case 103:{
        //我的包裹
            HXReceiveOrderListViewController*desVC=[[HXReceiveOrderListViewController alloc] init];
            desVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:desVC animated:YES];
        };break;
        case 104:{
        //我的寄件
            HXSendOrderListViewController*desVC=[[HXSendOrderListViewController alloc] init];
            desVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:desVC animated:YES];
        };break;
        default:
            break;
    }
    
}


//定位
- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //开始定位
    [self.locationManager startUpdatingLocation];

}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    //定位错误
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    //定位结果
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
  
   //停止定位
     [self.locationManager stopUpdatingLocation];
    if (!_hasLocation) {
        HXUserLocation*userLocation=[HXUserLocation new];
        userLocation.latitude=location.coordinate.latitude;
        userLocation.longitude=location.coordinate.longitude;
        [NSUserDefaultsUtil setUserLocation:userLocation];
        [self searchNearestPointFromMap_CloudWithUserLocation:userLocation];
        _hasLocation=YES;
    }
}



//云图搜索最近网点
-(void)searchNearestPointFromMap_CloudWithUserLocation:(HXUserLocation*)userLocation{
//    //配置用户Key
    [AMapServices sharedServices].apiKey = GD_Map_Key;
    
    //初始化检索对象
    _searchAPI = [[AMapSearchAPI alloc] init];
    _searchAPI.delegate = self;
    
    //构造AMapCloudPOIAroundSearchRequest对象，设置云周边检索请求参数
    AMapCloudPOIAroundSearchRequest *request = [[AMapCloudPOIAroundSearchRequest alloc] init];
    request.tableID = GD_MapCloud_TableId;//在数据管理台中取得
    request.center =  [AMapGeoPoint locationWithLatitude:userLocation.latitude  longitude:userLocation.longitude];
    request.radius = 5000;
    NSString*filterStr=[NSString stringWithFormat:@"type:2"];//type（1.学校,2网点）
    [request setFilter:@[filterStr]];
//    [request setOffset:20];
    [request setPage:1];
    //发起云本地检索
    [_searchAPI AMapCloudPOIAroundSearch:request];
}



//实现云检索对应的回调函数
- (void)onCloudSearchDone:(AMapCloudSearchBaseRequest *)request response:(AMapCloudPOISearchResponse *)response
{
    if(response.POIs.count == 0)
    {
        return;
    }
    //获取云图数据并显示
    NSMutableArray*cloudPOIs=[response.POIs mutableCopy];
    if (cloudPOIs.count>0) {
        NSArray *sortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES]];
        [cloudPOIs sortUsingDescriptors:sortDescriptors];
    }
    _poi=[cloudPOIs firstObject];
    
    _nearList=[cloudPOIs mutableCopy];
    [_nearList removeObjectAtIndex:0];

    [self updatePoint];
}


- (void)cloudRequest:(id)cloudSearchRequest error:(NSError *)error
{
    NSLog(@"CloudRequestError:{Code: %ld; Description: %@}", (long)error.code, error.localizedDescription);
}

-(void)updatePoint{
    //网点修改
    if (_poi) {
        NSString*sKey=[HXNSStringUtil getSkeyByParamInfo:@[_user.phoneNumber,[_poi.customFields objectForKey:@"code"],_user.token]];
        [HXHttpUtils requestJsonPostWithUrlStr:@"/user/editBindingPoint" params:@{@"phoneNumber":_user.phoneNumber,@"sKey":sKey,@"pointNo":[NSString stringWithFormat:@"%@",[_poi.customFields objectForKey:@"code"]]} onComplete:^(NSError *error, NSDictionary *resultJson) {
            if (error) {
                NSLog(@"%@",HXCodeString(error.code));
            }else{
                NSLog(@"修改成功");
                _user.pointNo=[_poi.customFields objectForKey:@"code"];
                _user.pointName=_poi.name;
                
                HXPlace*place=[HXPlace  new];
                place.province=[_poi.customFields objectForKey:@"_province"];
                place.city=[_poi.customFields objectForKey:@"_city"];
                place.area=[_poi.customFields objectForKey:@"_district"];
                
                NSString*subStr=[_poi.address stringByReplacingOccurrencesOfString:place.province withString:@""];
                subStr=[subStr stringByReplacingOccurrencesOfString:place.city withString:@""];
                subStr=[subStr stringByReplacingOccurrencesOfString:place.area withString:@""];
                place.detailAddress=subStr;
                
                NSDictionary*pointPlaceDic=@{@"province":place.province,@"city":place.city,@"area":place.area,@"address":place.detailAddress};
                _user.pointAddressJsonStr=[HXNSStringUtil getJsonStringFromDicOrArray:pointPlaceDic];
                
                [NSUserDefaultsUtil setLoginUser:_user];
                [_pointBtn setTitle:_user.pointName forState:UIControlStateNormal];
            }
            }];
    }
}

//-(void)showPointAlert{
//    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"请选择网点地址" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    if(_user.pointName.length){
//    [alert addAction:[UIAlertAction actionWithTitle:_user.pointName style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        [alert dismissViewControllerAnimated:YES completion:nil];
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"其他位置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"选择");
//    }]];
//    
//    }else{
//        [alert addAction:[UIAlertAction actionWithTitle:@"进入选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"选择");
//        }]];
//    }
//    [self presentViewController:alert animated:YES completion:nil];
//}


-(void)pointBtnClicked:(id)sender{
//选择其他网点
    HXSelePointViewController*desVC=[[HXSelePointViewController alloc] init];
    desVC.poi=_poi;
    desVC.nearList=[_nearList mutableCopy];
    desVC.delegate=self;
    [self.navigationController pushViewController:desVC animated:YES];
}

#pragma mark--HXSelectPointDelegate
-(void)selectVC:(HXSelePointViewController *)selectVC NewPoint:(AMapCloudPOI *)poi pointPlace:(HXPlace *)pointPlace{
    _user=[NSUserDefaultsUtil getLoginUser];
    [_pointBtn setTitle:_user.pointName forState:UIControlStateNormal];
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
