//
//  ;
//  TaxiDriver
//
//  Created by Sivilay on 25/10/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "FareAmmountViewController.h"
//#import "CallAPI.h"
#import "WebCallConstants.h"
#import <GrepixKit/GrepixKit.h>
#import "AppDelegate.h"
#import "SignInViewController.h"
#import "FareReviewViewController.h"
#import "PromoCodeModel.h"


#import "StripeAPIClient.h"
#import <STPAddCardViewController.h>
#import <STPPaymentCardTextField.h>

#import <STPCustomerContext.h>
#import <STPPaymentMethodsViewController.h>
#import <STPEphemeralKeyProvider.h>





//#import <PayPalHereSDK/PayPalHereSDK.h>
//#import "nsuserdefaults-helper.h"
#import "NSString+URLEncoding.h"
#import "StarRatingView.h"
#import "Utilities.h"

#define kLabelAllowance 50.0f
#define kStarViewHeight 35.0f
#define kStarViewWidth 180.0f
#define kLeftPadding 5.0f



@interface FareAmmountViewController ()<UITextViewDelegate, STPAddCardViewControllerDelegate, /*STPPaymentCardTextFieldDelegate,*/
                                        STPPaymentMethodsViewControllerDelegate, STPPaymentContextDelegate>
{
    double driverComm;
    PromoCodeModel *promoCode ;
    //    BOOL isPaid;
    StarRatingView* starViewNoLabel;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgCartBack;

@property (strong,nonatomic) STPCustomerContext *customerContext;
@property (strong,nonatomic) STPPaymentContext *paymentContext;

@end

@implementation FareAmmountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *tripFare = _curr_trip.trip_fare;
    
    [self.viewEnterPromoCode setHidden:YES];
    
    
    driverComm = [_curr_trip.trip_fare doubleValue]- [tripFare doubleValue]*_constantModel.connstant_appicial_commission/100;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:@"NotificationReceived" object:nil];
    
    [self.curr_trip refreshTripModelWithCompletionBlock:^(id results, NSError *error) {
        [self setDataonUI];
    } isShowLoader:YES];
    [self.btOffline setHidden:YES];
    [self.btFareReview setHidden:YES];
    
    self.imgCartBack.layer.cornerRadius = 5;
    
    self.txtviewFeedback.delegate = self;
    self.txtviewFeedback.placeholder = NSLocalizedString(@"Feedback", @"");
    [UtilityClass setCornerRadius: self.txtviewFeedback radius:5.0f border:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //[self setDataonUI]
    ;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)setThemeConstants{
    
    _viewHeader.backgroundColor = CONSTANT_THEME_COLOR1;
    _lblHeader.textColor =CONSTANT_TEXT_COLOR_HEADER;
    [_lblHeader setFont:FONTS_THEME_REGULAR(19)];
    [_lblHireMeCard setFont:FONTS_THEME_REGULAR(18)];
    [_lblAmountPayableTitle setFont:FONTS_THEME_REGULAR(16)];
    
    [_lbTripFareAmount setFont:FONTS_THEME_REGULAR(30)];
    [_lbPromocodeAmount setFont:FONTS_THEME_REGULAR(13)];
    [_btnDone.titleLabel setFont:FONTS_THEME_REGULAR(16)];
    [_btnOffline.titleLabel setFont:FONTS_THEME_REGULAR(16)];
    [_btnFareReview.titleLabel setFont:FONTS_THEME_REGULAR(16)];
    [_btnOffline.titleLabel setFont:FONTS_THEME_REGULAR(16)];
    [_btnDone.titleLabel setFont:FONTS_THEME_REGULAR(16)];
    [_btnSkip.titleLabel setFont:FONTS_THEME_REGULAR(16)];
    [_btnApply.titleLabel setFont:FONTS_THEME_REGULAR(14)];
    [_btnSubmit.titleLabel setFont:FONTS_THEME_REGULAR(16)];
     [_btnRatingSkip.titleLabel setFont:FONTS_THEME_REGULAR(16)];
     [_btnratingDone.titleLabel setFont:FONTS_THEME_REGULAR(16)];
    [_lblRateDriver setFont:FONTS_THEME_REGULAR(16)];
    [_txtPromoCode setFont:FONTS_THEME_REGULAR(17)];
    
    [_btnCancelCard.titleLabel setFont:FONTS_THEME_REGULAR(16)];
    [_btnPayCard.titleLabel setFont:FONTS_THEME_REGULAR(16)];
    [_lblCreditView setFont:FONTS_THEME_REGULAR(18)];
    _lblCreditView.textColor =CONSTANT_TEXT_COLOR_HEADER;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"FareReviewViewController"]) {
        
        FareReviewViewController *farerev =(FareReviewViewController *)[segue destinationViewController];
        farerev.cur_trip =_curr_trip;
    }
    
}


