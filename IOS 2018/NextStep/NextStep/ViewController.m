//
//  ViewController.m
//  NextStep
//
//  Created by baimi on 2018/8/15.
//  Copyright © 2018年 liubang. All rights reserved.
//

#import "ViewController.h"

#import "AFNetworking.h"

@interface ViewController ()


@end

@implementation ViewController
- (IBAction)oushhome:(id)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showdata];
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)showdata{
    AFHTTPSessionManager * session  = [AFHTTPSessionManager manager];
    NSDictionary *dict = @{@"foo":@"bar"};
    [session POST:@"https://httpbin.org/post" parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功");
        NSLog(@"-----%@ -----%@",responseObject ,responseObject[@"origin"]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
    }];
    
    //
   
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
