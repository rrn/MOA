//
//  MOAShopViewController.m
//  MOA
//
//  Created by Diana Sutandie on 11/23/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "MOAShopViewController.h"
#import "SWRevealViewController.h"
#import "VisitorInfoViewController.h"
#import "CrudOp.h"
#import "Reachability.h"

@interface MOAShopViewController ()

@end

@implementation MOAShopViewController

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
    
    
    if (!shopDescription){
        if (!generalTextArray || !generalTextArray.count){
            [self LoadAndUpdateData];
        } else {
            shopDescription = [generalTextArray objectAtIndex:0];
        }
    }
    
    NSMutableString* text = shopDescription;

    self.title = @"MOA Shop";
    self.description.numberOfLines = 0;
    self.description.text = text;
    [self.description sizeToFit];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)LoadAndUpdateData
{
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable){
        CrudOp* database = [CrudOp alloc];
        generalTextArray = [database PullFromLocalDB:@"general_text"];
        shopDescription = [generalTextArray objectAtIndex:0];
    } else {
        [self PullFromRemote];
    }
}

-(void) PullFromRemote
{
    NSDictionary* jsonDict = [VisitorInfoViewController PullRemoteData:@"http://pluto.moa.ubc.ca/_mobile_app_remoteData.php"];
    // NEEDS TO PERFORM UPDATE IN HERE - UPDATE THE LOCAL DB
    CrudOp *dbCrud = [[CrudOp alloc] init];
    NSMutableString *description, *identifier;
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
                
                if ([key isEqualToString:@"general_text"]) {
                    description = [NSMutableString stringWithString:[attribute objectForKey:@"Description"]];
                    identifier = [NSMutableString stringWithString:[attribute objectForKey:@"Identifier"]];
                    if ([identifier isEqualToString:@"Cafe"])
                        cafeDescription = description;
                    else if ([identifier isEqualToString:@"Shop"])
                        shopDescription = description;
                    [dbCrud UpdateRecords:identifier :description :rowIndex :@"generalText"];
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

@end
