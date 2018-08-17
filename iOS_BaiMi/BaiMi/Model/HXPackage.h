//
//  HXPackage.h
//  BaiMi
//
//  Created by licl on 16/7/8.
//  Copyright © 2016年 licl. All rights reserved.
//

//套餐 （洗衣机使用套餐）
#import <Foundation/Foundation.h>

@interface HXPackage : NSObject
@property(strong,nonatomic)NSString*no;//套餐编号
@property(strong,nonatomic)NSString*name;//套餐名称
@property(assign,nonatomic)int pulse;//脉冲
@property(assign,nonatomic)float fee; //费用

@property(assign,nonatomic)BOOL selected;
@end
