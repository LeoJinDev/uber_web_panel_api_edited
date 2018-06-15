//
//  StripeAPIClient.m
//  Xamoe
//
//  Created by SFYT on 24/08/17.
//  Copyright © 2017 Grepix. All rights reserved.
//

#import <GrepixKit/GrepixKit.h>

#import "StripeAPIClient.h"
#import "WebCallConstants.h"

#import "AppDelegate.h"
//#import "AFHTTPSessionManager.h"





@implementation StripeAPIClient

-(instancetype)initWithAPIVersion{
    
    self = [super init];
    
    if (self) {
    }
    
    return self;
    
}


- (void)createCustomerKeyWithAPIVersion:(NSString *)apiVersion completion:(STPJSONResponseCompletionBlock)completion {
  
    AppDelegate *delegate = APP_DELEGATE;
    NSDictionary *dict = @{
                           @"api_version"   : apiVersion,
                           P_USER_ID        : [defaults_object(P_USER_DICT) objectForKey:P_STRIPE_CUS_ID]
                           };
    
    [APP_CallAPI gcURL:BASE_URL app:API_GET_EPHEMERAL_KEY data:dict isShowErrorAlert:NO completionBlock:^(id results, NSError *error) {
        
        if (error == nil || [[results objectForKey:P_STATUS] isEqualToString:P_STATUS_OK]) {
            completion([results objectForKey:P_RESPONSE], nil);
        }
        else {
            completion(nil, error);
        }
        
    }];
    
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager POST:url.absoluteString
//       parameters:@{@"api_version": apiVersion}
//         progress:nil
//          success:^(NSURLSessionDataTask *task, id responseObject) {
//              completion(responseObject, nil);
//          } failure:^(NSURLSessionDataTask *task, NSError *error) {
//              completion(nil, error);
//          }];
    
}


