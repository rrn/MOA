//
//  TagList.m
//  MOA
//
//  Created by Sukhi Mann on 11/14/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "TagList.h"
#import "CrudOp.h"

@implementation TagList

@synthesize objectTypeTags, peopleTags, placesTags, materialsTags, culturesTags, extraPage;

+ (TagList *)sharedInstance
{
    // the instance of this class is stored here
    static TagList *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        // initialize variables here
    }
    // return the instance of this class
    return myInstance;
}


+ (void)downloadObjectJson{
    
    NSString *jsonString = [ [NSString alloc]
                            initWithContentsOfURL:[ [NSURL alloc] initWithString:@"http://www.rrnpilot.org/filters.json?filter_type=item_types&filters=held+at+MOA:+University+of+British+Columbia"]
                            encoding:NSUTF8StringEncoding
                            error:nil
                            ];
    
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *entireDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSArray *entireTagArrary = [[entireDictionary objectEnumerator] allObjects];
    [TagList sharedInstance].objectTypeTags = [[NSMutableArray alloc] init];
    
    
    for(int i=0; i < [entireTagArrary count]; i++){
        
        NSDictionary *temp = [entireTagArrary objectAtIndex:i];
        [[TagList sharedInstance].objectTypeTags addObject:[[temp objectForKey:@"name"] capitalizedString]];

    }
}
+ (void)downloadPeopleJson{
    
    NSString *jsonString = [ [NSString alloc]
                            initWithContentsOfURL:[ [NSURL alloc] initWithString:@"http://www.rrnpilot.org/filters.json?filter_type=people&filters=held+at+MOA:+University+of+British+Columbia"]
                            encoding:NSUTF8StringEncoding
                            error:nil
                            ];
    
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *entireDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSArray *entireTagArrary = [[entireDictionary objectEnumerator] allObjects];
    [TagList sharedInstance].peopleTags = [[NSMutableArray alloc] init];
    
    for(int i=0; i < [entireTagArrary count]; i++){
        
        NSDictionary *temp = [entireTagArrary objectAtIndex:i];
        [[TagList sharedInstance].peopleTags addObject:[[temp objectForKey:@"name"] capitalizedString]];
        
    }
}
+ (void)downloadPlacesJson{
    
    NSString *jsonString = [ [NSString alloc]
                            initWithContentsOfURL:[ [NSURL alloc] initWithString:@"http://www.rrnpilot.org/filters.json?filter_type=locations&filters=held+at+MOA:+University+of+British+Columbia"]
                            encoding:NSUTF8StringEncoding
                            error:nil
                            ];
    
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *entireDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSArray *entireTagArrary = [[entireDictionary objectEnumerator] allObjects];
    [TagList sharedInstance].placesTags = [[NSMutableArray alloc] init];
    
    for(int i=0; i < [entireTagArrary count]; i++){
        
        NSDictionary *temp = [entireTagArrary objectAtIndex:i];
        [[TagList sharedInstance].placesTags addObject:[[temp objectForKey:@"name"] capitalizedString]];
        
    }
}
+ (void)downloadMaterialsJson{
    
    NSString *jsonString = [ [NSString alloc]
                            initWithContentsOfURL:[ [NSURL alloc] initWithString:@"http://www.rrnpilot.org/filters.json?filter_type=materials&filters=held+at+MOA:+University+of+British+Columbia"]
                            encoding:NSUTF8StringEncoding
                            error:nil
                            ];
    
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *entireDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    [TagList sharedInstance].materialsTags = [[NSMutableArray alloc] init];
    
    NSArray *entireTagArrary = [[entireDictionary objectEnumerator] allObjects];
    
    
    for(int i=0; i < [entireTagArrary count]; i++){
        
        NSDictionary *temp = [entireTagArrary objectAtIndex:i];
        [[TagList sharedInstance].materialsTags addObject:[[temp objectForKey:@"name"] capitalizedString]];
        
    }
}

+ (void)downloadCulturesJson{
    
    NSString *jsonString = [ [NSString alloc]
                            initWithContentsOfURL:[ [NSURL alloc] initWithString:@"http://www.rrnpilot.org/filters.json?filter_type=cultures&filters=held+at+MOA:+University+of+British+Columbia"]
                            encoding:NSUTF8StringEncoding
                            error:nil
                            ];
    
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *entireDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    [TagList sharedInstance].culturesTags = [[NSMutableArray alloc] init];
    
    NSArray *entireTagArrary = [[entireDictionary objectEnumerator] allObjects];
    
    
    for(int i=0; i < [entireTagArrary count]; i++){
        
        NSDictionary *temp = [entireTagArrary objectAtIndex:i];
        [[TagList sharedInstance].culturesTags addObject:[[temp objectForKey:@"name"] capitalizedString]];
        
    }
}

//Method to load all the "What's on this Week" information"
+(void) loadInformation
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: @"http://pluto.moa.ubc.ca/_mobile_app_remoteData.php"]];
    NSError * e;
    NSData *remoteData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&e];
    NSMutableString* strRemoteData =[[NSMutableString alloc] initWithData:remoteData encoding:NSUTF8StringEncoding];
    //[self validateJSONString]; //sometimes data are returned in HTML form, we need to validate
    strRemoteData = [NSMutableString stringWithString:[self ValidateJSONFormat:strRemoteData]];
    NSData *jsonData = [strRemoteData dataUsingEncoding:NSUTF8StringEncoding];
    e = nil; // reset e variable
    //[[TagList sharedInstance] setCalendarEvents:[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e]];
    NSDictionary *temp = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];
    NSMutableArray *temp2 = [[NSMutableArray alloc] init];
    NSMutableDictionary *temp3 = [[NSMutableDictionary alloc] init];
    NSDate *nowDate = [[NSDate alloc] init];
//    NSCalendar *gregorian = [[NSCalendar alloc]
//                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    for(int eventIterator=0; eventIterator < [[temp objectForKey:@"whats_on"] count]; eventIterator++){
        NSString *eventDateString = [[[temp objectForKey:@"whats_on"] objectAtIndex:eventIterator] objectForKey:@"date"];
        NSDate *eventDate = [dateFormatter dateFromString:eventDateString];
        NSTimeInterval secs = [eventDate timeIntervalSinceDate:nowDate];
        //NSLog(@"time: %f", secs);
        if(secs < (60*60*24*7) && secs > 0){
            [temp2 addObject:[[temp objectForKey:@"whats_on"] objectAtIndex:eventIterator]];
            //NSLog(@"added an event");
        }
    }
    [temp3 setObject:temp2 forKey:@"whats_on"];
    [[TagList sharedInstance] setCalendarEvents:[temp3 objectForKey:@"whats_on"]];
    [[TagList sharedInstance] setExhibitionEvents:[temp objectForKey:@"moa_exhibitions"]];
    
    // store remote data to database
    CrudOp* localdb = [[CrudOp alloc]init];
    [localdb UpdateLocalDB:@"whats_on" :[temp objectForKey:@"whats_on"]];
    
    if (e) {
        NSLog(@"Error serializing %@", e);
    }
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
