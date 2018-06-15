//
//  TripModel.m
//  TaxiDriver
//
//  Created by SFYT on 25/05/17.
//  Copyright © 2017 SFYT. All rights reserved.
//


/*
 {
 Driver =     {
 "api_key" = 1efdad769eb65ab8f77c4be6eefcb9d3;
 "car_created" = "2016-10-13 14:20:34";
 "car_currency" = rupee;
 "car_desc" = "GOOD IN CONDITION.";
 "car_fare_per_km" = 0;
 "car_fare_per_min" = 0;
 "car_id" = 6;
 "car_model" = 2011;
 "car_modified" = "2016-10-13 14:20:34";
 "car_name" = Ford;
 "car_reg_no" = "RJ-02 AQ 2321";
 "category_id" = 3;
 "d_address" = "";
 "d_city" = "New Delhi";
 "d_country" = India;
 "d_created" = "2016-10-12 12:19:34";
 "d_degree" = 0;
 "d_device_token" = c721859059dcb7cb0f5ce0d801cd208492624454156086f7afde3b50a0a5d44e;
 "d_device_type" = ios;
 "d_email" = "test01@gmail.com";
 "d_fname" = test;
 "d_is_available" = 1;
 "d_is_verified" = 1;
 "d_lat" = "28.535584";
 "d_license_id" = 362;
 "d_license_image_path" = "4/vN5JG92Z0HKlvAH.jpg";
 "d_lname" = first4;
 "d_lng" = "77.259609";
 "d_modified" = "2017-06-20 07:03:59";
 "d_name" = test;
 "d_password" = 05a671c66aefea124cc08b76ea6d30bb;
 "d_phone" = 1236587457;
 "d_profile_image_path" = "6/jAuc1XYVd32OhUn.jpg";
 "d_rating" = "3.75";
 "d_rating_count" = 2;
 "d_rc" = 77;
 "d_rc_image_path" = "3/9eD29GUmZslLTRH.jpg";
 "d_state" = "";
 "d_zip" = "";
 "driver_id" = 1;
 "image_id" = 6;
 };
 User =     {
 active = 1;
 "api_key" = ee059a1e2596c265fd61c44f1855875e;
 "emergency_contact_1" = 2147483647;
 "emergency_contact_2" = 2147483647;
 "emergency_contact_3" = 2147483647;
 "emergency_email_1" = "";
 "emergency_email_2" = "";
 "emergency_email_3" = "";
 "group_id" = 1;
 "image_id" = 406;
 password = 170ba216da1314b2e1c4c400ebb74bdd5f27e09a;
 "u_address" = "";
 "u_city" = delhi;
 "u_country" = "";
 "u_created" = "2016-10-12 13:22:02";
 "u_degree" = 0;
 "u_device_token" = 1281e1a3ceb7d0c876e41434e969159b5f942586b8b5918a5143024c07d3c298;
 "u_device_type" = ios;
 "u_email" = "test@gmail.com";
 "u_fbid" = "";
 "u_fname" = "ram ";
 "u_is_available" = 0;
 "u_last_loggedin" = "2017-06-20 08:27:41";
 "u_lat" = "28.704100";
 "u_lname" = lasthsjnsn;
 "u_lng" = "77.102500";
 "u_modified" = "2017-06-20 08:27:42";
 "u_name" = "ram  lasthsjnsn";
 "u_password" = 098f6bcd4621d373cade4e832627b4f6;
 "u_phone" = 8787676565;
 "u_profile_image_path" = "7/QEKQVvCfEVgj9t8.jpg";
 "u_state" = "";
 "u_zip" = "";
 "user_id" = 3;
 username = sfasdfdsa;
 };
 "driver_id" = 1;
 "promo_id" = 0;
 "trip_actual_drop_lat" = "";
 "trip_actual_drop_lng" = "";
 "trip_actual_pick_lat" = "";
 "trip_actual_pick_lng" = "";
 "trip_created" = "2017-06-20 07:02:48";
 "trip_date" = "2017-06-20";
 "trip_distance" = 26;
 "trip_driver_commision" = 0;
 "trip_drop_time" = "";
 "trip_fare" = 0;
 "trip_feedback" = "";
 "trip_from_loc" = "Kalkaji,New Delhi,Delhi 110019,India";
 "trip_id" = 1799;
 "trip_modified" = "2017-06-20 07:03:55";
 "trip_pay_amount" = "328.2";
 "trip_pay_date" = "";
 "trip_pay_mode" = "";
 "trip_pay_status" = "";
 "trip_pickup_time" = "";
 "trip_promo_amt" = 0;
 "trip_promo_code" = "";
 "trip_rating" = "";
 "trip_reason" = Test;
 "trip_scheduled_drop_lat" = "28.587613";
 "trip_scheduled_drop_lng" = "77.042334";
 "trip_scheduled_pick_lat" = "28.535607";
 "trip_scheduled_pick_lng" = "77.259582";
 "trip_search_result_addr" = "Dwarka, New Delhi, Delhi, India";
 "trip_searched_addr" = "";
 "trip_status" = "driver_cancel";
 "trip_to_loc" = "Dwarka, New Delhi, Delhi, India";
 "trip_validity" = Past;
 "trip_wait_time" = "";
 "user_id" = 3;
 }

 */

#import "TripModel.h"
//#import "CallAPI.h"
 
#import "WebCallConstants.h"
#import <GrepixKit/GrepixKit.h>
@implementation TripModel
-(instancetype)initItemWithDict:(NSMutableDictionary *)tripDict{
    
    self = [super init];
    
    if (self) {
        [self  parseResponse:tripDict];
    }
    return self;
}


