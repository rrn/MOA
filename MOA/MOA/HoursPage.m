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
    
    NSMutableString* hoursStr = [NSMutableString stringWithFormat:@""];
    NSMutableString* day_temp = [NSMutableString stringWithFormat:@""];
    NSMutableString* hours_temp = [NSMutableString stringWithFormat:@""];
    for (int i = 0; i < 14; i++){
        day_temp = [generalHoursArray objectAtIndex:i]; i++;
        hours_temp = [generalHoursArray objectAtIndex:i];
        [hoursStr appendString:day_temp];
        [hoursStr appendString:@" : "];
        [hoursStr appendString:hours_temp];
        [hoursStr appendString:@"\n"];
    }
    for (int j = 14; j < [generalHoursArray count]; j++)
    {
        [hoursStr appendString:[generalHoursArray objectAtIndex:j]];
        [hoursStr appendString:@"\n"];
    }
    
    self.description.text = hoursStr;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
