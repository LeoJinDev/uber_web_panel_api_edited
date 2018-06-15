//
//  UpdateUserCurrentLocation.h
//  TeamJoe
//
//  Created by SFYT on 24/05/16.
//  Copyright © 2016 ZappDesignTemplates. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateUserCurrentLocation : NSObject
+ (UpdateUserCurrentLocation *)sharedInstance ;
/*
  This method is user to update user current loaction after 100 mm or 60 sec
 */
-(void) startUpdateCurrentLocation;
-(void) stopUpdateCurrentLocation;
-(void)updateLocationWhenLogin;
@end
