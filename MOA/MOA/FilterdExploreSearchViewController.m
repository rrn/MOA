//
//  FilterdExploreSearchViewController.m
//  MOA
//
//  Created by Sukhi Mann on 11/3/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "FilterdExploreSearchViewController.h"

@interface FilterdExploreSearchViewController ()

@end

@implementation FilterdExploreSearchViewController

@synthesize filterLabel;
@synthesize filterName;

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
    
    // Set the Label text with the selected recipe
    filterLabel.text = filterName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
