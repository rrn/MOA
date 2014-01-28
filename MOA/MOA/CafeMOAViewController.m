//
//  CafeMOAViewController.m
//  MOA
//
//  Created by Diana Sutandie on 11/23/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "CafeMOAViewController.h"
#import "SWRevealViewController.h"
#import "VisitorInfoViewController.h"
#import "CrudOp.h"
#import "Reachability.h"

@interface CafeMOAViewController ()

@end

@implementation CafeMOAViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self.scroll setScrollEnabled:YES];
    [self.scroll setContentSize:CGSizeMake(320, 700)];
    
    // Sidebar menu code
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
      
    if (!cafeHoursArray || !cafeHoursArray.count || !cafeDescription || !generalTextArray){
        [self LoadAndUpdateData];
    }
    
    NSString* descriptionText = cafeDescription;
    
    NSMutableString* cafeHoursStr = [NSMutableString stringWithFormat:@"Hours:\n\n"];
    for (int i = 0; i < [cafeHoursArray count]; i++){
        [cafeHoursStr appendString:[cafeHoursArray objectAtIndex:i]];
    }
    self.title = @"Cafe MOA";
    
    [self PrepareTextAlignmentForHours];
    self.description.text = descriptionText;
    self.hours.text = cafeHoursStr;
    [super viewDidLoad];
}

-(void)LoadAndUpdateData
{
    CrudOp* database = [CrudOp alloc];
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable){
        cafeHoursArray = [database PullFromLocalDB:@"cafe_hours"];
        generalTextArray = [database PullFromLocalDB:@"general_text"];
        cafeDescription = [generalTextArray objectAtIndex:1];
    } else {
        [self PullFromRemote];
    }
}


//
// This function set the Tab / Alignment for Hours text
//
- (void)PrepareTextAlignmentForHours
{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    CGFloat tabInterval = 100.0;
    paragraphStyle.defaultTabInterval = tabInterval;
    NSMutableArray *tabs = [NSMutableArray array];
    [tabs addObject:[[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentLeft location:tabInterval options:nil]]; // add tab stop
    paragraphStyle.tabStops = tabs;
    self.hours.typingAttributes = [NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
}

- (void)PullFromRemote
{
    NSDictionary* jsonDict = [VisitorInfoViewController PullRemoteData:@"http://pluto.moa.ubc.ca/_mobile_app_remoteData.php"];
    // NEEDS TO PERFORM UPDATE IN HERE - UPDATE THE LOCAL DB
    CrudOp *dbCrud = [[CrudOp alloc] init];
    NSMutableString *day, *hours;
    NSMutableString *description, *identifier;
    NSMutableString *temp;
    int rowIndex = 0;
    
    NSEnumerator *mainEnumerator = [jsonDict keyEnumerator];
    id key; NSArray *tableArray;
    while (key = [mainEnumerator nextObject]){
        rowIndex = 1;
        tableArray = [jsonDict objectForKey:key];
        for (NSDictionary *attribute in tableArray){
            NSEnumerator *attEnum = [attribute keyEnumerator];
            id attKey;
            while (attKey = [attEnum nextObject]){
                // attKey going to be rate etc, so need to insert to the array
                
                // CAFE HOURS
                if ([key isEqualToString:@"cafe_hours"]) {
                    day = [NSMutableString stringWithString:[attribute objectForKey:@"Day"]];
                    hours = [NSMutableString stringWithString:[attribute objectForKey:@"Hours"]];
                    temp = [NSMutableString stringWithFormat:@"%@ \t: %@\n", day, hours];
                    [cafeHoursArray addObject:temp];
                    [dbCrud UpdateRecords:hours :day :rowIndex :@"cafeHours"];
                    
                    // GENERAL TEXT
                } else if ([key isEqualToString:@"general_text"]) {
                    description = [NSMutableString stringWithString:[attribute objectForKey:@"Description"]];
                    identifier = [NSMutableString stringWithString:[attribute objectForKey:@"Identifier"]];
                    if ([identifier isEqualToString:@"Cafe"])
                        cafeDescription = description;
                    else if ([identifier isEqualToString:@"Shop"])
                        shopDescription = description;
                    [dbCrud UpdateRecords:description :identifier :rowIndex :@"generalText"];
                }
                
                // increase att key here
                attKey = [attEnum nextObject];
                rowIndex++;
            }
        }
    }

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// this code is needed since iOS 7 has different layout
- (void) viewDidLayoutSubviews {
   [self.scroll setContentSize:CGSizeMake(320, 700)];
}

@end
