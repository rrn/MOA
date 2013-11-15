//
//  TagList.m
//  MOA
//
//  Created by Sukhi Mann on 11/14/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "TagList.h"

@implementation TagList

@synthesize objectTypeTags, peopleTags, placesTags, materialsTags, culturesTags;

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

@end
