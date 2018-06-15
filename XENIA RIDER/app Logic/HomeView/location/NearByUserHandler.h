//
//  NearByUserHandler.h
//  XENIA RIDER
//
//  Created by Clean on 5/17/18.
//  Copyright © 2018 Grepixit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DriverModel.h"
#import "UserModel.h"
#import <MapKit/MapKit.h>
@class  NearByUserHandler;
@protocol NearByUserHandlerDelegate <NSObject>
-(void)onStartRefreshing;
-(void) onRefreshNearByDriver:(NSMutableArray *) arrayDrivers;

@end
@interface NearByUserHandler : NSObject

@property(strong,nonatomic) NSString *categoryId;
@property(strong,nonatomic)  CLLocation * pickUpLocation ;
@property(strong,nonatomic) id<NearByUserHandlerDelegate> delegate;

-(void) startGettingNearByDriver;
-(void) stopGetNearByDriver;

-(void) changeCategoryId :(int) categoryId;

-(void) changePickUpLocation :(CLLocation *) picklocation;


@end
