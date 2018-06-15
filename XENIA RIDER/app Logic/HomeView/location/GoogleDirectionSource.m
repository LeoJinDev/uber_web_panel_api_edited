//
//  GoogleDirectionSource.m
//  XENIA RIDER
//
//  Created by SFYT on 12/06/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "GoogleDirectionSource.h"
// 
#import "WebCallConstants.h"
#import <GrepixKit/GrepixKit.h>
#import "AFHTTPRequestOperationManager.h"

@interface GoogleDirectionSource()
{
    int apiCounter;
}
@end


@implementation GoogleDirectionSource
-(instancetype)initWithSource:(CLLocation *) source destination:(CLLocation *) destination
{
    self=[self init];
    self.source=source;
    self.destination=destination;
    return self;
}

-(void) findDirection_isInTrip:(BOOL)isInTrip WithCompletionBlock:(void (^)(id results, NSError *error)) block
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    
    NSString *googleKey;
    switch (apiCounter) {
        case 1:
            googleKey = GOOGLE_API_KEY;
            break;
        case 2:
            googleKey = GOOGLE_API_KEY_2;
            break;
        default: googleKey = GOOGLE_API_KEY_3;
            break;
    }
    
    NSLog(@"api counter: %d", apiCounter);
    
    NSString *urlString = [NSString stringWithFormat:
                           @"%@?origin=%f,%f&destination=%f,%f&sensor=true&key=%@&mode=driving",
                           @"https://maps.googleapis.com/maps/api/directions/json",
                           self.source.coordinate.latitude,
                           self.source.coordinate.longitude,
                           self.destination.coordinate.latitude,
                           self.destination.coordinate.longitude,
                           googleKey];
    
    
    [manager GET:urlString parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSDictionary *response = [[NSDictionary alloc] initWithDictionary:responseObject];
             if ([response objectForKey:@"error_message"] /*&& !isInTrip*/){    //[[response objectForKey:@"status"] isEqualToString:@"OVER_QUERY_LIMIT"]
                 
                 if (apiCounter>=2) {   //  //
                     [UtilityClass showWarningAlert:@"" message:NSLocalizedString(@"Contact Service Provider",@"") cancelButtonTitle:@"Ok" otherButtonTitle:nil];
                     //NSError *error = nil;
                     //block(nil,error);
                     block([self directionRoute:responseObject],nil);
                 }
                 else {
                     apiCounter++;
                     [self findDirection_isInTrip:isInTrip WithCompletionBlock:block];
                 }
             }
             else {
                 block([self directionRoute:responseObject],nil);
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             block(nil,error);
         }];
}

-(DirectionModel *)directionRoute:(NSDictionary *)response
{
    NSMutableArray *arrTrackedPoints =[[NSMutableArray alloc]init];
   NSMutableArray *arrManeuver =[[NSMutableArray alloc]init];
    float distanceMiles=0;
    float duration=0;
    if([[response objectForKey:P_STATUS] isEqualToString:@"OK"])
    {
        NSArray * routes=[response objectForKey:@"routes"];
        for(int i=0;i<routes.count;i++){
            NSArray  *jLegs = [( (NSDictionary *)[routes objectAtIndex:i]) objectForKey:@"legs"];
            
          
            
            for(int j=0;j<jLegs.count;j++){
                NSDictionary * dictLeg=[ jLegs objectAtIndex:j];
                
                // distance and time calculation
                   distanceMiles = [[[dictLeg objectForKey:@"distance"]objectForKey:@"value"] floatValue];
                 duration = [[[dictLeg objectForKey:@"duration"]objectForKey:@"value"] floatValue]/60;
                distanceMiles = distanceMiles/1000;
                
                NSArray *steps=[dictLeg objectForKey:@"steps"];
                
                for(int k=0;k<steps.count;k++){
                    
                    NSDictionary *step=[steps objectAtIndex:k];
                    NSString *points=   [[step objectForKey:@"polyline"]  objectForKey:@"points"];
                    //Maneuver
                    NSString *maneuver=[step objectForKey:@"maneuver"];
                    if(maneuver)
                    {
                        CLLocation *p=[[CLLocation alloc] initWithLatitude:[[[step objectForKey:@"start_location"] objectForKey:@"lat"] doubleValue] longitude:[[[step objectForKey:@"start_location"] objectForKey:@"lng"] doubleValue]];
                        NSDictionary *dict=@{@"Maneuver":[step objectForKey:@"maneuver"],@"html_instructions":[step objectForKey:@"html_instructions"],@"start_location":p};
                        
                        [arrManeuver addObject:dict];
                    }
                    NSArray * decodepoints=[self decodePoints:points];
                    for (CLLocation * lo in decodepoints) {
                        [arrTrackedPoints addObject:lo];
                    }
                }
            }
        }
    }
    else{
        
    }
    DirectionModel * dModel=[[DirectionModel alloc]  init];
    dModel.arrDirectionLatLng=arrTrackedPoints;
    dModel.arrManeuvers=arrManeuver;
    dModel.distance=distanceMiles;
    dModel.duration=duration;
    return  dModel;
    
}
-( NSArray *) decodePoints:(NSString *) encoded
{
    NSMutableArray *poly=[[NSMutableArray alloc] init];
    int index = 0;
    int len = (int)encoded.length;
    int lat = 0, lng = 0;
    
    while (index < len) {
        int b, shift = 0, result = 0;
        do {
            
            //            b = encoded.charAt(index++) - 63;
            b =  [encoded characterAtIndex:index++]- 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        
        shift = 0;
        result = 0;
        do {
            b =  [encoded characterAtIndex:index++]- 63;
            //            b = encoded.charAt(index++) - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        //        LatLng p = new LatLng((((double) lat / 1E5)),
        //                              (((double) lng / 1E5)));
        //        poly.add(p);
        CLLocation *p=[[CLLocation alloc] initWithLatitude:(((double) lat / 1E5)) longitude:(((double) lng / 1E5))];
        [poly addObject:p];
    }
    return poly;
}

@end
