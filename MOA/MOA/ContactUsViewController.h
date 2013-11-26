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

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, weak) IBOutlet UITextView* myView;
@property (nonatomic, weak) IBOutlet UITextView* webLink;


@end

UITextView *phone2;
UITextView *phone1;



