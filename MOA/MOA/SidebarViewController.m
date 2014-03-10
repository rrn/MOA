//
//  SidebarViewController.m
//  
//
//  Created by Diana Sutandie on 11/5/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "EmailHandler.h"
#import "WhatsOnThisWeekViewController.h"
#import "VisitorInfoViewController.h"
#import "SocialMediaViewController.h"
#import "AboutViewController.h"
#include "TagList.h"

@interface SidebarViewController ()

@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation SidebarViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.separatorColor = [UIColor colorWithWhite:0.15f alpha:0.2f];
    
    _menuItems = @[@"Cell0", @"Calendar", @"Cell2", @"Explore Our Collections", @"Cell4", @"Cell5", @"Cell6", @"Cell7", @"Cell8", @"Cell9", @"Cell10"];
    
    
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Make sure we are using the SWRevealViewControllerSegue
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc)
        {
            // The name of our view controller we want to navigate to
            NSString *vcName = @"";
            
            // Set the name of the Storyboard ID we want to switch to
            if ([segue.identifier isEqualToString:@"showCalendar"])
            {
                // get the UITabBarController
                vcName = @"TabBar";
                UITabBarController *vcNew = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:vcName];
                [self.revealViewController setFrontViewController:vcNew];
                [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
                
                // select index 0, which is THIS WEEK AT MOA
                [vcNew setSelectedIndex:0];
                
            } else if ([segue.identifier isEqualToString:@"showExplore"]){
                
                // get the UITabBarController
                vcName = @"TabBar";
                UITabBarController *vcNew = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:vcName];
                [self.revealViewController setFrontViewController:vcNew];
                [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
                
                // select index 1, which is Explore our Collections
                [vcNew setSelectedIndex:1];

            } else  if ([segue.identifier isEqualToString:@"showExhibitions"]) {
                vcName = @"TabBar";
                UITabBarController *vcNew = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:vcName];
                
                // Swap out the Front view controller and display
                [self.revealViewController setFrontViewController:vcNew];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated:YES];
                
                // select index 2, which is Exhibitions
                [vcNew setSelectedIndex:2];
            
            } else  if ([segue.identifier isEqualToString:@"showVisitor"]) {
                vcName = @"TabBar";
                UITabBarController *vcNew = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:vcName];
                
                // Swap out the Front view controller and display
                [self.revealViewController setFrontViewController:vcNew];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated:YES];
                
                // select index 3, which is Visitor Information
                [vcNew setSelectedIndex:3];
                
            }
            else if ([segue.identifier isEqualToString:@"showFacebook"]){
                vcName = @"TabBar";
                UITabBarController *vcNew = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:vcName];
                
                // Swap out the Front view controller and display
                [self.revealViewController setFrontViewController:vcNew];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated:YES];
                
                
                [[TagList sharedInstance] setExtraPage:0];
                // select index 3, which is Visitor Information
                [vcNew setSelectedIndex:4];
            }
            else if ([segue.identifier isEqualToString:@"showTwitter"]){
                vcName = @"TabBar";
                UITabBarController *vcNew = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:vcName];
                
                // Swap out the Front view controller and display
                [self.revealViewController setFrontViewController:vcNew];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated:YES];
                
                
                [[TagList sharedInstance] setExtraPage:1];
                // select index 3, which is Visitor Information
                [vcNew setSelectedIndex:4];
            }
            else if ([segue.identifier isEqualToString:@"showYoutube"]){
                vcName = @"TabBar";
                UITabBarController *vcNew = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:vcName];
                
                // Swap out the Front view controller and display
                [self.revealViewController setFrontViewController:vcNew];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated:YES];
                
                
                [[TagList sharedInstance] setExtraPage:2];
                // select index 3, which is Visitor Information
                [vcNew setSelectedIndex:4];
            }
        };
        }
    }

-(IBAction)finishedDoingWhatever:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 8 || indexPath.row == 9) {
    
    //[self.revealViewController setFrontViewController:vcNew];
    //[self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated:YES];
    
    EmailHandler* emailHandler = [[EmailHandler alloc]init];
        if (indexPath.row == 8) {
            MFMailComposeViewController* controller = [emailHandler composeEmail:0];
            controller.mailComposeDelegate = self;
            if (controller) [self presentViewController:controller animated:YES completion:nil];
        }
        else {
            MFMailComposeViewController* controller = [emailHandler composeEmail:1];
            controller.mailComposeDelegate = self;
            if (controller) [self presentViewController:controller animated:YES completion:nil];
        }
    }
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

@end
