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
    
    NSString *htmlString = @"<html><head><meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 212\"/></head><body style=\"background:#F00;margin-top:0px;margin-left:0px\"><div><object width=\"212\" height=\"172\"><param name=\"movie\" value=\"http://www.youtube.com/v/oHg5SJYRHA0&f=gdata_videos&c=ytapi-my-clientID&d=nGF83uyVrg8eD4rfEkk22mDOl3qUImVMV6ramM\"></param><param name=\"wmode\" value=\"transparent\"></param><embed src=\"http://www.youtube.com/v/oHg5SJYRHA0&f=gdata_videos&c=ytapi-my-clientID&d=nGF83uyVrg8eD4rfEkk22mDOl3qUImVMV6ramM\"type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"212\" height=\"172\"></embed></object></div></body></html>";
    
    [youtubeWebView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://www.your-url.com"]];
//    
//    
//    NSString *channelName = @"MUSEUMofANTHROPOLOGY";
//    
//    NSURL *linkToAppURL = [NSURL URLWithString:[NSString stringWithFormat:@"youtube://user/%@",channelName]];
//    NSURL *linkToWebURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/user/%@",channelName]];
//    
//    if ([[UIApplication sharedApplication] canOpenURL:linkToAppURL]) {
//        // Can open the youtube app URL so launch the youTube app with this URL
//        [[UIApplication sharedApplication] openURL:linkToAppURL];
//    }
//    else{
//        // Can't open the youtube app URL so launch Safari instead
//        [[UIApplication sharedApplication] openURL:linkToWebURL];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
