//
//  RatesPage.m
//  MOA
//
//  Created by Marilyn Edgar on 11/23/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "RatesPage.h"
#import "SWRevealViewController.h"

@interface RatesPage ()

@end

@implementation RatesPage

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
    self.title = @"Rates";
    
    // Sidebar menu code
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self.scroll setScrollEnabled:YES];
    [self.scroll setContentSize:CGSizeMake(320, 500)];

    NSMutableString* ratesStr = [NSMutableString stringWithFormat:@"General Rates:\n\n"];
    NSMutableString* description_tmp = [NSMutableString stringWithFormat:@""];
    NSMutableString* rate_tmp = [NSMutableString stringWithFormat:@""];
    for (int i = 0; i < [ratesGeneralArray count]; i++){
        rate_tmp = [ratesGeneralArray objectAtIndex:i]; i++;
        description_tmp = [ratesGeneralArray objectAtIndex:i];
        [ratesStr appendString:description_tmp];
        [ratesStr appendString:@"\t: "];
        [ratesStr appendString:rate_tmp];
        [ratesStr appendString:@"\n"];
    }
    [ratesStr appendString:@"\n\n"];
    [ratesStr appendString:@"Group Rates:\n\n"];
    for (int j = 0; j < [ratesGroupArray count]; j++){
        rate_tmp = [ratesGroupArray objectAtIndex:j]; j++;
        description_tmp = [ratesGroupArray objectAtIndex:j];
        [ratesStr appendString:description_tmp];
        // we don't want tabbed text on Notes, which is the last item
        if (j == [ratesGroupArray count]-1) {
            [ratesStr appendString:@" : "];
        } else {
            [ratesStr appendString:@"\t: "];
        }
        [ratesStr appendString:rate_tmp];
        [ratesStr appendString:@"\n"];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    CGFloat tabInterval = 225.0;
    paragraphStyle.defaultTabInterval = tabInterval;
    NSMutableArray *tabs = [NSMutableArray array];
    [tabs addObject:[[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentLeft location:tabInterval options:nil]];
    paragraphStyle.tabStops = tabs;
    self.description.typingAttributes = [NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    self.description.editable = NO;
    self.description.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
    self.description.text = ratesStr;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// this code is needed since iOS 7 has different layout
- (void) viewDidLayoutSubviews {
    [self.scroll setContentSize:CGSizeMake(320, 500)];
}

@end
