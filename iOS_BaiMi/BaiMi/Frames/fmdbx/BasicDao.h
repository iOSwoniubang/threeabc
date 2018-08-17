//
//  BasicDao.h
//
//  Created by licl on 15/10/13.
//  Copyright (c) 2015年 licl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseHelper.h"
#import "HXMacro.h"

@interface BasicDao : NSObject

/**
 *  表格列对应对象属性字典
 */
@property (strong, nonatomic) NSDictionary *column2NameMapper;

- (NSString*)ownerId;
/**
 * 不带参数的插入或者更新
 *
 * @param sql
 */
-(BOOL)update:(NSString*)sql;

/**
 * 带参数插入或者更新
 *
 * @param sql
 * @param args
 */
-(BOOL)update:(NSString*)sql withArgs:(NSArray*)args;

/**
 * 查询，返回多条记录
 *
 * @param sql
 * @param args
 * @param rowMapper 从表字段名到类属性的映射
 * @param class 要转换的目标类
 * @return
 */
-(NSArray*)query:(NSString*)sql withArgs:(NSArray*)args column2NameMapper:(NSDictionary*)rowMapper withClass:(Class)class;

/**
 * IN查询，返回LIST集合
 *
 * @param sql
 * @param args
 * @param multiRowMapper
 * @return
 */
-(NSArray*)queryForInSql:(NSString*)prefix withPrefixArgs:(NSArray*)prefixArgs inArgs:(NSArray*)inArgs postfix:(NSString*)postfix column2NameMapper:(NSDictionary*)rowMapper withClass:(Class)class;
/**
 *  查询，返回单个整数
 *
 *  @param sql
 *  @param args
 *
 *  @return
 */
-(int)queryForInt:(NSString*)sql withArgs:(NSArray*)args;
/**
 *  查询，返回单个整字符串
 *
 *  @param sql
 *  @param args
 *
 *  @return
 */
-(NSString*)queryForString:(NSString*)sql withArgs:(NSArray*)args;
@end
