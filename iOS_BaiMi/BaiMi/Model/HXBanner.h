//
//  HXBanner.h
//  BaiMi
//
//  Created by licl on 16/6/30.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXBanner : NSObject
@property(strong,nonatomic)NSString*uuid;
@property(strong,nonatomic)NSString*name; //广告名称
@property(strong,nonatomic)NSString*picUrl; //图片的地址
@property(strong,nonatomic)NSString*linkUrl; //图片跳转的地址
@property(assign,nonatomic)int type; //广告的类型；
@property(assign,nonatomic)int sort; //序号（排序页码）
@end
