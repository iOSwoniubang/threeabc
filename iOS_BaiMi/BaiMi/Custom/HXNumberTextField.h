//
//  HXNumberTextField.h
//  BaiMi
//
//  Created by licl on 16/8/8.
//  Copyright © 2016年 licl. All rights reserved.
//

#import <UIKit/UIKit.h>

//为数字、小数、电话键盘等类型的键盘增加完成按钮

@interface HXNumberTextField : UITextField
-(id)initWithFrame:(CGRect)frame Type:(UIKeyboardType)keyboardType;
@end
