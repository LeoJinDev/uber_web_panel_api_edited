//
//  ConstantModel.h
//  XENIA RIDER
//
//  Created by SFYT on 04/09/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConstantModel : NSObject

@property(nonatomic,strong) NSString *constant_distance;
@property(nonatomic,assign) float connstant_appicial_commission;
@property(nonatomic,strong) NSString *constant_currency;
@property(nonatomic,assign) float constant_base_fare;
@property(nonatomic,assign) float constant_tax_percenetage;
@property(nonatomic,assign) NSString *constant_driver_radius;
//@property(nonatomic,strong) NSString *constant_cost_per_km;
//@property(nonatomic,strong) NSString *constant_cost_waiting_time;

-(instancetype)initItemWithDict:(NSArray *)array;

@end
