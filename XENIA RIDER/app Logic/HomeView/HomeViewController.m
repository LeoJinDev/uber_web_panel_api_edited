////
//  HomeViewController.m
//  Store_project
//
//  Created by Sivilay on 25/10/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "HomeViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import <GrepixKit/GrepixKit.h>
//#import "CallAPI.h"
#import "WebCallConstants.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "TripModel.h"
#import "AFHTTPRequestOperationManager.h"
#import "FareAmmountViewController.h"
#import "SuggestedLocationCell.h"
#import "SuggestedLocationDataSource.h"
#import "GoogleDirectionSource.h"
#import "DriverModel.h"
#import "RequestViewController.h"
#import "UserModel.h"
#import "NearByDriverHandler.h"
#import "BeginTripViewController.h"
#import "CategoryModel.h"
#import "CustomPointAnnotation.h"
#import "UpdateUserCurrentLocation.h"
#import "ConstantModel.h"



@interface HomeViewController ()<SuggestedLocationDataSourceDelegate,RequestViewControllerDelegate,NearByDriverHandlerDelegate,UIGestureRecognizerDelegate>
{
    double angle;
    NSArray *driversArray;
    MKPointAnnotation *userPin;
    TripModel *currTrip;
    NSString *driverStatus;
    NSMutableArray *arrayCagetgory;
    ConstantModel *constantTaxiModel;
    NSString *userAvailability;
    GoogleDirectionSource * direction;
    UIButton * selectedButton;
    NearByDriverHandler * nearByDriverHandler;
    NSString * currentTripStatus;
    SuggestedLocationDataSource * locationDataSource;
    float tripTime;
    float tripDistance;
    NSMutableArray * arrAnotation;
    NSMutableArray * arrayDriversAnnotation;
    BOOL isMapDraged;
    BOOL isMapRouteMake;
    UIPanGestureRecognizer *panRec;
    UIPinchGestureRecognizer *pinchRec;
    CLLocationCoordinate2D centerCoordinate;
    
    BOOL isHome,isShowFareView;
    
    int apiCallAttempt;
    
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setThemeConstants];
    self.viewFareDetails.hidden =YES;
    self.btnFareDetails.hidden=YES;
    _lblShowEstimate.hidden=YES;
     self.btnFareDetailsBottomConstraints.constant =-72;
    tripTime=0;
    isMapDraged=NO;
    tripDistance=0;
    self.dragButton.delegate=self;
    [_txtDestinationAddres setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    arrAnotation=[[NSMutableArray alloc]  init];
    arrayDriversAnnotation=[[NSMutableArray alloc]  init];
    //    [self.viewHeaderTripAccept setHidden:YES];
    [self.viewArrvieTime.layer setCornerRadius:21];
    [self.viewArrvieTime.layer setBorderWidth:3];
    [self.viewArrvieTime.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [self.viewRequest.layer setCornerRadius:15];
    [self.viewRequest.layer setBorderWidth:1];
    [self.viewRequest.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.viewRequest setClipsToBounds:YES];
    
    selectedButton=_btCategory1;
    [_btCategory2 setImage:nil forState:UIControlStateNormal];
    _btCategory2.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [_btCategory3 setImage:nil forState:UIControlStateNormal];
    [self onCatgoryButtonTap:selectedButton];
    direction=[[GoogleDirectionSource alloc]  init];
    locationDataSource=[[SuggestedLocationDataSource alloc]  initWithTableView:self.tableViewLocation textFiled:self.txtDestinationAddres];
    locationDataSource.delegate=self;
    driversArray  =[[NSArray alloc]init];
    [self initMapView];
    nearByDriverHandler=[[NearByDriverHandler alloc]  init];
    nearByDriverHandler.delegate=self;
    
    [self.viewTimeDistance.layer setCornerRadius:15];
    [self.viewTimeDistance.layer setBorderWidth:1];
    [self.viewTimeDistance.layer setBorderColor:[UIColor blackColor].CGColor];
    apiCallAttempt =0;
    [self getCategoryFormServer];
    [self getTaxiConstant];
    
    
    [[UpdateUserCurrentLocation sharedInstance] startUpdateCurrentLocation];
    [self addUserInteractionChangeHandlerOnMap ];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    isMapDraged=NO;
    isMapRouteMake=NO;
    [super viewWillAppear:animated];
    NSString *savedTripId=defaults_object(TRIP_ID);
    isHome =YES;
    if(savedTripId!=nil)
    {
        [self checkTripStatus];
    }
    else{
        [self.btSearch setSelected:NO];
        [self.imCenterPickupLocation setHidden:NO];
        self.viewFareDetails.hidden =YES;
        self.btnFareDetails.hidden=YES;
        _lblShowEstimate.hidden=YES;
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView removeOverlays:self.mapView.overlays];
        [self.txtDestinationAddres setText:@""];
        [self setUserAnnotation];
    }
    [nearByDriverHandler  startGettingNearByDriver];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewOrderRequest:) name:@"NotificationReceived" object:nil];
    
   // [self handleDirectPayment];
}

