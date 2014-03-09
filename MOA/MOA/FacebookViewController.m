//
//  FacebookViewController.m
//  MOA
//
//  Created by Donald Cheng on 2014-03-09.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import "FacebookViewController.h"
#import "Reachability.h"

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
        NSString *urlAddress = @"http://www.facebook.com/MOAUBC";
        NSURL *url = [NSURL URLWithString:urlAddress];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        _webView.hidden = NO;
        [_webView loadRequest:requestObj];
    }
    
}

-(IBAction)exit:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonPressed:(id)sender {
    if(_webView.canGoBack==YES){
        [_webView goBack];
    }
    
}

- (IBAction)forwardButtonPressed:(id)sender {
    if(_webView.canGoForward){
        [_webView goForward];
    }
}

- (IBAction)refreshButtonPressed:(id)sender {
    [_webView reload];
}
@end
