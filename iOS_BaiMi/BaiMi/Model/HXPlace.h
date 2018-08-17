//
//  HXPlace.h
//  BaiMi
//
//  Created by licl on 16/7/19.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <MapKit/MapKit.h>

@interface HXPlace : NSObject
@property(strong,nonatomic)NSString*province;
@property(strong,nonatomic)NSString*city;
@property(strong,nonatomic)NSString*area;

@property(strong,nonatomic)NSString*detailAddress;

//@property(strong,nonatomic)CLLocation*location;
@property(strong,nonatomic)NSString*humanName; //地址主人
@property(strong,nonatomic)NSString*contactPhone;//地址主人电话
@end
