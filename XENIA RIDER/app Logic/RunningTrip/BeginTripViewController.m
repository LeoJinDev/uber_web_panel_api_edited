//
//  BeginTripViewController.m
//  XENIA RIDER
//
//  Created by SFYT on 15/06/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "BeginTripViewController.h"
#import "AppDelegate.h"
// 
////#import "nsuserdefaults-helper.h"
#import "GoogleDirectionSource.h"
#import "WebCallConstants.h"
#import "FareAmmountViewController.h"
#import <GrepixKit/GrepixKit.h>
#import "UIViewController+LGSideMenuController.h"
#import "DriverView.h"
#import "CustomPointAnnotation.h"
#import "UIImageView+WebCache.h"
@interface BeginTripViewController ()

@end

@implementation BeginTripViewController
{
    MKPointAnnotation *userPin;
    NSTimer *tripCheckTimer;
    NSString * currentTripStatus;
    NSArray * arrayAnotations;
    MKPointAnnotation *driverAnnotaion;
    BOOL isViewWillAppearCalled, isNotificationCame;
    DriverView *driverView;
    NSString *statusPre;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isNotificationCame=NO;
    [self setThemeConstants];
    [self.viewTime.layer setCornerRadius:23];
    [self.viewTime.layer setBorderWidth:1];
    [self.viewTime.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.viewTime setClipsToBounds:YES];
    [self initMapView];
    currentTripStatus=defaults_object(@"trip_status");
    if(self.currentTrip== nil)
    {
        [self initDummyTrip];
    }
    else{
        [self setUpUi];
        [self checkTripStatus];
    }
    // Do any additional setup after loading the view.
    
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isViewWillAppearCalled=NO;
}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    isViewWillAppearCalled=YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setThemeConstants{
    _viewHeader.backgroundColor =CONSTANT_THEME_COLOR1;
    [_lblDetinationTitle setFont:FONTS_THEME_REGULAR(13)];
    [_lbTime setFont:FONTS_THEME_REGULAR(10)];
    [_lbDestination setFont:FONTS_THEME_REGULAR(13)];
}
-(void) initDummyTrip
{
    self.currentTrip=[[TripModel alloc]  init];
    self.currentTrip.trip_Id=@"128";
    [self.currentTrip refreshTripModelWithCompletionBlock:^(id results, NSError *error) {
        [self setUpUi];
        [self checkTripStatus];
    } isShowLoader:YES];
}

-(void)initMapView
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationReceived:) name:@"NotificationReceived" object:nil];
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
    [self.mapView setRegion:region animated:TRUE];
    [self.mapView regionThatFits:region];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
     _locationManager.distanceFilter = 10.0;
    [_locationManager setPausesLocationUpdatesAutomatically:NO];
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.mapView.showsCompass = YES;
    [self setUserAnnotation];
}
-(void )onNotificationReceived:(NSNotification *) notification
{
    //     NSDictionary *dict = notification.userInfo;
    BOOL isCancelHandled=NO;
    AppDelegate * delegate=APP_DELEGATE;
    self.currentTrip.trip_Status=delegate.trip_status;
    currentTripStatus=delegate.trip_status;
    defaults_set_object(@"trip_status",self.currentTrip.trip_Status);
    NSString * message=[NSString stringWithFormat:@"Your Trip is %@",self.currentTrip.trip_Status];
    if([self.currentTrip.trip_Status isEqualToString:TS_ARRIVE])
    {
        message= NSLocalizedString(@"MESSAGE_ARRIVE", @"");
        statusPre =TS_ARRIVE;
    }
    else if([self.currentTrip.trip_Status isEqualToString:TS_BEGIN])
    {
        message=NSLocalizedString(@"MESSAGE_BEGIN", @"");
        statusPre =TS_BEGIN;
    }
    else if([self.currentTrip.trip_Status isEqualToString:TS_END])
    {
        message=NSLocalizedString(@"MESSAGE_END", @"");
       // statusPre =TS_END;
    }else if([self.currentTrip.trip_Status isEqualToString:TS_DRIVER_CANCEL_AT_PICKUP]){
        [self handelTripCancelCondition:TS_DRIVER_CANCEL_AT_PICKUP];
        isCancelHandled=YES;
    }
    else if([self.currentTrip.trip_Status isEqualToString:TS_DRIVER_CANCEL_AT_DROP]){
        [self handelTripCancelCondition:TS_DRIVER_CANCEL_AT_DROP];
        isCancelHandled=YES;
    }
    else if([self.currentTrip.trip_Status isEqualToString:TS_ACCEPTED]){
        message=NSLocalizedString(@"MESSAGE_ACCEPTED", @"");
        statusPre =TS_ACCEPTED;
    }
    if(!isCancelHandled)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"trip_status", @"")
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [self onOkButtonTapOnAlert];
                                                         }]; //You can use a block here to handle a press on this button
        
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"FareAmountViewController"]) {
        FareAmmountViewController *fareView =(FareAmmountViewController *)[segue destinationViewController];
        fareView.curr_trip =self.currentTrip;
        fareView.constantModel =self.constantModel;
    }
}


