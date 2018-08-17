//
//  HXContactPerson.h
//  BaiMi
//
//  Created by licl on 16/7/22.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXContactPerson : NSObject
@property (strong, nonatomic) NSString* firstPinyin;

@property (strong, nonatomic) NSString* pinyin;

@property (strong, nonatomic) NSString* name;

@property (strong, nonatomic) NSString* phone;

-(id)initWithFirstPinyin:(NSString*)firstPinyin pinyin:(NSString*)pinyin name:(NSString*)name phone:(NSString*)p;
@end
