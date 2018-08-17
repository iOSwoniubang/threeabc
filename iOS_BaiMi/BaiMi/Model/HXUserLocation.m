//
//  HXUserLocation.m
//  BaiMi
//
//  Created by licl on 16/7/16.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXUserLocation.h"

@implementation HXUserLocation
+(NSMutableDictionary*)dicOfLUserLocation:(HXUserLocation*)userLocation{
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithDouble:userLocation.latitude] forKey:@"latitude"];
    [dict setObject:[NSNumber numberWithDouble:userLocation.longitude] forKey:@"longitude"];
    return dict;
}

+(HXUserLocation*)getUserLocationByDic:(NSDictionary*)dict{
    HXUserLocation*userLocation=[HXUserLocation new];
    userLocation.latitude=[[dict objectForKey:@"latitude"] doubleValue];
    userLocation.longitude=[[dict objectForKey:@"longitude"] doubleValue];
    return userLocation;
}

@end
