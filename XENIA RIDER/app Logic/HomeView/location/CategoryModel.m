//
//  CategoryModel.m
//  XENIA RIDER
//
//  Created by Sivilay on 25/10/17.
//  Copyright © 2017 SFYT. All rights reserved.
//
/*
 "cat_base_price" = 15;
 "cat_created" = "2016-10-10 07:16:36";
 "cat_desc" = "";
 "cat_fare_per_km" = 12;
 "cat_fare_per_min" = 8;
 "cat_is_fixed_price" = 1;
 "cat_max_size" = 4;
 "cat_modified" = "2016-10-10 15:44:47";
 "cat_name" = Hatchback;
 "cat_prime_time_percentage" = 50;
 "cat_status" = 1;
 "category_id" = 1;
 */

#import <GrepixKit/GrepixKit.h>
#import "CategoryModel.h"
#import "WebCallConstants.h"
#import "ConstantModel.h"
//#import "nsuserdefaults-helper.h"

@implementation CategoryModel
-(instancetype) initWithDict:(NSDictionary *) dict
{
    self=[super init];
    
    NSArray * arr = defaults_object(@"constantResponse");
    ConstantModel *constantModel =[[ConstantModel alloc]initItemWithDict:arr];
    self.service_tax_percentage = constantModel.constant_tax_percenetage;
    self.categoryId=[[dict objectForKey:P_CATEGORY_ID]  intValue];
    self.cat_base_price=[[dict objectForKey:P_CATEGORY_BASE_PRICE]  floatValue];
    self.cat_fare_per_km=[[dict objectForKey:P_CATEGORY_FARE_PER_KM]  floatValue];
    self.cat_fare_per_min=[[dict objectForKey:P_CATEGORY_FARE_PER_MIN]  floatValue];
    self.cat_is_fixed_price=[[dict objectForKey:P_CATEGORY_IS_FIXED_PRICE]  boolValue];
    self.cat_prime_time_percentage=[[dict objectForKey:P_CATEGORY_PRIME_TIME_PERCENTAGE]  floatValue];
    self.cat_max_size = [dict objectForKey:P_CATEGORY_MAX_SIZE];
     self.cat_name = [dict objectForKey:P_CATEGORY_NAME];
    
    
    return self;
}


-(float) calculatePrice:(float )distance time:(float)min
{
    
    float distance1 = 0.0;
    if (distance>1) {
        
        distance1 = distance-1;
    }


    float totalPrice = self.cat_base_price + distance1*self.cat_fare_per_km;
    //float tax1 = totalPrice *self.service_tax_percentage/100;
    //totalPrice = totalPrice + tax1;
    
//    if(!self.cat_is_fixed_price)
//     {
//         float primepercentage=(totelPrice * self.cat_prime_time_percentage) / 100.0;
//         totelPrice=totelPrice+primepercentage;
//     }
    return  totalPrice;
}

+(NSMutableArray * ) parseResponse:(NSArray * ) arrCategory
{
    NSMutableArray * arr=[[NSMutableArray alloc]  init];
    for (NSDictionary * dict in arrCategory) {
        [arr addObject:[[CategoryModel alloc] initWithDict:dict]];
    }
    return  arr;
}
@end
