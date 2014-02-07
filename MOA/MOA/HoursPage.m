//
//  HoursPage.m
//  MOA
//
//  Created by Marilyn Edgar on 11/23/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "HoursPage.h"
#import "Constants.h"
#import "SWRevealViewController.h"
#import "VisitorInfoViewController.h"
#import "CrudOp.h"
#import "Reachability.h"

@interface HoursPage ()

@end

@implementation HoursPage

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"Hours";
    
    // Sidebar menu code
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    if (!generalHoursArray || !generalHoursArray.count){
        
        Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
        NetworkStatus internetStatus = [reachability currentReachabilityStatus];
        
        if (internetStatus == NotReachable){
            CrudOp* database = [CrudOp alloc];
            generalHoursArray = [database PullFromLocalDB:@"general_hours"];
        } else {
            [self PullFromRemote];
        }
    }
    
    NSMutableString* hoursStr = [NSMutableString stringWithFormat:@""];
    for (int i = 0; i < [generalHoursArray count]; i++){
        [hoursStr appendString:[generalHoursArray objectAtIndex:i]];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    CGFloat tabInterval = 150.0;
    paragraphStyle.defaultTabInterval = tabInterval;
    NSMutableArray *tabs = [NSMutableArray array];
    [tabs addObject:[[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentLeft location:tabInterval options:nil]];
    
    paragraphStyle.tabStops = tabs;
    self.description.typingAttributes = [NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    self.description.text = hoursStr;
}

-(void)PullFromRemote
{
    NSDictionary* jsonDict = [VisitorInfoViewController PullRemoteData:@"http://pluto.moa.ubc.ca/_mobile_app_remoteData.php"];
    // NEEDS TO PERFORM UPDATE IN HERE - UPDATE THE LOCAL DB
    CrudOp *dbCrud = [[CrudOp alloc] init];
    NSMutableString *day, *hours;
    NSMutableString *temp;
    int rowIndex = 0;
    
    NSEnumerator *mainEnumerator = [jsonDict keyEnumerator];
    id key; NSArray *tableArray;
    while (key = [mainEnumerator nextObject]){
        rowIndex = 1;
        tableArray = [jsonDict objectForKey:key];
        for (NSDictionary *attribute in tableArray){
            if ([key isEqualToString:@"general_hours"]) {
                NSEnumerator *attEnum = [attribute keyEnumerator];
                id attKey;
                while (attKey = [attEnum nextObject]){
                    // attKey going to be rate etc, so need to insert to the array
                    day = [NSMutableString stringWithString:[attribute objectForKey:@"Day"]];
                    hours = [NSMutableString stringWithString:[attribute objectForKey:@"Hours"]];
                    temp = [NSMutableString stringWithFormat:@"%@ \t: %@\n", day, hours];
                    [generalHoursArray addObject:temp];
                    [dbCrud UpdateRecords:hours :day :rowIndex :@"generalHours"];
                        
                    // increase att key here
                    attKey = [attEnum nextObject];
                    rowIndex++;
                }
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
