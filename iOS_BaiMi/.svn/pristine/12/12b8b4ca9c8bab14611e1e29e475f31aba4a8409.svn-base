//
//  HXExpressSearchDao.m
//  BaiMi
//
//  Created by licl on 16/7/11.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXExpressSearchDao.h"

@interface HXExpressSearchDao ()

@property(strong,nonatomic)NSDictionary*rowMapper;
@end

@implementation HXExpressSearchDao
-(id)init{
    if (self=[super init]) {
        self.rowMapper=@{
                    @"ownerId":@"ownerId",
                    @"expressNo":@"expressNo",
                    @"companyNo":@"companyNo",
                    @"companyName":@"companyName",
                    @"companyLogoUrl":@"companyLogoUrl",
                    @"searchTime":@"searchTime",
                    };
    }
    return self;
}


-(void)addUpdateOneExpress:(HXExpress*)e{
    [self update:@"replace into expressSearchHistory(ownerId,expressNo,companyNo,companyName,companyLogoUrl,searchTime) values(?,?,?,?,?,?)" withArgs:@[e.ownerId,e.expressNo,e.companyNo,e.companyName,e.companyLogoUrl,e.searchTime]];
    NSArray*array=[self query:@"select *from expressSearchHistory where ownerId=? order by searchTime desc" withArgs:@[e.ownerId] column2NameMapper:self.rowMapper withClass:[HXExpress class]];
    if (array.count>3) {
        HXExpress*e=[array objectAtIndex:0];
        [self update:@"delete from expressSearchHistory where ownerId=？and expressNo=?" withArgs:@[e.ownerId,e.expressNo]];
    }
}
-(NSArray*)findRecentExpressSearchListByOwnerId:(NSString*)ownerId{
    return [self query:@"select * from expressSearchHistory where ownerId=? order by searchTime desc limit 0,10" withArgs:@[ownerId] column2NameMapper:self.rowMapper withClass:[HXExpress class]];
}
-(HXExpress*)findOneExpressByOwnerId:(NSString*)ownerId ExpressNo:(NSString*)expressNo{
 NSArray*array= [self query:@"select * from expressSearchHistory where ownerId=? and expressNo=?" withArgs:@[ownerId,expressNo] column2NameMapper:self.rowMapper withClass:[HXExpress class]];
    if (array.count>0) {
        HXExpress*express=[array objectAtIndex:0];
        return express;
    }
    return nil;
}
-(void)deleteOneExpressByOwnerId:(NSString*)ownerId ExpressNo:(NSString*)expressNo{
    [self update:@"delete from expressSearchHistory where ownerId=? and expressNo=?" withArgs:@[ownerId,expressNo]];
}
@end
