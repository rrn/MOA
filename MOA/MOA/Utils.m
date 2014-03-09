//
//  Utils.m
//  This class contains helper functions
//  MOA
//
//  Created by Diana Sutandie on 2/6/2014.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (int)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
    return newSize.height;
}

+ (NSString*) convertDate:(NSString*) short_date
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

+ (NSString*) convertMonthToString:(NSString*) month_numeric
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

+(NSDictionary* )PullRemoteData:(NSString* )url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: @"http://pluto.moa.ubc.ca/_mobile_app_remoteData.php"]];
    NSError * e;
    NSData *remoteData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&e];
    NSMutableString* strRemoteData =[[NSMutableString alloc] initWithData:remoteData encoding:NSUTF8StringEncoding];
    //[self validateJSONString]; //sometimes data are returned in HTML form, we need to validate
    strRemoteData = [NSMutableString stringWithString:[self ValidateJSONFormat:strRemoteData]];
    NSData *jsonData = [strRemoteData dataUsingEncoding:NSUTF8StringEncoding];
    e = nil; // reset e variable
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];
    
    if (e) {
        NSLog(@"Error serializing %@", e);
    }
    return jsonDict;
}

+(NSString*)ValidateJSONFormat:(NSString *)json
{
    // sometimes remote data are returned in HTML form, and
    // we cannot remove HTML tags by stripping all the tags using regular expression
    // since the body of JSON contains HTML tags
    // so we have to do manually by removing beginning and end HTML tags
    
    NSMutableString *strToValidate = [json copy];
    
    //remove the initial html tag
    if ([strToValidate rangeOfString:@"<body>"].location == NSNotFound) {
        NSLog(@"Data is Good: Returned JSON String does not have end HTML tags");
    } else {
        int startingOffset = [strToValidate rangeOfString:@"{"].location;
        strToValidate = [[strToValidate substringFromIndex:startingOffset] copy];
    }
    
    //remove the end tag
    if ([strToValidate rangeOfString:@"</body>"].location == NSNotFound){
        NSLog(@"Data is Good: Returned JSON String does not have end HTML tags");
    } else {
        int endingOffset = [strToValidate rangeOfString:@"</body>"].location;
        strToValidate = [[strToValidate substringWithRange:NSMakeRange(0, endingOffset)] copy];
    }
    
    json = strToValidate;
    return json;
}

@end