-(void) checkTripStatus
{
    if(self.currentTrip)
    {
        [self.currentTrip refreshTripModelWithCompletionBlock:^(id results, NSError *error) {
            
            
            if(isViewWillAppearCalled)
            {
                return ;
            }
            BOOL isCancelHandled=NO;
            
            if ([self.currentTrip.trip_Status isEqualToString:TS_BEGIN]||[self.currentTrip.trip_Status isEqualToString:TS_END]) {
                [self removeDriverView];
            }
            
            
            if([self.currentTrip.trip_Status isEqualToString:TS_ACCEPTED]||[self.currentTrip.trip_Status isEqualToString:TS_ARRIVE]||[self.currentTrip.trip_Status isEqualToString:TS_BEGIN]||[self.currentTrip.trip_Status isEqualToString:TS_PICKED])
            {
                
                
                if(driverAnnotaion)
                {
                    [self.mapView removeAnnotation:driverAnnotaion];
                }
                driverAnnotaion = [[MKPointAnnotation alloc] init];
                CLLocation * driverLoc=[[CLLocation alloc]  initWithLatitude:self.currentTrip.driver.lat longitude:self.currentTrip.driver.lng];
                driverAnnotaion.coordinate =driverLoc.coordinate;
                
                [self.mapView addAnnotation:driverAnnotaion];
                
                // trip accept
                tripCheckTimer = [NSTimer scheduledTimerWithTimeInterval: 5.0 target: self
                                                                selector: @selector(checkTripStatus) userInfo: nil repeats: NO];
                
            }
            else if([self.currentTrip.trip_Status isEqualToString:TS_END])
            {
                [tripCheckTimer invalidate];
                tripCheckTimer=nil;
                if (!isNotificationCame) {
                    isNotificationCame = YES;
                    [self performSegueWithIdentifier:@"FareAmountViewController" sender:nil];
                }
               // statusPre = TS_END;
                //[self performSegueWithIdentifier:@"FareAmountViewController" sender:nil];
                return ;
            }
            else if([self.currentTrip.trip_Status isEqualToString:TS_DRIVER_CANCEL_AT_PICKUP]){
                [self handelTripCancelCondition:TS_DRIVER_CANCEL_AT_PICKUP];
                isCancelHandled=YES;
            }
            
            else if([self.currentTrip.trip_Status isEqualToString:TS_DRIVER_CANCEL_AT_DROP]){
                [self handelTripCancelCondition:TS_DRIVER_CANCEL_AT_DROP];
                isCancelHandled=YES;
            }
            
            else{
                NSString *savedTripId=defaults_object(TRIP_ID);
                if(savedTripId!=nil)
                {
                    defaults_remove(TRIP_ID);
                }
            }
            if(!isCancelHandled)
            {
                // when chnage the status of trip than show alert
                if(![currentTripStatus isEqualToString:self.currentTrip.trip_Status])
                {
                    NSString * message=[NSString stringWithFormat:@"Your Trip is %@",self.currentTrip.trip_Status];
                    if([self.currentTrip.trip_Status isEqualToString:TS_ARRIVE])
                    {
                        message=NSLocalizedString(@"MESSAGE_ARRIVE", @"");;
                        statusPre =TS_ARRIVE;
                    }
                    else if([self.currentTrip.trip_Status isEqualToString:TS_BEGIN])
                    {
                        message=NSLocalizedString(@"MESSAGE_BEGIN", @"");;
                        statusPre =TS_BEGIN;
                    } else if([self.currentTrip.trip_Status isEqualToString:TS_END])
                    {
                        message=NSLocalizedString(@"MESSAGE_END", @"");;
                        //statusPre =TS_END;
                    }
                    else if([self.currentTrip.trip_Status isEqualToString:TS_ACCEPTED]){
                        message=NSLocalizedString(@"MESSAGE_ACCEPTED", @"");
                        statusPre =TS_ACCEPTED;
                    }
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"trip_status", @"")
                                                                                             message:message
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                    //We add buttons to the alert controller by creating UIAlertActions:
                    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                                         [self onOkButtonTapOnAlert];
                                                                     }]; //You can use a block here to handle a press on this button
                    
                    [alertController addAction:actionOk];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                }
                currentTripStatus=self.currentTrip.trip_Status;
                AppDelegate * appDelegate=APP_DELEGATE;
                appDelegate.trip_status=self.currentTrip.trip_Status;
                defaults_set_object(@"trip_status", self.currentTrip.trip_Status);
            }
        } isShowLoader:NO];
    }else{
        // if trip id  is aved then   getTrip data
        NSString *savedTripId=defaults_object(TRIP_ID);
        if(savedTripId!=nil)
        {
            self.currentTrip=[[TripModel alloc]  init];
            self.currentTrip.trip_Id=defaults_object(TRIP_ID);
            [self checkTripStatus];
        }
    }
}