-(void)getNotification:(NSNotification *) notification {
    AppDelegate *appdelegate =APP_DELEGATE;
    if([appdelegate.trip_status isEqualToString:PAID])
    {
        /*UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                 message:MESSAGE_PAID
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        */
        return;
    }
    
    if ( [appdelegate.trip_status isEqualToString:CASH_PAY] || [appdelegate.trip_status isEqualToString:PAYPAL_PAY]) {
        
        if (![self.curr_trip isPaid]) {
            
            [self.curr_trip refreshTripModelWithCompletionBlock:^(id results, NSError *error) {
                
                [self setDataonUI];
            } isShowLoader:YES];
        }
    }
}



-(void)updatePaymentAmmount {
    
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                
                                                                                TRIP_DRIVER_COMISSION :[NSString stringWithFormat:@"%f",driverComm],
                                                                                TRIP_ID               : _curr_trip.trip_Id,
                                                                                }];
    
    
    [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
    
    [APP_CallAPI gcURL:BASE_URL app:TRIP_UPDATE
                        data:dict
                isShowErrorAlert:NO
                completionBlock:^(id results, NSError *error) {
                    if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                        // success
                        
                        //currTrip = [[TripModel alloc] initItemWithDict:[results objectForKey:P_RESPONSE]];
                        
                        [self unhideViews];
                    }
                    
                    [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
                    
                }];
    
}


-(void)updateFeedbackInTrip {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                
                                                                                TRIP_FEEDBACK         :[self.txtviewFeedback.text urlEncodeUsingEncoding],
                                                                                TRIP_ID               : _curr_trip.trip_Id,
                                                                                }];
    
    
    //[UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
    
    [APP_CallAPI gcURL:BASE_URL app:TRIP_UPDATE
                        data:dict
     isShowErrorAlert:NO
                completionBlock:^(id results, NSError *error) {
                    if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                        // success
                    }
                    
                    //[UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
                    
                }];
    
}


-(void)unhideViews {
    //
    //    _btnHome.hidden=NO;
    //    _btnOffline.hidden=NO;
    //    _btnFarereview.hidden=NO;
}

- (IBAction)ButtonOffline:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:NSLocalizedString(@"logout_alert_message", @"")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:NSLocalizedString(@"Yes", @"")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          //Handle your yes please button action here
                                                          
                                                          [self updateDriverStatus];
                                                          
                                                      }];
    
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:NSLocalizedString(@"No", @"")                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         //Handle your yes please button action here
                                                         
                                                         
                                                         
                                                     }];
    
    [alertController addAction:actionYes];
    [alertController addAction:actionNo];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)ButtonFarereviewPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"FareReviewViewController" sender:nil];
}
- (IBAction)ButtonHome:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateDriverStatus{
    
    AppDelegate *appdelegate =APP_DELEGATE;
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    
    [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                
                                                                                
                                                                                P_USER_ID          :[dict1 objectForKey:P_USER_ID],
                                                                                
                                                                                P_USER_IS_AVAILABLE    :@"0",
                                                                                
                                                                                }];
    
    
    
    
    
    [APP_CallAPI gcURL:BASE_URL app:API_UPDATE_USER_PROFILE
                        data:dict
     isShowErrorAlert:NO
                completionBlock:^(id results, NSError *error) {
                    if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                        // success
                        
                        
                        appdelegate.userDict = [results objectForKey:P_RESPONSE];
                        
                      //  SignInViewController *loginViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
                        
                       // UIWindow *window = UIApplication.sharedApplication.delegate.window;
                       // window.rootViewController = loginViewController;
                        
                       // [self.navigationController popToRootViewControllerAnimated:YES];
                        
                        
                    }
                    [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
                }];
    
    
}



