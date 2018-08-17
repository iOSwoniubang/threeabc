//
//  HXAdditonServiceDao.h
//  BaiMi
//
//  Created by licl on 16/7/20.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "BasicDao.h"
#import "HXAdditonService.h"

@interface HXAdditonServiceDao : BasicDao
-(void)addUpdateAddition:(HXAdditonService*)addition;
-(void)insertUpdateAdditions:(NSArray*)additions;
-(NSArray*)fetchAllAdditions;
@end
