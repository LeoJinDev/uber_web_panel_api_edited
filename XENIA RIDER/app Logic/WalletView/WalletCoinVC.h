//
//  WalletCoinVC.h
//  XENIA RIDER
//
//  Created by Clean on 4/20/18.
//  Copyright © 2018 Grepixit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
@interface WalletCoinVC : UIViewController<iCarouselDataSource, iCarouselDelegate>
@property (strong, nonatomic) IBOutlet iCarousel *card_view;
@property (strong, nonatomic) IBOutlet UIView *chooseCardView;
@property (strong, nonatomic) IBOutlet UIView *loadWalletView;

@end