-(void)sendNotificationPromoCode{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"message"          :@"Promo code apply",
                                                                                @"content-available":@"1",
                                                                                }];
    
    if ([self.curr_trip.driver.deviceType isEqualToString:@"ios"]) {
        
        [dict setObject:self.curr_trip.driver.deviceToken forKey:@"ios"];
    }
    else{
        
        [dict setObject:self.curr_trip.driver.deviceToken forKey:@"android"];
    }
    
    [dict setObject:self.curr_trip.trip_Id forKey:TRIP_ID];
    [dict setObject:PROMO_PAY_ACCEPT forKey:TRIP_STATUS];
    //[UtilityClass SetLoaderHidden:NO withTitle:@"Loading..."];
    
    if (self.curr_trip.driver.deviceToken.length>0) {
        
    
    [APP_CallAPI gcURL:url_notification app:send_driver_notification
                        data:dict
               isShowErrorAlert:NO
                completionBlock:^(id results, NSError *error) {
                    if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                        
                        NSLog(@"notification success");
                        
                    }
                    
                }];
    }
    
    
}
#pragma  mark - UI update


-(void) setDataonUI
{
    
    starViewNoLabel = [[StarRatingView alloc]initWithFrame:CGRectMake(0 ,0 , kStarViewWidth, kStarViewHeight) andRating:3*20 withLabel:NO animated:YES];
    [starViewNoLabel setUserInteractionEnabled:YES];
    
    [self.ratingBar addSubview:starViewNoLabel];
    
    NSString *currency =self.constantModel.constant_currency;
    
    if([self.curr_trip isPaid])
    {
        //        [self.viewAmount setHidden:YES];
        [self.viewStarContainer setHidden:NO];
        [self.btSubmit setHidden:YES];
        [self.viewOverly setHidden:YES];
        [self.viewPromoCode setHidden:YES];
    }
    else{
        //        _lbAmountToPay.text = [NSString stringWithFormat:@"$ %.02f", [_curr_trip.trip_fare doubleValue]];
        
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        //           NSString *currencySymbol = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
        
        
        _lbTripFareAmount.text =[NSString stringWithFormat:@"%@%.02f",currency, [_curr_trip.trip_fare doubleValue]];
        if(self.curr_trip.isPromoCodeUsed)
        {
            if(promoCode)
            {
                //             _lbAmountToPay.text =[NSString stringWithFormat:@"$ %@",[formatter stringFromNumber:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.02f", [_curr_trip.trip_fare doubleValue]-[self.curr_trip.trip_promo_amt doubleValue]]]]];
                _lbAmountToPay.text =[NSString stringWithFormat:@"%@%.02f",currency, [_curr_trip.trip_fare doubleValue]-[self.curr_trip.trip_promo_amt doubleValue]];
                [_lbPromocodeAmount setText:[NSString stringWithFormat:@"%@ %@%.2f",NSLocalizedString(@"Promo Code Applied:", @""),currency,[self.curr_trip.trip_promo_amt doubleValue]]];
            }
        }
        else{
            [_lbPromocodeAmount setText:@""];
            _lbAmountToPay.text =[NSString stringWithFormat:@"%@%.02f",currency, [_curr_trip.trip_fare doubleValue]];
          
        }
        
        
        //        [self.viewAmount setHidden:NO];
        [self.btFareReview setHidden:YES];
        [self.btOffline setHidden:YES];
        [self.btSubmit setHidden:NO];
        [self.viewStarContainer setHidden:YES];
        [self.viewOverly setHidden:YES];
        if(self.curr_trip.isPromoCodeUsed)
        {
            [self.viewPromoCode setHidden:YES];
        }
        else{
            [self.viewPromoCode setHidden:NO];
        }
    }
    
   
}


