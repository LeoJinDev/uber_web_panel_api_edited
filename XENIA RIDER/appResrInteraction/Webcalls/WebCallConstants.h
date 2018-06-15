//
//  WebCallConstants.h
//  Restau
//
//  Created by SFYT on 26/07/12.
//  Copyright (c) 2012 vinay@metadesignsolutions.in. All rights reserved.
//

#import "Keys.h"

#ifndef Restau_WebCallConstants_h
#define Restau_WebCallConstants_h
#define APP_DELEGATE (AppDelegate*) [[UIApplication sharedApplication] delegate]

#define APP_WEB_CALLS    (webcall*) [[webcall alloc] init]
#define FONT_HELVETICANEUE_LIGHT(fontSize)                                     \
([UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize])
#define FONT_HELVETICANEUE_BOLD(fontSize)                                      \
([UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize])

#define FONT_HELVETICANEUE_Italic(fontSize)                                     \
([UIFont fontWithName:@"HelveticaNeue-Italic" size:fontSize])
#define FONT_HELVETICANEUE_REGULAR(fontSize)                                   \
([UIFont fontWithName:@"Helvetica Neue" size:fontSize])

#define FONT_HELVETICANEUE(fontSize)                                      \
([UIFont fontWithName:@"HelveticaNeue" size:fontSize])

#define FONT_ROB_COND_REG(fontSize)                                        \
(UIFont *)[UIFont fontWithName:@"RobotoCondensed-Regular" size:fontSize]

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define APP_CallAPI (CallAPI *)[[CallAPI alloc] init]


#define FONTS_THEME_BOLD(fontSize)  (UIFont*) [UIFont fontWithName:@"RobotoCondensed-Regular" size:fontSize*(SCREEN_WIDTH/375.0)]
#define FONTS_THEME_REGULAR(fontSize)  (UIFont*) [UIFont fontWithName:@"RobotoCondensed-Regular" size:fontSize*(SCREEN_WIDTH/375.0)]

#define CONSTANT_THEME_COLOR1 [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1]
#define CONSTANT_THEME_COLOR2 [UIColor colorWithRed:252.0/255.0 green:227.0/255.0 blue:3.0/255.0 alpha:1]
#define CONSTANT_TEXT_COLOR_BUTTONS [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1]
#define CONSTANT_TEXT_COLOR_HEADER [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]


#define Share_Text          @"XeniaTeller is more than a crypto wallet, you can order a ride, be your own banker, withdraw cash through a teller closest to you download now! Xenia Teller!"





static inline NSString *isEmpty(id thing) {
    return (thing == nil || [thing isKindOfClass:[NSNull class]] ||
            ([thing respondsToSelector:@selector(length)] &&
             [(NSData *)thing length] == 0) ||
            ([thing respondsToSelector:@selector(count)] &&
             [(NSArray *)thing count] == 0))
    ? @""
    : thing;
}





// DB Common

#define send_driver_notification  @"DriverAndroidIosPushNotification.php"


#define API_UPDATE_DRIVER_PROFILE   @"driverapi/updatedriverprofile"
#define API_UPDATE_USER_PROFILE     @"userapi/updateuserprofile"


#define B_Key               @"bkey"
#define R_Key               @"rkey"


// APIs
#define google_plus_client  @"317874290475-26sr0rrs8m2v2rbham8lbho4fqhq7vg3.apps.googleusercontent.com"


#define current = "myOutput"
#define Email_symbols       @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
#define Symbols_text        @"~`!@#$%^&*()+=-/;:\"\'{}[]<>^?,™£¢∞§¶•ªº¥€|_.";


//fare amount init
#define accept_time                 30
#define price_per_km                5
#define waiting_charge_per_min      1
#define tax                         0.05 // 5% (Percentage)
#define driver_mi_charge            5
#define min_percentage_charge       10
#define SIZE                        10

#define SAVED_TOKEN             @"saveToken"


#define CASH_MSG                @"Please collect cash from Rider."
#define CARD_MSG                @"Rider is paying through Card."


#define Numbers_text            @"0123456789";
#define alphabets_text          @"abcdefghijklmnopqrstuvwxyz";
#define ACCEPTABLE_CHARACTERS   @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

#define GET_DRIVER_PROFILE      @"getdrivers"//@"display_details"


//side Menu
#define SIDE_MENU_LOGOUT        @"power-button"
#define SIDE_MENU_TERMS         @"terms_condition"

#define SIDE_MENU_SHARE         @"share"
#define SIDE_MENU_DEACTIVATE    @"deactivate"
#define SIDE_MENU_SUPPORT       @"support"
#define SIDE_MENU_XENIASIGNUP   @"XeniaSignUpViewController"
#define SIDE_MENU_WALLETOPTION  @"WalletCoinVC"
#define SIDE_MENU_WITHDRAW      @"XeniaWithdraw"

#define STRIPE_SUCCESS          @"success"
#define STRIPE_DECLINED         @"declined"

//API's
//#define GET_USER_PROFILE @"get_user_profile"//@"display_details"
//#define GET_DRIVER_PROFILE @"get_driver_profile"//@"display_details"


