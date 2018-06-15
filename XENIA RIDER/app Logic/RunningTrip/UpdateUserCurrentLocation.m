//
//  UpdateUserCurrentLocation.m
//  TeamJoe
//
//  Created by SFYT on 24/05/16.
//  Copyright © 2016 ZappDesignTemplates. All rights reserved.
//

#import <GrepixKit/GrepixKit.h>
#import "UpdateUserCurrentLocation.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "WebCallConstants.h"
@implementation UpdateUserCurrentLocation
{
    float distance;
    NSTimer *aTimer;
    int secondCount;
    CLLocation *preLocation;
    
}
+ (UpdateUserCurrentLocation *)sharedInstance {
    static UpdateUserCurrentLocation *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

-(void) startUpdateCurrentLocation
{
    distance=0;
    [self stopUpdateCurrentLocation];
    aTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(updateLocation)
                                            userInfo:nil
                                             repeats:YES];
}

-(void) updateLocation
{
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    secondCount++;
    
    if([APP_DELEGATE currLoc].latitude>0)
    {
        CLLocation * loc=[[CLLocation alloc]  initWithLatitude:[APP_DELEGATE currLoc].latitude longitude:[APP_DELEGATE currLoc].longitude];
        if(preLocation!=nil)
        {
            
            
            distance =[self calculateDistanceInMilesFrom:preLocation to:loc];
        }
        if(preLocation==nil || distance>100)
        {
            
            preLocation=loc;
            NSDictionary *dict;
            if([APP_DELEGATE currLoc].latitude>0)
            {
                dict=@{P_USER_LAT:@(preLocation.coordinate.latitude),
                       P_USER_LNG:@(preLocation.coordinate.longitude),
                       P_USER_ID:[dict1  objectForKey:P_USER_ID]};
            }
            CallAPI *callapi = [[CallAPI alloc] init];
            [callapi gcURL:BASE_URL app:API_UPDATE_USER_PROFILE
                            data:dict
                   isShowErrorAlert:NO
                    completionBlock:^(id results, NSError *error) {
                        if (error == nil) {
                            secondCount=0;
                            
                        }
                    }];
            
        }
        else{
            [self checkAndUpdateLocation];
        }
    }
    else{
        [self checkAndUpdateLocation];
    }
}

-(void)  checkAndUpdateLocation
{
    if(secondCount>60*5)
    {
    [self updateLocationWhenLogin];
        secondCount=0;
    }
}
-(void) updateLocationWhenLogin
{
    if ([APP_DELEGATE currLoc].latitude>0) {
        
    
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    
    NSDictionary *dict;
    if([APP_DELEGATE currLoc].latitude>0)
    {
        CLLocation * cLocation=[[CLLocation alloc]  initWithLatitude:[APP_DELEGATE currLoc].latitude longitude:[APP_DELEGATE currLoc].longitude];
        dict=@{P_USER_LAT:@(cLocation.coordinate.latitude),
               P_USER_LNG:@(cLocation.coordinate.longitude), P_USER_ID:[dict1 objectForKey:P_USER_ID]};
    }
    CallAPI *callapi = [[CallAPI alloc] init];
    [callapi gcURL:BASE_URL app:API_UPDATE_USER_PROFILE
                    data:dict
           isShowErrorAlert:NO
            completionBlock:^(id results, NSError *error) {
                if (error == nil) {
                    
                    
                }
            }];
    //            NSLog(@"updateLocation...............");
}
}
- (float)calculateDistanceInMilesFrom:(CLLocation *)currentLocation
                                   to:(CLLocation *)destinationLocation {
    
    //    float distance =
    //    [currentLocation distanceFromLocation:destinationLocation] * 0.000621371;
    float distanceCovered =
    [currentLocation distanceFromLocation:destinationLocation];
    
    return distanceCovered;
}
-(void) stopUpdateCurrentLocation
{
    if([aTimer isValid])
    {
        [aTimer  invalidate];
        aTimer=nil;
    }
    preLocation=nil;
}
@end
