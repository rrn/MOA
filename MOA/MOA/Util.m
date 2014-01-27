//
//  Util.m
//  MOA
//
//  Created by Diana Sutandie on 1/26/2014.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import "Util.h"

@implementation Util

+(NSDate*)parseDateString:(NSString *)dateString
{
    NSDateFormatter *rfc3339TimestampFormatterWithTimeZone = [[NSDateFormatter alloc] init];
    [rfc3339TimestampFormatterWithTimeZone setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [rfc3339TimestampFormatterWithTimeZone setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *theDate = nil;
    NSError *error = nil;
    if (![rfc3339TimestampFormatterWithTimeZone getObjectValue:&theDate forString:dateString range:nil error:&error]) {
        NSLog(@"Date '%@' could not be parsed: %@", dateString, error);
    }
    
    return theDate;
}



@end