-(void) viewWillDisappear:(BOOL)animated
{
    isHome =NO;
    [nearByDriverHandler stopGetNearByDriver];
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
    [[UpdateUserCurrentLocation sharedInstance] stopUpdateCurrentLocation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setThemeConstants{
    [_lblDestinationTitle setFont:FONTS_THEME_REGULAR(15)];
    _lblDestinationTitle.textColor =CONSTANT_THEME_COLOR2;
    [_lblPerKM setFont:FONTS_THEME_REGULAR(16)];
     [_lblPerKmTitle setFont:FONTS_THEME_REGULAR(16)];
     [_lblPerMin setFont:FONTS_THEME_REGULAR(16)];
     [_lblPerMinuteTitle setFont:FONTS_THEME_REGULAR(16)];
     [_lblBaseFare setFont:FONTS_THEME_REGULAR(16)];
     [_baseFareTitle setFont:FONTS_THEME_REGULAR(16)];
     [_lblDistance setFont:FONTS_THEME_REGULAR(16)];
     [_lblDistanceTitle setFont:FONTS_THEME_REGULAR(16)];
     [_lblMaxSize setFont:FONTS_THEME_REGULAR(16)];
     [_lblMaxSizeTitle setFont:FONTS_THEME_REGULAR(16)];
     [_lblEstimate setFont:FONTS_THEME_REGULAR(16)];
     [_lblEstimateTitle setFont:FONTS_THEME_REGULAR(16)];
    [_lblCategorySUV setFont:FONTS_THEME_REGULAR(16)];
    [_lblCategoryHatch setFont:FONTS_THEME_REGULAR(16)];
    [_lblCategorySedan setFont:FONTS_THEME_REGULAR(16)];
    [_lbTime setFont:FONTS_THEME_REGULAR(10)];
    [_lbDriversAvailableMessage setFont:FONTS_THEME_REGULAR(17)];
    [_txtDestinationAddres setFont:FONTS_THEME_REGULAR(14)];
}

- (void)addUserInteractionChangeHandlerOnMap {
    
    
    panRec =
    [[UIPanGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(didDragMap:)];
    [panRec setDelegate:self];
    [self.mapView addGestureRecognizer:panRec];
    
    pinchRec =
    [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(didDragMap:)];
    [pinchRec setDelegate:self];
    [self.mapView addGestureRecognizer:pinchRec];
    [self.mapView setUserInteractionEnabled:YES];
    
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
- (void)didDragMap:(UIGestureRecognizer *)gestureRecognizer {
    isMapDraged=YES;
    
    if (!self.imCenterPickupLocation.isHidden && gestureRecognizer.state == UIGestureRecognizerStateEnded )
    {
        CLLocation * userLoc=[[CLLocation alloc]  initWithCoordinate:centerCoordinate altitude:0 horizontalAccuracy:5 verticalAccuracy:5 timestamp:[NSDate date]];
        
        
        [[GMSGeocoder geocoder] reverseGeocodeCoordinate:userLoc.coordinate completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
            NSLog(@"reverse geocoding results:");
            
            GMSAddress* addressObj = [[response results] firstObject];
            
            NSLog(@"country=%@", addressObj.country);
            
            // NSLog(@"lines=%@", addressObj.lines);
            if (addressObj.lines) {
                
                NSString * result = [addressObj.lines componentsJoinedByString:@","];
                // NSString *firstLetter = [result substringToIndex:1];
                if ([result length] > 1 && [result hasPrefix:@","]) {
                    result = [result substringFromIndex:1];
                }
                
                direction.source =   userLoc;
                direction.pickAddress = [NSString stringWithString:result];
                direction.pickCountry = addressObj.country;
                
                
                if(!isMapRouteMake && isHome)
                {
                   
                  //  CLLocation * location=[[CLLocation alloc]  initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
                    [nearByDriverHandler changePickUpLocation:userLoc];
                }
                
                NSLog(@"%@",[NSString stringWithString:result]);
            }
            
        }];
        
        
    }
    
    
}

-(void)initMapView
{
    
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    AppDelegate *appdelegate =APP_DELEGATE;
    NSDictionary *lastloc = defaults_object(@"curr_loc");
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[lastloc objectForKey:@"lat"] floatValue], [[lastloc objectForKey:@"lng"] floatValue]);
    appdelegate.currLoc=coordinate;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.9;
    span.longitudeDelta=0.9;
    region.span=span;
    region.center=coordinate;
    if( coordinate.longitude > -89 && coordinate.longitude < 89 && coordinate.longitude > -179 && coordinate.longitude < 179 ){
        [self.mapView setRegion:region animated:YES];
    }
    //[self.mapView setRegion:region animated:TRUE];
    [self.mapView regionThatFits:region];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
     _locationManager.distanceFilter = 10.0;
     [_locationManager setPausesLocationUpdatesAutomatically:NO];
    [_locationManager requestAlwaysAuthorization];
    [_locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.mapView.showsCompass = YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //  Get the new view controller using [segue destinationViewController].
    //  Pass the selected object to the new view controller.
    
    
    if (constantTaxiModel==nil) {
        NSArray * arr = defaults_object(@"constantResponse");
        constantTaxiModel =[[ConstantModel alloc]initItemWithDict:arr];
    }

    if ([segue.identifier isEqualToString:@"FareAmountViewController"]) {
        
        FareAmmountViewController *fareView =(FareAmmountViewController *)[segue destinationViewController];
        fareView.curr_trip = currTrip;
        fareView.constantModel =constantTaxiModel;
        
    }else if([segue.identifier isEqualToString:@"RequestViewController"])
    {
        RequestViewController * vc=(RequestViewController *) segue.destinationViewController;
        vc.arrDrivers=driversArray;
        vc.directionSource=direction;
        if(arrayCagetgory.count>0)
        {
            for (CategoryModel * category in arrayCagetgory) {
                if(category.categoryId==selectedButton.tag)
                {
                    vc.carCategory=category;
                    
                }
            }
        }
        vc.searchText=self.txtDestinationAddres.text;
        vc.tripDistance=tripDistance;
        vc.tripTime = tripTime;
        vc.delegate=self;
        vc.constantModel =constantTaxiModel;
    }
    else if([segue.identifier isEqualToString:@"BeginTripViewController"])
    {
        BeginTripViewController *vc=(BeginTripViewController *) segue.destinationViewController;
        
        vc.currentTrip=currTrip;
        vc.constantModel = constantTaxiModel;
    }
}

#pragma mark - RequestViewController Delegate

-(void)onTripRequestCompletion:(TripModel *)tripModel
{
    if([tripModel.trip_Status isEqualToString:TS_ACCEPTED])
    {
        currTrip=tripModel;
        defaults_set_object(TRIP_ID, tripModel.trip_Id);
        //        [self.viewDriverSearch setHidden:YES];
        //        [self.viewCategory setHidden:YES];
        //        [self.viewHeaderTripAccept setHidden:NO];
        //        [self.viewHeader  setHidden:YES];
    }
    else
    {
        //        [self.viewHeader  setHidden:NO];
        //        [self.viewHeaderTripAccept setHidden:YES];
        //        [self.viewCategory setHidden:NO];
        //        [self.viewDriverSearch setHidden:NO];
    }
}


#pragma mark - Check trip Status Trip status

-(void) checkTripStatus
{
    if(currTrip)
    {
        
        [currTrip refreshTripModelWithCompletionBlock:^(id results, NSError *error) {
            
            if([currTrip.trip_Status isEqualToString:TS_ACCEPTED]||[currTrip.trip_Status isEqualToString:TS_ARRIVE]||[currTrip.trip_Status isEqualToString:TS_BEGIN]||[currTrip.trip_Status isEqualToString:TS_PICKED])
            {
                [self performSegueWithIdentifier:@"BeginTripViewController" sender:nil];
                //                 [self performSegueWithIdentifier:@"FareAmountViewController" sender:nil];
            }
            else if([currTrip.trip_Status isEqualToString:TS_END])
            {
                if(![currTrip.trip_pay_status isEqualToString:PAID])
                {
                    [self performSegueWithIdentifier:@"FareAmountViewController" sender:nil];
                }else
                {
                    defaults_remove(TRIP_ID);
                    defaults_remove(@"trip_status");
                }
                return ;
            }
            else{
            }
            
        } isShowLoader:NO];
    }else{
        // if trip id  is aved then   getTrip data
        NSString *savedTripId=defaults_object(TRIP_ID);
        if(savedTripId!=nil&&![savedTripId isEqualToString:@"0"])
        {
            currTrip=[[TripModel alloc]  init];
            currTrip.trip_Id=defaults_object(TRIP_ID);
            [self checkTripStatus];
        }
    }
}


-(void) onOkButtonTapOnAlert
{
    if([currTrip.trip_Status isEqualToString:TS_ACCEPTED])
    {
        [self.mapView removeOverlays:self.mapView.overlays];
        AppDelegate * appDelegate=APP_DELEGATE;
        CLLocation * userLoc=[[CLLocation alloc]  initWithCoordinate:appDelegate.currLoc altitude:0 horizontalAccuracy:5 verticalAccuracy:5 timestamp:[NSDate date]];
        CLLocation * driverLoc=[[CLLocation alloc]  initWithLatitude:currTrip.driver.lat longitude:currTrip.driver.lng];
        
        GoogleDirectionSource * userDriverLocationRoute=[[GoogleDirectionSource alloc]  initWithSource:userLoc destination:driverLoc];
        [userDriverLocationRoute  findDirection_isInTrip:YES WithCompletionBlock:^(id results, NSError *error) {
            if([results isKindOfClass:[DirectionModel class]])
            {
                DirectionModel * dModel=(DirectionModel *)results;
                [_mapView addOverlay:[ dModel getPolyline] level:MKOverlayLevelAboveRoads];
                [dModel zoomToPolyLine:self.mapView polyline:[dModel getPolyline] animated:YES];
            }
        }];
    }
    else if([currTrip.trip_Status isEqualToString:TS_BEGIN])
    {
        [self.mapView removeOverlays:self.mapView.overlays];
        CLLocation * userLoc=[[CLLocation alloc]   initWithLatitude:[currTrip.trip_pick_lat doubleValue] longitude:[currTrip.trip_pick_long doubleValue]];
        CLLocation * driverLoc=[[CLLocation alloc]  initWithLatitude:[currTrip.trip_drop_lat doubleValue] longitude:[currTrip.trip_drop_long doubleValue]];
        GoogleDirectionSource * userDriverLocationRoute=[[GoogleDirectionSource alloc]  initWithSource:userLoc destination:driverLoc];
        [userDriverLocationRoute  findDirection_isInTrip:YES WithCompletionBlock:^(id results, NSError *error) {
            if([results isKindOfClass:[DirectionModel class]])
            {
                DirectionModel * dModel=(DirectionModel *)results;
                [_mapView addOverlay:[ dModel getPolyline] level:MKOverlayLevelAboveRoads];
                [dModel zoomToPolyLine:self.mapView polyline:[dModel getPolyline] animated:YES];
            }
        }];
    }
}




#pragma mark -suggested location method
-(void) onAddressStartEditing
{
    [self.btSearch setSelected:YES];
}

-(void)onSelectLocation:(NSDictionary *)dictLocation
{
    [self.view endEditing:YES];
    [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"Loading Route...",@"")];
    NSString  *stringDestinationAddress=[dictLocation  objectForKey:@"description"];
    
    NSArray *arrTerms = [dictLocation  objectForKey:@"terms"];
    NSString * country = [[arrTerms objectAtIndex:arrTerms.count-1]objectForKey:@"value"];
    NSLog(@"Location : %@",stringDestinationAddress);
    
    [self getLocationFromAddressString:stringDestinationAddress withcompletionHandler:^(CLLocationCoordinate2D loc) {
        
        CLLocation * destination=[[CLLocation alloc]  initWithCoordinate:loc altitude:0 horizontalAccuracy:5 verticalAccuracy:5 timestamp:[NSDate date]];
        
        direction.destination=destination;
        direction.dropAddress=stringDestinationAddress;
        direction.dropCountry =country;
        
        if (direction.source !=nil) {
            
            if([direction.pickCountry isEqualToString:direction.dropCountry])
            {
                
                
                [self makeRouteOnMap];
            }
            else
            { // out side country
                [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"Loading Route...",@"")];
                [UtilityClass showWarningAlert:@"" message:NSLocalizedString(@"Unmatch Country",@"")
                             cancelButtonTitle:NSLocalizedString(@"alert_ok",@"") otherButtonTitle:nil];
            }
            
            
        }
        else{
            
            CLLocation * source=[[CLLocation alloc]  initWithCoordinate:centerCoordinate altitude:0 horizontalAccuracy:5 verticalAccuracy:5 timestamp:[NSDate date]];
            direction.source = source;
            
            [[GMSGeocoder geocoder] reverseGeocodeCoordinate:source.coordinate completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
                
                GMSAddress* addressObj = [[response results] firstObject];
                
                if (addressObj.lines) {
                    
                    NSString * result = [addressObj.lines componentsJoinedByString:@","];
                    // NSString *firstLetter = [result substringToIndex:1];
                    if ([result length] > 1 && [result hasPrefix:@","]) {
                        result = [result substringFromIndex:1];
                    }
                    
                    direction.pickAddress = [NSString stringWithString:result];
                    direction.pickCountry = addressObj.country;
                }
                
                if([direction.pickCountry isEqualToString:direction.dropCountry])
                {
                    
                    
                    [self makeRouteOnMap];
                }
                else
                { // out side country
                    [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"Loading Route...",@"")];
                    [UtilityClass showWarningAlert:@"" message:NSLocalizedString(@"Unmatch Country",@"")
                                 cancelButtonTitle:NSLocalizedString(@"alert_ok",@"") otherButtonTitle:nil];
                }
                
                
            }];
        }
        
    }];
}


