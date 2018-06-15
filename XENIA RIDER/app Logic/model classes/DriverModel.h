//
//  DriverModel.h
//  XENIA RIDER
//
//  Created by SFYT on 08/06/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriverModel : NSObject
@property(strong,nonatomic)  NSString *  driverId;
@property(strong,nonatomic)  NSString *  d_fname;
@property(strong,nonatomic)  NSString *  d_lname;

@property(nonatomic,strong) NSString *deviceToken;
@property(nonatomic,strong) NSString *deviceType;

@property(nonatomic,assign) float ratingCount;
@property(assign,nonatomic) float rating;
@property(nonatomic,assign) double lat;
@property(assign,nonatomic) double lng;
@property(assign,nonatomic) float distance;
@property(assign,nonatomic) int category_id;
@property(strong,nonatomic) NSString * carname;
@property(strong,nonatomic) NSString * d_profile_image_path;
@property (strong,nonatomic) NSString *phone;

@property (strong,nonatomic) NSString *car_registration_no;




-(instancetype)initItemWithDict:(NSDictionary *)dict;
-(BOOL ) isIos;
-(void) updateDriverRating:(float   ) rating completionBlock:(void (^)(id results, NSError *error))block  isShowLoader:(BOOL)isShowLoader;

+(NSMutableArray *) parseDirversResponse:(NSArray *) arrDrivers;
@end
