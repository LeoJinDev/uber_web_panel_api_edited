//
//  FareReviewViewController.m
//  TaxiDriver
//
//  Created by Sivilay on 25/10/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "FareReviewViewController.h"
#import "AppDelegate.h"
#import "WebCallConstants.h"
#import <GrepixKit/GrepixKit.h>
#import <MapKit/MapKit.h>
#import "CustomPointAnnotation.h"
//#import "nsuserdefaults-helper.h"
#import "ConstantModel.h"
#import "CategoryModel.h"
#import "UIImageView+WebCache.h"
#import "Utilities.h"
@interface FareReviewViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation FareReviewViewController
{
    NSMutableArray *arrAnotation;
    NSMutableArray *arrCategory;
    CategoryModel *carCategory;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    arrAnotation=[[NSMutableArray alloc]  init];
    // Do any additional setup after loading the view.
    arrCategory =[[NSMutableArray alloc]init];
    [self setThemeConstants];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   //  AppDelegate *delegate =APP_DELEGATE;
    NSArray * arrCateResponse=defaults_object(@"categoryResponse");
    if(arrCateResponse)
    {
        arrCategory=[CategoryModel parseResponse:arrCateResponse];
    }
   
    
    int catId = self.cur_trip.driver.category_id;
    for (CategoryModel * category in arrCategory) {
        if(category.categoryId == catId )
        {
            carCategory = category;
            
        }
    }

    
    NSArray * arr = defaults_object(@"constantResponse");
    ConstantModel *constantModel =[[ConstantModel alloc]initItemWithDict:arr];
    NSString *dis;
    NSString *tripDis;
    if ([[constantModel.constant_distance capitalizedString] isEqualToString:@"Km"]) {
        dis =@"km";
        tripDis = self.cur_trip.trip_distance;
    }
    else{
        dis =@"mi";
        float miles = [self.cur_trip.trip_distance floatValue]*0.621371192;
        tripDis = [NSString stringWithFormat:@"%.2f",miles];
        
    }
    _lbltripid.text =_cur_trip.trip_Id;
    _lblDriverId.text=_cur_trip.driver.driverId;
    _lblDropLocation.text =_cur_trip.trip_drop_loc;
    _lblPickupLocation.text =_cur_trip.trip_pick_loc;
    _lblDate.text  =[Utilities GetGMTDatetoLocalTZ:self.cur_trip.trip_created_time];
   
    
    NSString *imageName;
    
    if(self.cur_trip.driver.category_id==1)
    {
     
        imageName = @"Hatchback";
    }
    else if(self.cur_trip.driver.category_id==2)
    {
       
        imageName = @"sedan";
    }
    else  if(self.cur_trip.driver.category_id==3)
    {
       
        imageName = @"suv";
    }
    
    
    self.imgCar.image = [UIImage imageNamed:imageName];
    
    self.lbCarCategoryName.text=[NSString stringWithFormat:@"%@",isEmpty(carCategory.cat_name)];
    

    _lblTax.text = [NSString stringWithFormat:@"%@%.2f",constantModel.constant_currency, [_cur_trip.tax_amount floatValue]];
    
    _lblDistance.text =[NSString stringWithFormat:@"%@%@",tripDis,dis];
    
    
    _lblCharge.text =[NSString stringWithFormat:@"%@%.2f",constantModel.constant_currency,[_cur_trip.trip_fare floatValue]-  [_cur_trip.tax_amount floatValue]];
    _lbPromoCodeAmount.text=[NSString stringWithFormat:@"- %@%.2f",constantModel.constant_currency,[_cur_trip.trip_promo_amt floatValue]];
    _lblTotal.text=[NSString stringWithFormat:@"%@%.2f",constantModel.constant_currency,[_cur_trip.trip_fare floatValue]-[_cur_trip.trip_promo_amt floatValue]];
    
      _lblDriverName.text=[NSString stringWithFormat:@"%@ %@", _cur_trip.driver.d_fname,_cur_trip.driver.d_lname];
    
    NSString *profile= _cur_trip.driver.d_profile_image_path;
    
