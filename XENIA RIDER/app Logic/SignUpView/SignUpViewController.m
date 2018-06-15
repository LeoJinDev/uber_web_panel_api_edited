//
//  SignUpViewController.m
//  Store_project
//
//  Created by SFYT on 22/05/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "SignUpViewController.h"
#import <GrepixKit/GrepixKit.h>
//#import "CallAPI.h"
#import "WebCallConstants.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "HomeViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
////#import "nsuserdefaults-macros.h"
#import "VerifyViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setThemeConstants];
    [self setupTextField:_txtMobile];
    [self setupTextField:_txtLastName];
    [self setupTextField:_txtFirstName];
    [self setupTextField:_txtPassword];
    [self setupTextField:_txtEmail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setThemeConstants{
    
    _viewHeader.backgroundColor = CONSTANT_THEME_COLOR1;
    _btnJoin.backgroundColor = CONSTANT_THEME_COLOR2;
    [_btnJoin setTitleColor:CONSTANT_TEXT_COLOR_BUTTONS forState:UIControlStateNormal];
    _lblHeader.textColor =CONSTANT_TEXT_COLOR_HEADER;
    [_lblHeader setFont:FONTS_THEME_REGULAR(19)];
    [_btnJoin.titleLabel setFont:FONTS_THEME_REGULAR(18)];
    
    [_txtEmail setFont:FONTS_THEME_REGULAR(16)];
    [_txtPassword setFont:FONTS_THEME_REGULAR(16)];
    [_txtFirstName setFont:FONTS_THEME_REGULAR(16)];
    [_txtLastName setFont:FONTS_THEME_REGULAR(16)];
    [_txtMobile setFont:FONTS_THEME_REGULAR(16)];
    [_lblOrSignUpWith setFont:FONTS_THEME_REGULAR(15)];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)ButtonBackAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ButtonJoinPressed:(id)sender {
    
    if (![UtilityClass validateEmailWithString:_txtEmail.text]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert !",@"")
                                                                                 message:NSLocalizedString(@"invalid_email",@"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok",@"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    else if (_txtPassword.text.length<6){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert !",@"")
                                                                                 message:NSLocalizedString(@"password must be atleast 6 character long.",@"") 
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok",@"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    
    
    else if (_txtFirstName.text.length==0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert !", @"")
                                                                                 message:NSLocalizedString(@"firstname_alert", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else if (_txtLastName.text.length==0){
       
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert !", @"")
                                                                                 message:NSLocalizedString(@"lastname_alert", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    else if (_txtMobile.text.length==0  ){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert !", @"")
                                                                                 message:NSLocalizedString(@"mobile_alert", @"")                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    else{
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                    P_EMAIL      :_txtEmail.text,
                                                                                    P_PASSWORD   :_txtPassword.text,
                                                                                    P_FNAME      :_txtFirstName.text,
                                                                                    P_LNAME      :_txtLastName.text,
                                                                                    P_MOBILE     :_txtMobile.text,
                                                                                    }];
        
        NSString * deviceToken=[[NSUserDefaults standardUserDefaults] objectForKey:P_DEVICE_TOKEN];
        
        if (deviceToken.length>0) {
            
            [dict  setObject:deviceToken forKey:P_DEVICE_TOKEN];
            [dict  setObject:@"ios" forKey:P_DEVICE_TYPE];
        }
        
        
        [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
        
        
        [APP_CallAPI gcURL:BASE_URL app:USER_SIGNUP
                            data:dict
         isShowErrorAlert:NO
                    completionBlock:^(id results, NSError *error) {
                        
                        if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                            // success
                            
                            
                            
                            AppDelegate *appdelegate =APP_DELEGATE;
                            
                            appdelegate.userDict = [results objectForKey:P_RESPONSE];
                            
                            defaults_set_object(P_API_KEY, [appdelegate.userDict objectForKey:P_API_KEY]);
                             defaults_set_object(P_USER_DICT, appdelegate.userDict);
                            
                            [self navigateHome];
                            
                            
                        }
                         [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
                        
                    }];
        
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


- (IBAction)ButtonFacebookSignUp:(id)sender {

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
                    
                }];
    
}

-(void)updateDeviceToken{
    
    // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AppDelegate *appdelegate =APP_DELEGATE;
    NSString * deviceToken=[[NSUserDefaults standardUserDefaults] objectForKey:P_DEVICE_TOKEN];
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    
    if (deviceToken) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                    P_DEVICE_TOKEN :deviceToken,
                                                                                   P_DEVICE_TYPE   :@"ios",
                                                                                    P_USER_ID   :[dict1 objectForKey:P_USER_ID],
                                                                                    
                                                                                    
                                                                                    }];
        
        
        [APP_CallAPI gcURL:BASE_URL app:API_UPDATE_USER_PROFILE
                            data:dict
         isShowErrorAlert:NO
                    completionBlock:^(id results, NSError *error) {
                        if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                            // success
                            
                            appdelegate.userDict =[results objectForKey:P_RESPONSE];;
                            
                            [self navigateHome];
                            
                            
                        }
                        
                    }];
    }
    else{
        
        [self navigateHome];
    }
    
    
}



@end
