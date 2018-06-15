//
//  TripDetailsViewController.m
//  TaxiDriver
//
//  Created by SFYT on 30/05/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "TripDetailsViewController.h"
// 
#import <MapKit/MapKit.h>
#import <GrepixKit/GrepixKit.h>
#import "CustomPointAnnotation.h"
#import "WebCallConstants.h"
#import "UIImageView+WebCache.h"
#import "CategoryModel.h"
#import "Utilities.h"
//#import "nsuserdefaults-helper.h"
@interface TripDetailsViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *lbCarCategoryName;
@property (weak, nonatomic) IBOutlet UIImageView *imUserImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgCar;

@end

@implementation TripDetailsViewController
{
    NSMutableArray *arrAnotation;
    NSMutableArray *arrCategory;
    CategoryModel *carCategory;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setThemeConstants];
    arrAnotation=[[NSMutableArray alloc]  init];
    arrCategory =[[NSMutableArray alloc]init];
    [self initMapView];
    [self.imUserImage setClipsToBounds:YES];
    [self.imUserImage.layer setBorderWidth:1];
    
    [self.imUserImage.layer setBorderColor:[UIColor blackColor].CGColor];
    
    [self.imUserImage.layer setCornerRadius:20];
   

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *dis;
    NSString *tripDis;
    
    NSArray * arrCateResponse=defaults_object(@"categoryResponse");
    if(arrCateResponse)
    {
        arrCategory=[CategoryModel parseResponse:arrCateResponse];
    }
    
    
    int catId = self.trip.driver.category_id;
    for (CategoryModel * category in arrCategory) {
        if(category.categoryId == catId )
        {
            carCategory = category;
            
        }
    }

  
    
    if ([[_constantModel.constant_distance capitalizedString] isEqualToString:@"Km"]) {
        dis =@"km";
        tripDis = _trip.trip_distance;
    }
    else{
    dis =@"mi";
        float miles = [_trip.trip_distance floatValue]*0.621371192;
        tripDis = [NSString stringWithFormat:@"%.2f",miles];
        
    }
    
    
    NSString *imageName;
    if(self.trip.driver.category_id==1)
    {
        imageName = @"Hatchback";
    }
    else if(self.trip.driver.category_id==2)
    {
        imageName = @"sedan";
    }
    else  if(self.trip.driver.category_id==3)
    {

        imageName = @"suv";
        
        
    }
    
    self.imgCar.image = [UIImage imageNamed:imageName];
   
    self.lbCarCategoryName.text=[NSString stringWithFormat:@"%@",isEmpty(carCategory.cat_name)];
    
    _lblTax.text = [NSString stringWithFormat:@"%@%.2f",_constantModel.constant_currency, [self.trip.tax_amount floatValue]];

    
    _lblRiderName.text=[NSString stringWithFormat:@"%@ %@", self.trip.driver.d_fname,self.trip.driver.d_lname];
    _lblDate.text =[Utilities GetGMTDatetoLocalTZ:self.trip.trip_created_time];
    _lblDrop.text =_trip.trip_drop_loc;
    _lblPickup.text =_trip.trip_pick_loc;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    _lblAmmount.text =[NSString stringWithFormat:@"%@%.2f",_constantModel.constant_currency,[_trip.trip_fare floatValue]- [self.trip.tax_amount floatValue]];
    _lblDistance.text =[NSString stringWithFormat:@"%@ %@",tripDis,dis];
    _lbPromoAmmout.text=[NSString stringWithFormat:@"- %@%.2f",_constantModel.constant_currency,[_trip.trip_promo_amt floatValue]];
    _lbTotalPayAmount.text=[NSString stringWithFormat:@"%@%.2f",_constantModel.constant_currency,[_trip.trip_fare floatValue]-[_trip.trip_promo_amt floatValue]];
    NSString *profile= _trip.driver.d_profile_image_path;
    
    if (profile.length>0) {
        
        // [_imgProfile sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url_base_images, profile]]];
        
        [_imUserImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url_base_images, profile]] placeholderImage:[UIImage imageNamed:@"Profile Icon Crop Image"]];
    }else
    {
        [_imUserImage  setImage:[UIImage imageNamed:@"Profile Icon Crop Image"]];
        
    }
    
    if ([self.trip.trip_Status isEqualToString:TS_DRIVER_CANCEL_AT_PICKUP]) {
        
        _imgCancelTrip.hidden =NO;
        _lblAmmount.text =[NSString stringWithFormat:@"%@%@",_constantModel.constant_currency,@"0.00"];
        _lblDistance.text =[NSString stringWithFormat:@"%@%@",@"0.00",dis];
        _lbPromoAmmout.text =[NSString stringWithFormat:@"%@%@",_constantModel.constant_currency,@"0.00"];
        _lbTotalPayAmount.text =[NSString stringWithFormat:@"%@%@",_constantModel.constant_currency,@"0.00"];
        _lblTax.text =[NSString stringWithFormat:@"%@%@",_constantModel.constant_currency,@"0.00"];
    }
    else{
        
        _imgCancelTrip.hidden =YES;
    }

}