    if (profile.length>0) {
        
        // [_imgProfile sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url_base_images, profile]]];
        
        [_imgDriver sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url_base_images, profile]] placeholderImage:[UIImage imageNamed:@"Profile Icon Crop Image"]];
    }else
    {
        [_imgDriver  setImage:[UIImage imageNamed:@"Profile Icon Crop Image"]];
        
    }
   
    [self initMapView];
}

-(void)viewDidLayoutSubviews
{
    float dropLbl_height = [UtilityClass getLabelHeight:CGSizeMake(SCREEN_WIDTH - 68, 100000) forText:_cur_trip.trip_drop_loc withFont:FONT_ROB_COND_REG(16)];
    float pickLbl_height = [UtilityClass getLabelHeight:CGSizeMake(SCREEN_WIDTH - 68, 100000) forText:_cur_trip.trip_pick_loc withFont:FONT_ROB_COND_REG(16)];
    
    float heightScroll = 590 + dropLbl_height + pickLbl_height + 25; //variable height of labels + 5 bottom padding;
    
    
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, heightScroll)];//800
}


-(void)setThemeConstants{
    
    _viewHeader.backgroundColor = CONSTANT_THEME_COLOR1;
    _lblHeader.textColor =CONSTANT_TEXT_COLOR_HEADER;
    [_lblHeader setFont:FONTS_THEME_REGULAR(19)];
    
    [_lblDate setFont:FONTS_THEME_REGULAR(16)];
    [_lbCarCategoryName setFont:FONTS_THEME_REGULAR(16)];
    [_lblDriverName setFont:FONTS_THEME_REGULAR(16)];
    [_lblPickupLocation setFont:FONTS_THEME_REGULAR(16)];
    [_lblDropLocation setFont:FONTS_THEME_REGULAR(16)];
    [_lblDistance setFont:FONTS_THEME_REGULAR(16)];
    [_lblCharge setFont:FONTS_THEME_REGULAR(14)];
    [_lblTax setFont:FONTS_THEME_REGULAR(14)];
    [_lbPromoCodeAmount setFont:FONTS_THEME_REGULAR(14)];
    [_lblTotal setFont:FONTS_THEME_REGULAR(14)];
    [_lblTaxTitle setFont:FONTS_THEME_REGULAR(16)];
    [_lblPromoTitle setFont:FONTS_THEME_REGULAR(16)];
    [_lblAmountPaidTitle setFont:FONTS_THEME_REGULAR(16)];
    [_lblFareAmountTitle setFont:FONTS_THEME_REGULAR(16)];
    [_lbltripid setFont:FONTS_THEME_REGULAR(14)];
    [_lblDriverId setFont:FONTS_THEME_REGULAR(14)];
    [_lblTripIdTitle setFont:FONTS_THEME_REGULAR(16)];
    [_lblDriverIdTitle setFont:FONTS_THEME_REGULAR(16)];
    
    
}

-(void)initMapView
{
    
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = NO;
    
    [self.mapView removeAnnotations:arrAnotation];
    //    MKPointAnnotation *pickUp = [[MKPointAnnotation alloc] init];
    CustomPointAnnotation * pickUp=[[CustomPointAnnotation alloc]  initWithType:@"pick"];
    
    CLLocation * pick=[[CLLocation alloc]  initWithLatitude:[self.cur_trip.trip_pick_lat doubleValue] longitude:[self.cur_trip.trip_pick_long doubleValue]];
    pickUp.coordinate =pick.coordinate;
    [self.mapView addAnnotation:pickUp];
    CustomPointAnnotation * dropAno=[[CustomPointAnnotation alloc]  initWithType:@"drop"];
    CLLocation * drop=[[CLLocation alloc]  initWithLatitude:[self.cur_trip.trip_drop_lat doubleValue] longitude:[self.cur_trip.trip_drop_long doubleValue]];
    dropAno.coordinate=drop.coordinate;
    [self.mapView addAnnotation:dropAno];
    
    [arrAnotation addObject:pickUp];
    [arrAnotation addObject:dropAno];
    
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for (id <MKAnnotation> annotation in arrAnotation) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 2.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 2.1; // Add a little extra space on the sides
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    [self.mapView setUserInteractionEnabled:NO];
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


- (IBAction)ButtonBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBackButtonTap:(id)sender {
    [self.navigationController  popViewControllerAnimated:YES];
}






@end
