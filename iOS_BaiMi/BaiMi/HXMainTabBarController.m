 //
//  HXMainTabBarController.m
//  BaiMi
//
//  Created by licl on 16/6/23.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXMainTabBarController.h"
#import "HXNavigationController.h"
#import "HXHomeViewController.h"
#import "HXTaskListViewController.h"
#import "HXUserCenterViewController.h"
#import "HXArticleTypeDao.h"
#import "HXAdditonServiceDao.h"

@implementation HXMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSystemParams) name:HXNTFSystemParamsHttpRefresh object:nil];
    HXHomeViewController*homeVC=[[HXHomeViewController alloc] init];
    HXTaskListViewController*taskVC=[[HXTaskListViewController alloc]init];
    HXUserCenterViewController*userCenterVC=[[HXUserCenterViewController alloc] init];
    HXNavigationController*nav1=[[HXNavigationController alloc] initWithRootViewController:homeVC];
    HXNavigationController*nav2=[[HXNavigationController alloc] initWithRootViewController:taskVC];
    HXNavigationController*nav3=[[HXNavigationController alloc] initWithRootViewController:userCenterVC];
    self.viewControllers=@[nav1,nav2,nav3];
    NSArray*itemTitles=@[@"我的快递",@"任务广场",@"个人中心"];
    NSArray*itemImages= [NSArray arrayWithObjects:[UIImage imageNamed:@"express_click.png"],[UIImage imageNamed:@"task_unclick.png"],[UIImage imageNamed:@"user_unclick.png"],nil];
    UITabBar*tabBar=self.tabBar;
    for(int i=0;i<3;i++){
        UITabBarItem*barItem=[tabBar.items objectAtIndex:i];
        barItem.title=[itemTitles objectAtIndex:i];
        barItem.image=[itemImages objectAtIndex:i];
        barItem.titlePositionAdjustment=UIOffsetMake(-3, -3);
    }
    self.tabBar.tintColor=LightBlueColor;
    //获取后台配置的参数信息
    [self getSystemParams];
   }


//获取后台配置的参数信息
-(void)getSystemParams{
    dispatch_group_t group1 = dispatch_group_create();
    dispatch_group_async(group1, dispatch_queue_create("1", DISPATCH_QUEUE_CONCURRENT), ^{
        //寄件物品类型
        [self getArticleTypes];
    });
//    dispatch_group_async(group1, dispatch_queue_create("2", DISPATCH_QUEUE_CONCURRENT), ^{
//        //增值服务
//        [self getAdditionList];
//    });
}




//寄件物品种类
-(void)getArticleTypes{
    [HXHttpUtils requestJsonGetWithUrlStr:@"/user/send/stdmodeList" params:nil onComplete:^(NSError *error, NSDictionary *resultJson) {
        if (error) {
            NSLog(@"%@",HXCodeString(error.code));
        }else{
            NSArray*content=[resultJson objectForKey:@"content"];
            NSMutableArray*array=[NSMutableArray array];
            for(NSDictionary*dic in content){
                HXArticleType*articleType=[HXArticleType new];
                articleType.no=[dic objectForKey:@"no"];
                articleType.name=[dic objectForKey:@"stdmodeName"];
                [array addObject:articleType];
            }
            [[HXArticleTypeDao new] insertUpdateArticles:array];
        }
    }];
}

//-(void)getAdditionList{
//[HXHttpUtils requestJsonGetWithUrlStr:@"/user/send/additionList" params:nil onComplete:^(NSError *error, NSDictionary *resultJson) {
//    if (error) {
//        NSLog(@"%@",HXCodeString(error.code));
//    }else{
//        NSArray*content=[resultJson objectForKey:@"content"];
//        NSMutableArray*array=[NSMutableArray array];
//        for(NSDictionary*dic in content){
//            HXAdditonService*addtion=[HXAdditonService new];
//            addtion.no=[dic objectForKey:@"no"];
//            addtion.descriptin=[dic objectForKey:@"description"];
//            addtion.feeStr=[dic objectForKey:@"fee"];
//            [array addObject:addtion];
//        }
//            [[HXAdditonServiceDao new] insertUpdateAdditions:array];
//    }
//}];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
