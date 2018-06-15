//
//  GoogleDirectionSource.h
//  XENIA RIDER
//
//  Created by SFYT on 12/06/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "DirectionModel.h"
@interface GoogleDirectionSource : NSObject
@property(strong,nonatomic) CLLocation * source;
@property(strong,nonatomic) CLLocation * destination;
@property(strong,nonatomic) NSString * dropAddress;
@property(strong,nonatomic) NSString * pickAddress;
@property(strong,nonatomic) NSString * pickCountry;
@property(strong,nonatomic) NSString * dropCountry;

-(instancetype)initWithSource:(CLLocation *) sourse destination:(CLLocation *) destination;

-(void) findDirection_isInTrip:(BOOL)isInTrip WithCompletionBlock:(void (^)(id results, NSError *error)) block;
@end