-(void) getLocationFromAddressString: (NSString*) addressStr withcompletionHandler : (void(^)(CLLocationCoordinate2D loc))completionHandler {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"https://maps.google.com/maps/api/geocode/json?key=%@&sensor=false&address=%@",GOOGLE_API_KEY, esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    completionHandler(center);
    
}



-(NSString *) addressFromPlacemark:(CLPlacemark *)place{
    
    NSMutableString *addressString = [NSMutableString string];
    for (NSString* str in [place.addressDictionary objectForKey:@"FormattedAddressLines"]) {
        if (addressString.length > 0)
            [addressString appendString:@","];
        
        [addressString appendFormat:@"%@",str];
    }
    return addressString;
}


// find dreiction And drow route     A ˚MLØ>
-(void) makeRouteOnMap
{
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:arrAnotation];
    [direction  findDirection_isInTrip:NO WithCompletionBlock:^(id results, NSError *error) {
        if([results  isKindOfClass:[DirectionModel class]])
        {
            [self.imCenterPickupLocation setHidden:YES];
            DirectionModel * dModel=(DirectionModel *)results;
            tripTime=dModel.duration;
            tripDistance=dModel.distance;
            [self addMapAnnotationsWith:direction];
            isMapDraged=YES;
            isMapRouteMake=YES;
            [_mapView addOverlay:[ dModel getPolyline] level:MKOverlayLevelAboveRoads];
            //[dModel zoomToFitMapAnnotations:self.mapView suourceAndDestinationAnnotation:arrAnotation];
            
            [dModel zoomToPolyLine:self.mapView polyline:[dModel getPolyline] animated:YES];
            self.btnFareDetailsBottomConstraints.constant =-72;
            [_btnFareDetails setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            isShowFareView =NO;
            [self setfareDetails:[ dModel distance] isFrom:NO];
        }
        
        [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"Loading Route..." ,@"")];
    }];
}




