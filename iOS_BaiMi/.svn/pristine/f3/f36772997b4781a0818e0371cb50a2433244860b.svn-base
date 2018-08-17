//
//  NSInputStreamReader.h
//
//  Created by licl on 15/10/13.
//  Copyright (c) 2015年 licl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSInputStreamReader : NSObject

@property (strong, nonatomic) NSInputStream *inputStream;

-(id)initWithFileAtPath:(NSString*)filePath;
-(id)initWithData:(NSData*)data;
-(id)initWithURL:(NSURL*)url;

-(void)open;
-(void)close;

//没有新行则返回nil
-(NSString*)readLine;
@end