-(void) handelTripCancelCondition:(NSString *)status
{
    
    if(tripCheckTimer)
    {
        [tripCheckTimer invalidate];
        tripCheckTimer=nil;
    }
      AppDelegate * appDelegate=APP_DELEGATE;
    
    currentTripStatus=self.currentTrip.trip_Status;
  
    appDelegate.trip_status=self.currentTrip.trip_Status;
    defaults_set_object(@"trip_status", self.currentTrip.trip_Status);
    [self showAlertWhenDriverCancelRequest:status cancelReason: self.currentTrip.trip_cancel_reason];
}


-(void) showAlertWhenDriverCancelRequest:(NSString *) status cancelReason:(NSString * )cancelReson
{
    NSString *msg;
    
    if ([status isEqualToString:TS_DRIVER_CANCEL_AT_PICKUP]) {
        msg = MESSAGE_DRIVER_CANCEL;
    }
    else{
        msg =MESSAGE_END;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"trip_status", @"")
                                                                             message:[NSString stringWithFormat:@"%@  \n%@",msg ,cancelReson]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         if([status isEqualToString:TS_DRIVER_CANCEL_AT_DROP])
                                                         {
                                                             [self performSegueWithIdentifier:@"FareAmountViewController" sender:nil];
                                                         }
                                                         else{
                                                             defaults_remove(TRIP_ID);
                                                             defaults_remove(@"trip_status");
                                                             [self.navigationController popToRootViewControllerAnimated:YES];
                                                             //[self performSegueWithIdentifier:@"FareAmountViewController" sender:nil];
                                                         }
                                                     }]; //You can use a block here to handle a press on this button
    
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void) onOkButtonTapOnAlert
{
    
    if([self.currentTrip.trip_Status isEqualToString:TS_BEGIN])
    {
        [self removeDriverView];
        [self.mapView removeOverlays:self.mapView.overlays];
        
        CLLocation * userLoc=[[CLLocation alloc]   initWithLatitude:[self.currentTrip.trip_pick_lat doubleValue] longitude:[self.currentTrip.trip_pick_long doubleValue]];
        
        CLLocation * driverLoc=[[CLLocation alloc]  initWithLatitude:[self.currentTrip.trip_drop_lat doubleValue] longitude:[self.currentTrip.trip_drop_long doubleValue]];
        GoogleDirectionSource * userDriverLocationRoute=[[GoogleDirectionSource alloc]  initWithSource:userLoc destination:driverLoc];
        [userDriverLocationRoute  findDirection_isInTrip:NO WithCompletionBlock:^(id results, NSError *error) {
            if([results isKindOfClass:[DirectionModel class]])
            {
                [_lbDestination  setText:isEmpty(_currentTrip.trip_drop_loc)];
                [self addMapAnnotationsWith:userDriverLocationRoute];
                DirectionModel * dModel=(DirectionModel *)results;
                [self.lbTime setText:[NSString stringWithFormat:@"%d\nmin",(int)dModel.duration]];
                [_mapView addOverlay:[ dModel getPolyline] level:MKOverlayLevelAboveRoads];
                //                [dModel zoomToFitMapAnnotations:self.mapView suourceAndDestinationAnnotation:[[NSMutableArray alloc]  initWithArray:arrayAnotations] multiplier:1.1];
            }
        }];
    }
    else if([self.currentTrip.trip_Status isEqualToString:TS_END])
    {
        if (!isNotificationCame) {
            isNotificationCame = YES;
            [self performSegueWithIdentifier:@"FareAmountViewController" sender:nil];
        }
        //[self performSegueWithIdentifier:@"FareAmountViewController" sender:nil];
    }
    
}