#pragma  mark -Handle Button Actions

- (IBAction)handleCardBtn:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    
    if (btn.tag == 1) {// NO
        
        [self showCreditView:NO];
    }
    else if (btn.tag == 2){  //PAY
        
        [self showCreditView:NO];
        
        [self sendStripeCustomerIDToServer:[defaults_object(P_USER_DICT) objectForKey:P_STRIPE_CUS_ID] token:nil];
    }

    
}



// bottom button

- (IBAction)onSubmitButtonTap:(id)sender {
    //    UIActionSheet *actionSheet=[[UIActionSheet alloc]  initWithTitle: delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Paypay Payment",@"Cash On Hand", nil];
    //    [actionSheet showInView:self.view];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"pay_with", @"")
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    //
    
    //We add buttons to the alert controller by creating UIAlertActions:
    
    UIAlertAction *actionPayPal= [UIAlertAction actionWithTitle:NSLocalizedString(@"Paypay_Payment", @"")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            //Handle your yes please button action here
                                                            //                                                         [self sendNotification];
                                                            //                                                         [self.curr_trip setTrip_Status:PAID ];
                                                            //                                                         [self setDataonUI];
                                                            [self payWithPaypal];
                                                            
                                                        }];
    UIAlertAction *actionPayCash = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cash_On_Hand", @"")
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //Handle your yes please button action here
                                                              //                                                         [self sendNotification];
                                                              
                                                              [self payWithCashOnHand ];
                                                              
                                                          }];

    
    
    UIAlertAction *actionCreditCardDirect = [UIAlertAction actionWithTitle:NSLocalizedString(@"CREDIT_CARD", @"")
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //Handle your yes please button action here
                                                              
                                                              [self handleDirectPayment];
                                                              
                                                          }];
    
    UIAlertAction *actionCreditCardSAVE = [UIAlertAction actionWithTitle:NSLocalizedString(@"CREDIT_CARD_SAVE", @"")
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {
                                                                       //Handle your yes please button action here
                                                                       
                                                                       [self showPaymentMethodsController];
                                                                       
                                                                   }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //Handle your yes please button action here
                                                             //                                                         [self sendNotification];
                                                         }];
    
    [alertController addAction:actionCreditCardDirect];
    [alertController addAction:actionCreditCardSAVE];
    //[alertController addAction:actionPayPal];
    [alertController addAction:actionPayCash];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
}



-(void) payWithPaypal
{
    NSString *savedToken = [[NSUserDefaults standardUserDefaults] stringForKey:SAVED_TOKEN];
    if (savedToken) {
        [self initializeSDKMerchantWithToken:savedToken];
    } else {
        [self loginWithPayPal];
    }
}
- (void)loginWithPayPal {
    [self setWaitingForServer:YES];
    
    // Replace the url with your own sample server endpoint.
    [self forgetTokens];
    NSURL *url = [NSURL URLWithString:@"http://pph-retail-sdk-sample.herokuapp.com/toPayPal/live"];
    [[UIApplication sharedApplication] openURL:url];
}
- (void)forgetTokens {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SAVED_TOKEN];
}

