//
//  Utilities.m
//  TableViewDemo
//
//  Created by Vishal Chikara on 05/03/15.
//  Copyright (c) 2015 Vishal. All rights reserved.
//

#import "Utilities.h"


@implementation Utilities


+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(CGFloat)imageSizeWithImage: (CGSize) sourceImageSize scaleToWidth: (float) i_width
{
    float oldWidth = sourceImageSize.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImageSize.height * scaleFactor;
    return newHeight;
}

+ (CGFloat)getLabelHeight:(CGSize)label forText:(NSString*)textString withFont:(UIFont*)font
{
    CGSize constraint = CGSizeMake(label.width, MAXFLOAT);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    
    CGSize boundingBox = [textString boundingRectWithSize:constraint
                                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                               attributes:@{NSFontAttributeName:font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}

- (NSString*)getLabelHeight1:(NSString*)label label2:(NSString*) label2 width:(int)widthR  withFont:(UIFont*)font
{
    CGSize constraint = CGSizeMake(widthR, MAXFLOAT);
    float width;
    
    NSString *strConcat = [NSString stringWithFormat:@"%@ %@", label, label2];
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    
    CGSize boundingBox = [strConcat boundingRectWithSize:constraint
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes:@{NSFontAttributeName:font}
                                                 context:context].size;
    
    width =boundingBox.width;// CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    
    while (width>widthR) {
        NSString *str = [label substringToIndex:label.length - 1];
        [self getLabelHeight1:str label2:label2 width:widthR withFont:font];
    }
    
    
    return strConcat;
    
}

+(NSString *)GetGMTDatetoLocalTZ:(NSString *)strGMTDate {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDate *ts_GMT = [dateFormat dateFromString:strGMTDate];
    
    NSDateFormatter *df_local = [[NSDateFormatter alloc] init];
    [df_local setTimeZone:[NSTimeZone localTimeZone]];
    [df_local setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *strDTLocal = [df_local stringFromDate:ts_GMT];
    return strDTLocal;
}

+(NSDate *)GetGMTDatetoLocalTZ1:(NSString *)strGMTDate {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDate *ts_GMT = [dateFormat dateFromString:strGMTDate];
    
    NSDateFormatter *df_local = [[NSDateFormatter alloc] init];
    [df_local setTimeZone:[NSTimeZone localTimeZone]];
    [df_local setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
   // NSString *strDTLocal = [df_local stringFromDate:ts_GMT];
    return ts_GMT;
}

+(NSString*) getStringFromDate:(NSDate*)date{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [format setTimeZone:gmt];
    
    NSString *stringFromDate = [format stringFromDate:date];
    return stringFromDate;
    
}

@end
