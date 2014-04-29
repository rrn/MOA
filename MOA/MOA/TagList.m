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
        
        __block NSMutableString *lastWord = nil;
        
        [[[temp objectForKey:@"name"] capitalizedString] enumerateSubstringsInRange:NSMakeRange(0, [[[temp objectForKey:@"name"] capitalizedString] length]) options:NSStringEnumerationByWords | NSStringEnumerationReverse usingBlock:^(NSString *substring, NSRange subrange, NSRange enclosingRange, BOOL *stop) {
            lastWord = [substring mutableCopy];
            *stop = YES;
        }];
        NSString *firstName = [[[temp objectForKey:@"name"] capitalizedString] stringByReplacingOccurrencesOfString:lastWord withString:@""];
        NSString *formattedString = [NSString stringWithFormat:@"%@, %@",lastWord,firstName];
        [[TagList sharedInstance].peopleTags addObject:formattedString];
        
    }
    [[TagList sharedInstance].peopleTags sortUsingSelector:@selector(caseInsensitiveCompare:)];
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
    //  NSCalendar *gregorian = [[NSCalendar alloc]
    //                           initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //adding events to array that occur within one week's time
    for(int eventIterator=0; eventIterator < [[temp objectForKey:@"whats_on"] count]; eventIterator++){
        NSString *eventDateString = [[[temp objectForKey:@"whats_on"] objectAtIndex:eventIterator] objectForKey:@"date"];
        NSDate *eventDate = [dateFormatter dateFromString:eventDateString];
        NSTimeInterval secs = [eventDate timeIntervalSinceDate:nowDate];
        if(secs < (60*60*24*7) && secs >= -(60*60*24)){
            [temp2 addObject:[[temp objectForKey:@"whats_on"] objectAtIndex:eventIterator]];
            //NSLog(@"added an event");
        }
    }
    //sorting events to be in chronological order
    [temp2 sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate* date1 = [obj1 objectForKey:@"date"];
        NSDate* date2 = [obj2 objectForKey:@"date"];
        return [date1 compare:date2];
    }];
    
    [temp3 setObject:temp2 forKey:@"whats_on"];
    [[TagList sharedInstance] setCalendarEvents:[temp3 objectForKey:@"whats_on"]];
    
    if (!eventImages || ![eventImages count]){
        eventImages = [[NSMutableArray alloc] init];
    }
    
    for (int i = 0; i < [[[TagList sharedInstance] calendarEvents] count]; i++){
        UIImage *cellImage = [UIImage imageWithData: [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[[[[TagList sharedInstance] calendarEvents] objectAtIndex:i] objectForKey:@"image"]]]];
        UIImage *borderedImage = [UIImage imageWithCGImage:cellImage.CGImage scale:3 orientation:cellImage.imageOrientation];
        [eventImages insertObject:borderedImage atIndex:i];
    }
    NSLog(@"The total of event images is %d", [eventImages count]);
    
    // store remote data to database
    CrudOp* localdb = [[CrudOp alloc]init];
    [localdb UpdateLocalDB:@"whats_on" :[temp objectForKey:@"whats_on"]];
    
    if (e) {
        NSLog(@"Error serializing %@", e);
    }
}

+(void) loadExhibitionsInformation
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: @"http://pluto.moa.ubc.ca/_mobile_app_remoteData.php"]];
    NSError * e;
    NSData *remoteData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&e];
    NSMutableString* strRemoteData =[[NSMutableString alloc] initWithData:remoteData encoding:NSUTF8StringEncoding];
    strRemoteData = [NSMutableString stringWithString:[self ValidateJSONFormat:strRemoteData]];
    NSData *jsonData = [strRemoteData dataUsingEncoding:NSUTF8StringEncoding];
    e = nil; // reset e variable
    NSDictionary *temp = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];
    
    // ** INFORMATION FOR EXHIBITIONS PAGE**
    // filter exhibitions, get the current and future exhibitions only
    NSDate* currentDate = [NSDate date];
    NSDate* exhibitionExpiryDate = [NSDate alloc];
    NSMutableArray* filteredExhibitionsArray = [[NSMutableArray alloc] init];
    NSMutableDictionary* filteredExhibitions = [[NSMutableDictionary alloc] init];
    for (int exhibitionIterator = 0; exhibitionIterator < [[temp objectForKey:@"moa_exhibitions"] count]; exhibitionIterator++){
        
        // get expiry Date for each exhibition
        NSString* expiryDate = [[[temp objectForKey:@"moa_exhibitions"] objectAtIndex:exhibitionIterator] objectForKey:@"expiryDate"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        exhibitionExpiryDate = [dateFormat dateFromString:expiryDate];
        
        // compare with current date. only takes future exhibitions
        NSComparisonResult result = [currentDate compare:exhibitionExpiryDate];
        if (result == NSOrderedAscending || result == NSOrderedSame)
        {
            [filteredExhibitionsArray addObject:[[temp objectForKey:@"moa_exhibitions"] objectAtIndex: exhibitionIterator]];
        }
    }
    // sort the exhibitions by expiryDate
    [filteredExhibitionsArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate* date1 = [obj1 objectForKey:@"expiryDate"];
        NSDate* date2 = [obj2 objectForKey:@"expiryDate"];
        return [date1 compare:date2];
    }];
    
    [filteredExhibitions setObject:filteredExhibitionsArray forKey:@"moa_exhibitions"];
    [[TagList sharedInstance] setExhibitionEvents:[filteredExhibitions objectForKey:@"moa_exhibitions"]];
    // load exhibition images
    //[self performSelectorInBackground:@selector(loadExhibitionImages) withObject:nil];
    [self loadExhibitionImages];
    
}

+(void)loadExhibitionImages{
    
    if (!exhibitionImages){
        exhibitionImages = [[NSMutableArray alloc] init];
    }
    for (int i = 0; i < [[[TagList sharedInstance] exhibitionEvents] count]; i++)
    {
        NSString *imageURL = [[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:i] objectForKey:@"image"];
        UIImage* image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,300.0f, 200)];
        [imgView setImage:image];
        [exhibitionImages insertObject:imgView atIndex:i];
        
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
        int startingOffset = (int)[strToValidate rangeOfString:@"{"].location;
        strToValidate = [[strToValidate substringFromIndex:startingOffset] copy];
    }
    
    //remove the end tag
    if ([strToValidate rangeOfString:@"</body>"].location == NSNotFound){
        NSLog(@"Data is Good: Returned JSON String does not have end HTML tags");
    } else {
        int endingOffset = (int)[strToValidate rangeOfString:@"</body>"].location;
        strToValidate = [[strToValidate substringWithRange:NSMakeRange(0, endingOffset)] copy];
    }
    
    json = strToValidate;
    return json;
}

@end
