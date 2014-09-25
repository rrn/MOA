//
//  WhatsOnThisWeekViewController.m
//  MOA
//
//  Created by Diana Sutandie on 11/7/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "SWRevealViewController.h"
#import "WhatsOnThisWeekViewController.h"

@interface WhatsOnThisWeekViewController ()

@end

@implementation WhatsOnThisWeekViewController

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
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    
    [self.theScrollView setContentSize:CGSizeMake(((self.view.frame.size.width)*7), 1000)];
    self.theScrollView.pagingEnabled = YES;
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

//Method to load all the "What's on this Week" information"
//-(void) loadInformation
//{
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: @"http://pluto.moa.ubc.ca/_mobile_app_remoteData.php"]];
//    NSError * e;
//    NSData *remoteData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&e];
//    NSMutableString* strRemoteData =[[NSMutableString alloc] initWithData:remoteData encoding:NSUTF8StringEncoding];
//    //[self validateJSONString]; //sometimes data are returned in HTML form, we need to validate
//    strRemoteData = [NSMutableString stringWithString:[VisitorInfoViewController ValidateJSONFormat:strRemoteData]];
//    NSData *jsonData = [strRemoteData dataUsingEncoding:NSUTF8StringEncoding];
//    e = nil; // reset e variable
//    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];
//    
//    if (e) {
//        NSLog(@"Error serializing %@", e);
//    }
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
