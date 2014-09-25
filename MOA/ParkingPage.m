//
//  ParkingPage.m
//  MOA
//
//  Created by Diana Sutandie on 11/19/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "ParkingPage.h"
#import "SWRevealViewController.h"

@interface ParkingPage ()

@end

@implementation ParkingPage

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
    self.title = @"Parking";
    self.description.text = [[parkingInformationArray objectAtIndex:0] objectForKey:@"Description"];
        [self.description setFont:[UIFont fontWithName:@"HelveticaNeue-light" size:18]];
    //[parkingInformationArray objectAtIndex:0]; //index 0 contains parking description
    
    // Sidebar menu code
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Side Bar Menu
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor] ];
    
    // we want to be able to scroll
    [self.scroll setScrollEnabled:YES];
    [self.scroll setContentSize:CGSizeMake(320, 600)];
    
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// this code is needed since iOS 7 has different layout
- (void) viewDidLayoutSubviews {
    [self.scroll setContentSize:CGSizeMake(320, 600)];
}

@end
