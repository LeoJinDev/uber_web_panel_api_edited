//
//  RequestViewController.m
//  XENIA RIDER
//
//  Created by SFYT on 13/06/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "RequestViewController.h"
 
#import "WebCallConstants.h"
#import "AppDelegate.h"
//#import "CallAPI.h"
#import <GrepixKit/GrepixKit.h>
#import "TripModel.h"
#import "BeginTripViewController.h"
////#import "nsuserdefaults-helper.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Utilities.h"
@implementation RequestViewController
{
    TripModel * tripModel;
    NSTimer *updateDriverTimer;
    //__weak IBOutlet UILabel *lbMessage;
    NSTimer *timer;
    int secondCout;
    MPMoviePlayerController *moviePlayer;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.viewMessage setHidden:YES];
    [self createTrip];

    [_lbRequest setHidden:YES];
    [_progressBar setHidden:YES];
    [_progressBar setProgress:0];
    NSString *url =
    [[NSBundle mainBundle] pathForResource:@"taxivideo" ofType:@"mp4"];
    moviePlayer = [[MPMoviePlayerController alloc]
                   initWithContentURL:[NSURL fileURLWithPath:url]];
    [moviePlayer.view setFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                          self.view.frame.size.height)];
    moviePlayer.controlStyle = MPMovieControlStyleNone;
    moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    [self.viewVideoContainer addSubview:moviePlayer.view];
    moviePlayer.repeatMode = MPMovieRepeatModeOne;
    [moviePlayer play];
    [self setThemeConstant];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewImageFirst setHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationReceived:) name:@"NotificationReceived" object:nil];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(timer)
    {
        [timer invalidate];
        timer=nil;
    }
    [moviePlayer stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setThemeConstant{

    [_lbRequest setFont:FONTS_THEME_REGULAR(17)];
     [_lblMessage setFont:FONTS_THEME_REGULAR(17)];
     [_lblMessageTitle setFont:FONTS_THEME_REGULAR(22)];
    [_btnOK.titleLabel setFont:FONTS_THEME_REGULAR(17)];
    
}

-(void)onNotificationReceived:(NSNotification *) notification
{
    
    if(updateDriverTimer)
    {
        [updateDriverTimer invalidate];
        updateDriverTimer=nil;
    }
    if(timer)
    {
        [timer invalidate];
        timer=nil;
    }
    [_lbRequest setHidden:YES];
    [_progressBar setHidden:YES];
    [UtilityClass SetLoaderHidden:YES withTitle:@"Wait For Driver Response.."];
    AppDelegate * deleagte=APP_DELEGATE;
    tripModel.trip_Status=deleagte.trip_status;
    defaults_set_object(@"trip_status",tripModel.trip_Status);
//    [lbMessage setText:[NSString stringWithFormat:@"Wow, Your Trip Request has been confirmed. Get Ready %@ %@ ",tripModel.driver.d_fname,tripModel.driver.d_lname]];
    [_lblMessage setText:[NSString stringWithFormat:NSLocalizedString(@"Trip_Confirmed", @"")]];
    
    if([tripModel.trip_Status isEqualToString:TS_ACCEPTED] || [tripModel.trip_Status isEqualToString:TS_ARRIVE]||[tripModel.trip_Status isEqualToString:TS_BEGIN] )
    {
//        [lbMessage setText:[NSString stringWithFormat:@"Wow, Your Trip Request has been confirmed. Get Ready %@ %@ ",tripModel.driver.d_fname,tripModel.driver.d_lname]];
        [self checkTripStatus];
        //[lbMessage setText:[NSString stringWithFormat:@"Your Trip Request has been confirmed. Get Ready"]];
    }
    else{
        
        [_lblMessage setText:[NSString stringWithFormat:NSLocalizedString(@"Driver_Busy", @"")]];
         [self updateTripStatus];
        [self.viewMessage setHidden:NO];
        
    }
    
}



- (IBAction)onButtonTap:(id)sender {
    
    if([tripModel.trip_Status isEqualToString:TS_ACCEPTED]||[tripModel.trip_Status isEqualToString:TS_ARRIVE]||[tripModel.trip_Status isEqualToString:TS_BEGIN])
    {
        [self performSegueWithIdentifier:@"BeginTripViewController" sender:nil];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"BeginTripViewController"])
    {
        BeginTripViewController *vc=(BeginTripViewController *) segue.destinationViewController;
        vc.constantModel =self.constantModel;
        vc.currentTrip=tripModel;
    }
    
}
-(void) createTrip
{
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    NSMutableDictionary  *dict=[[NSMutableDictionary alloc] init];
    [dict  setObject:[dict1  objectForKey:P_API_KEY] forKey:P_API_KEY];
    [dict  setObject:[dict1  objectForKey:P_USER_ID] forKey:P_USER_ID];
    DriverModel * driver=[self.arrDrivers firstObject];
    [dict  setObject:isEmpty(driver.driverId) forKey:@"driver_id"];
    
    [dict  setObject:[NSString stringWithFormat:@"%f",self.directionSource.destination.coordinate.latitude] forKey:@"trip_scheduled_drop_lat"];
    [dict  setObject:[NSString stringWithFormat:@"%f",self.directionSource.destination.coordinate.longitude]   forKey:@"trip_scheduled_drop_lng"];
    [dict  setObject:[NSString stringWithFormat:@"%f",self.directionSource.source.coordinate.latitude]  forKey:@"trip_scheduled_pick_lat"];
    [dict  setObject:[NSString stringWithFormat:@"%f",self.directionSource.source.coordinate.longitude]  forKey:@"trip_scheduled_pick_lng"];
    
    [dict  setObject:isEmpty(self.searchText) forKey:@"trip_search_result_addr"];
    
    [dict  setObject:self.directionSource.dropAddress forKey:@"trip_to_loc"]; // drop
    [dict  setObject:self.directionSource.pickAddress  forKey:@"trip_from_loc"];
    [dict  setObject:TS_REQUEST forKey:TRIP_STATUS];
   // NSDateFormatter * dateFormatter=[[NSDateFormatter alloc] init];
    //[dateFormatter  setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [dict  setObject:[NSString stringWithFormat:@"%@",[Utilities getStringFromDate:[NSDate date]]] forKey:@"trip_date"];
    [dict  setObject:[NSString stringWithFormat:@"%.2f",self.tripDistance] forKey:@"trip_distance"];
    [dict  setObject:[NSString stringWithFormat:@"%.2f",[self.carCategory  calculatePrice:self.tripDistance time:self.tripTime]]  forKey:@"trip_pay_amount"];
    
    [UtilityClass SetLoaderHidden:NO withTitle:@"PLEASE WAIT…"];
    [APP_CallAPI gcURL:BASE_URL app:API_CREATE_TRIP
                        data:dict
     isShowErrorAlert:NO
                completionBlock:^(id results, NSError *error) {
                                        if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                        // success
                        tripModel=[[TripModel alloc]  initItemWithDict:[results objectForKey:P_RESPONSE]];
                                              [self sendNotificationToAllDriver];
                    }
                    else{
//                        [_btBack setHidden:NO];
                          [self.navigationController popViewControllerAnimated:YES];
                        [UtilityClass SetLoaderHidden:YES withTitle:@"PLEASE WAIT…"];
                    }
                }];
}

