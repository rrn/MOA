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
    self.hours.text = cafeHoursStr;
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
