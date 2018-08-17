//
//  HXNSStringUtil.m
//  BaiMi
//
//  Created by licl on 16/6/23.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXNSStringUtil.h"
#import "NSString+Encryption.h"
//#import "SFBubbleViewTools.h"
//#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24)

@implementation HXNSStringUtil

//获取skey
+(NSString*)getSkeyByParamInfo:(NSArray*)paramArray{
    NSMutableArray*array=[NSMutableArray array];
    if (paramArray.count)
        [array addObjectsFromArray:paramArray];
    NSString*sKey=[array componentsJoinedByString:@"|"];
    sKey=sKey.md5HexDigest;
    return sKey;
}

//是否是座机号码
+(BOOL)isZPhoneNumber:(NSString*)telephoneNum
{
    NSString*zPhone=@"0\\d{2,3}\\d{7,8}|\\d{7,8}";
    NSPredicate*regetestZP=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",zPhone];
    return [regetestZP evaluateWithObject:telephoneNum];
}

//是否是手机号码
+(BOOL)isMobilePhoneNumber:(NSString*)phoneNum{
//    NSString*mobilePhone= @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9])|(17[0-9]))\\d{8}$";
    NSString*mobilePhone=@"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate*regetestMobilePhone=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobilePhone];
    return [regetestMobilePhone evaluateWithObject:phoneNum];
}                                


+(BOOL)isPassword:(NSString*)password{
     //6-16位：全数字、全字母、全特殊字符(~!@#$%^&*.)、三种的组合、任意两种的组合
        NSString *passWordRegex = @"^[a-zA-Z0-9!\\#$%&'()*+,-./:;<=>?@\[\\\\]^_`\{\\|\\}\\~]{6,16}$";
        NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
        return [passWordPredicate evaluateWithObject:password];
}

//是否是身份证号
+(BOOL)isIdCardNumber:(NSString*)idCardNum{

BOOL flag;

if(idCardNum.length<=0){
    flag=NO;
    return flag;
}
NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
flag = [identityCardPredicate evaluateWithObject:idCardNum];

//如果通过该验证，说明身份证格式正确，但准确性还需计算
if(flag){
    if(idCardNum.length==18)
    {
        //将前17位加权因子保存在数组里
        NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        
        //用来保存前17位各自乖以加权因子后的总和
        
        NSInteger idCardWiSum = 0;
        for(int i = 0;i < 17;i++)
        {
            NSInteger subStrIndex = [[idCardNum substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            
            idCardWiSum+= subStrIndex * idCardWiIndex;
            
        }
        
        //计算出校验码所在数组的位置
        NSInteger idCardMod=idCardWiSum%11;
        
        //得到最后一位身份证号码
        NSString * idCardLast= [idCardNum substringWithRange:NSMakeRange(17, 1)];
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2)
        {
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
                return flag;
        else{
                flag =  NO;
                return flag;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
                return flag;
            else{
                flag =  NO;
                return flag;
            }
        }
    }
    else{
        flag =  NO;
        return flag;
    }
}
else
    return flag;
}


//是否是银行卡号
+(BOOL)isBankCardNumber:(NSString*)bankCarNum{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[bankCarNum length];
    int lastNum = [[bankCarNum substringFromIndex:cardNoLength-1] intValue];
    
    bankCarNum = [bankCarNum substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [bankCarNum substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}



+(NSString*)getJsonStringFromDicOrArray:(id)obj{
    NSString*str=@"";
    NSError *error=nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    if (!error)
        str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return str;
}

+(id)getJsonArrayOrJsonDicFormJsonStr:(NSString*)jsonStr{
    NSData*jsonData=[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    return obj;
}

//+(NSString*)getEmojiStringByReplaceEmojiCodeFromText:(NSString*)showStr{
//    NSString*textStr=showStr;
//    if ([textStr containsString:@"\\"]) {
//        NSDictionary * faceMap=[SFBubbleViewTools getFaceMap];
//        NSArray *valusArray = [faceMap allValues];
//        for (NSString *str1 in valusArray) {
//            if ([textStr containsString:str1]) {
//                NSDictionary *EmotDict = [SFBubbleViewTools getchangeEmot];
//                int emotEncode = [[EmotDict objectForKey:str1]  intValue];
//                int sym = EMOJI_CODE_TO_SYMBOL(emotEncode);
//                NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
//                NSString*placeStr=[NSString stringWithFormat:@"\\%@",str1];
//                showStr= [showStr stringByReplacingOccurrencesOfString:placeStr withString:emoT];
//            }
//        }
//    }
//    return showStr;
//}

@end
