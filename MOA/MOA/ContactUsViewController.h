//
//  ContactUsViewController.h
//  MOA
//
//  Created by Diana Sutandie on 11/23/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ContactUsViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextView* myView;
-(IBAction)buttonPressed:(id)sender;


@end
