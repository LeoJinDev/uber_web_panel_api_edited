//
//  CustomPointAnnotation.m
//  XENIA RIDER
//
//  Created by Sivilay on 25/10/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "CustomPointAnnotation.h"

@implementation CustomPointAnnotation

-(instancetype) initWithType:(NSString * ) type
{
    self = [super init];
    if (self) {
        self.type=type;
    }
    return self;
}
@end
