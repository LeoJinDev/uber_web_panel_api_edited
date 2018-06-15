//
//  NearByDriverHandler.m
//  XENIA RIDER
//
//  Created by SFYT on 14/06/17.
//  Copyright © 2017 SFYT. All rights reserved.
//
#import <GrepixKit/GrepixKit.h>

#import "NearByDriverHandler.h"
// 
#import "AppDelegate.h"
#import "WebCallConstants.h"
#import "ConstantModel.h"
#import <GrepixKit/GrepixKit.h>
//#import "CallAPI.h"
@implementation NearByDriverHandler
{
    
    NSTimer *nearbyTimer;
    BOOL isStoped;
    CallAPI *callapi;
}

-(instancetype)init
{
    self=[super init];
    self.categoryId = @"1";
    isStoped=NO;
    return  self;
}


-(void) startGettingNearByDriver
{
    isStoped=NO;
    
    [self getNearByDrivers];
    
}


-(void)getNearByDrivers{
    [self   getNearByDriverIdWithCompletion:^(id results, NSError *error) {
        if(error ==nil)
        {
            if(self.delegate)
            {
                [self.delegate onRefreshNearByDriver:results];
            }
//            if(!isStoped)
//            {
//                nearbyTimer = [NSTimer scheduledTimerWithTimeInterval: 15.0 target: self selector: @selector(getNearByDrivers) userInfo: nil repeats: NO];
//            }
        }else{
            //[self getNearByDrivers];
        }
        if(!isStoped)
        {
            if(nearbyTimer)
            {
                [nearbyTimer  invalidate];
                nearbyTimer=nil;
            }
            nearbyTimer = [NSTimer scheduledTimerWithTimeInterval: 15.0 target: self selector: @selector(getNearByDrivers) userInfo: nil repeats: NO];
        }
    }];
}


-(void) stopGetNearByDriver
{
    isStoped=YES;
    if(nearbyTimer)
    {
        [nearbyTimer  invalidate];
        nearbyTimer=nil;
    }
    if (callapi) {
        [callapi CancelRequest];
        callapi = nil;
    }
}

-(void) changePickUpLocation :(CLLocation *) picklocation
{
    self.pickUpLocation=picklocation;
    [self stopGetNearByDriver];
    [self startGettingNearByDriver];
}

-(void) changeCategoryId :(int) categoryId
{
    self.categoryId= [NSString stringWithFormat:@"%d", categoryId];
    [self stopGetNearByDriver];
    [self startGettingNearByDriver];
}


-(void)  getNearByDriverIdWithCompletion:(void (^)(id results, NSError *error)) block
{
    AppDelegate *appdelegate=APP_DELEGATE;
    
    NSArray * arr = defaults_object(@"constantResponse");
    ConstantModel *constantModel =[[ConstantModel alloc]initItemWithDict:arr];
    NSMutableDictionary *  dict =[[NSMutableDictionary alloc]init] ;
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    if(self.pickUpLocation)
    {
        dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                               
                                                               P_USER_ID            :[dict1 objectForKey:P_USER_ID],
                                                               P_LAT                : [NSString stringWithFormat:@"%f",self.pickUpLocation.coordinate.latitude],
                                                               P_LNG                : [NSString stringWithFormat:@"%f",self.pickUpLocation.coordinate.longitude],
                                                               P_CATEGORY_ID        :_categoryId,
                                                             
                                                               }];
    }
    else{
        
        dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                               
                                                               P_USER_ID            :[dict1 objectForKey:P_USER_ID],
                                                               P_LAT                : [NSString stringWithFormat:@"%f",appdelegate.currLoc.latitude],
                                                               P_LNG               : [NSString stringWithFormat:@"%f",appdelegate.currLoc.longitude],
                                                               P_CATEGORY_ID        : _categoryId,
                                                                                                                          }];
    }
    
    if (constantModel.constant_driver_radius == nil) {
        
        [dict setObject:@"2" forKey:@"miles"];
    }
    else{
    
         [dict setObject:constantModel.constant_driver_radius forKey:@"miles"];
    }
    
    callapi = [[CallAPI alloc] init];
    if(self.delegate)
    {
        [self.delegate onStartRefreshing];
    }
    if ([[dict objectForKey:P_LAT] floatValue]>0.0) {
        
    
    [callapi gcURL:BASE_URL app:GET_DRIVERS_NEARBY
                    data:dict
           isShowErrorAlert:NO
            completionBlock:^(id results, NSError *error) {
                
                if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                    // success
                    NSMutableArray * driversArray=[DriverModel parseDirversResponse:[results objectForKey:P_RESPONSE]];
                    block(driversArray,nil);
                    
                }
                else{
                    block(nil,error);
                    
                }
            }];
    }
    
}

@end
