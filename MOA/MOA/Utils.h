//
//  Utils.h
//  This class contains helper functions
//  MOA
//
//  Created by Diana Sutandie on 2/6/2014.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

// this functions alter the height of textView automatically, and returns the height of the view.
+ (int)textViewDidChange:(UITextView *)textView;

// These functions convert a date format
// From: 01/01/2014
// To: January 1, 2014
+(NSString*)convertDate:(NSString*) short_date;
+(NSString*)convertMonthToString:(NSString*) month_numeric;
+(NSDictionary* )PullRemoteData:(NSString* )url;
+(NSString*)ValidateJSONFormat:(NSString *)json;

@end
