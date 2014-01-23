//
//  RatesPage.m
//  MOA
//
//  Created by Marilyn Edgar on 11/23/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "RatesPage.h"
#import "SWRevealViewController.h"
#import "VisitorInfoViewController.h"
#import "CrudOp.h"

@interface RatesPage ()

@end

@implementation RatesPage

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
    self.title = @"Rates";
    
    // Sidebar menu code
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self.scroll setScrollEnabled:YES];
    [self.scroll setContentSize:CGSizeMake(320, 500)];
    
    // CHECK IF IT IS LOADED IF NOT, CHECK CONNECTIVITY
    // NO CONNECTION? LOCAL DB
    // CONNECTION? REMOTE.
    if (!ratesGeneralArray || !ratesGeneralArray.count){
        [self PullFromRemote];
    }
    
    NSMutableString* ratesStr = [NSMutableString stringWithFormat:@"General Rates:\n\n"];
    for (int i = 0; i < [ratesGeneralArray count]; i++){
        [ratesStr appendString:[ratesGeneralArray objectAtIndex:i]];
    }
    [ratesStr appendString:@"\n\n"];
    [ratesStr appendString:@"Group Rates:\n\n"];
    for (int j = 0; j < [ratesGroupArray count]; j++){
        [ratesStr appendString:[ratesGroupArray objectAtIndex:j]];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    CGFloat tabInterval = 225.0;
    paragraphStyle.defaultTabInterval = tabInterval;
    NSMutableArray *tabs = [NSMutableArray array];
    [tabs addObject:[[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentLeft location:tabInterval options:nil]];
    paragraphStyle.tabStops = tabs;
    self.description.typingAttributes = [NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    self.description.editable = NO;
    self.description.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
    self.description.text = ratesStr;
}

-(void)PullFromRemote
{
    NSDictionary* jsonDict = [VisitorInfoViewController PullRemoteData:@"http://pluto.moa.ubc.ca/_mobile_app_remoteData.php"];
    // NEEDS TO PERFORM UPDATE IN HERE - UPDATE THE LOCAL DB
    CrudOp *dbCrud = [[CrudOp alloc] init];
    NSMutableString *description, *rate;
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
                
                // GENERAL RATES
                if ([key isEqualToString:@"rates_general"]){
                    description = [NSMutableString stringWithString:[attribute objectForKey:@"Description"]];
                    rate = [NSMutableString stringWithString:[attribute objectForKey:@"Rate"]];
                    temp = [NSMutableString stringWithFormat:@"%@ \t: %@\n", description, rate];
                    [dbCrud UpdateRecords:rate :description : rowIndex :@"rateGeneral"];
                    [ratesGeneralArray addObject:temp];
                    
                    // GROUP RATES
                } else if ([key isEqualToString:@"rates_groups"]){
                    description = [NSMutableString stringWithString:[attribute objectForKey:@"Description"]];
                    rate = [NSMutableString stringWithString:[attribute objectForKey:@"Rate"]];
                    temp = [NSMutableString stringWithFormat:@"%@ \t: %@\n", description, rate];
                    [ratesGroupArray addObject:temp];
                    [dbCrud UpdateRecords:rate :description :rowIndex :@"rateGroups"];
                    
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
    // Dispose of any resources that can be recreated.
}

// this code is needed since iOS 7 has different layout
- (void) viewDidLayoutSubviews {
    [self.scroll setContentSize:CGSizeMake(320, 500)];
}

@end
