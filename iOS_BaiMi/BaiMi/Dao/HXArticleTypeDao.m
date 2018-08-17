//
//  HXArticleTypeDao.m
//  BaiMi
//
//  Created by licl on 16/7/19.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXArticleTypeDao.h"

@interface HXArticleTypeDao ()
@property(strong,nonatomic)NSDictionary*rowMapper;
@end
@implementation HXArticleTypeDao

-(id)init{
    if (self=[super init]) {
        self.rowMapper=@{
                         @"no":@"no",
                         @"name":@"name",
                         };
    }
    return self;
}


-(void)addUpdateArticle:(HXArticleType*)articleType{
    [self update:@"replace into articleTypeTable(no,name)values(?,?)" withArgs:@[articleType.no,articleType.name]];
}

-(void)insertUpdateArticles:(NSArray*)articles{
    for(HXArticleType*articleType in articles){
        [self addUpdateArticle:articleType];
    }
}

-(NSArray*)fetchAllArticles{
    return [self query:@"select * from articleTypeTable" withArgs:nil column2NameMapper:self.rowMapper withClass:[HXArticleType class]];
}
@end