//////////////////

//#define DRIVER_SIGNIN @"driver_signin"//@"signin1"
//#define DRIVER_SIGNUP @"driver_signup"//@"signup"
#define USER_SIGNUP                 @"userapi/registration"//@"signup"
#define USER_SIGNIN                 @"userapi/login"//@"signin1"
#define TRIP_UPDATE                 @"tripapi/updatetrip"
#define TRIP_GETTRIP                @"tripapi/gettrips"
#define CAR_GETCATEGORY             @"getcategories"
#define GET_CAR                     @"getcars"

#define API_PAYMENT_SAVE            @"paymentapi/save"
#define API_CREATE_TRIP             @"tripapi/save"
#define GET_USER_PROFILE            @"userapi/getusers"
#define API_GET_CATEGORY            @"categoryapi/getcategories"
#define MAP_ROUTE                   @"maproute"
#define DRIVER_STATUS               @"driverstatus"
#define TRIP_ID                     @"trip_id"
#define TRIP_STATUS                 @"trip_status"
#define TRIP_DRIVER_COMISSION       @"trip_driver_commision"
#define TRIP_PAY_AMOUNT             @"pay_amount"
#define TRIP_PAY_MODE               @"pay_mode"
#define TRIP_FEEDBACK               @"trip_feedback"

#define TRIP_PAY_STATUS             @"pay_status"
#define TRIP_PROMO_ID               @"promo_id"
#define TRIP_PROMO_CODE             @"pay_promo_code"
#define TRIP_PROMO_AMOUNT           @"pay_promo_amt"
#define TRIP_PAY_DATE               @"trip_pay_date"
#define TRIP_TOTAL_PAY              @"trip_pay_amount"
#define PAY_DATE                    @"pay_date"



#define PAYMENT_SAVE                @"save"
#define PAYMENT_GET_PAYMENTS        @"getpayments"
#define SET_DRIVER_LOCATION         @"set_driver_loc"//@"update_location"
#define GET_USER_LOCATION           @"get_user_loc"//@"get_userlocation"

#define GET_WAITING_TIME            @"get_request_waiting_duration"//@"GetRequestAcceptDuration"

#define ACCEPT_RIDE                 @"accept_ride"//@"accept"

#define GET_USER_DROP_LOCATION      @"get_user_drop_loc"//@"get_droploc"

#define SET_RIDE_STATS              @"set_ride_stats"//@"update_amount"

#define SET_RIDE_STATUS_BEGIN       @"set_ride_status_begin"//@"begin_trip"

#define DRIVER_CANCEL_RIDE_REQUEST  @"driver_cancel_ride_request"//@"drivercancel_request"

#define UPDATE_DEVICE_TOKEN         @"update_driver_device_token"//@"update_devicetoken"

#define CONFIRM_USER_PAY_CASH       @"confirm_user_pay_cash"//@"user_details"

#define SET_AVAILABILITY_OFF        @"set_driver_availability_off"//@"availability_off"

#define GET_RIDES_HISTORY           @"get_rides_history"//@"reviewhistory"


#define UPDATE_USER_PASSWORD        @"userapi/updateuserpassword"//@"update_details"

#define FB_LOGIN                    @"userapi/fblogin"

//#define DRIVER_CHANGE_PASSWORD @"driver_change_password"//@"reset_pwd"
#define DRIVER_CHANGE_PASSWORD      @"userapi/forgetpassword"//@"reset_pwd"



#define GET_RIDE_AMOUNT_CALCULATED  @"get_ride_amount_calc"//@"get_amount"

#define PROMO_PAY_ACCEPT            @"accept_payment_promo"

//#define GET_USERS_NEARBY @"get_users_nearby"//@"near_by_users"
#define GET_DRIVERS_NEARBY          @"driverapi/getnearbydriverlists"//@"near_by_users"

#define GET_USERS_NEARBY            @"userapi/getnearbyuserlists"

#define CANCEL_INTENTIONALLY        @"set_request_cancel_intentionally"//@"cancelreq_intentionally"

#define API_GET_TAXI_CONSTANT       @"constantapi/getconstants"

#define API_GET_EPHEMERAL_KEY       @"braintreeapi/stripeephemeralkey"

#define API_SEND_STRIPE_TOKEN       @"braintreeapi/stripetransactionsale"



#define API_VALIDATE_PROMO      @"promoapi/validatepromos"
#define  p_promo_code           @"promo_code"

#define  TS_REQUEST          @"request"
#define  TS_REJECTED         @"rejected"
#define  TS_ACCEPTED         @"accept"
#define  TS_END              @"end"
#define  TS_ARRIVE           @"arrive"
#define  TS_BEGIN            @"begin"
#define  TS_DRIVER_CANCEL    @"driver_cancel"
#define  TS_DRIVER_CANCEL_AT_PICKUP     @"driver_cancel_at_pickup"
#define  TS_DRIVER_CANCEL_AT_DROP       @"driver_cancel_at_drop"
#define  PAID                   @"Paid"
#define  PAY_ACCEPTED           @"payaccept"
#define  TS_WAITING             @"waiting"
#define  TS_PICKED              @"Picked"
#define  PAYPAL_PAY             @"PayPal"
#define  CASH_PAY               @"Cash"
#define  STRIPE_PAY             @"Stripe"