- (void)initializeSDKMerchantWithToken:(NSString *)token {
//    [[NSUserDefaults standardUserDefaults] setObject:token forKey:SAVED_TOKEN];
//    [self setWaitingForServer:YES];
//    
//    __weak typeof(self) weakSelf = self;
//    // Initialize the SDK with the token.
//    [PayPalHereSDK setupWithCompositeTokenString:token
//                           thenCompletionHandler:^(PPHInitResultType status, PPHError *error, PPHMerchantInfo *info) {
//                               if (error) {
//                                   [weakSelf payWithPaypal];
//                               } else {
//                                   [weakSelf gotoPaymentScreen];
//                               }
//                           }];
}
- (void)gotoPaymentScreen {
    [self setWaitingForServer:NO];
    
    //    [self.navigationController pushViewController:((AppDelegate *)[UIApplication sharedApplication].delegate).paymentVC animated:YES];
}


- (void)setWaitingForServer:(BOOL)waitingForServer {
    [UtilityClass SetLoaderHidden:waitingForServer withTitle:@"Please wait..."];
}
-(void)payWithCashOnHand
{
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]  init];
    [dict setObject:self.curr_trip.trip_Id forKey:@"trip_id"];
    [dict setObject:CASH_PAY forKey:@"trip_pay_mode"];
    [dict setObject:PAID forKey:@"trip_pay_status"];
    
    self.curr_trip.trip_pay_mode = CASH_PAY;
    
   // NSDateFormatter * dateFormatter=[[NSDateFormatter alloc] init];
   // [dateFormatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dict setObject:[Utilities getStringFromDate:[NSDate date]] forKey:@"trip_pay_date"];
    
    if (self.curr_trip.isPromoCodeUsed==YES) {
        if(promoCode)
        {
            [dict setObject:promoCode.promoId forKey:@"promo_id"];
            [dict setObject:promoCode.promoCode forKey:@"trip_promo_code"];
            [dict setObject:self.curr_trip.trip_promo_amt forKey:@"trip_promo_amt"];
        }
    }
    [self.curr_trip updateTripModelWith:dict completionBlock:^(id results, NSError *error) {
        if([[results objectForKey:P_STATUS] isEqualToString:@"OK"])
        {
            [self savePayment];
            [self setDataonUI];
        }
    } isShowLoader:YES isSendNotification:YES];
    
}



- (IBAction)onOfflineButtonTap:(id)sender {
    defaults_remove(TRIP_ID);
    defaults_remove(@"trip_status");
    [self.navigationController popToRootViewControllerAnimated:YES];
    //    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)onFareReviewButtonTap:(id)sender {
    [self performSegueWithIdentifier:@"FareReviewViewController" sender:nil];
}



// rating view ButtonActions
- (IBAction)onRatingSkipButtonTap:(id)sender {
    [self.viewOverly setHidden:YES];
    [self.viewStarContainer setHidden:YES];
    [self.btOffline setHidden:NO];
    [self.btFareReview setHidden:NO];
    
}



- (IBAction)onRatingDoneButtonTap:(id)sender {
    
      int rating1 = starViewNoLabel.rating/20;
    
    [self.curr_trip.driver updateDriverRating:rating1 completionBlock:^(id results, NSError *error) {
        [self.viewOverly setHidden:YES];
        
        if (self.txtviewFeedback.text.length>0) {
            [self updateFeedbackInTrip];
        }
        
        [self.viewStarContainer setHidden:YES];
        
        [self.btOffline setHidden:NO];
        [self.btFareReview setHidden:NO];
        
    } isShowLoader:YES];
}

#pragma  mark Promo Code
- (IBAction)onPromoCodeButtonTap:(id)sender {
    self.viewEnterPromoCode.hidden=!self.viewEnterPromoCode.hidden;
}

