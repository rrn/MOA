//
//  NewsletterViewController.h
//  MOA
//
//  Created by Donald Cheng on 2014-03-09.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsletterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)exit:(id)sender;

@end
