//
//  YoutubePageViewController.h
//  MOA
//
//  Created by Donald Cheng on 2014-03-09.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YoutubePageViewController : UIViewController
- (IBAction)exit:(id)sender;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)forwardButtonPressed:(id)sender;
- (IBAction)refreshButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end
