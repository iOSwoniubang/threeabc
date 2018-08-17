//
//  NSString+Encryption.m
//  BaiMi
//
//  Created by licl on 16/6/23.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "NSString+Encryption.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Encryption)

- (NSString *) md5HexDigest{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02x", result[i]];
    return [hash lowercaseString];
}

//将普通String转为base64机密字符串
-(NSString*)base64String{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    return base64String;
}

//将base64加密的字符串解密为普通String
-(NSString*)textFromBase64String{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return text;
}
@end
