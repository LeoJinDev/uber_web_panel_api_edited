//
//  WalletTypeVC.h
//  XENIA RIDER
//
//  Created by Clean on 4/24/18.
//  Copyright © 2018 Grepixit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletTypeVC : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imgCard;
@property (strong, nonatomic) IBOutlet UILabel *lblholderName;
@property (strong, nonatomic) IBOutlet UIButton *btnCnNaira;

@property (strong, nonatomic) IBOutlet UIButton *btnCnUSD;
@property (strong, nonatomic) IBOutlet UIButton *btnCnEuro;
@property (strong, nonatomic) IBOutlet UIButton *btnCnZar;

@end
