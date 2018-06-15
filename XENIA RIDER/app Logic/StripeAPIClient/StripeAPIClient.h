//
//  StripeAPIClient.h
//  EatStreet
//
//  Created by SFYT on 24/08/17.
//  Copyright © 2017 Grepix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Stripe.h>
//#import <STPEphemeralKeyProvider.h>

@interface StripeAPIClient : NSObject <STPEphemeralKeyProvider>


-(instancetype)initWithAPIVersion;
-(void)createCustomerKeyWithAPIVersion:(NSString *)apiVersion completion:(STPJSONResponseCompletionBlock)completion;

@end
