//
//  AboutViewController.m
//  MOA
//
//  Created by Marilyn Edgar on 2014-03-07.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import "AboutViewController.h"
#import "Reachability.h"
#import "SWRevealViewController.h"
#import "Global.h"
#import "Utils.h"
#import "CrudOp.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

@synthesize description;

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
    // Sidebar menu code
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.title = @"About Us";
    self.navigationItem.hidesBackButton = YES;
    
    [self prepareForDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForDisplay
{
    CrudOp* database = [CrudOp alloc];
    if (!generalTextArray || !generalTextArray.count){
        
        Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
        NetworkStatus internetStatus = [reachability currentReachabilityStatus];
        
        if (internetStatus == NotReachable){
            cafeHoursArray = [database PullFromLocalDB:@"cafe_hours"];
            generalTextArray = [database PullFromLocalDB:@"general_text"];
        } else {
            [self PullFromRemote];
            [self UpdateLocalDB];
        }
    }
    
    self.description = [[generalTextArray objectAtIndex:2] objectForKey:@"Description"];
    UITextView *descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height+10, 300.0f, 10)];
    descriptionTextView.text = description;
    descriptionTextView.editable = NO;
    descriptionTextView.userInteractionEnabled = NO;
    descriptionTextView.font = [UIFont systemFontOfSize:14];
    [Utils textViewDidChange:descriptionTextView];
    descriptionTextView.textAlignment = NSTextAlignmentJustified;
    [self.view addSubview:descriptionTextView];
    
}

- (void) PullFromRemote
{
    NSDictionary* jsonDict = [Utils PullRemoteData:@"http://pluto.moa.ubc.ca/_mobile_app_remoteData.php"];
    generalTextArray = [jsonDict objectForKey:@"general_text"];
    self.description = [[generalTextArray objectAtIndex:2] objectForKey:@"Description"];
}

-(void) UpdateLocalDB
{
    CrudOp *dbCrud = [[CrudOp alloc] init];
    [dbCrud UpdateLocalDB:@"general_text" :generalTextArray];
}


@end
