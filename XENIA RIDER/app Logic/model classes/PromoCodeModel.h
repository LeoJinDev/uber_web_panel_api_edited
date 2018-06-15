//
//  PromoCodeModel.h
//  XENIA RIDER
//
//  Created by SFYT on 08/06/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromoCodeModel : NSObject
@property(strong,nonatomic) NSString * promoId;
@property(strong,nonatomic) NSString * promoCode;
@property(strong,nonatomic) NSString * promoType;
@property(assign,nonatomic) float  promoValue;
@property(strong,nonatomic) NSString * promoStatus;
@property(strong,nonatomic) NSString * promoSreated;
@property(assign,nonatomic) float  percent;





-(instancetype)initWithPromode:(NSString *) promoCode;

-(void) validatePromoCodeWithCompletionBlock:(void (^)(id results, NSError *error))block;


-(float) calucalateAmtByPromoCode:(float ) tripAmount;
@end
