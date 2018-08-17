//
//  NSDate+Utils.h
//  BaiMi
//
//  Created by licl on 16/6/23.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utils)

- (BOOL)isThisYear;
- (BOOL)isToday;
- (BOOL)isSameDay:(NSDate*)date;
- (BOOL)isNowIn72hours:(NSDate*)lastDate;
- (BOOL)isExistDateTime;//时间是否大于时间纪元1970年1月1日0点，

- (NSInteger)weekday;
- (NSString*)toPastTimeString;  //几分钟前、几小时前、几天前
- (NSString*)remainingTimeStrSinceNow;//距现在几天几小时几分
- (NSString *)toReadableString;
- (NSString *)toReadableStringByDay;

- (NSString *)toStringByYear;
- (NSString *)toStringByMonth;
- (NSString *)toStringByDate;
- (NSString *)toStringByDateNoLine;
- (NSString *)toStringByDateNotYear;
- (NSString *)toStringByDateNotYearNoLine;
- (NSString *)toStringByDateNotYearDot;
- (NSString *)toStringByDayAndTime;
- (NSString *)toStringByTime;
- (NSString *)toStringByTimeSecond;

- (NSString *)toStringByChineseDate;
- (NSString *)toStringByChineseDateTime;
- (NSString*)toStringByChineseDateLine;
- (NSString*)toStringByChineseDateTimeLine;
- (NSString*)toStringByChineseDateTimeSecondLine;


- (NSString *)toStringByTimeAuto;
- (NSString *)toStringByTimeAutoInTodo;
- (NSString *)toStringByHour;
- (NSString *)toStringByMinute;
- (NSString *)toStringBySecond;
- (NSString *)toStringByMs;
- (NSString *)toStringByMinuteNotYear;
- (NSString *)toStringByWeekday;
- (NSString *)toStringByPattern:(NSString *)pattern;

- (NSDate *)toDateTo0;
- (NSDate *)toDateTo24;
- (NSDate *)toDateInZero;
- (NSDate *)toDateNextDay;
+ (NSDate *)toTodayInTimeMs:(long long)times;
+ (NSDate *)toDayInTimeMs:(long long)times InDay:(NSDate *)date;



/*!
 @method
 @abstract 从ms数得到时间
 @param ms ms数
 */
+ (instancetype)dateWithTimeInMsSince1970:(long long int)ms;
- (long long int)timeInMsSince1970;


@end
