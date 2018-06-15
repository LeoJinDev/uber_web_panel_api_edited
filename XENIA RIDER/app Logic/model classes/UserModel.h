//
//  UserModel.h
//  XENIA RIDER
//
//  Created by SFYT on 12/06/17.
//  Copyright © 2017 SFYT. All rights reserved.
//
/*
 {
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
 "u_device_token" = "dsQoY5Qag9I:APA91bE1wfev3uKCAI-YRExwuIWzQz6vvPDIXAtx1DpXVACGl-lEZPwIOPYnRlbCXS_jgIN00gINgTn0SzCPiq0SfqnVdZB6IK2hluOSc9urPS1PlTpPbA2RnmXcPPwvXVYmbua_igwp";
 "u_device_type" = Android;
 "u_email" = "test@gmail.com";
 "u_fbid" = "";
 "u_fname" = Ridere3;
 "u_is_available" = 1;
 "u_last_loggedin" = "2017-06-08 15:07:20";
 "u_lat" = "28.53556";
 "u_lname" = last;
 "u_lng" = "77.25949";
 "u_modified" = "2017-06-09 07:23:16";
 "u_name" = "Ridere3 last";
 "u_password" = 098f6bcd4621d373cade4e832627b4f6;
 "u_phone" = 8787676565;
 "u_profile_image_path" = "7/QEKQVvCfEVgj9t8.jpg";
 "u_state" = "";
 "u_zip" = "";
 "user_id" = 3;
 username = sfasdfdsa;
 }*/
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface UserModel : NSObject

@property(strong,nonatomic) NSString * api_key;
@property(strong,nonatomic) NSString * u_email;
@property(strong,nonatomic) NSString * u_lat;
@property(strong,nonatomic) NSString * u_lng;
@property(strong,nonatomic) NSString * user_id;
@property(strong,nonatomic) NSString * username;
@property(strong,nonatomic) NSString * u_fname;
@property(strong,nonatomic) NSString * u_lname;
@property(strong,nonatomic) NSString * u_profile_image_path;
@property(strong,nonatomic) NSString * emergency_contact_1;
@property(strong,nonatomic) NSString * emergency_contact_3;
@property(strong,nonatomic) NSString * emergency_contact_2;
@property(strong,nonatomic) NSString * emergency_email_1;
@property(strong,nonatomic) NSString * emergency_email_2;
@property(strong,nonatomic) NSString * emergency_email_3;


-(instancetype)  initWithDict:(NSDictionary *)dict;


-(void)updateUserLocation:(CLLocation *) locaion completionBlock:(void (^)(id results, NSError *error))block;
@end
