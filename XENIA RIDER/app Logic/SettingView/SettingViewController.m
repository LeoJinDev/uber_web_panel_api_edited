//
//  SettingViewController.m
//  XENIA RIDER
//
//  Created by SFYT on 07/06/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "WebCallConstants.h"
//#import "CallAPI.h"
#import <GrepixKit/GrepixKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface SettingViewController ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _settingView.hidden=YES;
    
    [self setThemeConstants];
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
    [_lblHeader setFont:FONTS_THEME_REGULAR(19)];
    _lblHeader.textColor = CONSTANT_TEXT_COLOR_HEADER;
    [_lblEmergencyContact setFont:FONTS_THEME_REGULAR(17)];
    [_lblEmergencyEmail setFont:FONTS_THEME_REGULAR(17)];
    [_txtemail1 setFont:FONTS_THEME_REGULAR(14)];
     [_txtEmail2 setFont:FONTS_THEME_REGULAR(14)];
     [_txtEmail3 setFont:FONTS_THEME_REGULAR(14)];
     [_txtContact1 setFont:FONTS_THEME_REGULAR(14)];
     [_txtContact2 setFont:FONTS_THEME_REGULAR(14)];
     [_txtContact3 setFont:FONTS_THEME_REGULAR(14)];
    [_btnEmailUpdate.titleLabel setFont:FONTS_THEME_REGULAR(17)];
    [_btnContactUpdate.titleLabel setFont:FONTS_THEME_REGULAR(17)];
    _btnContactUpdate.backgroundColor =CONSTANT_THEME_COLOR2;
    _btnEmailUpdate.backgroundColor =CONSTANT_THEME_COLOR1;
    [_btnAlertViaGmail.titleLabel setFont:FONTS_THEME_REGULAR(18)];
    [_btnAlertViaFacebook.titleLabel setFont:FONTS_THEME_REGULAR(18)];
    [_lblAlertViaSms.titleLabel setFont:FONTS_THEME_REGULAR(18)];
    _btnAlertViaFacebook.backgroundColor =CONSTANT_THEME_COLOR2;
    _btnAlertViaGmail.backgroundColor = CONSTANT_THEME_COLOR2;
    _lblAlertViaSms.backgroundColor =CONSTANT_THEME_COLOR2;
    _btnSetting.backgroundColor =CONSTANT_THEME_COLOR2;
    _btnEmailUpdate.backgroundColor =CONSTANT_THEME_COLOR2;
}
- (IBAction)ButtonBackAction:(id)sender {
    if (_settingView.isHidden) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        
        _settingView.hidden=YES;
    }
    
    
}

