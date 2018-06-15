//
//  VerifyViewController.m
//  XENIA RIDER
//
//  Created by SFYT on 07/06/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "VerifyViewController.h"
#import "AppDelegate.h"
#import "WebCallConstants.h"
//#import "CallAPI.h"
#import "MBProgressHUD.h"
#import <GrepixKit/GrepixKit.h>
////#import "nsuserdefaults-macros.h"
#import "MainViewController.h"
#import "HomeViewController.h"

@interface VerifyViewController ()

@end

@implementation VerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setThemeConstants];
    _txtFirstName.text =[_dictData objectForKey:P_FNAME];
    _txtLastName.text =[_dictData objectForKey:P_LNAME];
    
    if ([[_dictData objectForKey:P_EMAIL] length]>0) {
        _txtEmail.text = [_dictData objectForKey:P_EMAIL];
    }
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

-(void)setThemeConstants{
    
  
    [_btnNext setTitleColor:CONSTANT_TEXT_COLOR_HEADER forState:UIControlStateNormal];
    _lblHeader.textColor =CONSTANT_TEXT_COLOR_BUTTONS;
    [_lblHeader setFont:FONTS_THEME_REGULAR(19)];
    [_btnNext.titleLabel setFont:FONTS_THEME_REGULAR(18)];
    [_txtEmail setFont:FONTS_THEME_REGULAR(16)];
    [_txtFirstName setFont:FONTS_THEME_REGULAR(16)];
    [_txtLastName setFont:FONTS_THEME_REGULAR(16)];
    [_txtMobile setFont:FONTS_THEME_REGULAR(16)];
    
    
    
    
}

- (IBAction)ButtonNextAction:(id)sender {
    
    AppDelegate *appdelegate =APP_DELEGATE;
    
    if (_txtEmail.text.length ==0 || _txtLastName.text.length ==0 || _txtFirstName.text.length==0 || _txtMobile.text.length ==0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Warning!", @"")
                                                                                 message:NSLocalizedString(@"Please fill all the fields.", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else if (![UtilityClass validateEmailWithString:_txtEmail.text]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Warning!", @"")
                                                                                 message:NSLocalizedString(@"invalid_email", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
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
   
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[_dictData objectForKey:@"u_fbid"],@"u_fbid",_txtFirstName.text,P_FNAME,_txtLastName.text,P_LNAME,@"test",P_PASSWORD,_txtMobile.text,P_MOBILE,_txtEmail.text,P_EMAIL, nil];
    
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
                        
                        
                        appdelegate.userDict =[results objectForKey:P_RESPONSE];
                        defaults_set_object(P_API_KEY, [appdelegate.userDict objectForKey:P_API_KEY]);
                         defaults_set_object(P_USER_DICT, appdelegate.userDict);
                        defaults_set_object(@"isFBLogin", @"Yes");
                        
                        [self navigateHome];
                        
                        
                    }
                  
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

@end
