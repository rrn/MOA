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
#import "WhatsOnThisWeekViewController.h"
#import "VisitorInfoViewController.h"



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
    
    _menuItems = @[@"Cell0", @"Cell1", @"Cell2", @"Explore Our Collections", @"Cell4", @"Cell5", @"Cell6", @"Cell7"];
    
    
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
            if ([segue.identifier isEqualToString:@"showThisWeek"])
            {
                // get the UITabBarController
                vcName = @"TabBar";
                UITabBarController *vcNew = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:vcName];
                [self.revealViewController setFrontViewController:vcNew];
                [self.revealViewController setFrontViewPosition:FrontViewPositionLeft];
                
                // select index 0, which is THIS WEEK AT MOA
                [vcNew setSelectedIndex:0];
                
                // ** EXTRA CODE PLEASE DONT REMOVE FOR NOW - DIANA **
                //[vcNew.tabBarController.view setHidden:FALSE];
                //AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
                //[appDelegate Set:1];
                //[self.revealViewController setFrontViewController:vcNew];
                //[self.revealViewController setFrontViewPosition:FrontViewPositionLeft];
                //[self.parentViewController.tabBarController setSelectedIndex:0];
                //[self.tabBarController setSelectedIndex:1];
                //[self.tabBarController.view setNeedsDisplay];
                
            } else if ([segue.identifier isEqualToString:@"showVisitor"]){
                
                // get the UITabBarController
                vcName = @"TabBar";
                UITabBarController *vcNew = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:vcName];
                [self.revealViewController setFrontViewController:vcNew];
                [self.revealViewController setFrontViewPosition:FrontViewPositionLeft];
                
                // select index 2, which is VISITOR INFORMATION PAGE
                [vcNew setSelectedIndex:2];
            } else  if ([segue.identifier isEqualToString:@"showExplore"]) {
                vcName = @"Explore";
                UIViewController *vcNew = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:vcName];
                
                // Swap out the Front view controller and display
                [self.revealViewController setFrontViewController:vcNew];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
                
            }
        };
    }
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{}

@end
