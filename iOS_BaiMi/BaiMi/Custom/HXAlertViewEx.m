//
//  HXAlertViewEx.m
//  walrusWuLiuCP
//
//  Created by 海象 on 15/9/1.
//  Copyright (c) 2015年 海象. All rights reserved.
//

#import "HXAlertViewEx.h"
@interface HXAlertViewEx()<UIAlertViewDelegate>
@end
@implementation HXAlertViewEx
static HXAlertViewEx *obj;
static UIAlertView *alertView;
static NSString *lastContent;
static NSDate *lastTime;
static bool hasOne;

+ (HXAlertViewEx*)obj{
    @synchronized(self){
        if (obj == nil)
            obj = [HXAlertViewEx new];
        return obj;
    }
}

- (UIAlertView*)alertView{
    @synchronized(self)
    {
        alertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        alertView.delegate = self;
    }
    return alertView;
}
+ (void)showInTitle:(NSString*)title Message:(NSString*)message ViewController:(UIViewController*)vc{
    if (!hasOne) {
        HXAlertViewEx *obj = [self obj];
        [obj showInTitle:title Message:message ViewController:vc];
        hasOne=YES;
    }
}

- (void)showInTitle:(NSString*)title Message:(NSString*)message ViewController:(UIViewController*)vc{
    alertView = [self alertView];
    if (![message isEqualToString:lastContent] || (!lastContent.length) || [[NSDate date] timeIntervalSinceDate:lastTime] > 5) {
        [alertView setTitle:title];
        [alertView setMessage:message];
        [alertView show];
        lastContent = message;
        lastTime = [NSDate date];
        //         UIGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
        //                                                                action:@selector(tapGestured:)];
        //        tapGesture.cancelsTouchesInView = NO;
        //        [alertView.window addGestureRecognizer:tapGesture];
        
        [self performSelector:@selector(dissAlertView) withObject:nil afterDelay: MIN((float)(message.length+title.length)*0.15 + 1, 5.0)];
    }
}

- (void)dissAlertView{
    if (alertView){
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        alertView = nil;
        lastContent = nil;
        hasOne=NO;
    }
}


//-(void)tapGestured:(UIGestureRecognizer*)gesture{
//    if (gesture.state == UIGestureRecognizerStateEnded){
//        CGPoint location = [gesture locationInView:nil];
//        if (![alertView pointInside:[alertView convertPoint:location fromView:alertView.window] withEvent:nil]){
//            [alertView.window removeGestureRecognizer:gesture];
//            [alertView dismissWithClickedButtonIndex:0
//                                        animated:YES];
//        }
//    }
//}
@end
