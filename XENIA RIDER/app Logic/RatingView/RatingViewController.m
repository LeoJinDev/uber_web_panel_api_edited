//
//  RatingViewController.m
//  TaxiDriver
//
//  Created by SFYT on 24/05/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "RatingViewController.h"
#import "StarRatingView.h"
#import "WebCallConstants.h"
#import "AppDelegate.h"




#define kLabelAllowance 50.0f
#define kStarViewHeight 40.0f
#define kStarViewWidth 160.0f
#define kLeftPadding 5.0f


@interface RatingViewController ()

@end

@implementation RatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

     AppDelegate *appdelegate =APP_DELEGATE;
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    NSString *rating = [dict1 objectForKey:@"d_rating_count"];
    
    
    StarRatingView* starViewNoLabel = [[StarRatingView alloc]initWithFrame:CGRectMake(80, (self.view.frame.size.height/2)-20, self.view.frame.size.width-160, kStarViewHeight) andRating:[rating floatValue]*20 withLabel:NO animated:YES];
    [starViewNoLabel setUserInteractionEnabled:NO];
    
    [self.view addSubview:starViewNoLabel];
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
- (IBAction)ButtonBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
