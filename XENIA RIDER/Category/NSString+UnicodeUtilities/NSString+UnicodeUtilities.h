//
//  NSString+UnicodeUtilities.h
//  Application
//
//  Created by SFYT on 21/05/14.
//  Copyright (c) 2014 SFYT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UnicodeUtilities)
+ (NSString*) unescapeUnicodeString:(NSString*)string;
+ (NSString*) escapeUnicodeString:(NSString*)string;

@end
