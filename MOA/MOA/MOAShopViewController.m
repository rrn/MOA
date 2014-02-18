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
            
            Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
            NetworkStatus internetStatus = [reachability currentReachabilityStatus];
            
            if (internetStatus == NotReachable){
                CrudOp* database = [CrudOp alloc];
                generalTextArray = [database PullFromLocalDB:@"general_text"];
                shopDescription = [generalTextArray objectAtIndex:0];
            } else {
                [self PullFromRemote];
            }
        } else {
            shopDescription = [generalTextArray objectAtIndex:0];
        }
    }
    
    NSMutableString* text = shopDescription;
    self.title = @"MOA Shop";
    self.description.numberOfLines = 0;
    self.description.text = text;
    self.description.textAlignment = NSTextAlignmentJustified;
    [self.description sizeToFit];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) PullFromRemote
{
    NSDictionary* jsonDict = [VisitorInfoViewController PullRemoteData:@"http://pluto.moa.ubc.ca/_mobile_app_remoteData.php"];
    generalTextArray = [jsonDict objectForKey:@"general_text"];
    shopDescription = [[generalTextArray objectAtIndex:0] objectForKey:@"Description"];    
}

-(NSString*)ValidateJSONFormat:(NSString *)json
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
