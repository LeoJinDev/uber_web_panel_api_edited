//
//  TripDetailsViewController.h
//  TaxiDriver
//
//  Created by SFYT on 30/05/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripModel.h"
#import "ConstantModel.h"

@interface TripDetailsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lblRiderName;
@property (strong, nonatomic) IBOutlet UILabel *lblPickup;
@property (strong, nonatomic) IBOutlet UILabel *lblDrop;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblDistance;
@property (strong, nonatomic) IBOutlet UILabel *lblAmmount;
@property (weak, nonatomic) IBOutlet UILabel *lbPromoAmmout;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalPayAmount;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *lblWaitingCharge;
@property (strong, nonatomic) IBOutlet UILabel *lblTax;

@property (strong, nonatomic) TripModel *trip;
@property (strong,nonatomic) ConstantModel *constantModel;
@property (strong, nonatomic) IBOutlet UIImageView *imgCancelTrip;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblFareAmountTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTaxTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblAmountPaidTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblPromoTitle;

@end
