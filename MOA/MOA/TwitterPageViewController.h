//
//  TwitterPageViewController.h
//  MOA
//
//  Created by Donald Cheng on 2014-03-09.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterPageViewController : UIViewController
- (IBAction)exit:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)refreshButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)forwardButtonPressed:(id)sender;

@end
