//
//  DriverView.m
//  XENIA RIDER
//
//  Created by Sivilay on 25/10/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "DriverView.h"
#import <GrepixKit/GrepixKit.h>
#import "WebCallConstants.h"

@implementation DriverView


#define kLabelAllowance 50.0f
#define kStarViewHeight 35.0f
#define kStarViewWidth 180.0f
#define kLeftPadding 5.0f
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initFromNib{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil] firstObject];
}


-(void)awakeFromNib{
    [super awakeFromNib];
 
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 2; // if you like rounded corners
    self.layer.shadowOffset = CGSizeMake(-2, 2);
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.5;
    
    
    [UtilityClass setCornerRadius:self.viewDriverContainer radius:3.0 border:NO];
    
    
    [UtilityClass setCornerRadius:self.imgDriver radius:self.imgDriver.bounds.size.width/2 border:NO];
   // [UtilityClass setCornerRadius:self.lbEstimatedTime radius:self.lbEstimatedTime.bounds.size.width/2 borderColor:[UIColor colorWithRed:0.9568627451 green:0.7882352941 blue:0.1490196078 alpha:1.0]];
    [UtilityClass setCornerRadius:self.btCall radius:self.btCall.bounds.size.width/2 border:NO];
    
   
   //rating view
    [self.viewStarRating setUserInteractionEnabled:NO];
}


- (IBAction)handleBtnCall:(id)sender {
    
    
}

@end
