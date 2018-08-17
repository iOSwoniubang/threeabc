//
//  DatabaseHelper.h
//
//  Created by licl on 15/10/13.
//  Copyright (c) 2015年 licl. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DatabaseHelper : NSObject{
    FMDatabase* dbInstance;
}

@property (nonatomic) int dbVersion;    //Health-info.plist中记录的数据库版本号

-(FMDatabase*)databaseInstance;

-(void)close;

@end
