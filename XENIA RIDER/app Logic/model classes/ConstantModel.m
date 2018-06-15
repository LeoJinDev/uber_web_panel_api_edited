//
//  ConstantModel.m
//  XENIA RIDER
//
//  Created by SFYT on 04/09/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "ConstantModel.h"

@implementation ConstantModel

-(instancetype)initItemWithDict:(NSArray *)array;
{
    self = [super init];
    if (self) {
        
        for (NSDictionary *dict in array) {
            
            if ([[dict objectForKey:@"constant_key"]isEqualToString:@"distance_paramiter"]) {
                 self.constant_distance=[dict objectForKey:@"constant_value"];
            }
            else if ([[dict objectForKey:@"constant_key"]isEqualToString:@"appicial_commission"]){
             self.connstant_appicial_commission=[[dict objectForKey:@"constant_value"] floatValue];
            }
            else if ([[dict objectForKey:@"constant_key"]isEqualToString:@"currency"]){
              self.constant_currency=[dict objectForKey:@"constant_value"];
            }
            else if ([[dict objectForKey:@"constant_key"]isEqualToString:@"fix_amount"]){
             self.constant_base_fare=[[dict objectForKey:@"constant_value"] floatValue];
            }
            else if ([[dict objectForKey:@"constant_key"]isEqualToString:@"service_tax"]){
             
                self.constant_tax_percenetage=[[dict objectForKey:@"constant_value"] floatValue];
            }
            else if ([[dict objectForKey:@"constant_key"]isEqualToString:@"driver_radius"]){
                
                self.constant_driver_radius=[dict objectForKey:@"constant_value"];
            }
        }
        
    }
   
    return self;
   
}



@end
