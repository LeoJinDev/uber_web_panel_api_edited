//
//  DriverModel.m
//  XENIA RIDER
//
//  Created by SFYT on 08/06/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "DriverModel.h"
 
#import "WebCallConstants.h"
#import <GrepixKit/GrepixKit.h>
//#import "CallAPI.h"
@implementation DriverModel
-(instancetype)initItemWithDict:(NSDictionary *)dict;
{
    self = [super init];
    if (self) {
        self.rating=[[dict objectForKey:@"d_rating"]floatValue ];
        self.driverId=[dict objectForKey:@"driver_id"];
        self.d_fname=[dict objectForKey:@"d_fname"];
        self.d_lname=[dict objectForKey:@"d_lname"];
        self.ratingCount=[[dict objectForKey:@"d_rating_count"] floatValue];
        self.deviceToken=[dict objectForKey:@"d_device_token"];
        self.deviceType=[dict objectForKey:@"d_device_type"];
        self.lat = [[dict objectForKey:@"d_lat"] doubleValue];
        self.lng = [[dict objectForKey:@"d_lng"] doubleValue];
        self.category_id = [[dict objectForKey:@"category_id"] intValue];
        self.carname=[dict objectForKey:@"car_name"];
        self.d_profile_image_path=[dict objectForKey:@"d_profile_image_path"];
        self.phone = [dict objectForKey:@"d_phone"];
        // km
        self.distance=[[dict objectForKey:@"distance"] floatValue];
        
        self.car_registration_no = [dict objectForKey:@"car_reg_no"];
    }
    return self;
}

/*
Driver =     {
    "api_key" = 0ae689b8b1ef46ab503cc5ff18cc6d0b;
    "car_created" = "2016-10-13 14:17:18";
    "car_currency" = rupee;
    "car_desc" = "";
    "car_fare_per_km" = 0;
    "car_fare_per_min" = 0;
    "car_id" = 2;
    "car_model" = 2016;
    "car_modified" = "2016-10-13 14:17:18";
    "car_name" = Honda;
    "car_reg_no" = "DL-05 CN 2563";
    "category_id" = 1;
    "d_address" = "";
    "d_city" = New;
    "d_country" = IN;
    "d_created" = "2017-01-11 14:29:16";
    "d_degree" = "176.555";
    "d_device_token" = "e8WaeWNQ6us:APA91bF0xxnj-fBjgQaQAgnQy6KtFwzBvAmtRm6FxFskOXSkYTdYLv_Rspd50GuzE180oix88QVtAcOqzetXT1uzALA41bpV64hoHoNoO2GipgciXcWgXaV-e2anuaCceBeRh09NTD2q";
    "d_device_type" = Android;
    "d_email" = "driver02@gmail.com";
    "d_fname" = Krishantyh;
    "d_is_available" = 0;
    "d_is_verified" = 0;
    "d_lat" = "28.5354581";
    "d_license_id" = "";
    "d_license_image_path" = "";
    "d_lname" = verma;
    "d_lng" = "77.2591929";
    "d_modified" = "2017-03-07 06:21:13";
    "d_name" = Krishantyh;
    "d_password" = e358efa489f58062f10dd7316b65649e;
    "d_phone" = 95829793343;
    "d_profile_image_path" = "";
    "d_rating" = "3.75";
    "d_rating_count" = 2;
    "d_rc" = "";
    "d_rc_image_path" = "";
    "d_state" = "";
    "d_zip" = "";
    "driver_id" = 38;
    "image_id" = 4;
};
*/

-(BOOL ) isIos
{
    return  ![self.deviceType isEqualToString:@"Android"];
}

-(void) updateDriverRating:(float   ) rating completionBlock:(void (^)(id results, NSError *error))block  isShowLoader:(BOOL)isShowLoader
{
    
    
    float totalRating = 0;
    
    
    
    
    
    
    totalRating = (float) ((self.rating * self.ratingCount + rating) / (self.ratingCount + 1.0));
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]  init];
    [dict setObject:@(totalRating) forKey:@"d_rating"];
    [dict setObject:@(self.ratingCount + 1.0) forKey:@"d_rating_count"];
    [dict setObject:self.driverId forKey:@"driver_id"];
    if(isShowLoader)
    {
        [UtilityClass SetLoaderHidden:NO withTitle:@"Loading.."];
    }
    [APP_CallAPI gcURL:BASE_URL app:API_UPDATE_DRIVER_PROFILE
                        data:dict
                     isShowErrorAlert:NO
                completionBlock:^(id results, NSError *error) {
                    if(isShowLoader)
                    {
                        [UtilityClass SetLoaderHidden:YES withTitle:@"Loading.."];
                    }
                    if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                        self.rating=totalRating;
                        self.ratingCount++;
                    }
                    block(results,error);
                }];

}


+(NSMutableArray *) parseDirversResponse:(NSArray *) arrDrivers
{
    NSMutableArray * array=[[NSMutableArray alloc]  init];
    for (NSDictionary * dict in arrDrivers) {
        [array addObject:[[DriverModel alloc]  initItemWithDict:dict]];
    }
    return array;
}
@end
