//
//  HXSelectProCityAreaAlert.m
//  BaiMi
//
//  Created by licl on 16/7/19.
//  Copyright © 2016年 licl. All rights reserved.
//

#import "HXSelectProCityAreaAlert.h"
#import "HanyuPinyinOutputFormat.h"
#import "PinyinHelper.h"
#import "AppDelegate.h"

@interface HXSelectProCityAreaAlert ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property(strong,nonatomic)NSDictionary*proCityAreaDict;
@property(strong,nonatomic)NSString* selProvince;
@property(strong,nonatomic)NSString*selCity;
@property(strong,nonatomic)NSString*selArea;

@property(strong,nonatomic)UIControl *bgView;

@property(assign,nonatomic)long proSelectRow;
@property(assign,nonatomic)long citySelectRow;

@property(strong,nonatomic)NSMutableArray *proArray;
@property(strong,nonatomic)NSArray *cityArray;
@property(strong,nonatomic)NSArray *areaArray;
@property(strong,nonatomic)NSArray *selectArray;

@end
@implementation HXSelectProCityAreaAlert

- (id)initWithPlace:(HXPlace*)place{
    self = [super init];
    if (self) {
        self.clipsToBounds=YES;
        self.backgroundColor=[UIColor whiteColor];
        self.layer.cornerRadius=5;
        self.clipsToBounds=YES;
        self.frame=CGRectMake(20, 150,SCREEN_WIDTH-40, 250);
        
        NSArray*array=@[@"省",@"市",@"区"];
        int width=self.frame.size.width/3;
        
        for(int i=0;i<3;i++){
            UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(i*width,10, width, 21)];
            label.text=[array objectAtIndex:i];
            label.textAlignment=NSTextAlignmentCenter;
            label.font=[UIFont boldSystemFontOfSize:14.f];
            [self addSubview:label];
        }
        UIImageView*lineImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 36, self.frame.size.width, 1)];
        lineImgView.image=[UIImage imageNamed:@"dottedLine.png"];
        [self addSubview:lineImgView];

        if (!place)
            place=[HXPlace new];
        
        [self getDatas];
        
        UIPickerView*pickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(5, 35, self.frame.size.width-10, 165)];
        pickerView.delegate=self;
        pickerView.dataSource=self;
        [self addSubview:pickerView];
        
        UIImageView*lineImgView2=[[UIImageView alloc] initWithFrame:CGRectMake(0, pickerView.frame.origin.y+pickerView.frame.size.height, self.frame.size.width,1)];
        lineImgView2.image=[UIImage imageNamed:@"dottedLine.png"];
        [self addSubview:lineImgView2];

        UIButton*confirmBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-(self.frame.size.width*0.5)/2,ViewFrameY_H(pickerView)+10, self.frame.size.width*0.5, 30)];
        [confirmBtn setTitle:@"确 定" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        confirmBtn.titleLabel.font=[UIFont systemFontOfSize:15.f];
        confirmBtn.backgroundColor=LightBlueColor;
        confirmBtn.layer.cornerRadius=confirmBtn.frame.size.height/2;
        [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirmBtn];
        
        long proSelectRow=0;
        long citySelectRow=0;
        long areaSelectRow=0;
        
        if (place.province.length) {
            proSelectRow=[self.proArray indexOfObject:place.province];
            NSDictionary*proCityDic=[[_proCityAreaDict objectForKey:place.province] firstObject];
            self.cityArray=[proCityDic allKeys];
            citySelectRow=[self.cityArray indexOfObject:place.city];
            if (_cityArray.count>0) {
                self.areaArray=[proCityDic objectForKey:place.city];
              areaSelectRow=[self.areaArray indexOfObject:place.area];
            }
        }else{
            NSDictionary*proCityDic=[[_proCityAreaDict objectForKey:[self.proArray firstObject]] firstObject];
            self.cityArray=[proCityDic allKeys];
            if (_cityArray.count>0)
                self.areaArray=[proCityDic objectForKey:[self.cityArray firstObject]];
            
        }
        self.selProvince=[self.proArray objectAtIndex:proSelectRow];
        self.selCity=[self.cityArray objectAtIndex:citySelectRow];
        self.selArea=[self.areaArray objectAtIndex:areaSelectRow];
        
        [pickerView selectRow:proSelectRow inComponent:0 animated:NO];
        [pickerView selectRow:citySelectRow inComponent:1 animated:NO];
        [pickerView selectRow:areaSelectRow inComponent:2 animated:NO];
        _proSelectRow=proSelectRow;
        _citySelectRow=citySelectRow;
        [pickerView reloadAllComponents];
        _place=place;
    }
    return self;
}



