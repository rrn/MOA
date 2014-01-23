//
//  CafeMOAViewController.m
//  MOA
//
//  Created by Diana Sutandie on 11/23/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "CafeMOAViewController.h"
#import "SWRevealViewController.h"

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
    
    // Sidebar menu code
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    NSString* descriptionText = cafeDescription;
    
    NSMutableString* cafeHoursStr = [NSMutableString stringWithFormat:@"Hours:\n\n"];
    for (int i = 0; i < [cafeHoursArray count]; i++){
        [cafeHoursStr appendString:[cafeHoursArray objectAtIndex:i]];
    }
    self.title = @"Cafe MOA";
    
    // set the tab to align the "Hours" info
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    CGFloat tabInterval = 100.0;
    paragraphStyle.defaultTabInterval = tabInterval;
    NSMutableArray *tabs = [NSMutableArray array];
    [tabs addObject:[[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentLeft location:tabInterval options:nil]]; // add tab stop
    paragraphStyle.tabStops = tabs;
    self.hours.typingAttributes = [NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
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