#pragma  mark -mapview delegates


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    AppDelegate *appdelegate= APP_DELEGATE;
    
    appdelegate.currLoc = userLocation.coordinate;
    
    NSDictionary * dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",appdelegate.currLoc.latitude],@"lat",[NSString stringWithFormat:@"%f",appdelegate.currLoc.longitude ],@"lng", nil];
    defaults_set_object(@"curr_loc", dict);
    
    //    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    //    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *loc = locations.lastObject;
     AppDelegate *appdelegate= APP_DELEGATE;
    appdelegate.currLoc = loc.coordinate;
    
    NSDictionary * dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",appdelegate.currLoc.latitude],@"lat",[NSString stringWithFormat:@"%f",appdelegate.currLoc.longitude ],@"lng", nil];
    defaults_set_object(@"curr_loc", dict);

}



-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.userInfo);
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"permission_denied", @"")
                                                                                     message:NSLocalizedString(@"location_turn_on", @"")
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            //We add buttons to the alert controller by creating UIAlertActions:
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil]; //You can use a block here to handle a press on this button
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];        }
    }
}


- (void)addMapAnnotationsWith:(GoogleDirectionSource * )directionSource {
    
    [self.mapView removeAnnotation:userPin];
    [self.mapView removeAnnotations:arrAnotation];
    [arrAnotation  removeAllObjects];
    //    MKPointAnnotation *pickUp = [[MKPointAnnotation alloc] init];
    CustomPointAnnotation * pickUp=[[CustomPointAnnotation alloc]  initWithType:@"pick"];
    pickUp.coordinate = directionSource.source.coordinate;
    [self.mapView addAnnotation:pickUp];
    //    MKPointAnnotation *dropAno = [[MKPointAnnotation alloc] init];
    CustomPointAnnotation * dropAno=[[CustomPointAnnotation alloc]  initWithType:@"drop"];
    dropAno.coordinate = directionSource.destination.coordinate;
    [self.mapView addAnnotation:dropAno];
    
    [arrAnotation addObject:pickUp];
    [arrAnotation addObject:dropAno];
}

