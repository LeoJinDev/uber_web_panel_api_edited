//
//  Utilities.h
//  TableViewDemo
//
//  Created by Vishal Chikara on 05/03/15.
//  Copyright (c) 2015 Vishal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utilities : NSObject

+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width;
+(CGFloat)imageSizeWithImage: (CGSize) sourceImageSize scaleToWidth: (float) i_width;
+ (CGFloat)getLabelHeight:(CGSize)label forText:(NSString*)textString withFont:(UIFont*)font;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+(NSString *)GetGMTDatetoLocalTZ:(NSString *)strGMTDate;
+(NSDate *)GetGMTDatetoLocalTZ1:(NSString *)strGMTDate;
+(NSString*) getStringFromDate:(NSDate*)date;


@end
