//
//  HomeViewController.h
//  Store_project
//
//  Created by Sivilay on 25/10/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DragUIButton.h"
#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GoogleMaps.h>


@interface HomeViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate,DragUIButtonDelegate>
@property (weak, nonatomic) IBOutlet DragUIButton *dragButton;
@property (weak, nonatomic) IBOutlet UIImageView *imCenterPickupLocation;
@property (weak, nonatomic) IBOutlet UITextField *txtDestinationAddres;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UITableView *tableViewLocation;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activtiyIndicator;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UIView *viewTimeDistance;
@property (weak, nonatomic) IBOutlet UILabel *lbDriversAvailableMessage;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (strong,nonatomic) MKPlacemark *source;
@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UIView *viewRequest;
@property (strong, nonatomic) MKPlacemark *destination;
@property (weak, nonatomic) IBOutlet UIView *viewCategory;
@property (weak, nonatomic) IBOutlet UIView *viewArrvieTime;
@property (weak, nonatomic) IBOutlet UILabel *lbArriveAddress;
@property (weak, nonatomic) IBOutlet UIButton *btCategory1;
//@property (weak, nonatomic) IBOutlet UIView *viewHeaderTripAccept;
@property (weak, nonatomic) IBOutlet UIButton *btCategory3;
@property (weak, nonatomic) IBOutlet UIButton *btCategory2;

- (IBAction)onRequestButtonTap:(id)sender;

//DMS Rider new
@property (weak, nonatomic) IBOutlet UIView *viewDriverSearch;

@property (strong, nonatomic) IBOutlet UIView *ContainerView;
@property (weak, nonatomic) IBOutlet UIButton *btSearch;

- (IBAction)ButtonMenuPressed:(id)sender;
- (IBAction)onShowMyLocationTap:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblBaseFare;
@property (strong, nonatomic) IBOutlet UILabel *lblPerKM;
@property (strong, nonatomic) IBOutlet UILabel *lblPerMin;
@property (strong, nonatomic) IBOutlet UILabel *lblDistance;
@property (strong, nonatomic) IBOutlet UILabel *lblMaxSize;
@property (strong, nonatomic) IBOutlet UILabel *lblEstimate;
@property (strong, nonatomic) IBOutlet UIView *viewFareDetails;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *fareviewBottomConstraints;
@property (strong, nonatomic) IBOutlet UIButton *btnFareDetails;
@property (strong, nonatomic) IBOutlet UILabel *lblPricePerKM;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrencyType;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnFareDetailsBottomConstraints;

@property (weak, nonatomic) IBOutlet UILabel *lblCategoryHatch;
@property (weak, nonatomic) IBOutlet UILabel *lblCategorySedan;
@property (weak, nonatomic) IBOutlet UILabel *lblCategorySUV;
@property (strong, nonatomic) IBOutlet UILabel *lblDestinationTitle;

@property (strong, nonatomic) IBOutlet UILabel *baseFareTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblPerKmTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblPerMinuteTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDistanceTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblMaxSizeTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblEstimateTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblExpectedTime;
@property (strong, nonatomic) IBOutlet UILabel *lblShowEstimate;

@end