-(void)zoomToFitMapAnnotations:(NSMutableArray *) arrayAnotations
{
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for (id <MKAnnotation> annotation in arrayAnotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    angle = (double)newHeading.magneticHeading;
}




-(void)getLocation:(CLLocation *)locations withcompletionHandler : (void(^)(NSArray *arr))completionHandler{
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:locations completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks,
                                                                   NSError * _Nullable error) {
        completionHandler(placemarks);
    }];
    
}



-(void)showAllDrivers:(NSArray *)arrDrivers
{
    if (arrDrivers.count==0) {
        [self.mapView  removeAnnotations:arrayDriversAnnotation];
        return;
    }
    //    [self setUserAnnotation];
    [self.mapView removeAnnotations:arrayDriversAnnotation];
    [arrayDriversAnnotation removeAllObjects];
    for(int i = 0; i < arrDrivers.count; i++)
    {
        DriverModel * driver=[arrDrivers  objectAtIndex:i];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(driver.lat, driver.lng);
        MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
        mapPin.coordinate = coordinate;
        [self.mapView addAnnotation:mapPin];
        [arrayDriversAnnotation addObject:mapPin];
    }
    if(!isMapDraged)
    {
        //[self zoomToFitMapAnnotations:arrayDriversAnnotation ];   // test
    }
}

