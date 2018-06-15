//
//  CustomPointAnnotation.h
//  XENIA RIDER
//
//  Created by Sivilay on 25/10/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CustomPointAnnotation : MKPointAnnotation
@property(strong, nonatomic) NSString *type;
-(instancetype) initWithType:(NSString * ) type;

@end
