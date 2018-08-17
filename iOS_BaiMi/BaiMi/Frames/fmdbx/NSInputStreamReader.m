//
//每次读取一行文件
//  NSInputStreamReader.m
//
//  Created by licl on 15/10/13.
//  Copyright (c) 2015年 licl. All rights reserved.
//

#import "NSInputStreamReader.h"

@interface NSInputStreamReader()
@property (strong,nonatomic) NSMutableData* readedData;
@end

@implementation NSInputStreamReader

-(id)init{
    if(self = [super init]){
    }
    return self;
}

-(id)initWithFileAtPath:(NSString *)filePath{
    if(self = [super init]){
        self.inputStream = [[NSInputStream alloc] initWithFileAtPath:filePath];
    }
    return self;
}

-(id)initWithData:(NSData *)data{
    if(self = [super init]){
        self.inputStream = [[NSInputStream alloc] initWithData:data];
    }
    return self;
}

-(id)initWithURL:(NSURL *)url{
    if(self = [super init]){
        self.inputStream = [[NSInputStream alloc] initWithURL:url];
    }
    return self;
}

-(void)open{
    [self.inputStream open];
}

-(void)close{
    [self.inputStream close];
}

-(NSString *)readLine{
    if(self.readedData && self.readedData.length>0){
        NSInteger len = self.readedData.length;
        uint8_t buf[len];
        [self.readedData getBytes:buf length:len];
        NSInteger index = -1;
        for(int i=0;i<len;i++){
            if(buf[i] == '\n'){
                index = i;
                break;
            }
        }
        if(index != -1){
            if(index != len-1){
                self.readedData = [[self.readedData subdataWithRange:NSMakeRange(index+1, len-index-1)] mutableCopy];
            }
            else{
                self.readedData = nil;
            }
            return [[NSString alloc] initWithBytes:buf length:index encoding:NSUTF8StringEncoding];
        }
    }
    
    int maxLen = 512;
    uint8_t buf[maxLen];
    NSInteger readed = [self.inputStream read:buf maxLength:maxLen];
    while(readed > 0){
        if(self.readedData == nil){
            self.readedData = [[NSMutableData alloc] init];
        }
        [self.readedData appendBytes:buf length:readed];
        
        return [self readLine];//di gui
    }
    
    return nil;
}

@end
