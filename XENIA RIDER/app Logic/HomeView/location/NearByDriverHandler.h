//
//  NearByDriverHandler.h
//  XENIA RIDER
//
//  Created by SFYT on 14/06/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DriverModel.h"
#import <MapKit/MapKit.h>
@class  NearByDriverHandler;
@protocol NearByDriverHandlerDelegate <NSObject>
-(void)onStartRefreshing;
-(void) onRefreshNearByDriver:(NSMutableArray *) arrayDrivers;

@end
@interface NearByDriverHandler : NSObject

@property(strong,nonatomic) NSString *categoryId;
@property(strong,nonatomic)  CLLocation * pickUpLocation ;
@property(strong,nonatomic) id<NearByDriverHandlerDelegate> delegate;

-(void) startGettingNearByDriver;
-(void) stopGetNearByDriver;

-(void) changeCategoryId :(int) categoryId;

-(void) changePickUpLocation :(CLLocation *) picklocation;


@end
