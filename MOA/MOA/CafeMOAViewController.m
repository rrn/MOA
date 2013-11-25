//
//  CafeMOAViewController.m
//  MOA
//
//  Created by Diana Sutandie on 11/23/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "CafeMOAViewController.h"

@interface CafeMOAViewController ()

@end

@implementation CafeMOAViewController

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
    
    NSString* descriptionText = @"";
    bool foundCafeDescription = false;
    for (int index = 0; index < [generalTextArray count]; index++){
        if (foundCafeDescription == true){
            descriptionText = [generalTextArray objectAtIndex:index];
            break;
        }
        if ([[generalTextArray objectAtIndex:index] isEqualToString:@"Cafe"]){
            foundCafeDescription = true;
        }
    }
    NSMutableString* cafeHoursStr = [NSMutableString stringWithFormat:@"Hours:\n\n"];
    NSMutableString* day_temp = [NSMutableString stringWithFormat:@""];
    NSMutableString* hours_temp = [NSMutableString stringWithFormat:@""];
    for (int i = 0; i < [cafeHoursArray count]; i++){
        day_temp = [cafeHoursArray objectAtIndex:i]; i++;
        hours_temp = [cafeHoursArray objectAtIndex:i];
        [cafeHoursStr appendString:day_temp];
        [cafeHoursStr appendString:@" : "];
        [cafeHoursStr appendString:hours_temp];
        [cafeHoursStr appendString:@"\n"];
    }
    self.title = @"Cafe MOA";
    self.description.text = descriptionText;
    self.hours.text = cafeHoursStr;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// this code is needed since iOS 7 has different layout
- (void) viewDidLayoutSubviews {
   [self.scroll setContentSize:CGSizeMake(320, 700)];
}

@end
