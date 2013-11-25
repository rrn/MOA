//
//  LocationPage.m
//  MOA
//
//  Created by Marilyn Edgar on 11/23/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "LocationPage.h"

@interface LocationPage ()

@end

@implementation LocationPage

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
    self.title = @"Location";
    
    self.description.text = @"Museum of Anthropology at University of British Columbia 6393 NW Marine Drive Vancouver BC";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