-(void)viewDidLayoutSubviews
{
    float dropLbl_height = [UtilityClass getLabelHeight:CGSizeMake(SCREEN_WIDTH - 64, 100000) forText:_trip.trip_drop_loc withFont:FONT_ROB_COND_REG(16)];
    float pickLbl_height = [UtilityClass getLabelHeight:CGSizeMake(SCREEN_WIDTH - 64, 100000) forText:_trip.trip_pick_loc withFont:FONT_ROB_COND_REG(16)];
    
    float heightScroll = 550 + dropLbl_height + pickLbl_height + 5; //variable height of labels + 5 bottom padding;
    
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, heightScroll)];//600
}


-(void)setThemeConstants{
    
    _viewHeader.backgroundColor = CONSTANT_THEME_COLOR1;
    _lblHeader.textColor =CONSTANT_TEXT_COLOR_HEADER;
    [_lblHeader setFont:FONTS_THEME_REGULAR(19)];
    [_lblDate setFont:FONTS_THEME_REGULAR(16)];
    [_lbCarCategoryName setFont:FONTS_THEME_REGULAR(16)];
    [_lblRiderName setFont:FONTS_THEME_REGULAR(16)];
    [_lblPickup setFont:FONTS_THEME_REGULAR(16)];
    [_lblDrop setFont:FONTS_THEME_REGULAR(16)];
    [_lblDistance setFont:FONTS_THEME_REGULAR(16)];
    [_lblAmmount setFont:FONTS_THEME_REGULAR(14)];
    [_lblTax setFont:FONTS_THEME_REGULAR(14)];
    [_lbTotalPayAmount setFont:FONTS_THEME_REGULAR(14)];
    [_lbPromoAmmout setFont:FONTS_THEME_REGULAR(14)];
    [_lblTaxTitle setFont:FONTS_THEME_REGULAR(16)];
    [_lblPromoTitle setFont:FONTS_THEME_REGULAR(16)];
    [_lblAmountPaidTitle setFont:FONTS_THEME_REGULAR(16)];
    [_lblFareAmountTitle setFont:FONTS_THEME_REGULAR(16)];
    
    
}
-(void)initMapView
{
    
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = NO;

    [self.mapView removeAnnotations:arrAnotation];
    //    MKPointAnnotation *pickUp = [[MKPointAnnotation alloc] init];
    CustomPointAnnotation * pickUp=[[CustomPointAnnotation alloc]  initWithType:@"pick"];

    CLLocation * pick=[[CLLocation alloc]  initWithLatitude:[_trip.trip_pick_lat doubleValue] longitude:[_trip.trip_pick_long doubleValue]];
    pickUp.coordinate =pick.coordinate;
    [self.mapView addAnnotation:pickUp];
    CustomPointAnnotation * dropAno=[[CustomPointAnnotation alloc]  initWithType:@"drop"];
    CLLocation * drop=[[CLLocation alloc]  initWithLatitude:[_trip.trip_drop_lat doubleValue] longitude:[_trip.trip_drop_long doubleValue]];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)ButtonBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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




@end