- (IBAction)onApplyPromoCodeButtonTap:(id)sender {
    [self.view endEditing:YES];
    if(self.txtPromoCode.text.length==0)
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Enter_Promo_Code", @"")
                                                                                 message:@""
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        //
        
        //We add buttons to the alert controller by creating UIAlertActions:
        
        UIAlertAction *actionOk= [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            //Handle your yes please button action here
                                                            //                                                         [self sendNotification];
                                                            
                                                            
                                                        }];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        promoCode=[[PromoCodeModel alloc]  initWithPromode:self.txtPromoCode.text];
        [promoCode validatePromoCodeWithCompletionBlock:^(id results, NSError *error) {
            if([[results objectForKey:P_STATUS] isEqualToString:@"OK"])
            {
                float tripFareAfterApllyPromoCode=[promoCode calucalateAmtByPromoCode:[self.curr_trip.trip_fare floatValue]];
                //                self.curr_trip.trip_fare=[NSString stringWithFormat:@"%f",([_curr_trip.trip_fare floatValue]-tripFareAfterApllyPromoCode)];
                self.curr_trip.trip_promo_amt=[NSString stringWithFormat:@"%.2f",tripFareAfterApllyPromoCode];
                self.curr_trip.isPromoCodeUsed=YES;
                [self updateTripAfterApplyPromocode ];
                [self setDataonUI];
            }
        }];
    }
    
}


-(void) updateTripAfterApplyPromocode
{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]  init];
    [dict setObject:self.curr_trip.trip_Id forKey:@"trip_id"];
    //    [dict setObject:CASH_PAY forKey:@"trip_pay_mode"];
    //    [dict setObject:PAID forKey:@"trip_pay_status"];
    
    //    NSDateFormatter * dateFormatter=[[NSDateFormatter alloc] init];
    //    [dateFormatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    [dict setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"trip_pay_date"];
    
    if (self.curr_trip.isPromoCodeUsed==YES) {
        if(promoCode)
        {
            [dict setObject:promoCode.promoId forKey:@"promo_id"];
            [dict setObject:promoCode.promoCode forKey:@"trip_promo_code"];
            [dict setObject:self.curr_trip.trip_promo_amt forKey:@"trip_promo_amt"];
        }
    }
    [self.curr_trip updateTripModelWith:dict completionBlock:^(id results, NSError *error) {
        if([[results objectForKey:P_STATUS] isEqualToString:@"OK"])
        {
            [self sendNotificationPromoCode];
        }
    } isShowLoader:YES isSendNotification:YES];
}

-(void) savePayment
{
    NSString *payment = [NSString stringWithFormat:@"%f",[_curr_trip.trip_fare floatValue]-[_curr_trip.trip_promo_amt floatValue]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                 @{
                                   TRIP_ID         : _curr_trip.trip_Id,
                                   TRIP_PAY_AMOUNT : payment,
                                   TRIP_PAY_STATUS : PAID,
                                   PAY_DATE   : [Utilities getStringFromDate:[NSDate date]],
                                  // TRIP_TOTAL_PAY  : _curr_trip.trip_fare
                                   }];
    //    if payby Stripe
    if([_curr_trip.trip_pay_mode isEqualToString:PAYPAL_PAY])
    {
        [dict setObject:STRIPE_PAY forKey:TRIP_PAY_MODE]; //PAYPAL_PAY
    }
    else {
        [dict setObject:CASH_PAY forKey:TRIP_PAY_MODE];
    }
    if(_curr_trip.isPromoCodeUsed)
    {
        [dict setObject:promoCode.promoId forKey:TRIP_PROMO_ID];
        [dict setObject:promoCode.promoCode forKey:TRIP_PROMO_CODE];
        [dict setObject:_curr_trip.trip_promo_amt forKey:TRIP_PROMO_AMOUNT];
    }
    
    [APP_CallAPI gcURL:BASE_URL app:API_PAYMENT_SAVE
                        data:dict
     isShowErrorAlert:NO
                completionBlock:^(id results, NSError *error) {
                    if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                        // success
                        
                        
                        
                    }
                    
                }];
    
    //    url_paymentapi
}



#pragma mark - Text View Delegates

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO; // or true, whetever you's like
    }
    
    return textView.text.length + (text.length - range.length) <= 75;   //restrict user to 75 characters
}



