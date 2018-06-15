//
//  AppDelegate.m
//  Store_project
//
//  Created by SFYT on 06/02/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "AppDelegate.h"
#import "WebCallConstants.h"
#import <GrepixKit/GrepixKit.h>
#import <AudioToolbox/AudioServices.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@import GoogleMaps;
@import GooglePlaces;
@import Bugsee;
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <Stripe/Stripe.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [GMSServices provideAPIKey:GOOGLE_API_KEY];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
//    
//    NSDictionary * options = @{
//                               BugseeShakeToReportKey      : BugseeTrue,
//                               BugseeScreenshotToReportKey : BugseeTrue,
//                               BugseeCrashReportKey        : BugseeTrue
//                               };
    
    [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:STRIPE_TEST_KEY];
   // [Bugsee launchWithToken:@"41658695-7601-404a-8fc5-66510027b319" andOptions:options];
    
             [Fabric with:@[[Crashlytics class]]];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
#ifdef __IPHONE_8_0
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound |
                                                UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
#endif
    } else {
        
        //        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        //        [application registerForRemoteNotificationTypes:myTypes];
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }    return YES;
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    // Add any custom logic here.
    return handled;
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Unable to Register for push notificaitons : %@",error.localizedDescription);
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

//For interactive notification only
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if (application.applicationState == UIApplicationStateBackground) {
        
        NSLog(@"application Background - notification has arrived when app was in background");
        NSString* contentAvailable = [NSString stringWithFormat:@"%@", [[userInfo valueForKey:@"aps"] valueForKey:@"content-available"]];
        
        if([contentAvailable isEqualToString:@"1"]) {
            // do tasks
            [self manageRemoteNotification:userInfo application:application];
            NSLog(@"content-available is equal to 1");
            completionHandler(UIBackgroundFetchResultNewData);
        }
    }
    else {
        NSLog(@"application Active - notication has arrived while app was opened");
        //Show an in-app banner
        //do tasks
        [self manageRemoteNotification:userInfo application:application];
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *) deviceToken {
    
    
    NSString *strDeviceToken =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    //    _deviceToken =strDeviceToken;
    
    NSLog(@"Device token %@", strDeviceToken);
    
    [[NSUserDefaults standardUserDefaults]setObject:strDeviceToken forKey:P_DEVICE_TOKEN];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:strDeviceToken delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //        [alert show];
    
    
    // defaults_set_object(@"deviceToken", );
    
}


-(void)manageRemoteNotification:(NSDictionary *)userInfo application:(UIApplication *)application{
    
    
    NSLog(@"%@",userInfo);
    
    if (application.applicationState == UIApplicationStateActive) {
        
        SystemSoundID completeSound;
        NSURL *audioPath = [[NSBundle mainBundle] URLForResource:@"Alert" withExtension:@"mp3"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)audioPath, &completeSound);
        AudioServicesPlaySystemSound (completeSound);
    }
    
    NSMutableDictionary *dicAps=[userInfo valueForKey:@"aps"];
    //application.applicationIconBadgeNumber = [[dicAps objectForKey: @"badge"] intValue];
    self.trip_id= [dicAps objectForKey:@"trip_id"];
    self.trip_status= [dicAps objectForKey:@"trip_status"];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"NotificationReceived"
     object:userInfo];
    //
    //            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",userInfo] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //            [alert show];
}

/**
 * This method validates whether the internet is reachable or not
 */
- (void)checkNetworkStatus:(NSNotification *)notice {
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus) {
        case NotReachable: {
            
            if (self.connectionStatus) {
                [UtilityClass showWarningAlertWithDelegate:self
                                                     title:NSLocalizedString(@"Network Error",@"")
                                                   message:NSLocalizedString(@"network_error", @"")
                                         cancelButtonTitle:NSLocalizedString(@"alert_ok", @"")
                                          otherButtonTitle:nil
                                    dontShowAgainCheckShow:NO];
            }
            
            self.connectionStatus = FALSE;
            break;
        }
        case ReachableViaWiFi:
        case ReachableViaWWAN: {
            self.connectionStatus = TRUE;
            
            break;
        }
    }
}

@end
