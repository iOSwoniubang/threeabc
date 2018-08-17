//
//  BasicDao.m

//  Created by licl on 15/10/13.
//  Copyright (c) 2015年 licl. All rights reserved.
//

#import "BasicDao.h"
#import <objc/runtime.h>
#import "AppDelegate.h"

static NSCondition* lock;
static int symbol=1;
@interface BasicDao()
@property (nonatomic,strong) DatabaseHelper* dbHelper;
@end
@implementation BasicDao
- (NSString *)ownerId{
    HXLoginUser*user=[NSUserDefaultsUtil getLoginUser];
    return user.phoneNumber;
}

-(id)init{
    if(self=[super init]){
        self.dbHelper = [[DatabaseHelper alloc] init];
        @synchronized([BasicDao class]){
            if(lock == nil){
                lock = [[NSCondition alloc] init];
            }
        }
    }
    return self;
}

-(FMDatabase*)databaseInstance{
    [lock lock];
    @try {
        if(symbol == 1){
            symbol = 0;
        }
        else{
            while(symbol == 0){
                [lock wait];
            }
        }
    }
    @finally {
        [lock unlock];
    }
    
    return self.dbHelper.databaseInstance;
}

-(void)close{
    [self.dbHelper close];
    [lock lock];
    @try {
        if(symbol == 0){
            symbol = 1;
            [lock signal];
        }
    }
    @finally {
        [lock unlock];
    }
}

/**
 * 不带参数的插入或者更新
 *
 * @param sql
 */
-(BOOL)update:(NSString*)sql{
    FMDatabase* db = [self databaseInstance];
    [db beginTransaction];
    BOOL success = NO;
    @try {
        success = [db executeUpdate:sql];
        if(!success){
            NSLog(@"update error:%@",[db lastErrorMessage]);
        }
        [db commit];
    }
    @catch (NSException* e) {
        NSLog(@"sql err:%@",e);
        [db rollback];
    }
    @finally {
        [self close];
    }
    return success;
}

/**
 * 带参数插入或者更新
 *
 * @param sql
 * @param args
 */
-(BOOL)update:(NSString*)sql withArgs:(NSArray*)args{
    FMDatabase* db = [self databaseInstance];
    
    [db beginTransaction];
    @try {
        BOOL result = [db executeUpdate:sql withArgumentsInArray:args];
        if(!result)
            NSLog(@"update error:%@,%d,%@",[db lastError],[db lastErrorCode],[db lastErrorMessage]);
        [db commit];
        return result;
    }
    @catch (NSException* e) {
        NSLog(@"sql err:%@",e);
        [db rollback];
    }
    @finally {
        [self close];
    }
    return NO;
}

/**
 * 查询，返回多条记录
 *
 * @param sql
 * @param args
 * @param rowMapper 从表字段名到类属性的映射
 * @param class 要转换的目标类
 * @return
 */
-(NSArray*)query:(NSString*)sql withArgs:(NSArray*)args column2NameMapper:(NSDictionary*)rowMapper withClass:(Class)class{
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:5];
    
    FMDatabase* db = [self databaseInstance];
    FMResultSet * rs = nil;
    @try {
        rs = [db executeQuery:sql withArgumentsInArray:args];
        if(rs == nil)
            NSLog(@"queryForInt Null:%@",[db lastErrorMessage]);
        else {
            NSMutableArray* columns = [[NSMutableArray alloc] init];
            for(int i = 0; i<[rs columnCount];i++){
                [columns addObject:[rs columnNameForIndex:i]];
            }
            
            while([rs next]){
                NSObject* obj = [class new];
                for(NSString* column in columns){
                    NSString * propertyName = [rowMapper valueForKey:column];
                    if(!propertyName){
                        continue;
                    }
                    NSString* propertyType = [self getPropertyAttributes:class byName:propertyName];
                    if([propertyType rangeOfString:@"NSDate"].location != NSNotFound){
                        NSDate* o = [rs dateForColumn:column];
                        [obj setValue:o forKey:propertyName];
                    }
                    else{
                        NSObject* o = [rs objectForColumnName:column];
                        if(![o isEqual:[NSNull null]]){
                            [obj setValue:o forKey:propertyName];
                        }
                    }
                }
                [array addObject:obj];
            }
        }
    }
    @catch (NSException *e) {
        NSLog(@"query exception:%@",e);
        NSLog(@"query exception callStackSymbols:%@",e.callStackSymbols);
    }
    @finally {
        [rs close];
        [self close];
    }
    return array;
}

// 获取类属性名称
-(NSString*) getPropertyAttributes:(Class)c byName:(NSString*)name{
    if(!name)
        return @"";
    objc_property_t t = class_getProperty(c, name.UTF8String);
    const char* str = property_getAttributes(t);
    NSString* s = [NSString stringWithUTF8String:str];
    return s;
}
/**
 * IN查询，返回LIST集合
 *
 * @param sql
 * @param args
 * @param multiRowMapper
 * @return
 */
-(NSArray*)queryForInSql:(NSString*)prefix withPrefixArgs:(NSArray*)prefixArgs inArgs:(NSArray*)inArgs postfix:(NSString*)postfix column2NameMapper:(NSDictionary*)rowMapper withClass:(Class)class{
    if(inArgs.count == 0){
        return nil;
    }
    NSMutableString* sql = [[NSMutableString alloc] init];
    [sql appendString:prefix];
    [sql appendString:@" ("];
    int n = (int)inArgs.count-1;
    for(int i=0;i<n;i++){
        [sql appendString:@"?,"];
    }
    [sql appendString:@"?)"];
    NSMutableArray* args = [NSMutableArray arrayWithArray:prefixArgs];
    [args addObjectsFromArray:inArgs];
    
    if (postfix.length) {
        [sql appendString:postfix];
    }
    
    return [self query:sql withArgs:args column2NameMapper:rowMapper withClass:class];
}

-(int)queryForInt:(NSString*)sql withArgs:(NSArray*)args{
    FMDatabase* db = [self databaseInstance];
    FMResultSet * rs = nil;
    int count = 0;
    @try {
        rs = [db executeQuery:sql withArgumentsInArray:args];
        if(rs == nil){
            NSLog(@"queryForIntError:%@",[db lastErrorMessage]);
        }
        else if([rs next]){
            count = [rs intForColumnIndex:0];
        }
    }
    @finally {
        [rs close];
        [self close];
    }
    return count;
}
-(NSString*)queryForString:(NSString*)sql withArgs:(NSArray*)args{
    FMDatabase* db = [self databaseInstance];
    FMResultSet * rs = nil;
    NSString *string = 0;
    @try {
        rs = [db executeQuery:sql withArgumentsInArray:args];
        if(rs == nil){
            NSLog(@"queryForIntError:%@",[db lastErrorMessage]);
        }
        else if([rs next]){
            string = [rs stringForColumnIndex:0];
        }
    }
    @finally {
        [rs close];
        [self close];
    }
    return string;
}

@end
