//
//  DatabaseHelper.m
//
//  Created by licl on 15/10/13.
//  Copyright (c) 2015年 licl. All rights reserved.
//

#import "DatabaseHelper.h"
#import "NSInputStreamReader.h"

static NSString* DB_NAME = @"project.db";

//用于初始化或升级数据库的文件名
static NSString* DB_INIT_OR_UPGRADE_FILENAME = @"db_${db.version}";

static NSString* DB_OLD_VERSION_KEY = @"db.old.version.key";
@implementation DatabaseHelper

-(id)init{
    if(self=[super init]){
        self.dbVersion = ((NSNumber*)[[[NSBundle mainBundle] infoDictionary] valueForKey:@"dbVersion"]).intValue;
        if(self.dbVersion <= 0){
            NSLog(@"dbVersion must >= 1");
        }
    }
    return self;
}

-(FMDatabase *)databaseInstance{
    if(dbInstance == nil){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DB_NAME];
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        if (![db open]) {
            NSLog(@"Could not open db.");
            return nil;
        }
        int oldVersion = (int)[[NSUserDefaults standardUserDefaults] integerForKey:DB_OLD_VERSION_KEY];
        [self upgradeDb:db fromVersion:oldVersion toVersion:self.dbVersion];
        dbInstance = db;
    }
    
    return dbInstance;
}

-(void)close{
    [dbInstance close];
    dbInstance = nil;
}

-(void)upgradeDb:(FMDatabase*)db fromVersion:(int)oldVersion toVersion:(int)newVersion{
    if(oldVersion >= newVersion){
        return;
    }
    
    [db beginTransaction];
    @try {
        for(int i=oldVersion+1;i<=newVersion;i++){
            NSString* fileName = [DB_INIT_OR_UPGRADE_FILENAME stringByReplacingOccurrencesOfString:@"${db.version}" withString:[NSString stringWithFormat:@"%d",i]];
            [self executeSqlFromFile:fileName inDb:db];
        }
        
        [db commit];
    }
    @catch (NSException *exception) {
        NSLog(@"upgradeDb error:%@",exception);
        [db rollback];
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:self.dbVersion forKey:DB_OLD_VERSION_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)executeSqlFromFile:(NSString*)fileName inDb:(FMDatabase*)db{
    NSLog(@"begin to execute sql in %@", fileName);
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"sql"];
    
    NSInputStreamReader* inp = [[NSInputStreamReader alloc] initWithFileAtPath:filePath];
    [inp open];
    @try {
        NSMutableString *sql = [[NSMutableString alloc] initWithCapacity:30];
        NSString* line = [inp readLine];
        while(line){
            line = [inp readLine];
            if([line rangeOfString:@"--"].location == 0 || !line.length){// 注释行
                continue;
            }
            if([line isEqualToString:@"go"]){// 表示一句sql的结束
                [self executeSql:sql inDb:db];
                sql = [[NSMutableString alloc] initWithCapacity:30];
                continue;
            }
            else if ([[line substringFromIndex:line.length-1] isEqualToString:@";"]) {// 表示一句sql的结束
                [sql appendString:[line substringToIndex:line.length-1]];
                [self executeSql:sql inDb:db];
                sql = [[NSMutableString alloc] initWithCapacity:30];
                continue;
            }
            [sql appendString:line];
        }
        
        [self executeSql:sql inDb:db];
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        [inp close];
    }
    
    NSLog(@"finish to execute sql in %@", fileName);
}

-(void)executeSql:(NSString*)sql inDb:(FMDatabase*)db{
    if(sql.length){
        // 执行sql
        //NSLog(@"%@",sql);
        BOOL success = [db executeUpdate:sql];
        if(!success){
            @throw [NSException exceptionWithName:@"fuck" reason:[db lastErrorMessage] userInfo:nil];
        }
    };
}

@end