//TRIP MESSAGES

#define  MESSAGE_REJECTED         @"Driver has rejected taxi request"
#define  MESSAGE_ACCEPTED         @"Your Trip Request has been confirmed. Get Ready"
#define  MESSAGE_END              @"Your trip completed successfully. Thanks"
#define  MESSAGE_ARRIVE           @"Hey, Cab will arrive soon. Be Ready"
#define  MESSAGE_BEGIN            @"Your trip has been started. Good Luck"
#define  MESSAGE_DRIVER_CANCEL    @"Driver has cancelled the Trip. Ask him"
#define  MESSAGE_PAID             @"You have paid successfully"


#define MESSAGE_FACEBOOK_INVALID_ID     @"Invalid FB ID OR FB ID not found."


// string contants

#define P_STATUS                    @"status"
#define P_RESPONSE                  @"response"
#define P_STATUS_OK                 @"OK"
#define P_MESSAGE                   @"message"
#define P_ERROR                     @"error"

#define P_FAVOURITE_DEALS           @"favourite"

// LOGIN
#define P_ADDRESS                   @"address"
#define P_CITY                      @"city"
#define P_COUNTRY                   @"country"
#define P_EMAIL                     @"u_email"
#define P_USER_ID                   @"user_id"
#define P_PASSWORD                  @"u_password"
#define P_NEW_PASSWORD              @"new_password"
#define P_MOBILE                    @"u_phone"
#define P_STATE                     @"state"
#define P_STATUS                    @"status"
#define P_TOKEN                     @"token"
#define P_USERNAME                  @"username"
#define P_ZIP                       @"u_zipcode"
#define P_FNAME                     @"u_fname"
#define P_LNAME                     @"u_lname"
#define P_GENDER                    @"gender"
#define P_API_KEY                   @"api_key"
#define P_DEVICE_TOKEN              @"u_device_token"
#define P_DEVICE_TYPE               @"u_device_type"
#define P_PROFILE_IMAGE_PATH        @"u_profile_image_path"
#define P_USER_IS_AVAILABLE         @"u_is_available"
#define P_USER_IS_DELETE            @"is_delete"
#define P_USER_ACTIVE               @"active"
#define P_STRIPE_CUS_ID             @"strip_cus_id"
#define P_STRIPE_TOKEN              @"source"



#define P_USER_LAT                  @"u_lat"
#define P_USER_LNG                  @"u_lng"
#define P_EMERGENCY_CONTACT_1       @"emergency_contact_1"
#define P_EMERGENCY_CONTACT_2       @"emergency_contact_2"
#define P_EMERGENCY_CONTACT_3       @"emergency_contact_3"
#define P_EMERGENCY_EMAIL_1         @"emergency_email_1"
#define P_EMERGENCY_EMAIL_2         @"emergency_email_2"
#define P_EMERGENCY_CEMAIL_3        @"emergency_email_3"

#define P_CAR_NAME_HATCHBACK        @"HatchBack"
#define P_CAR_NAME_SEDAN            @"sedan"
#define P_CAR_NAME_SUV              @"suv"
#define P_LAT                       @"lat"
#define P_LNG                       @"lng"
#define P_CATEGORY_ID               @"category_id"
#define P_CATEGORY_BASE_PRICE       @"cat_base_price"
#define P_CATEGORY_FARE_PER_KM      @"cat_fare_per_km"
#define P_CATEGORY_FARE_PER_MIN     @"cat_fare_per_min"
#define P_CATEGORY_IS_FIXED_PRICE   @"cat_is_fixed_price"
#define P_CATEGORY_PRIME_TIME_PERCENTAGE    @"cat_prime_time_percentage"
#define P_CATEGORY_MAX_SIZE @"cat_max_size"
#define P_CATEGORY_NAME         @"cat_name"

#define P_USER_DICT                 @"user_dict"


//Wallet Card
#define WC_TYPE                     @"wallet_type"
#define WC_NAIRA                    @"wallet_type_naira"
#define WC_EURO                     @"wallet_type_euro"
#define WC_DOLLAR                   @"wallet_type_dollar"
#define WC_RAND                     @"wallet_type_rand"
#define WC_ZAR                      @"wallet_type_zar"
#define WC_PREORDERCARD_ID                  @"wallet_preorder_id"
//Xenia Coin Platform API

#define XC_GET_CARD_PREORDER_LIST        @"api/v1/card_holders"
#define XC_SET_CARD_PREORDER                 @"api/v1/card_holders"
#define XC_ACCESS_TOKEN                  @"access_token"
#define XC_Email                    @"email"
#define XC_NAME                     @"name"
#define XC_REQUEST_FROM             @"request_from"
#define XC_CARD_REQUEST             @"card_requests"

#define XC_TOKEN           @"864a94657f70285adb81c9a9ed292826"









#endif


