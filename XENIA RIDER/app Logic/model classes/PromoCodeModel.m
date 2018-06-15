//
//  PromoCodeModel.m
//  XENIA RIDER
//
//  Created by SFYT on 08/06/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "PromoCodeModel.h"
#import "WebCallConstants.h"
 
//#import "CallAPI.h"
#import <GrepixKit/GrepixKit.h>
@implementation PromoCodeModel
-(instancetype)initWithPromode:(NSString *)promoCode
{
    if(self)
    {
        self=[self init];
        self.promoCode=promoCode;
    }
    return  self;
}

-(void) validatePromoCodeWithCompletionBlock:(void (^)(id results, NSError *error))block
{
    [UtilityClass SetLoaderHidden:NO withTitle:@"Validating..."];
    [APP_CallAPI gcURL:BASE_URL app:API_VALIDATE_PROMO
                        data:@{p_promo_code:self.promoCode}
     isShowErrorAlert:NO
                completionBlock:^(id results, NSError *error) {
                    [UtilityClass SetLoaderHidden:YES withTitle:@"Validating..."];
                    if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                        NSArray * arrPromoCodes=[results objectForKey:P_RESPONSE];
                        if(arrPromoCodes.count>0){
                            [self parsePromoCodeResponse:[arrPromoCodes  objectAtIndex:0]];
                        }
                    }
                    block(results,error);
                }];
    
}

-(void) parsePromoCodeResponse:(NSDictionary *) dict
{
    self.promoId=[dict objectForKey:@"promo_id"];
    self.promoCode=[dict objectForKey:@"promo_code"];
    self.promoType=[dict objectForKey:@"promo_type"];
    self.promoValue=[[dict objectForKey:@"promo_value"] floatValue];
    self.promoStatus=[dict objectForKey:@"promo_status"];
    self.percent=[[dict objectForKey:@"percent"] floatValue];
}


-(float) calucalateAmtByPromoCode:(float ) tripAmount {
    if ([self isFixed]) {
        return  self.promoValue;
    } else {
        return  (float) ((tripAmount *  self.promoValue) / 100.0f);
    }
}

-(BOOL) isFixed {
    return [self.promoType isEqualToString:@"Fixed Amt"];
}
@end