- (IBAction)ButtonUpdateContact:(id)sender {
    
    if (_txtContact1.text.length ==0 && _txtContact2.text.length==0 && _txtContact3.text.length==0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                 message:NSLocalizedString(@"Please enter atleast one Contact", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if (_txtContact1.text.length == 0 ) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                 message:NSLocalizedString(@"mobile_alert", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if (_txtContact2.text.length ==0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                 message:NSLocalizedString(@"mobile_alert", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if (_txtContact3.text.length == 0 ) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                 message:NSLocalizedString(@"mobile_alert", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    [self updateProfile:_txtContact1.text item2:_txtContact2.text item3:_txtContact3.text sender:@"mobile"];
}
- (IBAction)ButtonUpdateEmail:(id)sender {
    
    if (_txtemail1.text.length ==0 && _txtEmail2.text.length==0 && _txtEmail3.text.length==0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                 message:NSLocalizedString(@"invalid_email", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    
    
    
    if (_txtemail1.text.length>0 && ![UtilityClass validateEmailWithString:_txtemail1.text]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                 message:NSLocalizedString(@"invalid_email", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    if (_txtEmail2.text.length>0 && ![UtilityClass validateEmailWithString:_txtEmail2.text]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                 message:NSLocalizedString(@"invalid_email", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if (_txtEmail3.text.length>0 && ![UtilityClass validateEmailWithString:_txtEmail3.text]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                 message:NSLocalizedString(@"invalid_email", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    [self updateProfile:_txtemail1.text item2:_txtEmail2.text item3:_txtEmail3.text sender:@"email"];
    
}

- (IBAction)ButtonFacebook:(id)sender {
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"];
    
    //
    //
    ////    content.hashtag = [FBSDKHashtag hashtagWithString:@"#MadeWithHackbook"];
    //
    ////    FBSDKShareLinkContent  *content = [[FBSDKShareLinkContent alloc] init];
    ////    //content.contentURL = [NSURL URLWithString:@"www.google.co.in"];
    ////    content.quote =@"testing";
    ////    //    [content set]
    ////     content.contentDescription = @"testing";
    ////    content.contentTitle = @"Alert.";
    //
    //    [FBSDKShareDialog showFromViewController:self
    //                                 withContent:content
    //                                    delegate:self];
    //
    ////    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    //    content.contentURL = [NSURL URLWithString:@"http://google.com"];
    //    content.contentTitle = @"teamJOE";
    //    content.imageURL=[NSURL URLWithString:imageUrl ];
    //    content.contentDescription=@"An event-based multi-level, multi-discipline social fitness community of sports enthusiasts (from mall walkers to elite athletes) who want to spontaneously connect \"now\" to walk, run, cycle, swim, hike, golf, ski, weight train, cross-fit, yoga, and more, individually or in groups; or schedule a time/date to meet; and comment and share their fitness lifestyle (via photographs and videos), the gear they wear, facilities and trainers they train with, training techniques and routines, sporting events and competitions they attend and more.";
    [FBSDKShareDialog showFromViewController:nil
                                 withContent:content
                                    delegate:self];
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    NSLog(@"completed");
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    NSLog(@"fail %@",error.description);
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    NSLog(@"cancel");
}

#pragma  mark - Handle  Button  Actions


- (IBAction)ButtonGmail:(id)sender {
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
        
        NSString * email1=    [dict1  objectForKey:@"emergency_email_1"];
        NSString * email2=    [dict1  objectForKey:@"emergency_email_2"];
        NSString * email3=    [dict1  objectForKey:@"emergency_email_3"];
        NSMutableArray  *arrayEmails=[[NSMutableArray alloc]  init];
        if(email1.length>0)
        {
            [arrayEmails addObject:email1];
            
        }
        if(email2.length>0)
        {
            [arrayEmails addObject:email2];
            
        }
        if(email3.length>0)
        {
            [arrayEmails addObject:email3];
        }
        
        [mailCont setToRecipients:arrayEmails];
        [mailCont setSubject:@"SOS Alert"];
        
        NSMutableString *body = [NSMutableString string];
        
        
        NSString *url = [NSString stringWithFormat:@"http://maps.google.com?q=%f,%f",[APP_DELEGATE currLoc].latitude,[APP_DELEGATE currLoc].longitude];
        
        
        [body appendString:[NSString stringWithFormat:@"Please help, I am in danger and need assistance.Follow my location,<a href=\"%@\">Click Here</a> \n ",url]];
        
        [mailCont setMessageBody:body isHTML:YES];
        [self presentViewController:mailCont animated:YES completion:nil];
    }
    else
    {
        [UtilityClass showWarningAlert:@"Whoops!" message:NSLocalizedString(@"Config_Mail", @"") cancelButtonTitle:NSLocalizedString(@"alert_ok", @"") otherButtonTitle:nil];
        
        
    }
    
    
}



- (IBAction)ButtonSms:(id)sender {
    
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    NSMutableString *body = [NSMutableString string];
    NSString *url = [NSString stringWithFormat:@"http://maps.google.com?q=%f,%f",[APP_DELEGATE currLoc].latitude,[APP_DELEGATE currLoc].longitude];
    [body appendString:[NSString stringWithFormat:@"Please help, I am in danger and need assistance.Follow my location,%@.",url]];
    NSString * contactNumber1=    [dict1 objectForKey:@"emergency_contact_1"];
    NSString * contactNumber2=    [dict1  objectForKey:@"emergency_contact_2"];
    NSString * contactNumber3=    [dict1  objectForKey:@"emergency_contact_3"];
    NSMutableArray  *arrayNumber=[[NSMutableArray alloc]  init];
    if(contactNumber1.length>0)
    {
        [arrayNumber addObject:contactNumber1];
        
    }
    if(contactNumber2.length>0)
    {
        [arrayNumber addObject:contactNumber2];
        
    }
    if(contactNumber3.length>0)
    {
        [arrayNumber addObject:contactNumber3];
    }
    
    [self showSMS:[NSString stringWithString:body] number:arrayNumber];
    
    
    
}



- (IBAction)ButtonSetting:(id)sender {
    _settingView.hidden=NO;
}

-(void)updateProfile:(NSString *)item1 item2:(NSString *)item2 item3:(NSString *)item3 sender:(NSString *)sender{
    
    //AppDelegate *appdelegate =APP_DELEGATE;
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                
                                                                                P_USER_ID  :[dict1 objectForKey:P_USER_ID],
                                                                                
                                                                                
                                                                                }];
    
    if ([sender isEqualToString:@"mobile"]) {
        
        if (item1.length>0) {
            
            [dict setValue:item1 forKey:P_EMERGENCY_CONTACT_1];
        }
        
        if (item2.length>0) {
            
            [dict setValue:item2 forKey:P_EMERGENCY_CONTACT_2];
        }
        
        if (item3.length>0) {
            
            [dict setValue:item3 forKey:P_EMERGENCY_CONTACT_3];
        }
        
    }
    else{
        
        if (item1.length>0) {
            
            [dict setValue:item1 forKey:P_EMERGENCY_EMAIL_1];
        }
        
        if (item2.length>0) {
            
            [dict setValue:item2 forKey:P_EMERGENCY_EMAIL_2];
        }
        
        if (item3.length>0) {
            
            [dict setValue:item3 forKey:P_EMERGENCY_CEMAIL_3];
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
                        
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                                 message:NSLocalizedString(@"Successfully_Updated", @"")
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







#pragma  mark -  Mail and Message delegate method


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

- (void)showSMS:(NSString *)message number:(NSArray *)number{
    
    if ([MFMessageComposeViewController canSendText]) {
        
        MFMessageComposeViewController *messageController =
        [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        
        [messageController setBody:message];
        messageController.recipients=number;
        [self presentViewController:messageController animated:YES completion:nil];
    } else {
        NSLog(@"Unable to open message composer by device.");
        UIAlertView *warningAlert =
        [[UIAlertView alloc] initWithTitle:@"Whoops!"
                                   message:@"Your device doesn't support SMS!"
                                  delegate:nil
                         cancelButtonTitle:@"Ok"
                         otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
}

- (void)messageComposeViewController:
(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Failed");
            break;
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}



@end