-(void)setUserAnnotation{
    AppDelegate *appdelegate =APP_DELEGATE;
    if(appdelegate.currLoc.latitude !=0)
    {
        if(userPin)
        {
            [self.mapView removeAnnotation:userPin];
        }
        userPin = [[MKPointAnnotation alloc] init];
        
        userPin.coordinate = appdelegate.currLoc;
        // driverPin=YES;
        //        [self.mapView addAnnotation:userPin];
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(appdelegate.currLoc, 800, 800);
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
        
    }
    
    
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
    //NSLog(@"Changed Location %f  %f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
    if(!isMapRouteMake && isHome)
    {
        centerCoordinate=mapView.centerCoordinate;
       // CLLocation * location=[[CLLocation alloc]  initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
        //[nearByDriverHandler changePickUpLocation:location];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    
    MKAnnotationView *pinView = nil;
    
    if(annotation != self.mapView.userLocation)
    {
        
        static NSString *defaultPinID = @"com.user.pin";
        pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        if([annotation isKindOfClass:[CustomPointAnnotation class]])
        { CustomPointAnnotation  *mAnno=(CustomPointAnnotation *) annotation;
            if([mAnno.type isEqualToString:@"pick"])
            {
                pinView.image = [UIImage imageNamed:@"PIN"];
            }else{
                pinView.image = [UIImage imageNamed:@"pin-red"];
            }
            
        }
        else if (annotation == userPin) {
            pinView.image = [UIImage imageNamed:@"PIN"];
            //driverPin=NO;
        }
        else{
            
            pinView.image = [UIImage imageNamed:@"car3"];    //as suggested by Squatch
            
        }
    }
    else {
        [self.mapView.userLocation setTitle:@"I am here"];
        
        //        [self.mapView.userLocation setTitle:@"I am here"];
    }
    return pinView;
}

#pragma api calls

-(void)getNewOrderRequest:(NSNotification *) notification{
    AppDelegate *appdelegate = APP_DELEGATE;
    defaults_set_object(TRIP_ID, appdelegate.trip_id);
    if(currTrip==nil)
    {
        currTrip=[[TripModel alloc]  init];
        currTrip.trip_Id=appdelegate.trip_id;
    }
    [self checkTripStatus];
}


#pragma mark - Near By Drivers

-(void)onStartRefreshing
{
    [self.activtiyIndicator setHidden:NO];
    [self.activtiyIndicator startAnimating];
    [self.viewTimeDistance setHidden:YES];
}
-(void)onRefreshNearByDriver:(NSMutableArray *)arrayDrivers
{
    driversArray =[[NSMutableArray alloc]init];
    
    [self.activtiyIndicator stopAnimating];
    [self.activtiyIndicator setHidden:YES];
    [self.viewTimeDistance setHidden:NO];
    
    if(arrayDrivers.count==0)
    {
        [self.lbDriversAvailableMessage setText:NSLocalizedString(@"No Cars Available", @"")];
        [_lbTime setText:@""];
        
    }
    else{
        int arrvingTime=0;
        // find nearest driver time
        for (DriverModel *dModel in arrayDrivers) {
            int arrvingTimeTemp=(int)(dModel.distance*60/40.0);
            if(arrvingTimeTemp>=arrvingTime)
            {
                arrvingTime=arrvingTimeTemp;
            }
            
        }
        if(arrvingTime<=1)
        {
            arrvingTime=1;
        }
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        
        NSString *time=[NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", arrvingTime]]]];
        [_lbTime setText:[NSString stringWithFormat:@"%@\n%@",time,NSLocalizedString(@"min", @"")]];
        [self.lbDriversAvailableMessage setText:NSLocalizedString(@"Cars Available", @"")];
    }
    
    driversArray=arrayDrivers;
    [self showAllDrivers:driversArray];
}



- (IBAction)ButtonFareDetails:(id)sender {
    if (!isShowFareView) {
        isShowFareView =YES;
        //self.fareviewBottomConstraints.constant = 0;
        
        
        
        [UIView animateWithDuration:15.0f delay:8.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            //self.fareviewBottomConstraints.constant = -125;
        } completion:^(BOOL finished)
         {
            // self.fareviewBottomConstraints.constant = 0;
             self.viewFareDetails.hidden =NO;
             _lblShowEstimate.hidden =YES;
             self.btnFareDetailsBottomConstraints.constant =10;
             [self.btnFareDetails setImage:[UIImage imageNamed:@"show-icon"] forState:UIControlStateNormal];
         }];
    }
    else{
        isShowFareView =NO;
        
        
        
        [UIView animateWithDuration:15.0f delay:8.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            //self.fareviewBottomConstraints.constant = 0;
        } completion:^(BOOL finished)
         {
             [self.btnFareDetails setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
             //self.fareviewBottomConstraints.constant = -125;
              self.viewFareDetails.hidden =YES;
             _lblShowEstimate.hidden =NO;
             self.btnFareDetailsBottomConstraints.constant =-72;
         }];
    }
    
}


- (IBAction)onCatgoryButtonTap:(UIButton *)sender {
    [selectedButton setImage:nil forState:UIControlStateNormal];
    selectedButton=sender;
    
    NSString *imageName;
    switch (sender.tag) {
        case 1:
            [self.dragButton setFrame:CGRectMake(10, 30, 60, 60)];
            imageName = @"Hatchback_r";
            break;
        case 2:
            [self.dragButton setFrame:CGRectMake(SCREEN_WIDTH/2-30, 30, 60, 60)];
            imageName = @"sedan_r";
            break;
        default: imageName = @"suv_r";
            [self.dragButton setFrame:CGRectMake(SCREEN_WIDTH-70, 30, 60, 60)];
            break;
    }
    [self.dragButton setImage:[UIImage imageNamed:imageName
                      ] forState:UIControlStateNormal];
    NSLog(@"%ld",(long)sender.tag);
    [nearByDriverHandler changeCategoryId:(int)sender.tag];
    
    if (isMapRouteMake) {

        //_lblShowEstimate.hidden =YES;
        
        [self setfareDetails:tripDistance isFrom:YES];
    }
}
#pragma mark - DragUIButton methods

-(void) button:(DragUIButton *) button index:(int) index
{
    [nearByDriverHandler changeCategoryId:index+1];
}


#pragma mark - MKMapViewDelegate methods

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor colorWithRed:0.0/255.0 green:171.0/255.0 blue:253.0/255.0 alpha:1.0];
    renderer.lineWidth = 2.0;
    return  renderer;
}