/*
#pragma mark - STRIPE


-(void)handleDirectPayment:(id)delegate {
    
    //[UtilityClass SetLoaderHidden:YES withTitle:@"Order processing..."];
    
    self.delegate = delegate;
    
    // Setup add card view controller
    STPAddCardViewController *addCardViewController = [[STPAddCardViewController alloc] init];
    addCardViewController.delegate = delegate;
    
    // Present add card view controller
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addCardViewController];
    [delegate presentViewController:navigationController animated:YES completion:nil];
}


- (void)showPaymentMethodsController:(id)delegate finalAmount:(float)finalAmount {
    
    //[UtilityClass SetLoaderHidden:YES withTitle:@"Order processing..."];
    
    self.delegate = delegate;
    
    // Setup customer context
    self.customerContext = [[STPCustomerContext alloc] initWithKeyProvider:[[StripeAPIClient alloc] initWithAPIVersion]];
    
    //now set up payment context
    self.paymentContext = [[STPPaymentContext alloc] initWithCustomerContext:self.customerContext];
    self.paymentContext.delegate = self;
    self.paymentContext.hostViewController = delegate;
    self.paymentContext.paymentAmount = finalAmount;
    
    [self.paymentContext presentPaymentMethodsViewController];
    
    
    // Setup payment methods view controller
    STPTheme *theme = [STPTheme defaultTheme];
    theme.accentColor = [UIColor greenColor];
    
    STPPaymentConfiguration *payConfig = [STPPaymentConfiguration sharedConfiguration];
    payConfig.canDeletePaymentMethods = NO;
    //payConfig.additionalPaymentMethods = STPPaymentMethodTypeNone;
    
    //    STPPaymentMethodsViewController *paymentMethodsViewController = [[STPPaymentMethodsViewController alloc] initWithConfiguration:payConfig
    //                                                                                                                             theme:theme
    //                                                                                                                   customerContext:self.customerContext
    //                                                                                                                          delegate:self
    //                                                                     ];
    //
    //    // Present payment methods view controller
    //    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:paymentMethodsViewController];
    //    [self presentViewController:navigationController animated:YES completion:nil];
}



-(void)sendStripeCustomerIDToServer:(NSString *)stripeCustomerID
                              token:(STPToken*)token
                         completion:(void (^)(id result, NSError *error))completion{
    
    //[UtilityClass SetLoaderHidden:NO withTitle:@"Order processing..."];
    
   
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary: @{
//                                                                                 R_Key                    : appDelegate.ORDER.RESTAURANT.rKey,
//                                                                                 //p_stripe_customer_id     : stripeCustomerID,
//                                                                                 order_amount             : [NSString stringWithFormat:@"%0.2f",finalAmount],
//                                                                                 order_id                 : @(appDelegate.ORDER.orderID),
//                                                                                 p_user_id                : [appDelegate.dictUser objectForKey:p_user_id],
//                                                                                 p_user_name              : [appDelegate.dictUser objectForKey:p_user_name],
//                                                                                 p_destination_acc_id     : STRIPE_CONNECT_ID
                                                                                 }];
    
    
    
    if (token != nil) {
        [dict setValue:token forKey:P_STRIPE_TOKEN];
    }
    else {
        [dict setValue:stripeCustomerID forKey:P_STRIPE_CUS_ID];
    }
    
    
    [APP_CallAPI gcURL:BASE_URL app:API_SEND_STRIPE_TOKEN data:dict completionBlock:^(id results, NSError *error) {
        
        //[UtilityClass SetLoaderHidden:YES withTitle:@"Order processing..."];
        if(error == nil)
        {
            //NSLog(@"%@",[results objectForKey:p_response]);
            NSDictionary *responseDict = [results objectForKey:P_RESPONSE];
            
            if ([[responseDict objectForKey:P_RESPONSE] isEqualToString:STRIPE_SUCCESS]) {
                
                //call completion block
                completion(STRIPE_SUCCESS,nil);
                
                
                //[self getRestaurant_DeviceTokens];
                
                //succeess
               
                //delegate.ORDER.paymentState = StripePaymentSendToServer;//  BraintreeNonceUpdatedOnServer;
                
                
                
                
            }
            else if ([[responseDict objectForKey:P_RESPONSE] isEqualToString:STRIPE_DECLINED]){
               
                completion(STRIPE_DECLINED,error);
                //declined
//                [UtilityClass alertControllerWithDelegate:self
//                                                    title:@"" message:[responseDict objectForKey:@"result"]
//                                        cancelButtonTitle:@"Ok" otherButtonTitle:nil];
                
                
            }
            
            
        }
        else{
            //show error
           
        }
    }];
    
}




#pragma mark STPPaymentMethodsViewControllerDelegate

- (void)paymentMethodsViewController:(STPPaymentMethodsViewController *)paymentMethodsViewController didFailToLoadWithError:(NSError *)error {
    // Dismiss payment methods view controller
    [self.delegate dismissViewControllerAnimated:YES completion:nil];
    
    // Present error to user...
    //NSLog(@"Payment ViewController error: %@",error.localizedDescription);
}

- (void)paymentMethodsViewControllerDidCancel:(STPPaymentMethodsViewController *)paymentMethodsViewController { //Cancel
    // Dismiss payment methods view controller
    [self.delegate dismissViewControllerAnimated:YES completion:nil];
}

- (void)paymentMethodsViewControllerDidFinish:(STPPaymentMethodsViewController *)paymentMethodsViewController { // Finish  //called in last
    
    // Dismiss payment methods view controller
    [self.delegate dismissViewControllerAnimated:YES completion:nil];
}

- (void)paymentMethodsViewController:(STPPaymentMethodsViewController *)paymentMethodsViewController didSelectPaymentMethod:(id<STPPaymentMethod>)paymentMethod {
    // Save selected payment method
    //self.selectedPaymentMethod = paymentMethod;
    
}



#pragma mark - STPPaymentContext Delegates

-(void)paymentContextDidChange:(STPPaymentContext *)paymentContext{
    //NSLog(@"Payment Context Result Called :%@", paymentContext.selectedPaymentMethod.label);
    
    if (self.paymentContext.selectedPaymentMethod != nil) {
        //[self reloadCreditCardBtn];
        
        //[self showCreditView:YES];
    }
    
}

-(void)paymentContext:(STPPaymentContext *)paymentContext didFailToLoadWithError:(NSError *)error{
    
}

-(void)paymentContext:(STPPaymentContext *)paymentContext didFinishWithStatus:(STPPaymentStatus)status error:(NSError *)error{
    //NSLog(@"Payment Context Staus Called");
}

-(void)paymentContext:(STPPaymentContext *)paymentContext didCreatePaymentResult:(STPPaymentResult *)paymentResult completion:(STPErrorBlock)completion{
    //NSLog(@"Payment Context Result Called :%@", paymentResult.source.stripeID);
    
}



#pragma mark STPAddCardViewControllerDelegate

- (void)addCardViewControllerDidCancel:(STPAddCardViewController *)addCardViewController {
    // Dismiss add card view controller
    [self.delegate dismissViewControllerAnimated:YES completion:nil];
}



- (void)addCardViewController:(STPAddCardViewController *)addCardViewController didCreateToken:(STPToken *)token completion:(STPErrorBlock)completion {
    //    [self submitTokenToBackend:token completion:^(NSError *error) {
    //        if (error) {
    //            // Show error in add card view controller
    //            completion(error);
    //        }
    //        else {
    //            // Notify add card view controller that token creation was handled successfully
    //            completion(nil);
    //            
    //            // Dismiss add card view controller
    //            [self dismissViewControllerAnimated:YES completion:nil];
    //        }
    //    }];
    
    [self sendStripeCustomerIDToServer:nil token:token completion:nil];
    
    [self.delegate dismissViewControllerAnimated:YES completion:nil];
}
*/


@end
