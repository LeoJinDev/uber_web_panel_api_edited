//
//  ForgotPasswordViewController.m
//  Store_project
//
//  Created by Sivilay on 25/10/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "WebCallConstants.h"
#import <GrepixKit/GrepixKit.h>
#import "MBProgressHUD.h"
//#import "CallAPI.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    _viewHeader.backgroundColor = CONSTANT_THEME_COLOR1;
    _btnResetPassword.backgroundColor = CONSTANT_THEME_COLOR2;
    [_btnResetPassword setTitleColor:CONSTANT_TEXT_COLOR_BUTTONS forState:UIControlStateNormal];
    _lblHeader.textColor =CONSTANT_TEXT_COLOR_HEADER;
    [_lblHeader setFont:FONTS_THEME_REGULAR(19)];
    [_btnResetPassword.titleLabel setFont:FONTS_THEME_REGULAR(18)];
    
    
    [_txtEmail setFont:FONTS_THEME_REGULAR(16)];
    [_lblEnterYourEmail setFont:FONTS_THEME_REGULAR(12)];
    
}
- (IBAction)ButtonResetPasswordPressed:(id)sender {
    
    if (![UtilityClass validateEmailWithString:_txtEmail.text ]){
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Warning!", @"")
                                                                                 message:NSLocalizedString(@"invalid_email", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok",@"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [self dismissViewControllerAnimated:YES completion:nil];
                                                         }]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
    else{
        
        [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
        
        NSDictionary *dict = @{P_EMAIL:_txtEmail.text };
        
        [APP_CallAPI gcURL:BASE_URL app:DRIVER_CHANGE_PASSWORD
                            data:dict
                    completionBlock:^(id results, NSError *error) {
                        if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                            // success
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                                     message:NSLocalizedString(@"forgot_password_link",@"")
                                                                                              preferredStyle:UIAlertControllerStyleAlert];
                            //We add buttons to the alert controller by creating UIAlertActions:
                            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok",@"")
                                                                               style:UIAlertActionStyleDefault
                                                                             handler:nil]; //You can use a block here to handle a press on this button
                            [alertController addAction:actionOk];
                            [self presentViewController:alertController animated:YES completion:nil];
                            
                        }
                        [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
                    }];
        
    }
    
    
}

- (IBAction)ButtonBackAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
