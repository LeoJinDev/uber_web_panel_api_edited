//
//  UserModel.m
//  XENIA RIDER
//
//  Created by SFYT on 12/06/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import <GrepixKit/GrepixKit.h>

#import "UserModel.h"
//#import "CallAPI.h"
#include "WebCallConstants.h"
#include "AppDelegate.h"
@implementation UserModel




-(instancetype)initWithDict:(NSDictionary *)dict
{
    self=[self init];
    [self parseResponse:dict];
    return self;
}

-(void) parseResponse:(NSDictionary *)dict
{
    self.api_key=[dict objectForKey:@"api_key"];
    self.u_email=[dict objectForKey:@"u_email"];
    self.user_id=[dict objectForKey:@"user_id"];
    self.u_lat=[dict objectForKey:@"u_lat"];
    self.u_lng=[dict objectForKey:@"u_lng"];
    self.username=[dict objectForKey:@"username"];
    self.u_fname=[dict objectForKey:@"u_fname"];
    self.u_lname=[dict objectForKey:@"u_lname"];
    self.u_profile_image_path=[dict objectForKey:@"u_profile_image_path"];
    self.emergency_contact_1=[dict objectForKey:@"emergency_contact_1"];
    self.emergency_contact_2=[dict objectForKey:@"emergency_contact_2"];
    self.emergency_contact_3=[dict objectForKey:@"emergency_contact_3"];
    self.emergency_email_1=[dict objectForKey:@"emergency_email_1"];
    self.emergency_email_2=[dict objectForKey:@"emergency_email_2"];
    self.emergency_email_3=[dict objectForKey:@"emergency_email_3"];
}
-(void)updateUserLocation:(CLLocation *) locaion completionBlock:(void (^)(id results, NSError *error))block
{
    
    
    
    if (locaion !=nil) {
        
        [self getLocation:locaion withcompletionHandler:^(NSArray *arr) {
            
            // you will get whole array here in `arr`, now you can manipulate it according to requirement
            NSLog(@"your response array : %@",arr);
            
            
            CLPlacemark *placemark = [arr lastObject];
            
            if (placemark.locality !=nil) {
                
                NSDictionary *addressDictionary =
                placemark.addressDictionary;
                
                NSString *city = [addressDictionary objectForKey:@"City"];
                
                NSString *country = [addressDictionary objectForKey:@"Country"];
                
                if (locaion !=nil && city.length>0 && country.length>0) {
                    
                    [self updateUserLocation1:city country:country loc:locaion completionBlock:block];
                }
                
                else{
                    block(nil,nil);
                }
                
            }
            
        }];
    }
    else{
        block(nil,nil);
    }

    
}


-(void)updateUserLocation1:(NSString *)city country:(NSString *)country loc:(CLLocation *)location completionBlock:(void (^)(id results, NSError *error))block{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                
                                                                                @"user_id"          :self.user_id,
                                                                                @"d_city"             : city,
                                                                                @"d_country"          : country,
                                                                                @"d_degree"           : [NSString stringWithFormat:@"%f",0.0],
                                                                                @"d_lat"              :[NSString stringWithFormat:@"%f",location.coordinate.latitude],
                                                                                @"d_lng"              :[NSString stringWithFormat:@"%f",location.coordinate.longitude],
                                                                                @"d_is_available"     :@(1),
                                                                                }];
    
    [APP_CallAPI gcURL:BASE_URL app:API_UPDATE_USER_PROFILE
                        data:dict
     isShowErrorAlert:NO
                completionBlock:^(id results, NSError *error) {
                    if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                        // success

                        AppDelegate * appdelgate =APP_DELEGATE;
                        appdelgate.userDict= [results objectForKey:P_RESPONSE];
                        [self parseResponse:appdelgate.userDict];
                    }
                    block(results,error);
                    
                }];
    
    
}

-(void)getLocation:(CLLocation *)locations withcompletionHandler : (void(^)(NSArray *arr))completionHandler{
    
    
    
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:locations completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks,
                                                                   NSError * _Nullable error) {
        // placemark = [placemarks lastObject];
        
        completionHandler(placemarks);
        
    }];
    
}
@end
