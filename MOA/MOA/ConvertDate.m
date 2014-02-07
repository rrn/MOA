//
//  ConvertDate.m
//  MOA
//
//  Created by Marilyn Edgar on 2/6/2014.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import "ConvertDate.h"

@implementation ConvertDate


- (NSString*) convertDate:(NSString*) short_date
{
    //convert short date to long date
    NSArray* components = [short_date componentsSeparatedByString:@"-"];
    
    NSString *year = [components objectAtIndex:0];
    NSString *month_numeric = [components objectAtIndex:1];
    NSString *month_string = [self convertMonthToString:month_numeric];
    NSString *day = [components objectAtIndex:2];
    
    NSString *long_date = [NSString stringWithFormat:@"%@ %d, %@", month_string, day.intValue, year];
    
    return long_date;
}

- (NSString*) convertMonthToString:(NSString*) month_numeric
{
    switch (month_numeric.intValue)
    {
        case 1:
            return @"January";
        case 2:
            return @"February";
        case 3:
            return @"March";
        case 4:
            return @"April";
        case 5:
            return @"May";
        case 6:
            return @"June";
        case 7:
            return @"July";
        case 8:
            return @"August";
        case 9:
            return @"September";
        case 10:
            return @"October";
        case 11:
            return @"November";
        case 12:
            return @"December";
            
        default: return @"January";
    }
}

@end
