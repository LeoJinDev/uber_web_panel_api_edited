//
//  UtilityClass.h
//  Frankly_App
//
//  Created by Vinay Jain on 14/02/14.
//  Copyright (c) 2013 Vinay Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface UtilityClass : NSObject

/**
 * This method shows the alert which has no delegate
 */
+ (void)showWarningAlert:(NSString *)title
                 message:(NSString *)message
       cancelButtonTitle:(NSString *)cancelButtonTitle
        otherButtonTitle:(NSString *)otherButtonTitle;

/**
 * This method shows the alert with the delegate
 */
+ (void)showWarningAlertWithDelegate:(id)delegate
                               title:(NSString *)title
                             message:(NSString *)message
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                    otherButtonTitle:(NSString *)otherButtonTitle
              dontShowAgainCheckShow:(BOOL)show;/////////////

/**
 * This method shows the toast on the screen to intimate
 * the user for 2 seconds
 */
+ (void)ShowToastWithString:(NSString *)text toView:(UIView *)view;
+ (void)ShowToastWithView:(UIView *)viewtoShow toView:(UIView *)view;
+ (void)ShowToastWithView:(UIView *)viewtoShow
                   toView:(UIView *)view
             withDuration:(int)duration;
/**
 * This method validates the email address using regex.
 */
+ (BOOL)validateEmailWithString:(NSString *)strEmail;


/**
 * This method converts the string to date and returns it.
 */
- (NSDate *)GetDateFromString:(NSString *)strDate;

/**
 * This method show/hide the loader on the screen.
 * The ishidden parameter will decide whether the loader should be shown/hide.
 * The title is the text being displayed with the loader.
 */
+ (void)SetLoaderHidden:(BOOL)isHidden withTitle:(NSString *)title;
+ (void)SetLoaderHidden:(BOOL)isHidden
              withTitle:(NSString *)title
         withIntraction:(BOOL)isIntract
               withView:(UIView *)view;

+ (void)SetAllLoadersHidden;

- (void)AddTitleShadowToView:(UIView *)view;

- (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;


/**
 * This method save the screenshot of the view
 */
- (UIImage *)captureView:(UIView *)view;

- (void)popVCFromNavigationVC:(UINavigationController *)navigationVC
                      toIndex:(int)index;

- (UIImage *)compressImage:(UIImage *)image;

- (NSData *)compressImageToData:(UIImage *)image;

- (NSData *)compressImageToData:(UIImage *)image withQuality:(float)compressionQuality;

- (NSString *)GetGMTDatetoLocalTZ:(NSString *)strGMTDate;



- (NSDate *)ExtractDateFromStringTimestamp:(NSString *)timeStamp;

- (NSDate *) toLocalTime:(NSDate*)localDate;

- (CGFloat)getStringHeight:(NSString *)strText withWidth:(int)width withFont:(UIFont *)font;

- (NSString *)encodeString:(NSString *)string;
- (NSString *)decodeString:(NSString *)string;


- (NSString *)getLabelHeight1:(NSString *)label label2:(NSString *)label2 width:(int)widthR withFont:(UIFont *)font;


+ (CGFloat)getLabelHeight:(CGSize)label forText:(NSString*)textString withFont:(UIFont*)font;


+(NSString *)  formatDateWithLocale:(NSString *) stringDate;

+ (void)setCornerRadius:(UIView *)view radius:(int)cornerRadius border:(BOOL)border;
+ (void)setCornerRadius:(UIView *)view radius:(int)cornerRadius borderColor:(UIColor *)borderColor;

@end
