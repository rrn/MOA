//
//  MOAShopViewController.m
//  MOA
//
//  Created by Diana Sutandie on 11/23/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "MOAShopViewController.h"

@interface MOAShopViewController ()

@end

@implementation MOAShopViewController

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
    
    NSMutableString* text = [NSMutableString stringWithFormat:@""];
    bool foundShopDescription = FALSE;
    for (int index = 0; index < [generalTextArray count]; index++){
        if (foundShopDescription == TRUE){
            text = [generalTextArray objectAtIndex:index];
            break;
        }
        if ([[generalTextArray objectAtIndex:index] isEqualToString:@"Shop"]){
            foundShopDescription = TRUE;
        }
    }
    
    self.title = @"MOA Shop";
    self.description.numberOfLines = 0;
    self.description.text = text;
    [self.description sizeToFit];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
