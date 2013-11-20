//
//  FromLowerMainland.m
//  MOA
//
//  Created by Diana Sutandie on 11/20/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "FromLowerMainland.h"

@interface FromLowerMainland ()

@end

@implementation FromLowerMainland

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
    self.title = @"Parking & Directions";
    self.description.text = [parkingInformationArray objectAtIndex:2];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
