//
//  EditProfileViewController.m
//  Store_project
//
//  Created by Sivilay on 25/10/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "EditProfileViewController.h"
#import <GrepixKit/GrepixKit.h>
//#import "CallAPI.h"
#import "WebCallConstants.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+LGSideMenuController.h"
//#import "Base64.h"

@interface EditProfileViewController ()
@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _viewPassword.alpha=0;
    [self setThemeConstants];
    [self setupTextField:_txtMobile];
    [self setupTextField:_txtLastName];
    [self setupTextField:_txtFirstName];
    [self setupTextField:_txtNewPassword];
    [self setupTextField:_txtOldPassword];
    [self setupTextField:_txtConfirmPassword];
    [self.imgProfile.layer setBorderWidth:2];
    [self.imgProfile.layer setBorderColor:[UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1].CGColor];
    
    _spinnerView.hidden=YES;
    [self setData];
    
  

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setThemeConstants{
    
    _viewHeader.backgroundColor = CONSTANT_THEME_COLOR1;
    _btnSave.backgroundColor = CONSTANT_THEME_COLOR2;
    [_btnSave setTitleColor:CONSTANT_TEXT_COLOR_BUTTONS forState:UIControlStateNormal];
    _lblHeader.textColor =CONSTANT_TEXT_COLOR_HEADER;
    [_lblHeader setFont:FONTS_THEME_REGULAR(19)];
    [_btnSave.titleLabel setFont:FONTS_THEME_REGULAR(18)];
    [_txtEmail setFont:FONTS_THEME_REGULAR(16)];
    [_txtFirstName setFont:FONTS_THEME_REGULAR(16)];
    [_txtLastName setFont:FONTS_THEME_REGULAR(16)];
    [_txtMobile setFont:FONTS_THEME_REGULAR(16)];
    [_txtOldPassword setFont:FONTS_THEME_REGULAR(16)];
    [_txtNewPassword setFont:FONTS_THEME_REGULAR(16)];
    [_txtConfirmPassword setFont:FONTS_THEME_REGULAR(16)];
    [_lblChangePassword setFont:FONTS_THEME_REGULAR(16)];
    
    
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
}



-(void)setupTextField:(UITextField*)textField{
    
    [textField setValue:[UIColor colorWithRed:0.6156862745 green:0.6156862745 blue:0.6235294118 alpha:1]
             forKeyPath:@"_placeholderLabel.textColor"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
   
    
}

-(void)setData{
   // AppDelegate *appdelegate =APP_DELEGATE;
    
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    
    _txtEmail.text =[dict1 objectForKey:P_EMAIL];
    _txtMobile.text =[dict1 objectForKey:P_MOBILE];
    _txtFirstName.text =[dict1 objectForKey:P_FNAME];
    _txtLastName.text =[dict1 objectForKey:P_LNAME];
    
    NSString *profile=[dict1 objectForKey:P_PROFILE_IMAGE_PATH];
    
    if (profile.length>0) {
        
        // [_imgProfile sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url_base_images, profile]]];
        
        [_imgProfile sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url_base_images, profile]] placeholderImage:[UIImage imageNamed:@"Profile Icon Crop Image"]];
    }
    
}


- (IBAction)ButtonSavePressed:(id)sender {
    
   // AppDelegate *appdelegate =APP_DELEGATE;
    
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    
    if (_txtMobile.text.length==0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert !", @"")
                                                                                 message:NSLocalizedString(@"mobile_alert", @"")                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    if(_txtEmail.text>0 && ![UtilityClass validateEmailWithString:_txtEmail.text]){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert !", @"")
                                                                                 message:NSLocalizedString(@"Email_Error", @"")                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
        
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                
                                                                                P_USER_ID          :[dict1 objectForKey:P_USER_ID],
                                                                                P_FNAME            : _txtFirstName.text,
                                                                                P_LNAME             : _txtLastName.text,
                                                                                P_MOBILE            : _txtMobile.text,
                                                                                
                                                                                }];
    
    
    if (_switchChangePass.isOn) {
        
        if ([self checkPasswordValidity]) {
            
            [self updatePassword];
            return;
        }
        else{
            return;
        }
        
    }
    
    
    
    [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
    
    [APP_CallAPI gcURL:BASE_URL app:API_UPDATE_USER_PROFILE
                        data:dict
                      isShowErrorAlert:NO
                completionBlock:^(id results, NSError *error) {
                    if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                        // success
                        
                        AppDelegate *appdelegate =APP_DELEGATE;
                        
                        appdelegate.userDict = [results objectForKey:P_RESPONSE];
                        defaults_set_object(P_USER_DICT,appdelegate.userDict );
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"change_profile" object:nil];
                        if (_switchChangePass.isOn) {
                            [[NSUserDefaults standardUserDefaults]setObject:_txtNewPassword.text forKey:@"password"];
                        }
                        
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                                 message:NSLocalizedString(@"Profile Updated", @"")
                                                                                          preferredStyle:UIAlertControllerStyleAlert];
                        //We add buttons to the alert controller by creating UIAlertActions:
                        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                                           style:UIAlertActionStyleDefault
                                                                         handler:nil]; //You can use a block here to handle a press on this button
                        [alertController addAction:actionOk];
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                        
                        
                    }
                    [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
                }];
    
    
}

