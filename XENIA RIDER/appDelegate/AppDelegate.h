//
//  AppDelegate.h
//  Store_project
//
//  Created by SFYT on 06/02/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <CoreLocation/CoreLocation.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Reachability *internetReachable;
    Reachability *hostReachable;
}
@property(nonatomic) BOOL connectionStatus;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSDictionary *userDict;
@property (nonatomic) CLLocationCoordinate2D currLoc;
@property (strong, nonatomic) NSString *trip_id;
@property (strong, nonatomic) NSString *trip_status;




@end