-(void) setUpUi{
    
    [self.lbDestination setText:self.currentTrip.trip_pick_loc];
    if([self.currentTrip.trip_Status isEqualToString:TS_ACCEPTED]||[self.currentTrip.trip_Status isEqualToString:TS_ARRIVE])
    {
        
        [self.mapView removeOverlays:self.mapView.overlays];
        // user consider like destination
        CLLocation * userLoc=[[CLLocation alloc]   initWithLatitude:[self.currentTrip.trip_pick_lat doubleValue] longitude:[self.currentTrip.trip_pick_long doubleValue]];
        //        CLLocation * userLoc=[[CLLocation alloc]  initWithCoordinate:appDelegate.currLoc altitude:0 horizontalAccuracy:5 verticalAccuracy:5 timestamp:[NSDate date]];
        // user consider like source
        CLLocation * driverLoc=[[CLLocation alloc]  initWithLatitude:self.currentTrip.driver.lat longitude:self.currentTrip.driver.lng];
        
        [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"Loading Route...",@"")];
        GoogleDirectionSource * userDriverLocationRoute=[[GoogleDirectionSource alloc]  initWithSource:driverLoc destination:userLoc];
        [userDriverLocationRoute  findDirection_isInTrip:YES WithCompletionBlock:^(id results, NSError *error) {
            [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"Loading Route...",@"")];
            if([results isKindOfClass:[DirectionModel class]])
            {
                DirectionModel * dModel=(DirectionModel *)results;
                [self setTripTime:dModel.duration];
                [self addMapAnnotationsWith:userDriverLocationRoute];
                [_mapView addOverlay:[ dModel getPolyline] level:MKOverlayLevelAboveRoads];
                //                [dModel zoomToFitMapAnnotations:self.mapView suourceAndDestinationAnnotation:[[NSMutableArray alloc]  initWithArray:arrayAnotations] multiplier:1.1];
            }
        }];
        
        //Driver View
        [self setDriverView];
        
        
    }else  if([self.currentTrip.trip_Status isEqualToString:TS_BEGIN]){
        [self.mapView removeOverlays:self.mapView.overlays];
        CLLocation * userLoc=[[CLLocation alloc]   initWithLatitude:[self.currentTrip.trip_pick_lat doubleValue] longitude:[self.currentTrip.trip_pick_long doubleValue]];
        CLLocation * driverLoc=[[CLLocation alloc]  initWithLatitude:[self.currentTrip.trip_drop_lat doubleValue] longitude:[self.currentTrip.trip_drop_long doubleValue]];
        GoogleDirectionSource * userDriverLocationRoute=[[GoogleDirectionSource alloc]  initWithSource:userLoc destination:driverLoc];
        [userDriverLocationRoute  findDirection_isInTrip:YES WithCompletionBlock:^(id results, NSError *error) {
            if([results isKindOfClass:[DirectionModel class]])
            {
                [self addMapAnnotationsWith:userDriverLocationRoute];
                [_lbDestination  setText:isEmpty(_currentTrip.trip_drop_loc)];
                DirectionModel * dModel=(DirectionModel *)results;
                [self setTripTime:dModel.duration];
                [_mapView addOverlay:[ dModel getPolyline] level:MKOverlayLevelAboveRoads];
                //                [dModel zoomToFitMapAnnotations:self.mapView suourceAndDestinationAnnotation:[[NSMutableArray alloc]  initWithArray:arrayAnotations] multiplier:1.1];
                
               
            }
        }];
        
         [self removeDriverView];
    }
}


