//
//  SocialMediaViewController.m
//  MOA
//
//  Created by Donald Cheng on 2/19/2014.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import "SocialMediaViewController.h"
#import "SWRevealViewController.h"
#import "Reachability.h"
#import "TagList.h"

@interface SocialMediaViewController ()
@property (strong, nonatomic)  UIBarButtonItem *nextItem;
@property (strong, nonatomic)  UIBarButtonItem *previousItem;
@property (strong, nonatomic) UIBarButtonItem *spacing;
@end

@implementation SocialMediaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)previousItem:(id)sender{
    if(_webView.canGoBack==YES){
        [_webView goBack];
    }
}

-(IBAction)nextItem:(id)sender{
    if(_webView.canGoForward){
        [_webView goForward];
    }
}
//After looking into it, canGoForward and canGoBack are flawed and not working properly at the moment,
//Apple needs to fix this before button utility works better
//Source: http://www.mobilexweb.com/blog/safari-ios7-html5-problems-apis-review
//
//- (void)webViewDidStartLoad:(UIWebView *)webView {
//    _previousItem.enabled = (_webView.canGoBack);
//    _nextItem.enabled = (_webView.canGoForward);
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    _previousItem.enabled = (_webView.canGoBack);
//    _nextItem.enabled = (_webView.canGoForward);
//}
//
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    _previousItem.enabled = (_webView.canGoBack);
//    _nextItem.enabled = (_webView.canGoForward);
//    return YES;
//}



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
    
    _nextItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(nextItem:)];
    _previousItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(previousItem:)];
    _spacing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    _spacing.width = [UIScreen mainScreen].bounds.size.width/6;
    NSMutableArray *toolbarButtons = [self.navigationItem.rightBarButtonItems mutableCopy];
    _webView.delegate=self;

    
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
            if(![toolbarButtons containsObject:_nextItem])
            {
                [toolbarButtons addObject:_spacing];
                [toolbarButtons addObject:_nextItem];
                [toolbarButtons addObject:_previousItem];
                [self.navigationItem setRightBarButtonItems:toolbarButtons animated:YES];
            }
        } else if ([[TagList sharedInstance] extraPage] ==1) {
            NSString *urlAddress = @"https://twitter.com/MOA_UBC";
            NSURL *url = [NSURL URLWithString:urlAddress];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            _webView.hidden = NO;
            [_webView loadRequest:requestObj];
            if(![toolbarButtons containsObject:_nextItem])
            {
                [toolbarButtons addObject:_spacing];

                [toolbarButtons addObject:_nextItem];
                [toolbarButtons addObject:_previousItem];
                [self.navigationItem setRightBarButtonItems:toolbarButtons animated:YES];
            }
        } else if ([[TagList sharedInstance] extraPage] ==2) {
            NSString *urlAddress = @"http://www.youtube.com/user/MUSEUMofANTHROPOLOGY";
            NSURL *url = [NSURL URLWithString:urlAddress];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            _webView.hidden = NO;
            [_webView loadRequest:requestObj];
            if(![toolbarButtons containsObject:_nextItem])
            {
                [toolbarButtons addObject:_spacing];
                [toolbarButtons addObject:_nextItem];
                [toolbarButtons addObject:_previousItem];
                [self.navigationItem setRightBarButtonItems:toolbarButtons animated:YES];
            }
        }else{
            [toolbarButtons removeObject:_nextItem];
            [toolbarButtons removeObject:_previousItem];
            [toolbarButtons removeObject:_spacing];
            [self.navigationItem setRightBarButtonItems:toolbarButtons];
            _webView.hidden = YES;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
