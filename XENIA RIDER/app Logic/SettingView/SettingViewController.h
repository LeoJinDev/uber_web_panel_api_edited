//
//  SettingViewController.h
//  XENIA RIDER
//
//  Created by SFYT on 07/06/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface SettingViewController : UIViewController<FBSDKSharingDelegate>

@property (strong, nonatomic) IBOutlet UIView *settingView;
@property (strong, nonatomic) IBOutlet UITextField *txtContact1;
@property (strong, nonatomic) IBOutlet UITextField *txtContact2;
@property (strong, nonatomic) IBOutlet UITextField *txtContact3;
@property (strong, nonatomic) IBOutlet UITextField *txtemail1;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail2;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail3;
@property (strong, nonatomic) IBOutlet UILabel *lblHeader;
@property (strong, nonatomic) IBOutlet UIButton *btnAlertViaFacebook;
@property (strong, nonatomic) IBOutlet UIButton *btnAlertViaGmail;
@property (strong, nonatomic) IBOutlet UIButton *lblAlertViaSms;
@property (strong, nonatomic) IBOutlet UIButton *btnSetting;
@property (strong, nonatomic) IBOutlet UILabel *lblEmergencyContact;
@property (strong, nonatomic) IBOutlet UILabel *lblEmergencyEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnContactUpdate;
@property (strong, nonatomic) IBOutlet UIButton *btnEmailUpdate;

@end