-(void)setDriverView{
    driverView = [[DriverView alloc] initFromNib];
    [driverView.btCall addTarget:self action:@selector(makeCall) forControlEvents:UIControlEventTouchDown];
    driverView.frame = CGRectMake(8, 85, SCREEN_WIDTH - 16, 94);
    driverView.lblDriverName.text = [NSString stringWithFormat:@"%@ %@",self.currentTrip.driver.d_fname,self.currentTrip.driver.d_lname];
    driverView.lbCarName.text = self.currentTrip.driver.carname;
    driverView.lbCarNumber.text = self.currentTrip.driver.car_registration_no;
    
    NSString *profile=self.currentTrip.driver.d_profile_image_path;
    if (profile.length>0) {
        [driverView.imgDriver sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url_base_images, profile]] placeholderImage:[UIImage imageNamed:@"Profile Icon Crop Image"]];
        
        //[driverView.imgDriver setImage:[UIImage imageNamed:@"Profile Icon Crop Image"]];
    }
    driverView.imgDriver.layer.cornerRadius =25;
    driverView.imgDriver.clipsToBounds=YES;
    float rating = self.currentTrip.driver.rating;

    StarRatingView *rateView = [[StarRatingView alloc]initWithFrame:CGRectMake((driverView.viewStarRating.bounds.origin.x) , driverView.viewStarRating.bounds.origin.y, driverView.viewStarRating.bounds.size.width, driverView.viewStarRating.bounds.size.height) andRating:rating*20 withLabel:NO animated:YES];

    
    [driverView.viewStarRating addSubview:rateView];
    [self.view addSubview:driverView];
}

-(void)removeDriverView{
    [driverView removeFromSuperview];
    driverView = nil;
}

-(void)makeCall{
    NSURL *phoneUrl = [NSURL URLWithString:[@"telprompt://"stringByAppendingString:self.currentTrip.driver.phone]];
    NSURL *phoneFallbackUrl = [NSURL URLWithString:[@"tel://" stringByAppendingString:self.currentTrip.driver.phone]];
    
    
    if ([UIApplication.sharedApplication canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else if ([UIApplication.sharedApplication canOpenURL:phoneFallbackUrl]) {
        [UIApplication.sharedApplication openURL:phoneFallbackUrl];
    } else {
        [UtilityClass showWarningAlert:nil
                               message:NSLocalizedString(@"No_Call_Facility", @"")
                     cancelButtonTitle:@"Ok"
                      otherButtonTitle:nil];
    }

    
}



-(void) setTripTime:(int) duration
{
    int hours=(int)duration/60;
    int min=(int)duration%60;
    if(hours==0)
    {
        [self.lbTime setText:[NSString stringWithFormat:@"%d\nmin",duration]];
    }
    else
    {
        [self.lbTime setText:[NSString stringWithFormat:@"%dh\n%dmin",hours, min]];
    }
}

-(void)setUserAnnotation{
    
    //    AppDelegate *appdelegate =APP_DELEGATE;
    //
    //
    //    if(appdelegate.currLoc.latitude !=0)
    //    {
    //
    //        [self.mapView removeAnnotations:self.mapView.annotations];
    //
    //        userPin = [[MKPointAnnotation alloc] init];
    //
    //        userPin.coordinate = appdelegate.currLoc;
    //        // driverPin=YES;
    //        [self.mapView addAnnotation:userPin];
    //
    //    }
    //
    // user this if need to show user location
    //    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    //        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
}


#pragma mark - Location Manager  methods

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
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

#pragma mark - MKMapViewDelegate methods

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    AppDelegate *appdelegate= APP_DELEGATE;
    
    appdelegate.currLoc = userLocation.coordinate;
    
    NSDictionary * dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",appdelegate.currLoc.latitude],@"lat",[NSString stringWithFormat:@"%f",appdelegate.currLoc.longitude ],@"lng", nil];
    defaults_set_object(@"curr_loc", dict);
    
    //    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    //    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"Changed Location %f  %f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
    
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
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor colorWithRed:0.0/255.0 green:171.0/255.0 blue:253.0/255.0 alpha:1.0];
    renderer.lineWidth = 2.0;
    return  renderer;
}
- (void)addMapAnnotationsWith:(GoogleDirectionSource * )directionSource {
    
    [self .mapView removeAnnotations:arrayAnotations];
    CustomPointAnnotation *pickUp = [[CustomPointAnnotation alloc]initWithType:@"pick"];
    pickUp.coordinate = directionSource.source.coordinate;
    [self.mapView addAnnotation:pickUp];
    
    CustomPointAnnotation *pickDrop = [[CustomPointAnnotation alloc] initWithType:@"drop"];
    pickDrop.coordinate = directionSource.destination.coordinate;
    [self.mapView addAnnotation:pickDrop];
    
    
    arrayAnotations=@[pickUp,pickDrop];
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude =  -90;
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
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.8; // Add a little extra space on the sides //1.1
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.8; // Add a little extra space on the sides //1.1
    
    //MKCoordinateRegion regionTest = MKCoordinateRegionMakeWithDistance(directionSource.source.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
}
- (IBAction)onMenuButtonTap:(id)sender {
    [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
}
- (IBAction)onMyLocationButtonTap:(id)sender {
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
}
@end
