//
//  WhatsOnThisWeekViewController.m
//  MOA
//
//  Created by Diana Sutandie on 11/7/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "SWRevealViewController.h"
#import "WhatsOnThisWeekViewController.h"
#import "Reachability.h"
#import "TagList.h"
#import "WOTWEventViewController.h"

@interface WhatsOnThisWeekViewController ()

@end

@implementation WhatsOnThisWeekViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    
    // Set the gesture
    self.title = @"This Week at MOA";
    self.tableView.rowHeight=70;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 1;
    // Return the number of rows in the section.
    return [[[TagList sharedInstance] calendarEvents] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"eventCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    cell.textLabel.numberOfLines=3;
    NSDictionary *event = [[[TagList sharedInstance] calendarEvents] objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@",[event objectForKey:@"programType"], [event objectForKey:@"title"],[event objectForKey:@"date"]];
    cell.imageView.image = [UIImage imageWithData: [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[event objectForKey:@"image"]]]];
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    WOTWEventViewController *view = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    view.title = [[[NSDictionary alloc] initWithDictionary:[[[TagList sharedInstance] calendarEvents] objectAtIndex:indexPath.row]] objectForKey:@"title"];
    view.index = indexPath.row;
}


@end
