//
//  LeftViewController.m
//  TempProject
//
//  Created by SFYT on 09/02/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "LeftViewController.h"
#import "SideMenuCell.h"
#import "EditProfileViewController.h"
#import "WebCallConstants.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
//#import "CallAPI.h"
#import "WebCallConstants.h"
//#import "nsuserdefaults-macros.h"
#import "SignInViewController.h"
#import <GrepixKit/GrepixKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <MessageUI/MFMailComposeViewController.h>
//#import <MessageUI/MFMessageComposeViewController.h>


@interface LeftViewController ()<MFMailComposeViewControllerDelegate/*,MFMessageComposeViewControllerDelegate*/>


@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setThemeConstants];
    [self.imgProfile.layer setBorderWidth:2];
    [self.imgProfile.layer setBorderColor:[UIColor whiteColor].CGColor];
    // Do any additional setup after loading the view.
    
    //    arrMenu =[[NSArray alloc]initWithObjects:@"Profile",@"Trip History",@"Rating",@"Logout", nil];
    //    arrIcons =[[NSArray alloc]initWithObjects:@"man",@"order",@"star",@"power-button", nil];
    //    arrIdentifier =[[NSArray alloc]initWithObjects:@"EditProfileViewController",@"OpenCloseViewController",@"TutorialViewController",@"SettingsViewController", nil];
    
    [self.lblName setFont:FONT_ROB_COND_REG(16)];
    
    _arrSideMenu =[[NSArray alloc]initWithObjects:@{
                                                    @"title":NSLocalizedString(@"Profile", @""),
                                                    @"icon":@"man",
                                                    @"identifier":@"EditProfileViewController"
                                                    
                                                    },@{@"title":NSLocalizedString(@"SOS", @""),
                                                        @"icon":@"sos_alarm",
                                                        @"identifier":@"SettingViewController",
                                                        },@{
                                                            @"title":NSLocalizedString(@"Trip_History", @""),
                                                            @"icon":@"order",
                                                            @"identifier":@"TripHistoryViewController"
                                                            },
                   
                   
                   @{
                     @"title":NSLocalizedString(@"Share", @""),
                     @"icon":@"share",
                     @"identifier":SIDE_MENU_SHARE
                     },
                   @{
                     @"title":NSLocalizedString(@"Deactivate_Acc", @""),
                     @"icon":@"deactivate",
                     @"identifier":SIDE_MENU_DEACTIVATE
                     },
                   @{
                     @"title":NSLocalizedString(@"Support", @""),
                     @"icon":@"support",
                     @"identifier": SIDE_MENU_SUPPORT
                     },
                   @{
                     @"title":NSLocalizedString(@"XeniaWallet", @""),
                     @"icon":@"xc_coin",
                     @"identifier":SIDE_MENU_WALLETOPTION
                     },
                   
                   @{
                     @"title":NSLocalizedString(@"XeniaSignUp", @""),
                     @"icon":@"xc_wallet",
                     @"identifier": SIDE_MENU_XENIASIGNUP
                     },
                   @{
                     @"title":NSLocalizedString(@"WithDraw", @""),
                     @"icon":@"xc_wallet",
                     @"identifier": SIDE_MENU_WITHDRAW
                     },
                   @{
                     @"title":NSLocalizedString(@"Logout", @""),
                     @"icon":@"power-button",
                     @"identifier":SIDE_MENU_LOGOUT
                     },
                   nil];
    
    
    UINib *nib = [UINib nibWithNibName:@"SideMenuCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"SideMenuCell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    NSString *status = defaults_object(DRIVER_STATUS);
    
    if ([status isEqualToString:TS_WAITING] || status==nil) {
        
        _switchAvailability.userInteractionEnabled=YES;
        [_switchAvailability setOn:YES];
        
    }
    else{
        
        _switchAvailability.userInteractionEnabled=NO;
        [_switchAvailability setOn:NO];
    }
    
    // [self switchChange:_switchAvailability];
   // AppDelegate *appdelegate =APP_DELEGATE;
    [self setprofileImage];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setprofileImage) name:@"change_profile" object:nil];
    
    
}

-(void)setThemeConstants{
    
    _viewBackground.backgroundColor = CONSTANT_THEME_COLOR1;
    _viewSeparator.backgroundColor =CONSTANT_THEME_COLOR2;

    
}

