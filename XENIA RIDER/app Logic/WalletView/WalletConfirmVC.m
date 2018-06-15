//
//  WalletConfirmVC.m
//  XENIA RIDER
//
//  Created by Clean on 4/24/18.
//  Copyright © 2018 Grepixit. All rights reserved.
//

#import "WalletConfirmVC.h"
#import "LeftViewController.h"
#import "WebCallConstants.h"
#import "AppDelegate.h"
#import <GrepixKit/GrepixKit.h>
//#import <AFNetworking.h>

@interface WalletConfirmVC ()

@end

@implementation WalletConfirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setCardImage];
}
-(void) setCardImage
{
    NSString *Card_Type=[[NSUserDefaults standardUserDefaults] objectForKey:WC_TYPE];
    _img_cardholder.contentMode=UIViewContentModeScaleToFill;
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
}
- (IBAction)showWalletInviteVC:(id)sender {
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults] objectForKey:P_USER_DICT];
    // _lblholderName.text = [[dict1 objectForKey:P_FNAME] stringByAppendingString:[dict1 objectForKey:P_LNAME]];
    //_lblholderName.text =[dict1 objectForKey:P_EMAIL];
    //_txtMobile.text =[dict1 objectForKey:P_MOBILE];
    //_txtFirstName.text =[dict1 objectForKey:P_FNAME];
    //_txtLastName.text =[dict1 objectForKey:P_LNAME];
    
    //[self setTransferData];
    [self PostJson];
    //[self setInvite];
    

}
-(void) setTransferData
{
    
     //  [manager.requestSerializer setValue:XC_TOKEN forHTTPHeaderField:@"access_token"];
     NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults] objectForKey:P_USER_DICT];
     NSString *set_card_holder_url=[NSString stringWithFormat:@"%@%@",XC_Platform_Link,XC_SET_CARD_PREORDER];
     NSDictionary *params = @{@"access_token":XC_TOKEN,
     @"card_requests":@{
     @"request_from": @"xenia_teller",
     XC_Email : [dict1 objectForKey:P_EMAIL],
     XC_NAME : [[dict1 objectForKey:P_FNAME] stringByAppendingString:[dict1 objectForKey:P_LNAME]]
     }
     
     };
     
     [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
     
     
     [APP_CallAPI gcURL:XC_Platform_Link app:XC_SET_CARD_PREORDER
     data:params
     isShowErrorAlert:NO
     completionBlock:^(id results, NSError *error) {
     
     
         NSLog(@"%@", results);
         NSString *i=@"fe";
     if([i isEqualToString:@"fe"])// ([[results objectForKey:P_STATUS] isEqualToString:@"success"]) {
     // success
     {
     
     NSLog(@"%@", results);
     [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
     
     
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
-(void) setInvite
{
    //NSString *post = @"postKey=postVar";
    //NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    //NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults] objectForKey:P_USER_DICT];
    NSString *set_card_holder_url=[NSString stringWithFormat:@"%@%@",XC_Platform_Link,XC_SET_CARD_PREORDER];
    NSString *postData=[NSString stringWithFormat:@"card_requests[request_from]=%@&card_requests[email]=%@&card_requests[name]=%@&access_token=%@", @"xenia_teller",[dict1 objectForKey:P_EMAIL],[[dict1 objectForKey:P_FNAME] stringByAppendingString:[dict1 objectForKey:P_LNAME]],XC_TOKEN];
    NSString *finalURL=[set_card_holder_url stringByAppendingString:@"?"];
    finalURL=[finalURL stringByAppendingString:postData];
    
    NSURL *url = [NSURL URLWithString:finalURL];
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    //[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (data == nil) {
                                          [self printCannotLoad];
                                      } else {
                                          [self parseWeatherJSON:data];
                                      }
                                  }];
    [task resume];

}
- (void) parseWeatherJSON:(NSData *) jsonData {
    NSError *error = nil;
    id object = [NSJSONSerialization
                 JSONObjectWithData:jsonData
                 options:0
                 error:&error];
    
    if(error) {
        [self printCannotLoad];
        return;
    }
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *mainObject = [object valueForKey:@"main"];
        NSDictionary *weatherObject = [object valueForKey:@"weather"][0];
        NSString *textString = [NSString stringWithFormat:@"%@, %@ celsius", weatherObject[@"description"], mainObject[@"temp"]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            //[[NSUserDefaults standardUserDefaults] setObject:[decodedData[@"id"] stringValue] forKey:WC_PREORDERCARD_ID];
            
            [self setViewControllers:@"WalletInviteVC"];
        });
    } else {
        [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Warning!", @"")
                                                                                 message:NSLocalizedString(@"api_communication_error", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok",@"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        [self navigateHome];    }
}

- (void) printCannotLoad {
    dispatch_sync(dispatch_get_main_queue(), ^{
        [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Warning!", @"")
                                                                                 message:NSLocalizedString(@"api_communication_error", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok",@"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        [self navigateHome];
    });
}

-(void)PostJson {
    [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
    NSInteger success = 1;
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults] objectForKey:P_USER_DICT];
    NSString *set_card_holder_url=[NSString stringWithFormat:@"%@%@",XC_Platform_Link,XC_SET_CARD_PREORDER];
    NSDictionary *params = @{@"access_token":XC_TOKEN,
                             @"card_requests":@{
                                     @"request_from": @"xenia_teller",
                                     XC_Email : [dict1 objectForKey:P_EMAIL],
                                     XC_NAME : [[dict1 objectForKey:P_FNAME] stringByAppendingString:[dict1 objectForKey:P_LNAME]]
                                     }
                             
                             };
    
    NSURL *url = [NSURL URLWithString:set_card_holder_url];
    NSData *postData = [[[NSString alloc] initWithFormat:@"card_requests[request_from]=%@&card_requests[email]=%@&card_requests[name]=%@&access_token=%@", @"xenia_teller",[dict1 objectForKey:P_EMAIL],[[dict1 objectForKey:P_FNAME] stringByAppendingString:[dict1 objectForKey:P_LNAME]],XC_TOKEN] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:postData];
    
    NSError *requestError = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:&response
                                                        error:&requestError];
    __weak MainViewController *mainViewController=(MainViewController *)self.sideMenuController;
  //  dispatch_queue_t queue = dispatch_queue_create("Q", NULL);
    //dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0
                                                 ), ^(void){
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if ([response statusCode] >= 200 && [response statusCode] < 300) {
                    NSError *serializeError = nil;
                    NSDictionary *jsonData = [NSJSONSerialization
                                              JSONObjectWithData:urlData
                                              options:NSJSONReadingMutableContainers
                                              error:&serializeError];
                    
                    NSArray* data=jsonData;
                    NSMutableDictionary* decodedData=[data objectAtIndex:0];
                    
                    if([decodedData[@"status"] isEqualToString:@"success"])
                    {
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[decodedData[@"id"] stringValue] forKey:WC_PREORDERCARD_ID];
                        [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
                        [self setViewControllers:@"WalletInviteVC"];
                        
                        //      MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
                        
                        //[self performSegueWithIdentifier:@"WalletinviteVC" sender:self];
                        //success! do stuff with the jsonData dictionary here
                    }
                    else
                    {
                        [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Warning!", @"")
                                                                                                 message:NSLocalizedString(@"api_communication_error", @"")
                                                                                          preferredStyle:UIAlertControllerStyleAlert];
                        //We add buttons to the alert controller by creating UIAlertActions:
                        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok",@"")
                                                                           style:UIAlertActionStyleDefault
                                                                         handler:nil]; //You can use a block here to handle a press on this button
                        [alertController addAction:actionOk];
                        [self presentViewController:alertController animated:YES completion:nil];
                        [self navigateHome];
                    }
                    
                }
                else {
                    
                    [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Warning!", @"")
                                                                                             message:NSLocalizedString(@"api_communication_error", @"")
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                    //We add buttons to the alert controller by creating UIAlertActions:
                    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok",@"")
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:nil]; //You can use a block here to handle a press on this button
                    [alertController addAction:actionOk];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self navigateHome];
                    //handle error for unsuccessful communication with server
                }
            });
        });
        //if communication was successful
        //});
}

-(void)setViewControllers:(NSString *)sender{
    
    
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
    UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
    UIViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:sender];
    
    [navigationController pushViewController:viewController animated:YES];
    [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
    
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

@end