#pragma handle driver states

- (IBAction)onTripEndButtonTap:(id)sender {
    [self performSegueWithIdentifier:@"FareAmountViewController" sender:nil];
}

- (IBAction)onRequestButtonTap:(id)sender {
    
    
    
    if(self.txtDestinationAddres.text.length==0 || direction.dropAddress.length==0)
    {
        //        [self performSegueWithIdentifier:@"BeginTripViewController" sender:nil];
        [UtilityClass showWarningAlert:@"" message:NSLocalizedString(@"Please Enter Destination address", @"") cancelButtonTitle:NSLocalizedString(@"alert_ok", @"") otherButtonTitle:nil];
        return;
    }
    if(driversArray.count==0)
    {
        [UtilityClass showWarningAlert:@"" message:NSLocalizedString(@"No Driver Found", @"") cancelButtonTitle:NSLocalizedString(@"alert_ok", @"")  otherButtonTitle:nil];
    }
    else{
        [self performSegueWithIdentifier:@"RequestViewController" sender:nil];
    }
}
- (IBAction)ButtonMenuPressed:(id)sender {
    [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
}

- (IBAction)onShowMyLocationTap:(id)sender {
    isMapDraged=NO;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([APP_DELEGATE currLoc], 800, 800);//600,600
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    if(!isMapRouteMake && isHome)
    {
        
       NSTimer *tripCheckTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self
                                                        selector: @selector(callNearbyDriverOnMyLocationTap) userInfo: nil repeats: NO];
        
    }
    
}

-(void)callNearbyDriverOnMyLocationTap{

    CLLocation * userLoc=[[CLLocation alloc]  initWithCoordinate:centerCoordinate altitude:0 horizontalAccuracy:5 verticalAccuracy:5 timestamp:[NSDate date]];
    [nearByDriverHandler changePickUpLocation:userLoc];
}

- (IBAction)onSearchButtonTap:(UIButton *)sender {
    if(sender.selected)
    {
        [self reset:sender];
    }
}