-(void)setprofileImage{
    
   // AppDelegate *appdelegate =APP_DELEGATE;
    
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    
    _lblName.text =[dict1 objectForKey:@"u_name"];
    [_lblName setFont:FONTS_THEME_REGULAR(15)];
    
    NSString *profile=[dict1 objectForKey:@"u_profile_image_path"];
    
    if (profile.length>0) {
        
        
        [_imgProfile sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url_base_images, profile]] placeholderImage:[UIImage imageNamed:@"Profile Icon Crop Image"]];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrSideMenu.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SideMenuCell";
    
    
    
    SideMenuCell *cell = (SideMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SideMenuCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.lblMenu.text =[[_arrSideMenu objectAtIndex:indexPath.row]objectForKey:@"title"];
    [cell.imgIcon setImage:[UIImage imageNamed:[[_arrSideMenu objectAtIndex:indexPath.row] objectForKey:@"icon"]]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.viewSeparator.backgroundColor =CONSTANT_THEME_COLOR2;
     cell.contentView.backgroundColor =CONSTANT_THEME_COLOR1;
    [cell.lblMenu setFont:FONTS_THEME_REGULAR(17)];
    
    //    [cell.lblMenu setFont:FONT_HELVETICANEUE_REGULAR(18)];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        [cell setSelected:YES animated:NO];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 52;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSString *sideOption = [[_arrSideMenu objectAtIndex:indexPath.row] objectForKey:@"identifier"];
    
    if ([sideOption isEqualToString:SIDE_MENU_LOGOUT]) {
        
        [self LogoutPressed_isLogout:YES];
    }
    
    else if ([sideOption isEqualToString:SIDE_MENU_TERMS]) {
        NSURL *url = [NSURL URLWithString:Terms_Conditions];
        [self openUrl:url];
    }
    
    else if ([sideOption isEqualToString:SIDE_MENU_SHARE]) {
        [self shareApp];
    }
    
    else if ([sideOption isEqualToString:SIDE_MENU_DEACTIVATE]) {
        [self LogoutPressed_isLogout:NO];
    }
    
    else if ([sideOption isEqualToString:SIDE_MENU_SUPPORT]) {
         [self openMailComposer];
    }
    else if ([sideOption isEqualToString:SIDE_MENU_WITHDRAW]) {
        [self showNearByUser];
    }
    
    
    
    else{
        
        [self setViewControllers:sideOption]; //[[_arrSideMenu objectAtIndex:indexPath.row] objectForKey:@"identifier"]
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}


- (void)LogoutPressed_isLogout:(BOOL)isLogout {
    
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:isLogout ? NSLocalizedString(@"Logout", @"") : NSLocalizedString(@"Deactivate_Acc", @"")
                                 message: isLogout ? NSLocalizedString(@"logout_alert_message", @"") : NSLocalizedString(@"Deactivate_Alert", @"")
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Yes", @"")
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    isLogout ? [self LogoutPressed] : [self deactivateAccount];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"No", @"")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}







-(void)openUrl:(NSURL *)url{
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }else {
        [UtilityClass showWarningAlert:nil message:NSLocalizedString(@"Url_Cannot_Open", @"") cancelButtonTitle:@"Ok" otherButtonTitle:nil];
    }
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
}

-(void)deactivateAccount{
    
    //AppDelegate *appdelegate =APP_DELEGATE;
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                
                                                                                P_USER_ID          :[dict1 objectForKey:P_USER_ID],
                                                                                P_USER_IS_AVAILABLE    :@"0",
                                                                                P_USER_ACTIVE   : @0
                                                                                }];
    
    [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
    
    [APP_CallAPI gcURL:BASE_URL app:API_UPDATE_USER_PROFILE
                        data:dict
     isShowErrorAlert:NO
                completionBlock:^(id results, NSError *error) {
                    if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                        // success
                        defaults_remove(P_API_KEY);
                        defaults_remove(TRIP_ID);
                        defaults_remove(@"trip_status");
                        defaults_remove(P_USER_DICT);
                        SignInViewController *loginViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
                        
                        UIWindow *window = UIApplication.sharedApplication.delegate.window;
                        window.rootViewController = loginViewController;
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                    }
                    [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
                }];
    

}

- (void)LogoutPressed {
    
    NSString *status = defaults_object(DRIVER_STATUS);
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    if ([status isEqualToString:TS_WAITING] || status==nil) {
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
        
       // AppDelegate *appdelegate =APP_DELEGATE;
        
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                    
                                                                                    P_USER_ID          :[dict1 objectForKey:P_USER_ID],
                                                                                    P_USER_IS_AVAILABLE    :@"0"
                                                                                    
                                                                                    }];
        
        [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
        
        [APP_CallAPI gcURL:BASE_URL app:API_UPDATE_USER_PROFILE
                            data:dict
         isShowErrorAlert:NO
                    completionBlock:^(id results, NSError *error) {
                        if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                            // success
                            defaults_remove(P_API_KEY);
                            defaults_remove(TRIP_ID);
                            defaults_remove(@"trip_status");
                            defaults_remove(P_USER_DICT);
                          
                            SignInViewController *loginViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
                            
                            UIWindow *window = UIApplication.sharedApplication.delegate.window;
                            window.rootViewController = loginViewController;
                            
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            
                        }
                        [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
                    }];
        
    }
    
}

