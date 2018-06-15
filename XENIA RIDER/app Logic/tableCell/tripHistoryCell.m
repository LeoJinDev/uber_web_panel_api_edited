//
//  tripHistoryCell.m
//  TaxiDriver
//
//  Created by SFYT on 29/05/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "tripHistoryCell.h"
#import "UIImageView+WebCache.h"
#import "WebCallConstants.h"
#import <GrepixKit/GrepixKit.h>
#import "Utilities.h"

@implementation tripHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.imgRider setClipsToBounds:YES];
    [self.imgRider.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.imgRider.layer setBorderWidth:1];
    [self.imgRider .layer setCornerRadius:25];
    [self setThemeConstants];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setThemeConstants{
    [_lblDate setFont:FONTS_THEME_REGULAR(16)];
    [_lblAmmount setFont:FONTS_THEME_REGULAR(16)];
    [_lblriderName setFont:FONTS_THEME_REGULAR(14)];
    [_lbPickUpAddress setFont:FONTS_THEME_REGULAR(16)];
    [_lbDropUpAddress setFont:FONTS_THEME_REGULAR(16)];
}



-(void)setdataWithTripModel:(TripModel *)tripModel{
    
//    _lblriderName.text = tripModel.trip_user_full_name;;
    
    _arrCategory =[[NSMutableArray alloc]init];
    NSArray * arrCateResponse=defaults_object(@"categoryResponse");
    if(arrCateResponse)
    {
        _arrCategory=[CategoryModel parseResponse:arrCateResponse];
    }

    
    int catId = tripModel.driver.category_id;
    for (CategoryModel * category in _arrCategory) {
        if(category.categoryId == catId )
        {
            _carCategory = category;
            
        }
    }

    
    NSString *carImageName;
     if(tripModel.driver.category_id==1)
     {

         carImageName = @"Hatchback";
     }
    else if(tripModel.driver.category_id==2)
    {
       
        carImageName = @"sedan";
    }
    else  if(tripModel.driver.category_id==3)
    {
      
        carImageName = @"suv";
    }
    
    self.imgCar.image =  [UIImage imageNamed:carImageName];
    
    _lblriderName.text=[NSString stringWithFormat:@"%@",isEmpty(_carCategory.cat_name)];
//    _lblriderName.text=[NSString stringWithFormat:@"%@ %@",isEmpty(categoryName), isEmpty(tripModel.driver.carname)];
    _lblDate.text =[Utilities GetGMTDatetoLocalTZ:tripModel.trip_created_time];
    _lbDropUpAddress.text=tripModel.trip_drop_loc;
    _lbPickUpAddress.text=tripModel.trip_pick_loc;
//    NSString *currencySymbol = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];

    

//    _lblAmmount.text =[NSString stringWithFormat:@"%@ %@",currencySymbol,tripModel.trip_fare];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    _lblAmmount.text =[NSString stringWithFormat:@"%@%0.2f",_constantModel.constant_currency,[tripModel.trip_fare floatValue]-[tripModel.trip_promo_amt floatValue]];

    NSString *profile= tripModel.driver.d_profile_image_path;
    
    if (profile.length>0) {
        
        // [_imgProfile sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url_base_images, profile]]];
        
        [_imgRider sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url_base_images, profile]] placeholderImage:[UIImage imageNamed:@"Profile Icon Crop Image"]];
    }
    
    
}


@end
