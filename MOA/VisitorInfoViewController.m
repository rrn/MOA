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

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: @"http://localhost/eece419/remoteData.php"]];
    NSError         * e;
    NSData      *remoteData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&e];
    NSString *strRemoteData = [[NSString alloc] initWithData:remoteData encoding:NSUTF8StringEncoding];
    NSData *jsonData = [strRemoteData dataUsingEncoding:NSUTF8StringEncoding];
    
    e = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&e];
    NSEnumerator *mainEnumerator = [jsonDict keyEnumerator];
    id key;
    NSArray *tableArray;
    while (key = [mainEnumerator nextObject]){
        tableArray = [jsonDict objectForKey:key];
        for (NSDictionary *attribute in tableArray){
            NSEnumerator *attEnum = [attribute keyEnumerator];
            id attKey;
            while (attKey = [attEnum nextObject]){
                //do sth : pKey going to be rate etc, so need to insert to the array
                if ([key isEqualToString:@"rates_general"]){
                    // add to rates general array
                } else if ([key isEqualToString:@"rates_group"]){
                    // add to rates group array
                } else if ([key isEqualToString:@"cafe_hours"]) {
                    if ([attKey isEqualToString:@"Hours"])
                        [cafeHoursArray addObject:[attribute objectForKey:attKey]];
                } else if ([key isEqualToString:@"parking_and_directions"]){
                    if ([attKey isEqualToString:@"Description"])
                        [parkingInformationArray addObject:[attribute objectForKey:attKey]];
                } else if ([key isEqualToString:@"general_hours"]) {
                    // add to general hours array
                }
            }
            //do somethig
        }
    }
   }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
