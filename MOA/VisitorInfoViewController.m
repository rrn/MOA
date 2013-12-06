//
//  VisitorInfoViewController.m
//  MOA
//
//  Created by Marilyn Edgar on 11/16/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "VisitorInfoViewController.h"
#import "SWRevealViewController.h"

@interface VisitorInfoViewController ()

-(void) validateJSONString;
@end


@implementation VisitorInfoViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Visitor Information";
    
    // Sidebar menu code
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    [self clearOldData];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: @"http://pluto.moa.ubc.ca/_mobile_app_remoteData.php"]];
    NSError * e;
    NSData *remoteData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&e];
    strRemoteData =[[NSString alloc] initWithData:remoteData encoding:NSUTF8StringEncoding];
    [self validateJSONString]; //sometimes data are returned in HTML form, we need to validate
    NSData *jsonData = [strRemoteData dataUsingEncoding:NSUTF8StringEncoding];
    e = nil; // reset e variable
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];

    if (e) {
        NSLog(@"Error serializing %@", e);
    }
    NSLog(@"%@",jsonDict);
    NSEnumerator *mainEnumerator = [jsonDict keyEnumerator];
    id key; NSArray *tableArray;
    while (key = [mainEnumerator nextObject]){
        tableArray = [jsonDict objectForKey:key];
        for (NSDictionary *attribute in tableArray){
            NSEnumerator *attEnum = [attribute keyEnumerator];
            id attKey;
            while (attKey = [attEnum nextObject]){
                //attKey going to be rate etc, so need to insert to the array
                if ([key isEqualToString:@"rates_general"]){
                    [ratesGeneralArray addObject:[attribute objectForKey:attKey]];
                } else if ([key isEqualToString:@"rates_groups"]){
                    [ratesGroupArray addObject:[attribute objectForKey:attKey]];
                } else if ([key isEqualToString:@"cafe_hours"]) {
                    [cafeHoursArray addObject:[attribute objectForKey:attKey]];
                } else if ([key isEqualToString:@"parking_and_directions"]){
                    if ([attKey isEqualToString:@"Description"])
                        [parkingInformationArray addObject:[attribute objectForKey:attKey]];
                } else if ([key isEqualToString:@"general_hours"]) {
                    [generalHoursArray addObject:[attribute objectForKey:attKey]];
                } else if ([key isEqualToString:@"general_text"]) {
                    [generalTextArray addObject:[attribute objectForKey:attKey]];
                }
            }
        }
    }
    // testing purpose only
    //NSLog(@"%@", ratesGroupArray);
    
}

-(void) clearOldData {
    
    [generalHoursArray removeAllObjects];
    [parkingInformationArray removeAllObjects];
    [generalTextArray removeAllObjects];
    [cafeHoursArray removeAllObjects];
    [ratesGeneralArray removeAllObjects];
    [ratesGroupArray removeAllObjects];

}

-(void) validateJSONString{
    
    // sometimes remote data are returned in HTML form, and
    // we cannot remove HTML tags by stripping all the tags using regular expression
    // since the body of JSON contains HTML tags
    // so we have to do manually by removing beginning and end HTML tags
    
    NSMutableString *strToValidate = [strRemoteData copy];
    
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
    
    strRemoteData = strToValidate;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
