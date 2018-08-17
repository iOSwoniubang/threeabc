//
//  HXCompany.h
//  BaiMi
//
//  Created by licl on 16/7/11.
//  Copyright © 2016年 licl. All rights reserved.
//

//快递公司
#import <Foundation/Foundation.h>

@interface HXCompany : NSObject
@property(strong,nonatomic)NSString*logoUrl;
@property(strong,nonatomic)NSString*no;//快递编号
@property(strong,nonatomic)NSString*name;
@property(assign,nonatomic)BOOL isDefault; //是否是系统默认
@end
