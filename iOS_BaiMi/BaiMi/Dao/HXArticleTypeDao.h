//
//  HXArticleTypeDao.h
//  BaiMi
//
//  Created by licl on 16/7/19.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "BasicDao.h"
#import "HXArticleType.h"

@interface HXArticleTypeDao : BasicDao

-(void)addUpdateArticle:(HXArticleType*)articleType;
-(void)insertUpdateArticles:(NSArray*)articles;
-(NSArray*)fetchAllArticles;
@end
