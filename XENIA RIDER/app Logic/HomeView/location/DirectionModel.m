//
//  DirectionModel.m
//  XENIA RIDER
//
//  Created by SFYT on 12/06/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import <GrepixKit/GrepixKit.h>
#import "DirectionModel.h"
#import "WebCallConstants.h"
// 

@implementation DirectionModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.distance=0;
        self.arrDirectionLatLng=[[NSMutableArray alloc]  init];
        self.arrManeuvers=[[NSMutableArray alloc] init];
    }
    return self;
}



-(void)zoomToPolyLine: (MKMapView*)map polyline: (MKPolyline*)polyline animated: (BOOL)animated
{
    [map setVisibleMapRect:[polyline boundingMapRect] edgePadding:UIEdgeInsetsMake(40.0, 60.0, 40.0, 60.0) animated:animated];
}





- (void)zoomToFitMapAnnotations:(MKMapView *)mapView    suourceAndDestinationAnnotation:(NSMutableArray  *)arrAnotations
{
 
    [self zoomToFitMapAnnotations:mapView suourceAndDestinationAnnotation:arrAnotations multiplier:2.1];
}



- (void)zoomToFitMapAnnotations:(MKMapView *)mapView    suourceAndDestinationAnnotation:(NSMutableArray  *)arrAnotations  multiplier:(float) multiplier{
    
    
    CLLocationDistance distance = 0.0f;
    
    
    NSLog(@"zoomToFitMapAnnotations called again");
    CLLocation *currentLocation=[self calCenterLoc:arrAnotations];
    
    for (CLLocation *location in self.arrDirectionLatLng) {
        CLLocationDistance distanceTemp =  [currentLocation distanceFromLocation:location];
        if (distanceTemp > distance)
        {
            distance = distanceTemp;
        }
    }
    
    distance *= multiplier;
    
    // setting the min zoom level
    if (distance < SCREEN_WIDTH)
    {
        distance =SCREEN_WIDTH;
    }
    if ( self.arrDirectionLatLng.count > 2) {
        CLLocationCoordinate2D loc = [currentLocation coordinate];
        MKCoordinateRegion region =
        MKCoordinateRegionMakeWithDistance(loc, distance, distance);
        MKCoordinateRegion regionMap = [mapView region];
        MKCoordinateRegion adjustedRegion = [mapView regionThatFits:region];
        BOOL isContained = MKMapRectContainsRect( [self mapRectForCoordinateRegion:regionMap],  [self mapRectForCoordinateRegion:adjustedRegion]);
        // map will adjust zoom only if required.
        if (isContained) {
            [mapView setCenterCoordinate:currentLocation.coordinate];
        }
        else{
            [mapView setRegion:adjustedRegion animated:NO];
        }
    }
}

-(CLLocation *)  calCenterLoc :(NSMutableArray * )arrAnotation
{
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for (id <MKAnnotation> annotation in arrAnotation) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    CLLocation * centLoc=[[CLLocation alloc]  initWithLatitude:region.center.latitude longitude:region.center.longitude];
    return centLoc;
}

- (MKMapRect)mapRectForCoordinateRegion:(MKCoordinateRegion)coordinateRegion
{
    CLLocationCoordinate2D topLeftCoordinate =
    CLLocationCoordinate2DMake(coordinateRegion.center.latitude
                               + (coordinateRegion.span.latitudeDelta/2.0),
                               coordinateRegion.center.longitude
                               - (coordinateRegion.span.longitudeDelta/2.0));
    
    MKMapPoint topLeftMapPoint = MKMapPointForCoordinate(topLeftCoordinate);
    
    CLLocationCoordinate2D bottomRightCoordinate =
    CLLocationCoordinate2DMake(coordinateRegion.center.latitude
                               - (coordinateRegion.span.latitudeDelta/2.0),
                               coordinateRegion.center.longitude
                               + (coordinateRegion.span.longitudeDelta/2.0));
    
    MKMapPoint bottomRightMapPoint = MKMapPointForCoordinate(bottomRightCoordinate);
    
    MKMapRect mapRect = MKMapRectMake(topLeftMapPoint.x,
                                      topLeftMapPoint.y,
                                      fabs(bottomRightMapPoint.x-topLeftMapPoint.x),
                                      fabs(bottomRightMapPoint.y-topLeftMapPoint.y));
    
    return mapRect;
}






-(MKPolyline *) getPolyline
{
    CLLocationCoordinate2D coords[self.arrDirectionLatLng.count];
    
    for (int i = 0; i < self.arrDirectionLatLng.count; i++) {
        CLLocation *location = [self.arrDirectionLatLng objectAtIndex:i];
        coords[i] = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude);
    }
    
    return   [MKPolyline polylineWithCoordinates:coords count:self.arrDirectionLatLng.count];
}
@end
