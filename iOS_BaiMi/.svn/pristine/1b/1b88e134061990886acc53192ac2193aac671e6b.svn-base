//
//  NSDate+Utils.m
//  BaiMi
//
//  Created by licl on 16/6/23.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

- (BOOL)isThisYear{
    if([[self toStringByYear] isEqualToString:[[NSDate date] toStringByYear]])
        return YES;
    return NO;
}
- (BOOL)isToday{
    if([self isSameDay:[NSDate date]])
        return YES;
    return NO;
}

- (BOOL)isYesterday{
    NSDate* yestoday = [NSDate dateWithTimeIntervalSinceNow:-24*3600];
    if([self isSameDay:yestoday])
        return YES;
    return NO;
}

- (BOOL)isTheDayBeforeYesterday{
    NSDate* dayBeforeYestoday = [NSDate dateWithTimeIntervalSinceNow:-48*3600];
    if([self isSameDay:dayBeforeYestoday])
        return YES;
    return NO;
}
- (BOOL)isSameDay:(NSDate*)date{
    if([[self toStringByDate] isEqualToString:[date toStringByDate]])
        return YES;
    return NO;
}
- (BOOL)isNowIn72hours:(NSDate*)lastDate{
    NSTimeInterval loginSeperate=-[lastDate timeIntervalSinceNow];
    if (loginSeperate>0 && loginSeperate<72*3600)
        return YES;
    return NO;
}

- (BOOL)isExistDateTime{
    NSDate*beginEraTime=[NSDate dateWithTimeInMsSince1970:0];
    NSTimeInterval timeInterval=[self timeIntervalSinceDate:beginEraTime];
    if (timeInterval>0)
        return YES;
    return NO;
}


-(NSString*)toPastTimeString{
        NSCalendar* cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSLocale * locale = [NSLocale systemLocale];
        NSDateFormatter * df = [[NSDateFormatter alloc] init];
        [df setCalendar:cal];
        [df setLocale:locale];
        //    [df setDateFormat:@"yyyy/MM/dd HH:mm"];
        
        NSTimeInterval interval=-1*[self timeIntervalSinceNow];
        
        if (interval<60)
            return @"刚刚";
        else if (interval>=60 && interval<3600)
            return [NSString stringWithFormat:@"%d分钟前",(int)interval/60];
        else if (interval>=3600 && interval<24*3600)
            return [NSString stringWithFormat:@"%d小时前",(int)interval/3600];
        else if(interval>24*3600 && interval<=7*24*3600)
            return [NSString  stringWithFormat:@"%d天前",(int)interval/(24*3600)];
        else
        {
            [df setDateFormat:@"yyyy/MM/dd"];
            return [df stringFromDate:self];
        }
        //    NSLog(@"[df stringFromDate:self]");
}

-(NSString*)remainingTimeStrSinceNow{
    NSString*remainningTimeStr=@"";
    NSTimeInterval interval=[self timeIntervalSinceNow];
    if (interval>0) {
        if (interval/3600<1) {
            int minute=interval/60;
            remainningTimeStr=[NSString stringWithFormat:@"剩余%d分",minute];
        }else if(interval/3600>1 && interval/(3600*24)<1){
            int hour=interval/3600;
            int minute=(interval-hour*3600)/60;
            remainningTimeStr=[NSString stringWithFormat:@"剩余%d小时%d分",hour,minute];
        }else if (interval/(3600*24)>1){
            int day=interval/(3600*24);
            int hour=(interval-day*3600*24)/3600;
            int minute=(interval-day*3600*24-hour*3600)/60;
            remainningTimeStr=[NSString stringWithFormat:@"剩余%d天%d小时%d分",day,hour,minute];
        }
    }else
        remainningTimeStr=@"已超时";
    return  remainningTimeStr;
}

