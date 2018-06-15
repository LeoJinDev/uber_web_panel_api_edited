//
//  WalletInviteVC.m
//  XENIA RIDER
//
//  Created by Clean on 4/24/18.
//  Copyright © 2018 Grepixit. All rights reserved.
//

#import "WalletInviteVC.h"
#import "WebCallConstants.h"
#import "LeftViewController.h"
#import "SideMenuCell.h"
#import "EditProfileViewController.h"
#import "WebCallConstants.h"
#import "AppDelegate.h"
#import <GrepixKit/GrepixKit.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface WalletInviteVC ()

@end

@implementation WalletInviteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [self setCardSetting];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) setCardSetting
{
    NSString *Card_Type=[[NSUserDefaults standardUserDefaults] objectForKey:WC_TYPE];
    if([Card_Type isEqualToString:WC_ZAR])
    {
        [_img_cardholder setImage:[UIImage imageNamed:@"card_hold_purple_rand.jpg"]];
    }
    else if([Card_Type isEqualToString:WC_NAIRA])
    {
        [_img_cardholder setImage:[UIImage imageNamed:@"card_hold_purple_naira.jpg"]];
    }
    else if([Card_Type isEqualToString:WC_DOLLAR])
    {
        [_img_cardholder setImage:[UIImage imageNamed:@"card_hold_purple_dollar.jpg"]];
        
    }
    else
    {
        [_img_cardholder setImage:[UIImage imageNamed:@"card_hold_purple_euro.jpg"]];
    }
    NSString *showingIDTxtPrefix=@"Your position is #";
    NSString *showingID=[[NSUserDefaults standardUserDefaults] objectForKey:WC_PREORDERCARD_ID];
    NSString *showingIDTxtsuffix=@" in your region";
    showingIDTxtPrefix=[showingIDTxtPrefix stringByAppendingString:showingID];
    showingIDTxtPrefix=[showingIDTxtPrefix stringByAppendingString:showingIDTxtsuffix];
    [_lblOrderIDShowing setText:showingIDTxtPrefix];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onMenuButtonTap:(id)sender {
    [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
}
- (IBAction)btnLaterTap:(id)sender {
    [self navigateHome];
}

-(void)navigateHome{
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    
    
    
    [navigationController setViewControllers:@[[storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"]]];
    
    
    MainViewController *mainViewController =[storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    mainViewController.rootViewController = navigationController;
    [mainViewController setupWithType:2];
    //    self.leftViewWidth =;
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    window.rootViewController = mainViewController;
    
    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
    
    [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
    
}
- (IBAction)btnInviteFriendClicked:(id)sender {
  
    [self shareApp];
    //[self navigateHome];
}
-(void)shareApp{
    NSString *textToShare = Share_Text;
    NSURL *myWebsite = [NSURL URLWithString:Promotion_Link];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
    /*
    if([self presentedViewController])
    {
        [[self presentedViewController] dismissViewControllerAnimated:NO completion:^{dispatch_sync(dispatch_get_main_queue(), ^{
            [self presentViewController:activityVC animated:YES completion:nil];
            });
        }];
    }
    else
    {
    }
   */
}
@end