-(void)reset:(id)sender{
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:arrAnotation];
    [self.txtDestinationAddres setText:@""];
    [self.btSearch setSelected:NO];
    [self onShowMyLocationTap:sender];
    self.viewFareDetails.hidden =YES;
    self.btnFareDetails.hidden=YES;
    _lblShowEstimate.hidden=YES;
    isMapRouteMake=NO;
    
//    self.viewFareDetails.hidden =YES;
//    self.btnFareDetails.hidden=YES;
//    _lblShowEstimate.hidden=YES;
    //self.btnFareDetailsBottomConstraints.constant =-72;
    isShowFareView =NO;
    [self.view endEditing:YES];
    
    [self.imCenterPickupLocation setHidden:NO];
}

-(void) onAddressEndEditing{
    
}


#pragma API CALLS

-(void)getCategoryFormServer
{
    [APP_CallAPI gcURL:BASE_URL app:API_GET_CATEGORY
                        data:nil
                isShowErrorAlert:NO
                completionBlock:^(id results, NSError *error) {
                    apiCallAttempt++;
                    if([[results objectForKey:P_RESPONSE]isKindOfClass:[NSArray class]])
                    {
                        defaults_set_object(@"categoryResponse", [results objectForKey:P_RESPONSE]);
                        arrayCagetgory=[CategoryModel parseResponse:[results objectForKey:P_RESPONSE]];
                        [self setCategoriesName];
                        
                    }
                    else{
                    
                        if(apiCallAttempt<3){
                            [self getCategoryFormServer];
                        }
                    }
                }];
    
}

-(void)setCategoriesName{
    
    for (CategoryModel *cat in arrayCagetgory) {
        if (cat.categoryId == 1) {
            self.lblCategoryHatch.text = cat.cat_name;
        }
        else if (cat.categoryId == 2){
            self.lblCategorySedan.text = cat.cat_name;
        }
        else if (cat.categoryId == 3){
            self.lblCategorySUV.text = cat.cat_name;
        }
        
    }
}

-(void)getTaxiConstant
{
    [APP_CallAPI gcURL:BASE_URL app:API_GET_TAXI_CONSTANT
                        data:nil
                        isShowErrorAlert:NO
     
                completionBlock:^(id results, NSError *error) {
                    if([[results objectForKey:P_STATUS] isEqualToString:@"OK"])
                    {
                        defaults_set_object(@"constantResponse", [results objectForKey:P_RESPONSE]);
                        constantTaxiModel = [[ConstantModel alloc]initItemWithDict:[results objectForKey:P_RESPONSE]];
                        
                    }
                }];
    
}


-(void)setfareDetails:(float)distance isFrom:(BOOL)fromCat{
    
    
    NSString *dis;
    NSString *tripDis;
    float distance1=0.0;
    if ([[constantTaxiModel.constant_distance capitalizedString] isEqualToString:@"Km"]) {
        dis =@"km";
        tripDis =[NSString stringWithFormat:@"%.2f",distance];
        distance1 =distance;
    }
    else{
        
        dis =@"mi";
        float miles = distance*0.621371192;
        tripDis = [NSString stringWithFormat:@"%.2f",miles];
        distance1 = distance*0.621371192;
        
    }
    
    
//    self.viewFareDetails.hidden =NO;
    self.btnFareDetails.hidden =NO;
    
    _lblShowEstimate.hidden=NO;
    if (fromCat &&!_viewFareDetails.hidden) {
         _lblShowEstimate.hidden=YES;
    }
    
    
    //[self.btnFareDetails setImage:[UIImage imageNamed:@"hide-icon"] forState:UIControlStateNormal];
    
    CategoryModel *catModel;
    
    if (selectedButton.tag ==1) {
        
        catModel =[arrayCagetgory objectAtIndex:2];
    }
    else if (selectedButton.tag ==2){
        
        catModel =[arrayCagetgory objectAtIndex:1];
    }
    else{
    
        catModel =[arrayCagetgory objectAtIndex:0];
    }
    
  
    _lblPerKM.text =[NSString stringWithFormat:@"%@%.2f per %@",constantTaxiModel.constant_currency,catModel.cat_fare_per_km,dis];
    _lblMaxSize.text =[NSString stringWithFormat:@"%@",catModel.cat_max_size];
    _lblPerMin.text =[NSString stringWithFormat:@"%@%.2f per min",constantTaxiModel.constant_currency,catModel.cat_fare_per_min];
    _lblDistance.text =[NSString stringWithFormat:@"%@ %@",tripDis,dis];
    _lblEstimate.text=[NSString stringWithFormat:@"%@%.2f",constantTaxiModel.constant_currency,[catModel  calculatePrice:distance1  time:tripTime]];
    _lblExpectedTime.text =  [NSString stringWithFormat:@"%d min",(int)tripTime];
    
}





@end