-(void)updatePassword{
    
   // AppDelegate *appdelegate =APP_DELEGATE;
    
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    
    if (_txtMobile.text.length==0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert !", @"")
                                                                                 message:NSLocalizedString(@"mobile_alert", @"")                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                
                                                                                P_USER_ID          :[dict1 objectForKey:P_USER_ID],
                                                                                P_PASSWORD        : _txtOldPassword.text,
                                                                                P_NEW_PASSWORD       : _txtNewPassword.text,
                                                                                P_FNAME             : _txtFirstName.text,
                                                                                P_LNAME             : _txtLastName.text,
                                                                                P_MOBILE           : _txtMobile.text,
                                                                                
                                                                                }];
    
    
    [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
    
    [APP_CallAPI gcURL:BASE_URL app:UPDATE_USER_PASSWORD
                        data:dict
                    isShowErrorAlert:NO
                completionBlock:^(id results, NSError *error) {
                    if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                        // success
                        
                        AppDelegate *appdelegate =APP_DELEGATE;
                        appdelegate.userDict = [results objectForKey:P_RESPONSE];
                        defaults_set_object(P_USER_DICT,appdelegate.userDict );
                        
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"change_profile" object:nil];
                        
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                                 message:NSLocalizedString(@"Password Updated", @"")
                                                                                          preferredStyle:UIAlertControllerStyleAlert];
                        //We add buttons to the alert controller by creating UIAlertActions:
                        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                                           style:UIAlertActionStyleDefault
                                                                         handler:nil]; //You can use a block here to handle a press on this button
                        [alertController addAction:actionOk];
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                        
                        
                    }
                    else{
                        
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                                 message:NSLocalizedString(@"Password alert", @"")
                                                                                          preferredStyle:UIAlertControllerStyleAlert];
                        //We add buttons to the alert controller by creating UIAlertActions:
                        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                                           style:UIAlertActionStyleDefault
                                                                         handler:nil]; //You can use a block here to handle a press on this button
                        [alertController addAction:actionOk];
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                    }
                    [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
                }];
}
- (IBAction)ButtonProfileTapped:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}
- (IBAction)ButtonBackPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)checkPasswordValidity{
    
    
    if (_txtOldPassword.text.length==0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert !"
                                                                                 message:NSLocalizedString(@"Password_old_alert", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return NO;
    }
    
    else if (_txtNewPassword.text.length<6){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert !"
                                                                                 message:NSLocalizedString(@"password must be atleast 6 character long.", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return NO;
    }
    
    else if (![_txtNewPassword.text isEqualToString:_txtConfirmPassword.text]){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert !"
                                                                                 message:NSLocalizedString(@"password not matching", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        return NO;
    }
    else  if (_txtMobile.text.length==0){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert !"
                                                                                 message:NSLocalizedString(@"mobile_alert", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return NO;
    }
    return YES;
    
}
- (IBAction)switchChange:(UISwitch *)sender {
    
    if (sender.isOn) {
        
        _viewPassword.alpha=1;
    }
    else{
        
        _viewPassword.alpha=0;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    AppDelegate *appdelegate =APP_DELEGATE;
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    _spinnerView.hidden=NO;
    [_spinnerView startAnimating];
    
    UIImage *resizeImage= [self imageWithImage:chosenImage scaledToSize:CGSizeMake(300, 300)];
    
    
    [Base64 initialize];
    NSString *strImage =[Base64 encode:UIImagePNGRepresentation(resizeImage)];
    
    NSDictionary * dict=@{@"api_key":[dict1 objectForKey:P_API_KEY],@"user_id":[dict1 objectForKey:@"user_id"],@"image_type":@"jpg",@"user_image":strImage};
    
    [APP_CallAPI gcURL:BASE_URL app:API_UPDATE_USER_PROFILE
                        data:dict
                    isShowErrorAlert:NO
       completionBlock:^(id results, NSError *error) {
                            if([[results objectForKey:P_STATUS] isEqualToString:@"OK"])
                            {
                                appdelegate.userDict = [results objectForKey:P_RESPONSE];
                                defaults_set_object(P_USER_DICT,appdelegate.userDict );
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"change_profile" object:nil];
                                NSString *profile=[appdelegate.userDict objectForKey:@"u_profile_image_path"];
                                if (profile.length>0) {
                                    [_imgProfile sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url_base_images, profile]] placeholderImage:[UIImage imageNamed:@"Profile Icon Crop Image"]];
                                }
                            }
                            _spinnerView.hidden=YES;
                            [_spinnerView stopAnimating];
                        }];
}


-(NSString *)encodeImageToBase64String:(UIImage *)image
{
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (IBAction)ButtonUploadDocuments:(id)sender {
    
    [self performSegueWithIdentifier:@"UploadDocumentViewController" sender:nil];
}

@end
