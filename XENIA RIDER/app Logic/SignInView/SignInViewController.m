//
//  SignInViewController.m
//  Store_project
//
//  Created by SFYT on 22/05/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "SignInViewController.h"
#import <GrepixKit/GrepixKit.h>
#import "WebCallConstants.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "HomeViewController.h"
//#import "CallAPI.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
////#import "nsuserdefaults-macros.h"
#import "VerifyViewController.h"

@interface SignInViewController ()


@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setThemeConstants];
    [self setNeedsStatusBarAppearanceUpdate];
    [self setupTextField:_txtEmail];
    [self setupTextField:_txtPassword];
    _txtPassword.secureTextEntry=YES;
   // _txtEmail.text=@"mahesh01@gmail.com";
    //_txtPassword.text =@"testtest";
    
    
    
  
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleLightContent;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    NSString *apiKey =[[NSUserDefaults standardUserDefaults]objectForKey:P_API_KEY];
    //    NSString *driverId =[[NSUserDefaults standardUserDefaults]objectForKey:@"driver_id"];
    
    if (apiKey.length>0) {
        //        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self getUserProfile:apiKey];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setThemeConstants{
    
    _viewHeader.backgroundColor = CONSTANT_THEME_COLOR1;
    _btnSignIn.backgroundColor = CONSTANT_THEME_COLOR2;
    [_btnSignIn setTitleColor:CONSTANT_TEXT_COLOR_BUTTONS forState:UIControlStateNormal];
    _lblHeader.textColor =CONSTANT_TEXT_COLOR_HEADER;
    [_lblHeader setFont:FONTS_THEME_REGULAR(19)];
    [_btnSignIn.titleLabel setFont:FONTS_THEME_REGULAR(18)];
    [_btnSignUp.titleLabel setFont:FONTS_THEME_REGULAR(14)];
    [_btnForgotPassword.titleLabel setFont:FONTS_THEME_REGULAR(14)];
    [_txtEmail setFont:FONTS_THEME_REGULAR(16)];
    [_txtPassword setFont:FONTS_THEME_REGULAR(16)];
    [_lblOrSignIn setFont:FONTS_THEME_REGULAR(15)];
    [_btnFacebookLogin.titleLabel setFont:FONTS_THEME_REGULAR(17)];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    if ([segue.identifier isEqualToString:@"VerifyViewController"]) {
        VerifyViewController *view =(VerifyViewController *)[segue destinationViewController];
        view.dictData =sender;
    }
}


-(void)setupTextField:(UITextField*)textField{

    [textField setValue:[UIColor colorWithRed:0.6156862745 green:0.6156862745 blue:0.6235294118 alpha:1]
                    forKeyPath:@"_placeholderLabel.textColor"];
}

- (IBAction)ButtonSignUpPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"SignUpViewController" sender:nil];
}
- (IBAction)ButtonForgotPasswordPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"forgotPasswordViewController" sender:nil];
}

- (IBAction)ButtonBackAction:(id)sender {
    
     [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)ButtonSignIN:(id)sender {
    
    [self.view endEditing:YES];
    if (self.txtPassword.text.length == 0 || self.txtEmail.text.length == 0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Warning!", @"")
                                                                                 message:NSLocalizedString(@"email_invalid_error", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok",@"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
    
    else if (![UtilityClass validateEmailWithString:_txtEmail.text ]){
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Warning!", @"")
                                                                                 message:NSLocalizedString(@"invalid_email", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok",@"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
    else{
        
        
        NSDictionary *dict = @{P_EMAIL:_txtEmail.text, P_PASSWORD:_txtPassword.text };
        
        [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];

        
        [APP_CallAPI gcURL:BASE_URL app:USER_SIGNIN
                            data:dict
                            isShowErrorAlert:NO
                    completionBlock:^(id results, NSError *error) {
                        
                        NSLog(@"%@", error.localizedDescription);
                        
                        if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                            // success
                            
                                                AppDelegate *appdelegate =APP_DELEGATE;
                                                 appdelegate.userDict = [results objectForKey:P_RESPONSE];
                            
                            
                                                  defaults_set_object(P_API_KEY, [appdelegate.userDict objectForKey:P_API_KEY]);
                                                  defaults_set_object(P_USER_DICT, appdelegate.userDict);
                           
                                                 [self updateDeviceToken];
                            
                        }
                        else{
                            [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Warning!", @"")
                                                                                                     message:NSLocalizedString(@"login_error_message", @"")
                                                                                              preferredStyle:UIAlertControllerStyleAlert];
                            //We add buttons to the alert controller by creating UIAlertActions:
                            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok",@"")
                                                                               style:UIAlertActionStyleDefault
                                                                             handler:nil]; //You can use a block here to handle a press on this button
                            [alertController addAction:actionOk];
                            [self presentViewController:alertController animated:YES completion:nil];
                        
                        }
                       
                    }];
    
}
}

-(void)updateDeviceToken{
    
    // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
      AppDelegate *appdelegate =APP_DELEGATE;
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    NSString * deviceToken=[[NSUserDefaults standardUserDefaults] objectForKey:P_DEVICE_TOKEN];
    
    
    if (deviceToken) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                    P_DEVICE_TOKEN :deviceToken,
                                                                                    P_DEVICE_TYPE   :@"ios",
                                                                                    P_USER_ID  :[dict1 objectForKey:P_USER_ID],
                                                                                    
                                                                                    
                                                                                    }];
        
        
        [APP_CallAPI gcURL:BASE_URL app:API_UPDATE_USER_PROFILE
                            data:dict
         isShowErrorAlert:NO
                    completionBlock:^(id results, NSError *error) {
                        if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                            // success
                            
                             appdelegate.userDict =[results objectForKey:P_RESPONSE];
                             defaults_set_object(P_API_KEY, [appdelegate.userDict objectForKey:P_API_KEY]);
                            
                            [self navigateHome];
                            
                            
                        }
                       
                    }];
    }
    else{
    
        [self navigateHome];
    }
    
    
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

