//
//  HXGetAreaViewController.h
//  BaiMi
//
//  Created by HXMAC on 16/7/19.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>

//
typedef NS_ENUM(NSInteger,HXsearchType){
    HXSearchTypeArea=0,//区域
    HXSearchTypeDormitory =1, //楼栋
};
@interface HXGetAreaViewController : UIViewController
@property (nonatomic,strong)NSString *searchNum;
@property (nonatomic,assign)HXsearchType type;
@property(strong,nonatomic)NSMutableArray *sourceArray;

@end