#pragma mark - STRIPE


-(void)handleDirectPayment {
    
    //[UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
    
    // Setup add card view controller
    STPAddCardViewController *addCardViewController = [[STPAddCardViewController alloc] init];
    addCardViewController.delegate = self;
    
    // Present add card view controller
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addCardViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}


- (void)showPaymentMethodsController {
    
    //[UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
    
    // Setup customer context
    self.customerContext = [[STPCustomerContext alloc] initWithKeyProvider:[[StripeAPIClient alloc] initWithAPIVersion]];
    
    //now set up payment context
    self.paymentContext = [[STPPaymentContext alloc] initWithCustomerContext:self.customerContext];
    self.paymentContext.delegate = self;
    self.paymentContext.hostViewController = self;
   
    
//    NSString *amount;
//    if(self.curr_trip.isPromoCodeUsed)
//    {
//        if(promoCode)
//        {
//            amount =[NSString stringWithFormat:@"%.02f",[_curr_trip.trip_fare doubleValue]-[self.curr_trip.trip_promo_amt doubleValue]];
//        }
//    }
//    else{
//        amount =[NSString stringWithFormat:@"%.02f",[_curr_trip.trip_fare doubleValue]];
//    }
    
     self.paymentContext.paymentAmount = [[NSString stringWithFormat:@"%0.02f",[_curr_trip.trip_fare floatValue]-[_curr_trip.trip_promo_amt floatValue]] floatValue];

    
    [self.paymentContext presentPaymentMethodsViewController];
    
    
    // Setup payment methods view controller
    STPTheme *theme = [STPTheme defaultTheme];
    //theme.accentColor = [UIColor greenColor];
    
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
                              token:(STPToken*)token{
    
    
    [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
    
    float amount = [[NSString stringWithFormat:@"%0.2f",[_curr_trip.trip_fare floatValue]-[_curr_trip.trip_promo_amt floatValue]] floatValue] * 100;
    
   
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                 @{
                                             @"amount"                : @(amount),
                                             TRIP_ID                  : self.curr_trip.trip_Id,
                                             P_USER_ID                : [defaults_object(P_USER_DICT) objectForKey:P_USER_ID]
                                             }];
    
    
    
    if (token != nil) {
        [dict setValue:token forKey:P_STRIPE_TOKEN];
    }
    else {
        [dict setValue:stripeCustomerID forKey:@"customer"];//cus_BTEwnlSO5ce9ju
    }
    
    
    [APP_CallAPI gcURL:BASE_URL app:API_SEND_STRIPE_TOKEN data:dict
     isShowErrorAlert:NO
       completionBlock:^(id results, NSError *error) {
        
        //[UtilityClass SetLoaderHidden:YES withTitle:@"Order processing..."];
        
        //defaults_set_object(hireApi_Key, P_API_KEY);
        
        if(error == nil || [[results objectForKey:P_STATUS] isEqualToString:P_STATUS_OK])
        {
            //NSLog(@"%@",[results objectForKey:p_response]);
            NSDictionary *responseDict = [results objectForKey:P_RESPONSE];
            
            if ([[responseDict objectForKey:P_RESPONSE] isEqualToString:STRIPE_SUCCESS]) {
                
                [self proceedFurtherAfterStripe];
                
            }
            else if ([[responseDict objectForKey:P_RESPONSE] isEqualToString:STRIPE_DECLINED]){
                
                
                
                //declined
                
                [UtilityClass showWarningAlert:@"" message:[responseDict objectForKey:@"result"]//NSLocalizedString(@"Unmatch Country",@"")
                             cancelButtonTitle:NSLocalizedString(@"alert_ok",@"") otherButtonTitle:nil];
                
                [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
            }
            
            
            
        }
        else{
            //show error
            [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
            
            //[self proceedFurtherAfterStripe];
        }
        
    }];
    
}




#pragma mark STPPaymentMethodsViewControllerDelegate

- (void)paymentMethodsViewController:(STPPaymentMethodsViewController *)paymentMethodsViewController didFailToLoadWithError:(NSError *)error {
    // Dismiss payment methods view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // Present error to user...
    NSLog(@"Payment ViewController error: %@",error.localizedDescription);
}

- (void)paymentMethodsViewControllerDidCancel:(STPPaymentMethodsViewController *)paymentMethodsViewController { //Cancel
    // Dismiss payment methods view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)paymentMethodsViewControllerDidFinish:(STPPaymentMethodsViewController *)paymentMethodsViewController { // Finish  //called in last
    
    // Dismiss payment methods view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)paymentMethodsViewController:(STPPaymentMethodsViewController *)paymentMethodsViewController didSelectPaymentMethod:(id<STPPaymentMethod>)paymentMethod {
    // Save selected payment method
    //self.selectedPaymentMethod = paymentMethod;
    
}



#pragma mark - STPPaymentContext Delegates

-(void)paymentContextDidChange:(STPPaymentContext *)paymentContext{
    //NSLog(@"Payment Context Result Called :%@", paymentContext.selectedPaymentMethod.label);
    
    if (self.paymentContext.selectedPaymentMethod != nil) {
        [self reloadCreditCardBtn];
        
        [self showCreditView:YES];
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
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    [self sendStripeCustomerIDToServer:nil token:token];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




-(void)proceedFurtherAfterStripe
{
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]  init];
    [dict setObject:self.curr_trip.trip_Id forKey:@"trip_id"];
    [dict setObject:PAYPAL_PAY forKey:@"trip_pay_mode"];
    [dict setObject:PAID forKey:@"trip_pay_status"];
    
    self.curr_trip.trip_pay_mode = PAYPAL_PAY;
    
    // NSDateFormatter * dateFormatter=[[NSDateFormatter alloc] init];
    // [dateFormatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dict setObject:[Utilities getStringFromDate:[NSDate date]] forKey:@"trip_pay_date"];
    
    if (self.curr_trip.isPromoCodeUsed==YES) {
        if(promoCode)
        {
            [dict setObject:promoCode.promoId forKey:@"promo_id"];
            [dict setObject:promoCode.promoCode forKey:@"trip_promo_code"];
            [dict setObject:self.curr_trip.trip_promo_amt forKey:@"trip_promo_amt"];
        }
    }
    [self.curr_trip updateTripModelWith:dict completionBlock:^(id results, NSError *error) {
        if([[results objectForKey:P_STATUS] isEqualToString:@"OK"])
        {
            [self savePayment];
            [self setDataonUI];
        }
    } isShowLoader:YES isSendNotification:YES];
    
}




#pragma mark - Save Credit View

-(void)showCreditView:(BOOL)toShow{
    toShow ?
    [self showViewAnimated:self.viewCreditContainer] : [self hideViewAnimated:self.viewCreditContainer];
}


-(void)reloadCreditCardBtn{
    //NSLog(@"payment method: %@", self.paymentContext.selectedPaymentMethod.label);
    
    UIImage *image = self.paymentContext.selectedPaymentMethod.image;
    //UIImage *templateImage = self.paymentContext.selectedPaymentMethod.templateImage;
    
    [self.btnCreditCard setImage:image forState:UIControlStateNormal];
    [self.btnCreditCard setTitle:self.paymentContext.selectedPaymentMethod.label forState:UIControlStateNormal];
}


-(void)showViewAnimated:(UIView *)view{
    [view setHidden:NO];
    view.alpha = 0;
    
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.alpha = 1;
        
    } completion:^(BOOL finished) {
        nil;
    }];
}
-(void)hideViewAnimated:(UIView*)view{
    view.alpha = 1;
    
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.alpha = 0;
        
    } completion:^(BOOL finished) {
        [view setHidden:YES];
        [view endEditing:YES];
    }];
}











@end
