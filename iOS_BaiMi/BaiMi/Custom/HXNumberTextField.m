//
//  HXNumberTextField.m
//  BaiMi
//
//  Created by licl on 16/8/8.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXNumberTextField.h"

@implementation HXNumberTextField

-(id)initWithFrame:(CGRect)frame Type:(UIKeyboardType)keyboardType{
    self=[super init];
    if (self) {
    self.frame=frame;
    self.keyboardType=keyboardType;
    UIToolbar *toolBar=[[UIToolbar alloc]init];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *done=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];

    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithCustomView:[self createBtn]];
    toolBar.items=@[space,done];
    self.inputAccessoryView=toolBar;
    toolBar.bounds=CGRectMake(0, 0, 100, 44);
    }
    return self;
}

-(UIButton*)createBtn{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 2, 70, 40)];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:LightBlueColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(void)doneClick
{
    [self endEditing:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
