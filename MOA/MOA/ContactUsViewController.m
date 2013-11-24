//
//  ContactUsViewController.m
//  MOA
//
//  Created by Diana Sutandie on 11/23/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "ContactUsViewController.h"


@interface ContactUsViewController ()
@end

@implementation ContactUsViewController

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
    _myView.text = @"info@moa.ubc.ca";
    _myView.editable = NO;
    
    // add gesture recognizer to the mail
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapRecognized:)];
    singleTap.numberOfTapsRequired = 1;
    [_myView addGestureRecognizer:singleTap];

    [super viewDidLoad];
    
}

- (void)singleTapRecognized:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"single tap");
    
    MFMailComposeViewController *composer =[[MFMailComposeViewController alloc] init];
    NSArray *usersTo = [NSArray arrayWithObject: @"info@moa.ubc.ca"];
    [composer setMailComposeDelegate:self];
    [composer setToRecipients:usersTo];
    [composer setSubject:@"Message from MOA App User"];
    [composer setMessageBody:@"Email Body" isHTML:YES];
    
    [self presentModalViewController:composer animated:YES];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