- (NSString *)toReadableString{
    NSCalendar* cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSLocale * locale = [NSLocale systemLocale];
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setCalendar:cal];
    [df setLocale:locale];
    [df setDateFormat:@"HH:mm"];
    
    NSDate* today = [NSDate date];
    if([self isSameDay:today]){
        return [NSString stringWithFormat:@"今天 %@",[df stringFromDate:self]];
    }
    NSDate* tomorrow = [NSDate dateWithTimeIntervalSinceNow:24*3600];
    if([self isSameDay:tomorrow]){
        return [NSString stringWithFormat:@"明天 %@",[df stringFromDate:self]];
    }
    NSDate* dayAfterTomorrow = [NSDate dateWithTimeIntervalSinceNow:48*3600];
    if([self isSameDay:dayAfterTomorrow]){
        return [NSString stringWithFormat:@"后天 %@",[df stringFromDate:self]];
    }
    NSDate* yestoday = [NSDate dateWithTimeIntervalSinceNow:-24*3600];
    if([self isSameDay:yestoday]){
        return [NSString stringWithFormat:@"昨天 %@",[df stringFromDate:self]];
    }
    NSDate* dayBeforeYestoday = [NSDate dateWithTimeIntervalSinceNow:-48*3600];
    if([self isSameDay:dayBeforeYestoday]){
        return [NSString stringWithFormat:@"前天 %@",[df stringFromDate:self]];
    }
    [df setDateFormat:@"MM/dd HH:mm"];
    return [df stringFromDate:self];
}

- (NSString*)toReadableStringByDay
{
    NSCalendar* cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSLocale * locale = [NSLocale systemLocale];
    
    NSDate* today = [NSDate date];
    if([self isSameDay:today]){
        return @"今天";
    }
    NSDate* tomorrow = [NSDate dateWithTimeIntervalSinceNow:24*3600];
    if([self isSameDay:tomorrow]){
        return @"明天";
    }
    NSDate* dayAfterTomorrow = [NSDate dateWithTimeIntervalSinceNow:48*3600];
    if([self isSameDay:dayAfterTomorrow]){
        return @"后天";
    }
    NSDate* yestoday = [NSDate dateWithTimeIntervalSinceNow:-24*3600];
    if([self isSameDay:yestoday]){
        return @"昨天";
    }
    NSDate* dayBeforeYestoday = [NSDate dateWithTimeIntervalSinceNow:-48*3600];
    if([self isSameDay:dayBeforeYestoday]){
        return @"前天";
    }
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setCalendar:cal];
    [df setLocale:locale];
    [df setDateFormat:@"yyyy/MM/dd"];
    return [df stringFromDate:self];
}

- (NSString*)toStringByYear{
    return [self toStringByPattern:@"yyyy"];
}
-(NSString*)toStringByMonth{
 return [self toStringByPattern:@"yyyy/MM"];
}
- (NSString*)toStringByDate{
    return [self toStringByPattern:@"yyyy/MM/dd"];
}
-(NSString*)toStringByDateNoLine{
    return [self toStringByPattern:@"yyyyMMdd"];
}
- (NSString*)toStringByDateNotYear{
    return [self toStringByPattern:@"MM/dd"];
}
- (NSString *)toStringByDateNotYearNoLine{
    return [self toStringByPattern:@"MMdd"];
}
- (NSString *)toStringByDateNotYearDot{
    return [self toStringByPattern:@"MM.dd"];
}
-(NSString *)toStringByDayAndTime{
    return [self toStringByPattern:@"dd HH:mm:ss"];
}
- (NSString*)toStringByTime{
    return [self toStringByPattern:@"HH:mm"];
}
-(NSString*)toStringByTimeSecond{
   return [self toStringByPattern:@"HH:mm:ss"];
}
-(NSString*)toStringByChineseDateLine{
   return [self toStringByPattern:@"yyyy-MM-dd"];
}
-(NSString*)toStringByChineseDateTimeLine{
 return [self toStringByPattern:@"yyyy-MM-dd HH:mm"];
}

-(NSString*)toStringByChineseDateTimeSecondLine{
    return [self toStringByPattern:@"yyyy-MM-dd HH:mm:ss"];
}
-(NSString*)toStringByChineseDate{
 return [self toStringByPattern:@"yyyy年MM月dd日"];
}
-(NSString*)toStringByChineseDateTime{
    return [self toStringByPattern:@"yyyy年MM月dd日 HH:mm"];
}

