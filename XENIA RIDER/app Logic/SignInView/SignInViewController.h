//
//  SignInViewController.h
//  Store_project
//
//  Created by SFYT on 22/05/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SignInViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblHeader;
@property (strong, nonatomic) IBOutlet UIButton *btnSignUp;
@property (strong, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (strong, nonatomic) IBOutlet UILabel *lblOrSignIn;
@property (strong, nonatomic) IBOutlet UIButton *btnFacebookLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnSignIn;

@end
