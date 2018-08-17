//
//  HXCouponModel.h
//  BaiMi
//
//  Created by HXMAC on 16/7/13.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXCouponModel : NSObject
@property (nonatomic,strong)NSString *title;//标题
@property (nonatomic,strong)NSString *couponNo;//优惠券编号

@property (nonatomic,strong)NSDate *createTime;
@property (nonatomic,strong)NSDate*expireTime;//过期时间

@property (nonatomic,strong)NSDate *usesTime; //使用时间(已使用优惠券有效)
@property (nonatomic,assign)HXCouponType type;//优惠券类型（1.现金抵用券  2.折扣券）
@property (nonatomic,assign)HXBusinessType businessType;//抵用券业务类型
@property (nonatomic,strong)NSString *businessNo;//业务编号(已使用优惠券有效)
@property (nonatomic,strong)NSString *faceValue;//优惠券面值
@property (nonatomic,strong)NSString *floor;//使用下限
@property (nonatomic,strong)NSString *remark;//备注

@property(assign,nonatomic)BOOL selected;

@end
