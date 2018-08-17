//
//  HXAdditonServiceDao.m
//  BaiMi
//
//  Created by licl on 16/7/20.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXAdditonServiceDao.h"
@interface HXAdditonServiceDao()
@property(strong,nonatomic)NSDictionary*rowMapper;
@end

@implementation HXAdditonServiceDao

-(id)init{
    if (self=[super init]) {
        self.rowMapper=@{
                         @"no":@"no",
                         @"descriptin":@"descriptin",
                         @"feeStr":@"feeStr",
                         };
    }
    return self;
}


-(void)addUpdateAddition:(HXAdditonService*)addition{
   [self update:@"replace into additionServiceTable(no,descriptin,feeStr)values(?,?,?)" withArgs:@[addition.no,addition.descriptin,addition.feeStr]];
}

-(void)insertUpdateAdditions:(NSArray*)additions{
    for(HXAdditonService *addition in additions){
        [self addUpdateAddition:addition];
    }
}

-(NSArray*)fetchAllAdditions{
    return [self query:@"select * from additionServiceTable" withArgs:nil column2NameMapper:self.rowMapper withClass:[HXAdditonService class]];
}

@end
