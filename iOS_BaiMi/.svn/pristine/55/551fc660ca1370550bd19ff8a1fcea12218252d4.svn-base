//
//  HXChooseCityListViewController.h
//  BaiMi
//
//  Created by HXMAC on 16/7/22.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  GOBACKDelegate<NSObject>
- (void)goBack:(NSArray *)array;
@end

typedef NS_ENUM(NSInteger,HXChooseCityType)
{
    HXProvinceType = 1,
    HXCityType = 2,
    HXAreaType = 3
};
@interface HXChooseCityListViewController : UIViewController
@property (nonatomic,assign)HXChooseCityType chooseType;
@property (nonatomic,weak)id<GOBACKDelegate> delegate;
@property (nonatomic,strong)NSArray *chooseIndexArray;
@property (nonatomic,strong)NSMutableArray *resultArray;
@property (nonatomic,assign)BOOL isChooseSchool;
@end