-(void)  parseResponse:(NSMutableDictionary *)tripDict
{
    self.trip_Id  = [tripDict objectForKey:@"trip_id"];
    self.trip_fare = [tripDict objectForKey:@"trip_pay_amount"];
    self.trip_Status = [tripDict objectForKey:@"trip_status"];
    self.trip_drop_loc = [tripDict objectForKey:@"trip_to_loc"];
    self.trip_distance = [tripDict objectForKey:@"trip_distance"];
    self.trip_user_device_type = [[tripDict objectForKey:@"User"] objectForKey:@"u_device_type"];
    self.trip_user_device_token=[[tripDict objectForKey:@"User"] objectForKey:@"u_device_token"];
    self.trip_user_full_name = [[tripDict objectForKey:@"User"] objectForKey:@"u_name"];
    self.trip_pick_loc = [tripDict objectForKey:@"trip_from_loc"];
    self.trip_user_image = [tripDict objectForKey:@"u_profile_image_path"];
    self.trip_created_time = [tripDict objectForKey:@"trip_created"];
    self.trip_user_mobile_number = [[tripDict objectForKey:@"User"] objectForKey:@"u_phone"];
    
    self.trip_pick_lat = [tripDict objectForKey:@"trip_scheduled_pick_lat"];
    self.trip_drop_lat = [tripDict objectForKey:@"trip_scheduled_drop_lat"];
    self.trip_drop_long = [tripDict objectForKey:@"trip_scheduled_drop_lng"];
    self.trip_pick_long = [tripDict objectForKey:@"trip_scheduled_pick_lng"];
    self.trip_driver_commision = [tripDict objectForKey:@"trip_driver_commision"];
    self.trip_pay_mode = [tripDict objectForKey:@"trip_pay_mode"];
    self.trip_pay_status = [tripDict objectForKey:@"trip_pay_status"];
    self.trip_promo_amt = [tripDict objectForKey:@"trip_promo_amt"];
    self.trip_cancel_reason=[tripDict objectForKey:@"trip_reason"];
    
    self.trip_pickup_time = [tripDict objectForKey:@"trip_pickup_time"];
    self.trip_drop_time = [tripDict objectForKey:@"trip_drop_time"];
    
    self.tax_amount = [tripDict objectForKey:@"tax_amt"];
    NSObject * driverDict=[tripDict  objectForKey:@"Driver"];
     if([driverDict  isKindOfClass:[NSDictionary class]])
     {
         self.driver=[[DriverModel alloc]  initItemWithDict:[tripDict  objectForKey:@"Driver"]];
     }
}

-(void) refreshTripModelWithCompletionBlock:(void (^)(id results, NSError *error))block isShowLoader:(BOOL)isShowLoader
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                
                                                                                TRIP_ID :self.trip_Id
                                                                                }];
    if(isShowLoader)
    {
        [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
    }
    [APP_CallAPI gcURL:BASE_URL app:TRIP_GETTRIP
                        data:dict
                       isShowErrorAlert:NO
                       completionBlock:^(id results, NSError *error) {
                    if(isShowLoader)
                    {
                        [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
                    }
                    if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                        NSArray * arrTrip=[results objectForKey:P_RESPONSE];
                        if(arrTrip.count>0)
                        {
                            [self parseResponse:[arrTrip  objectAtIndex:0]];
                        }
                    }
                    block(results,error);
                }];
}



-(void) updateTripModelWith:(NSDictionary *) dict completionBlock:(void (^)(id results, NSError *error))block isShowLoader:(BOOL)isShowLoader
{
    [self updateTripModelWith:dict completionBlock:block isShowLoader:isShowLoader isSendNotification:NO];
    
}



-(void) updateTripModelWith:(NSDictionary *) dict completionBlock:(void (^)(id results, NSError *error))block isShowLoader:(BOOL)isShowLoader isSendNotification:(BOOL)isSendNotification
{
    
    if(isShowLoader)
    {
        [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
    }
    [APP_CallAPI gcURL:BASE_URL app:TRIP_UPDATE
                        data:dict
                   isShowErrorAlert:NO
                completionBlock:^(id results, NSError *error) {
                    
                    if(isShowLoader)
                    {
                        [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
                    }
                    if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                        self.trip_pay_status=PAID;
                        if(isSendNotification)
                        {
                            [self sendNotification];
                        }
                    }
                    block(results,error);
                }];
}




-(void)sendNotification{
    
    NSString * message=@"";
    if([self isPaid])
    {
        if ([self.trip_pay_mode isEqualToString:PAYPAL_PAY]) {
            message = CARD_MSG;
        }
        else {
            message = CASH_MSG;
        }
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                
                                                                                @"message"          :message,
                                                                                @"content-available":@"1",
                                                                                }];
    
    if ([self.driver.deviceType isEqualToString:@"ios"]) {
        
        [dict setObject:self.driver.deviceToken forKey:@"ios"];
    }
    else{
        
        [dict setObject:self.driver.deviceToken forKey:@"android"];
    }
    
    [dict setObject:self.trip_Id forKey:TRIP_ID];
    [dict setObject:@"Cash" forKey:TRIP_STATUS];
    //[UtilityClass SetLoaderHidden:NO withTitle:@"Loading..."];
    
    [APP_CallAPI gcURL:url_notification app:send_driver_notification
                        data:dict
               isShowErrorAlert:NO
                completionBlock:^(id results, NSError *error) {
                    if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                        
                        NSLog(@"notification success");
                        
                    }
                    
                }];
    
    
}


-(BOOL) isPaid
{
    return  [self.trip_pay_status isEqualToString:PAID];
}

@end
