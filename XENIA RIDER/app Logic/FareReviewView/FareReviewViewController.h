//
//  FareReviewViewController.h
//  TaxiDriver
//
//  Created by Sivilay on 25/10/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripModel.h"

@interface FareReviewViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lbltripid;
@property (strong, nonatomic) IBOutlet UILabel *lblDriverId;
@property (strong, nonatomic) IBOutlet UILabel *lblPickupLocation;
@property (strong, nonatomic) IBOutlet UILabel *lblDropLocation;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblDistance;
@property (strong, nonatomic) IBOutlet UILabel *lblCharge;
@property (strong, nonatomic) IBOutlet UILabel *lblWaitingCharge;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic)  TripModel *cur_trip;
- (IBAction)onBackButtonTap:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbCarCategoryName;
@property (weak, nonatomic) IBOutlet UILabel *lbPromoCodeAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblTax;
@property (strong, nonatomic) IBOutlet UIImageView *imgCar;
@property (strong, nonatomic) IBOutlet UIImageView *imgDriver;
@property (strong, nonatomic) IBOutlet UILabel *lblDriverName;
@property (strong, nonatomic) IBOutlet UIImageView *imgCancelTrip;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblFareAmountTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTaxTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblAmountPaidTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblPromoTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTripIdTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDriverIdTitle;

@end
