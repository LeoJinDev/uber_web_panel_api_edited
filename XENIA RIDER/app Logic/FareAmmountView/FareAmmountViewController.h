//
//  FareAmmountViewController.h
//  TaxiDriver
//
//  Created by Sivilay on 25/10/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripModel.h"
#import "SAMTextView.h"
#import "ConstantModel.h"


@interface FareAmmountViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lbPromocodeAmount;
@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UIView *viewAmount;
@property (weak, nonatomic) IBOutlet UILabel *lbTripFareAmount;

@property (weak, nonatomic) IBOutlet UIButton *btSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btOffline;

@property (weak, nonatomic) IBOutlet UIButton *btFareReview;

// Amount View
@property (weak, nonatomic) IBOutlet UIView *viewOverly;

@property (weak, nonatomic) IBOutlet UILabel *lbAmountToPay;

@property (weak, nonatomic) IBOutlet UIView *viewEnterPromoCode;


@property (weak, nonatomic) IBOutlet UITextField *txtPromoCode;
@property (strong, nonatomic) TripModel *curr_trip;
@property (strong, nonatomic) ConstantModel *constantModel;


@property (weak, nonatomic) IBOutlet UIView *viewPromoCode;

@property (weak, nonatomic) IBOutlet UIView *viewStarContainer;
@property (weak, nonatomic) IBOutlet SAMTextView *txtviewFeedback;
@property (strong, nonatomic) IBOutlet UIView *ratingBar;

@property (strong, nonatomic) IBOutlet UILabel *lblHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblHireMeCard;
@property (strong, nonatomic) IBOutlet UILabel *lblAmountPayableTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnSkip;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) IBOutlet UIButton *btnOffline;
@property (strong, nonatomic) IBOutlet UIButton *btnFareReview;
@property (strong, nonatomic) IBOutlet UIButton *btnPromoCode;
@property (strong, nonatomic) IBOutlet UIButton *btnApply;
@property (strong, nonatomic) IBOutlet UIButton *btnRatingSkip;
@property (strong, nonatomic) IBOutlet UIButton *btnratingDone;
@property (strong, nonatomic) IBOutlet UILabel *lblRateDriver;

@property (weak, nonatomic) IBOutlet UIView *viewCreditContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblCreditView;
@property (weak, nonatomic) IBOutlet UIButton *btnCreditCard;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelCard;
@property (weak, nonatomic) IBOutlet UIButton *btnPayCard;


@end
