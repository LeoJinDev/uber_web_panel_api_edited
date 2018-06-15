//
//  DriverView.h
//  XENIA RIDER
//
//  Created by Sivilay on 25/10/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarRatingView.h"

@interface DriverView : UIView


@property (weak, nonatomic) IBOutlet UIView *viewDriverContainer;
@property (weak, nonatomic) IBOutlet UIImageView *imgDriver;
@property (weak, nonatomic) IBOutlet UILabel *lblDriverName;
@property (weak, nonatomic) IBOutlet UILabel *lbCarNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbCarName;
@property (weak, nonatomic) IBOutlet UIButton *btCall;
@property (weak, nonatomic) IBOutlet StarRatingView *viewStarRating;

-(instancetype)initFromNib;

@end