- (IBAction)ButtonFacebookSignIn:(id)sender {

    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [login
     logInWithReadPermissions: @[@"public_profile",@"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             
             [self getProfileInfo:[[result token] tokenString]];
             
         }
     }];
}

-(void)getProfileInfo:(NSString *)fbtoken{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                       parameters:@{@"fields": @"picture, email , name, first_name, last_name"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             
          NSString  *email =[result objectForKey:@"email"];
             
             [self SocialLogin:[result objectForKey:@"id"] fb_token:fbtoken fname:[result objectForKey:@"first_name"] lname:[result objectForKey:@"last_name"] email:email];
             
         }
         else{
             NSLog(@"%@", [error localizedDescription]);
         }
     }];
}

-(void)SocialLogin:(NSString *)fb_id fb_token:(NSString *)fbtoken fname:(NSString *)fname lname:(NSString *)lname email:(NSString *)email{
    
    AppDelegate *appdelegate =APP_DELEGATE;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"u_fbid" :fb_id,
                                                                                
                                                                                }];
    
    [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];

    [APP_CallAPI gcURL:BASE_URL app:FB_LOGIN
                        data:dict
     isShowErrorAlert:NO
                completionBlock:^(id results, NSError *error) {
                    if (error ==nil) {
                        
                        appdelegate.userDict =[results objectForKey:P_RESPONSE];
                        defaults_set_object(P_API_KEY, [appdelegate.userDict objectForKey:P_API_KEY]);
                         defaults_set_object(P_USER_DICT, appdelegate.userDict);
                        defaults_set_object(@"isFBLogin", @"Yes");
                        
                        [self updateDeviceToken];
                        // success
                        
                        }
                        else{

                        // [self registerSocial:fb_id fb_token:fbtoken fname:fname lname:lname email:email];
                            
                            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:fb_id,@"u_fbid",fname,P_FNAME,lname,P_LNAME,@"test",P_PASSWORD, nil];
                            
                            
                            if (email.length>0) {
                                [dict setValue:email forKey:P_EMAIL];
                            }
                            else{
                             [dict setValue:@"" forKey:P_EMAIL];
                            }
                            
                            [self performSegueWithIdentifier:@"VerifyViewController" sender:dict];
                           
                        }
                    [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];

                }];

}


-(void)getUserProfile:(NSString *)apikey{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                P_API_KEY :apikey,
                                                                                
                                                                                }];
    
    
    [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
    
    [APP_CallAPI gcURL:BASE_URL app:GET_USER_PROFILE
                        data:dict
     isShowErrorAlert:NO
                completionBlock:^(id results, NSError *error) {
                    if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                        // success
                        
                        AppDelegate *appdelegate =APP_DELEGATE;
                        appdelegate.userDict = [[results objectForKey:P_RESPONSE]objectAtIndex:0];
                        defaults_set_object(P_API_KEY, [appdelegate.userDict objectForKey:P_API_KEY]);
                          defaults_set_object(P_USER_DICT, appdelegate.userDict);
                       // [self navigateHome];
                        [self updateDeviceToken];
                        
                        
                    }
                    [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
                }];
    
    
}





@end
