//
//  TripModel.h
//  TaxiDriver
//
//  Created by SFYT on 25/05/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DriverModel.h"



@interface TripModel : NSObject

@property(nonatomic) NSString* trip_Id;
@property(nonatomic,strong) NSString *trip_Status;
@property(nonatomic,strong) NSString *trip_user_full_name;
@property(nonatomic,strong) NSString *trip_user_mobile_number;
@property(nonatomic,strong) NSString *trip_user_image;
@property(nonatomic,strong) NSString *trip_user_device_token;
@property(nonatomic,strong) NSString *trip_user_device_type;
@property(nonatomic,strong) NSString *trip_pick_loc;
@property(nonatomic,strong) NSString *trip_drop_loc;
@property(nonatomic,strong) NSString *trip_pick_lat;
@property(nonatomic,strong) NSString *trip_pick_long;
@property(nonatomic,strong) NSString *trip_drop_lat;
@property(nonatomic,strong) NSString *trip_drop_long;
@property(nonatomic,strong) NSString *trip_created_time;
@property(nonatomic,strong) NSString *trip_fare;
@property(nonatomic,strong) NSString *trip_driver_commision;
@property(nonatomic,strong) NSString *trip_distance;
@property(nonatomic,strong) NSString *trip_pay_mode;
@property(nonatomic,strong) NSString *trip_pay_status;
@property(nonatomic,strong) NSString *trip_promo_amt;
@property(nonatomic,strong) NSString *trip_cancel_reason;
@property(nonatomic,assign) float trip_time;
@property(nonatomic,strong) NSString *tax_amount;
@property(nonatomic,assign) BOOL isPromoCodeUsed;
@property(strong,nonatomic) DriverModel *driver;
@property(nonatomic,strong) NSString *trip_pickup_time;
@property(nonatomic,strong) NSString *trip_drop_time;




-(BOOL) isPaid;

-(void)sendNotification;

-(instancetype)initItemWithDict:(NSMutableDictionary *)tripDict;

-(void) updateTripModelWith:(NSDictionary *) dict completionBlock:(void (^)(id results, NSError *error))block isShowLoader:(BOOL)isShowLoader;
-(void) updateTripModelWith:(NSDictionary *) dict completionBlock:(void (^)(id results, NSError *error))block isShowLoader:(BOOL)isShowLoader isSendNotification:(BOOL)isSendNotification;

-(void) refreshTripModelWithCompletionBlock:(void (^)(id results, NSError *error))block isShowLoader:(BOOL)isShowLoader;
@end