- (NSString*)toStringByTimeAuto{
    if ([self isToday])
        return [NSString stringWithFormat:@"今天%@",[self toStringByTime]];
    if ([self isYesterday])
        return [NSString stringWithFormat:@"昨天%@",[self toStringByTime]];
    if ([self isTheDayBeforeYesterday])
        return [NSString stringWithFormat:@"前天%@",[self toStringByTime]];
    else
        return [self toStringByMinute];
}
- (NSString*)toStringByTimeAutoInTodo{
    if ([self isToday])
        return [NSString stringWithFormat:@"今天%@",[self toStringByTime]];
    else
        return [self toStringByDate];
}
- (NSString*)toStringByHour{
    return [self toStringByPattern:@"yyyy/MM/dd HH"];
}
- (NSString *)toStringByMinute{
    return [self toStringByPattern:@"yyyy/MM/dd HH:mm"];
}
- (NSString *)toStringBySecond{
    return [self toStringByPattern:@"yyyy/MM/dd HH:mm:ss"];
}
- (NSString *)toStringByMs{
    return [self toStringByPattern:@"yyyy/MM/dd HH:mm:ss.SSS"];
}
- (NSString*)toStringByMinuteNotYear{
    return [self toStringByPattern:@"MM/dd HH:mm"];
}
- (NSDate *)toDateTo0{
    return [self toDateByPattern:@"yyyy/MM/dd" from:[self toStringByDate]];
}

- (NSDate *)toDateTo24{
    NSDate *date = [self toDateByPattern:@"yyyy/MM/dd" from:[self toStringByDate]];
    return [NSDate dateWithTimeInterval:86400 sinceDate:date];
}
- (NSDate*)toDateInZero{
    return [self toDateByPattern:@"yyyy/MM/dd" from:[self toStringByDate]];
}
- (NSDate*)toDateNextDay{
    NSTimeInterval time = [self timeIntervalSince1970];
    time +=86400;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    return date;
}
+ (NSDate*)toTodayInTimeMs:(long long)times{
    return [self toDayInTimeMs:times InDay:[NSDate date]];
}
+ (NSDate*)toDayInTimeMs:(long long)times InDay:(NSDate*)date{
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond |NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    NSDate *date0 = [NSDate dateWithTimeInMsSince1970:times];
    NSDateComponents *dateComponents0 = [calendar components:unitFlags fromDate:date0];
    dateComponents.hour = dateComponents0.hour;
    dateComponents.minute = dateComponents0.minute;
    dateComponents.second = 0;
    return [calendar dateFromComponents:dateComponents];
}

- (NSString *)toStringByPattern:(NSString *)pattern{
    NSCalendar* cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSLocale * locale = [NSLocale systemLocale];
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setCalendar:cal];
    [df setLocale:locale];
    [df setDateFormat:pattern];
    return [df stringFromDate:self];
}
- (NSString*)toStringByWeekday{
    NSInteger weekday = [self weekday];
    NSString *str = @"";
    switch (weekday) {
        case 1: str = @"星期日"; break;
        case 2: str = @"星期一"; break;
        case 3: str = @"星期二"; break;
        case 4: str = @"星期三"; break;
        case 5: str = @"星期四"; break;
        case 6: str = @"星期五"; break;
        case 7: str = @"星期六"; break;
        default: break;
    }
    return str;
}
- (NSInteger)weekday{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps =[calendar components:(NSCalendarUnitWeekOfMonth| NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)
                       fromDate:self];
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    return weekday;
}
- (NSDate *)toDateByPattern:(NSString *)pattern from:(NSString*)dateStr{
    NSCalendar* cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSLocale * locale = [NSLocale systemLocale];
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setCalendar:cal];
    [df setLocale:locale];
    [df setDateFormat:pattern];
    return [df dateFromString:dateStr];
}

+ (instancetype)dateWithTimeInMsSince1970:(long long)ms{
    return [NSDate dateWithTimeIntervalSince1970:ms*1.0/1000];
}

- (long long)timeInMsSince1970{
    NSTimeInterval a = [self timeIntervalSince1970];
    long long int ret = 0;
    ret = (ret+a)*1000;
    return ret;
}



@end
