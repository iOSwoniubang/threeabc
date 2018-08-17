//
//  HXExpressSearchDao.h
//  BaiMi
//
//  Created by licl on 16/7/11.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "BasicDao.h"
#import "HXExpress.h"

@interface HXExpressSearchDao : BasicDao
-(void)addUpdateOneExpress:(HXExpress*)express;
-(NSArray*)findRecentExpressSearchListByOwnerId:(NSString*)ownerId;
-(HXExpress*)findOneExpressByOwnerId:(NSString*)ownerId ExpressNo:(NSString*)expressNo ;
-(void)deleteOneExpressByOwnerId:(NSString*)ownerId ExpressNo:(NSString*)expressNo;
@end
