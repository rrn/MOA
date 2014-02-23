//
//  YoutubeViewController.m
//  MOA
//
//  Created by Marilyn Edgar on 2/22/2014.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import "YoutubeViewController.h"

@interface YoutubeViewController ()

@end

@implementation YoutubeViewController

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
    
    NSString *channelName = @"MUSEUMofANTHROPOLOGY";
    
    NSURL *linkToAppURL = [NSURL URLWithString:[NSString stringWithFormat:@"youtube://user/%@",channelName]];
    NSURL *linkToWebURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/user/%@",channelName]];
    
    if ([[UIApplication sharedApplication] canOpenURL:linkToAppURL]) {
        // Can open the youtube app URL so launch the youTube app with this URL
        [[UIApplication sharedApplication] openURL:linkToAppURL];
    }
    else{
        // Can't open the youtube app URL so launch Safari instead
        [[UIApplication sharedApplication] openURL:linkToWebURL];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