-(void)setViewControllers:(NSString *)sender{
    
    
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
    UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
    UIViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:sender];
    
    [navigationController pushViewController:viewController animated:YES];
    [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
    
}
- (IBAction)switchChange:(UISwitch *)sender {
    
    AppDelegate *appdelegate =APP_DELEGATE;
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    
    NSString *status;
    
    if (_switchAvailability.isOn) {
        status=@"1";
    }
    else{
        status=@"0";
    }
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                
                                                                                P_USER_ID          :[dict1 objectForKey:P_USER_ID],
                                                                                P_USER_IS_AVAILABLE      :status
                                                                                
                                                                                }];
    
    [APP_CallAPI gcURL:BASE_URL app:API_UPDATE_USER_PROFILE
                        data:dict
     isShowErrorAlert:NO
                completionBlock:^(id results, NSError *error) {
                    if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                        // success
                        appdelegate.userDict =[results objectForKey:P_RESPONSE];
                        NSLog(@"switch changed");
                        
                        
                    }
                    
                }];
    
    
}

#pragma  mark -  Mail delegate method

-(void)openMailComposer{
    
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
        
        
        NSString * supportEmail = SUPPORT_EMAIL;
        NSMutableArray  *arrayEmails=[[NSMutableArray alloc]  init];
        [arrayEmails addObject:supportEmail];
        
        [mailCont setToRecipients:arrayEmails];
        /*
         [mailCont setSubject:@""];
        NSMutableString *body = [NSMutableString string];
        NSString *url = [NSString stringWithFormat:@"http://maps.google.com?q=%f,%f",[APP_DELEGATE currLoc].latitude,[APP_DELEGATE currLoc].longitude];
        [body appendString:[NSString stringWithFormat:@"Please help, I am in danger and need assistance.Follow my location,<a href=\"%@\">Click Here</a> \n ",url]];
        
        [mailCont setMessageBody:body isHTML:YES];
         */
        [self presentViewController:mailCont animated:YES completion:nil];
    }
    else
    {
        [UtilityClass showWarningAlert:@"Whoops!" message:NSLocalizedString(@"Config_Mail", @"") cancelButtonTitle:NSLocalizedString(@"alert_ok", @"") otherButtonTitle:nil];
    }
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    if(error!= nil)
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Whoops!"
                                                                                 message:[NSString stringWithFormat:@" ERROR %@",error]                                                                       preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}


-(void) showNearByUser
{
    AppDelegate *appdelegate =APP_DELEGATE;
    if (appdelegate.currLoc.latitude> 0) {
        
        //NSLog(@" ********* api count %d",count++);
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                    @"lat"                : [NSString stringWithFormat:@"%f",appdelegate.currLoc.latitude],
                                                                                    @"lng"                : [NSString stringWithFormat:@"%f",appdelegate.currLoc.longitude],
                                                                                    
                                                                                    }];
       [dict setObject:@"2" forKey:@"miles"];
        /*
        if (constantTaxiModel.constant_driver_radius ==nil) {
            
            [dict setObject:@"2" forKey:@"miles"];
        }
        else{
            
            [dict setObject:constantTaxiModel.constant_driver_radius forKey:@"miles"];
        }
        */
        [APP_CallAPI gcURL:BASE_URL app:GET_USERS_NEARBY
                      data:dict
          isShowErrorAlert:NO
           completionBlock:^(id results, NSError *error) {
               NSLog(@"%@",[results objectForKey:P_STATUS]);
               if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                   // success
                   
                   NSArray *ridersArray = [results objectForKey:P_RESPONSE];
                   
                   if (ridersArray.count>0) {
                       
                       [self showAllUsers:ridersArray];
                   }
                   
               }
               
           }];
    }
    
    else{
        /*
        [self invalidateNearByTimer];
        //NSLog(@" ********* api count %d",count++);
        nearbyTimer = [NSTimer scheduledTimerWithTimeInterval: 15.0 target: self
                                                     selector: @selector(getNearByRiders) userInfo: nil repeats: YES];
         */
    }
}
-(void)showAllUsers:(NSArray *)arrUsers
{
    // [self setDriverLocation];
    /*
    [self.mapView removeAnnotations:arraynearbyAnnotations];
    
    arraynearbyAnnotations = [[NSMutableArray alloc]init];
    for(int i = 0; i < arrUsers.count; i++)
    {
        double latitude = [[[arrUsers objectAtIndex:i] objectForKey:@"u_lat"] doubleValue];
        double longitude = [[[arrUsers objectAtIndex:i] objectForKey:@"u_lng"] doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
        mapPin.coordinate = coordinate;
        
        [arraynearbyAnnotations addObject:mapPin];
        [self.mapView addAnnotation:mapPin];
        
    }
    
    //[self zoomToFitMapAnnotations];
    */
    
}

@end