-(void) targetMethod
{
    if(secondCout>42)
    {
        [timer  invalidate];
        [self .progressBar setProgress:100];
        
        timer=nil;
    }
    [self.progressBar setProgress:(2.2*secondCout)/100.0];
    secondCout++;
}
-(void) sendNotificationToAllDriver
{
    if(tripModel==nil)
    {
        return;
    }
    NSMutableDictionary  *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:@"Hey, You received a new Trip Request. Act Fast" forKey:@"message"];
    [dict setObject:tripModel.trip_Id forKey:@"trip_id"];
    [dict setObject:TS_REQUEST forKey:@"trip_status"];
    NSMutableArray *arrayIosDevices=[[NSMutableArray alloc] init];
    NSMutableArray *arrayAndroidDevices=[[NSMutableArray alloc] init];
    for (DriverModel *dModel in self.arrDrivers) {
        if(dModel.deviceToken.length>0)
        {
            if([dModel  isIos])
            {
                [arrayIosDevices addObject:[NSString stringWithFormat:@"%@",dModel.deviceToken]];
            }
            else{
                [arrayAndroidDevices addObject:[NSString stringWithFormat:@"%@",dModel.deviceToken]];
            }
        }
    }
    if(arrayIosDevices.count>0)
    {
        [dict setObject:[arrayIosDevices componentsJoinedByString:@","] forKey:@"ios"];
    } if(arrayAndroidDevices.count>0)
    {
        
        [dict setObject:[arrayAndroidDevices componentsJoinedByString:@","] forKey:@"android"];
    }

    [dict setObject:@"1" forKey:@"content-available"];
    [APP_CallAPI gcURL:url_notification app:send_driver_notification
                        data:dict
               isShowErrorAlert:NO
                completionBlock:^(id results, NSError *error) {
                    [UtilityClass SetLoaderHidden:YES withTitle:@"PLEASE WAIT…"];
                    if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                        
                    }
                    else{
                        
                    }
                    timer= [NSTimer scheduledTimerWithTimeInterval:1.0
                                                            target:self
                                                          selector:@selector(targetMethod)
                                                          userInfo:nil
                                                           repeats:YES];
                    [_lbRequest setHidden:NO];
                    [_progressBar setHidden:NO];
                    secondCout=0;
                    updateDriverTimer = [NSTimer scheduledTimerWithTimeInterval: 40.0 target: self
                                                                       selector: @selector(checkTripStatus) userInfo: nil repeats: NO];
                } ];
}

-(void) checkTripStatus
{
    
    [tripModel  refreshTripModelWithCompletionBlock:^(id results, NSError *error) {
        [_lbRequest setHidden:YES];
        [_progressBar setHidden:YES];
//        [UtilityClass SetLoaderHidden:YES withTitle:@"Wait For Driver Response.."];
        if([tripModel.trip_Status isEqualToString:TS_ACCEPTED]||[tripModel.trip_Status isEqualToString:TS_ARRIVE]||[tripModel.trip_Status isEqualToString:TS_BEGIN])
        {
        
           
            defaults_set_object(@"trip_status",tripModel.trip_Status);
        
            [_lblMessage setText:[NSString stringWithFormat:NSLocalizedString(@"Trip_Confirmed", @"")]];
        }
        else{
            [_lblMessage setText:[NSString stringWithFormat:NSLocalizedString(@"Driver_Busy", @"")]];
            [self updateTripStatus];
        }
        if(self.delegate)
        {
            [self.delegate  onTripRequestCompletion:tripModel];
        }
        [self.viewMessage setHidden:NO];
    } isShowLoader:NO];
}




- (IBAction)onBackButtonTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateTripStatus{
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]  init];
    [dict setObject:tripModel.trip_Id forKey:@"trip_id"];
    [dict setObject:@"expired" forKey:@"trip_status"];
    
    
    [tripModel updateTripModelWith:dict completionBlock:^(id results, NSError *error) {
        if([[results objectForKey:P_STATUS] isEqualToString:@"OK"])
        {
            
        }
    } isShowLoader:NO isSendNotification:YES];
}
@end
