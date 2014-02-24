//
//  FacebookViewController.m
//  MOA
//
//  Created by Donald Cheng on 2/19/2014.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import "FacebookViewController.h"
#import "SWRevealViewController.h"
#import "Reachability.h"
#import "TagList.h"

@interface FacebookViewController ()

@end

@implementation FacebookViewController

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
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sideBarButton.target = self.revealViewController;
    _sideBarButton.action = @selector(rightRevealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.ca"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if(internetStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Alert!"
                              message: @"There is no internet connection, certain features will not be fully functional."
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        if([[TagList sharedInstance] extraPage] == 0){
            NSString *urlAddress = @"http://www.facebook.com/MOAUBC";
            NSURL *url = [NSURL URLWithString:urlAddress];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            _webView.hidden = NO;
            [_webView loadRequest:requestObj];
        } else if ([[TagList sharedInstance] extraPage] ==1) {
            NSString *urlAddress = @"https://twitter.com/MOA_UBC";
            NSURL *url = [NSURL URLWithString:urlAddress];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            _webView.hidden = NO;
            [_webView loadRequest:requestObj];
        }
        else
            _webView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
