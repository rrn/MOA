//
//  ExhibitChildViewController.m
//  MOA
//
//  Created by Marilyn Edgar on 1/25/2014.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import "ExhibitChildViewController.h"

@interface ExhibitChildViewController ()

@end

@implementation ExhibitChildViewController

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
    
    self.screenNumber.text = [NSString stringWithFormat:@"Screen #%d", self.index];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
