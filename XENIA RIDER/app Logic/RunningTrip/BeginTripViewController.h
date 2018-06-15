;//
//  BeginTripViewController.h
//  XENIA RIDER
//
//  Created by SFYT on 15/06/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TripModel.h"
#import "ConstantModel.h"
@interface BeginTripViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *lbDestination;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIView *viewTime;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
- (IBAction)onMyLocationButtonTap:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblDetinationTitle;

@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property(strong,nonatomic) TripModel * currentTrip;
@property(strong,nonatomic) ConstantModel * constantModel;
@end
