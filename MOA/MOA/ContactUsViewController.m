//
//  ContactUsViewController.m
//  MOA
//
//  Created by Diana Sutandie on 11/23/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "ContactUsViewController.h"


@interface ContactUsViewController ()

-(void) phoneNumbersInitialization;
-(void) emailInitialization;
-(void) contentsInitialization;
-(void) urlInitialization;

@end

@implementation ContactUsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {


    }
    return self;
}

- (void)viewDidLoad
{
    [self contentsInitialization];
    [super viewDidLoad];
    
}

- (void)contentsInitialization{
    [self phoneNumbersInitialization];
    [self emailInitialization];
    [self urlInitialization];
}

-(void)emailInitialization{
    _myView.text = @"info@moa.ubc.ca";
    _myView.editable = NO;
    _myView.dataDetectorTypes = UIDataDetectorTypeLink;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapRecognized:)];
    singleTap.numberOfTapsRequired = 1;
    [_myView addGestureRecognizer:singleTap];

}

-(void)urlInitialization{
    _webLink.text = @"www.moa.ubc.ca";
    _webLink.editable = NO;
    _webLink.dataDetectorTypes = UIDataDetectorTypeLink;
}


- (void)phoneNumbersInitialization{
    phone1 = [[UITextView alloc] initWithFrame:CGRectMake(166, 211, 123, 29)];
    phone2 = [[UITextView alloc] initWithFrame:CGRectMake(166, 258, 123, 29)];
    phone1.text = @"604.822.5087";
    phone2.text = @"604.822.5932";
    
    NSArray *phoneNumbers = [NSArray arrayWithObjects: phone1, phone2, nil];
    for (UITextView *phone in phoneNumbers){
        phone.font = [UIFont systemFontOfSize:15];
        phone.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
        phone.editable = NO;
        phone.selectable = YES;
        phone.scrollEnabled = NO;
        phone.userInteractionEnabled = YES;
        phone.delegate = self;
        [self.view addSubview:phone];
    }
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