-(void)getDatas{
    //由xml解析出的plist文件
    NSString *listPath = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    _proCityAreaDict = [[NSDictionary alloc] initWithContentsOfFile:listPath];
    self.proArray=[[_proCityAreaDict allKeys] mutableCopy];
    NSArray*provinces=[[_proCityAreaDict allKeys] mutableCopy];
    //省份按拼音排序
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    NSMutableArray*proObjArray=[NSMutableArray array];
    for(NSString*name in provinces){
        NSString* pinyin = [PinyinHelper toHanyuPinyinStringWithNSString:name withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
        [proObjArray addObject:@{@"name":name,@"pinyin":pinyin}];
    }
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinyin" ascending:YES]];
    [proObjArray sortUsingDescriptors:sortDescriptors];
    self.proArray=[NSMutableArray array];
    for(NSDictionary*dic in proObjArray){
        [self.proArray addObject:[dic objectForKey:@"name"]];
    }
    //    排序后的省份数组
    
}

-(void)confirmBtnClicked:(id)sender{
    _place.province=self.selProvince;
    _place.city=self.selCity;
    _place.area=self.selArea;
//    [self getCLLocationByAdressStr:[NSString stringWithFormat:@"%@,%@",_place.city,_place.area]];
    
    if ([_Cudelegate respondsToSelector:@selector(alertView:selectPlace:)]) {
        [_Cudelegate alertView:self selectPlace:_place];
    }
    [[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self alertRemoveFromSuperview];
}


-(void)show{
    AppDelegate*appDelegate=[AppDelegate appDelegate];
    _bgView=[[UIControl alloc] initWithFrame:CGRectMake(appDelegate.window.frame.origin.x, appDelegate.window.frame.origin.y, appDelegate.window.frame.size.width, appDelegate.window.frame.size.height)];
    _bgView.backgroundColor=[UIColor lightGrayColor];
    _bgView.alpha=0.8;
    
    self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [appDelegate.window addSubview:_bgView];
    [appDelegate.window addSubview:self];
    [_bgView addTarget:self action:@selector(alertRemoveFromSuperview) forControlEvents:UIControlEventTouchUpInside];
}
-(void)alertRemoveFromSuperview
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.alpha=0;
    _bgView.alpha=0;
    [UIView commitAnimations];
    [_bgView removeFromSuperview];
    [self removeFromSuperview];
    
}


#pragma mark-UIPickerViewDataSource & UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return self.proArray.count;
            break;
        case  1:{
            return self.cityArray.count;
        };break;
        case 2:{
            return self.areaArray.count;
        };break;
        default:
            break;
    }
    return 0;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    UILabel *titleView = nil;
    NSString*title=@"";
    if (component==0) {
        title=[self.proArray objectAtIndex:row];
    }else if (component==1){
        title=[self.cityArray objectAtIndex:row];
    }else if (component==2){
        title=[self.areaArray objectAtIndex:row];
    }
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width/3, 30)];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = title;
    titleView.font = [UIFont systemFontOfSize:14];
    
    return titleView;
    
}



- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.frame.size.width/3;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"点击了");
        if(component==0){
            self.selProvince=[self.proArray objectAtIndex:row];
            NSDictionary*proCityDic=[[_proCityAreaDict objectForKey:self.selProvince] firstObject];
            _cityArray=[proCityDic allKeys];
            if (_cityArray.count>0)
                _areaArray=[proCityDic objectForKey:[_cityArray objectAtIndex:0]];
            else
                _areaArray=nil;
            
            [pickerView selectRow:0 inComponent:1 animated:NO];
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:2 animated:NO];
            self.selCity=[_cityArray objectAtIndex:0];
            self.selArea=[_areaArray objectAtIndex:0];
        }
        if (component==1){
            NSDictionary*proCityDic=[[_proCityAreaDict objectForKey:self.selProvince] firstObject];
            _cityArray=[proCityDic allKeys];
             self.selCity=[_cityArray objectAtIndex:row];
            if (_cityArray.count>0)
                _areaArray=[proCityDic objectForKey:self.selCity];
            else
                _areaArray=nil;

            [pickerView selectRow:0 inComponent:2 animated:NO];
            self.selArea=[_areaArray objectAtIndex:0];
        }
        if (component==2) {
            [pickerView selectedRowInComponent:2];
            self.selArea=[self.areaArray objectAtIndex:row];
        }
        [pickerView reloadComponent:2];
}





//-(void)getCLLocationByAdressStr:(NSString*)adressStr{
//    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
//    [myGeocoder geocodeAddressString:adressStr completionHandler:^(NSArray *placemarks, NSError *error) {
//        if ([placemarks count] > 0 && error == nil)
//        {
//            //            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
//            CLPlacemark *firstPlacemark = [placemarks firstObject];
//            NSLog(@"%@ :Lng:%f , Lat:%f",firstPlacemark.name,firstPlacemark.location.coordinate.longitude,firstPlacemark.location.coordinate.latitude);
//            CLLocation* location=[[CLLocation alloc] initWithLatitude:firstPlacemark.location.coordinate.latitude longitude:firstPlacemark.location.coordinate.longitude];
//            _place.location=location;
//        }
//        else if (placemarks.count == 0 && error == nil)
//        {
//            NSLog(@"Found no placemarks.");
//        }
//        else if (error != nil)
//        {
//            NSLog(@"An error occurred = %@", error);
//        }
//        if ([_Cudelegate respondsToSelector:@selector(alertView:selectPlace:)]) {
//            [_Cudelegate alertView:self selectPlace:_place];
//        }
//        [[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
//        [self alertRemoveFromSuperview];
//        
//    }];
//}


@end
