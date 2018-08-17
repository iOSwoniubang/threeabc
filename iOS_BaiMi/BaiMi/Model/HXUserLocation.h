//
//  HXUserLocation.h
//  BaiMi
//
//  Created by licl on 16/7/16.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXUserLocation : NSObject
@property (assign, nonatomic) float        latitude;       // 纬度
@property (assign, nonatomic) float        longitude;      // 经度


+(NSMutableDictionary*)dicOfLUserLocation:(HXUserLocation*)userLocation;
+(HXUserLocation*)getUserLocationByDic:(NSDictionary*)dict;

@end
