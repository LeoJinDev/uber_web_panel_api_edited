//
//  RequestViewController.h
//  XENIA RIDER
//
//  Created by SFYT on 13/06/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleDirectionSource.h"
#import "TripModel.h"
#import "CategoryModel.h"
#import "ConstantModel.h"
@class RequestViewController;
@protocol RequestViewControllerDelegate <NSObject>

-(void) onTripRequestCompletion:(TripModel *) tripModel;

@end

@interface RequestViewController :UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *viewImageFirst;
@property (weak, nonatomic) IBOutlet UIView *viewVideoContainer;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *lbRequest;

@property (weak, nonatomic) IBOutlet UIView *viewMessage;
@property(strong,nonatomic) NSArray * arrDrivers;
@property(strong,nonatomic) CategoryModel * carCategory;
@property(strong,nonatomic) ConstantModel * constantModel;
@property(assign,nonatomic) float tripDistance;
@property(assign,nonatomic) float tripTime;
@property(strong,nonatomic) NSString *searchText;
@property (strong, nonatomic) GoogleDirectionSource  *directionSource;
@property (weak, nonatomic) IBOutlet UIButton *btBack;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property(strong, nonatomic) id<RequestViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *btnOK;
@property (strong, nonatomic) IBOutlet UILabel *lblMessageTitle;
- (IBAction)onBackButtonTap:(id)sender;
@end
