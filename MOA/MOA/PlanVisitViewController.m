//
//  PlanVisitViewController.m
//  MOA
//
//  Created by Marilyn Edgar on 11/16/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "PlanVisitViewController.h"
#import "SWRevealViewController.h"
#import "DBDataList.h"
#import "DBData.h"

#define DegreesToRadians(x) (M_PI * x / 180.0)

@interface PlanVisitViewController ()

@end

@implementation PlanVisitViewController {
    
    NSArray *sectionData;
    NSArray *rowData;
    
    NSString *locationData;

}

@synthesize datas;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    if (section == 1)
        return YES;
    
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Sidebar menu code
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc] init];
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    sectionData = [NSArray arrayWithObjects:@"Location",@"Directions & Parking", @"Hours", @"Rates", nil];
    
    rowData = [NSArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array], [NSMutableArray array],[NSMutableArray array], nil];
    
    [[rowData objectAtIndex:0] addObject:@"Blank"];// 0 : location
    [[rowData objectAtIndex:0] addObject:@"Museum of Anthropology at University of British Columbia 6393 NW Marine Drive Vancouver BC"];
    [[rowData objectAtIndex:1] addObject:@"Blank"];// 1 : directions and parking
    [[rowData objectAtIndex:1] addObject:@"MOA is located on the campus of the University of British Columbia, 20 minutes from downtown Vancouver."];
    [[rowData objectAtIndex:1] addObject:@"Get Directions to MOA"];
    [[rowData objectAtIndex:1] addObject:@"Parking"];
    [[rowData objectAtIndex:1] addObject:@"Public Transit"];
    [[rowData objectAtIndex:1] addObject:@"From Vancouver"];
    [[rowData objectAtIndex:1] addObject:@"From YVR"];
    [[rowData objectAtIndex:2] addObject:@"Blank"];// 2 : hours
    [[rowData objectAtIndex:2] addObject:@"Label8"];
    [[rowData objectAtIndex:3] addObject:@"Blank"];// 3 : rates
    [[rowData objectAtIndex:3] addObject:@"Label9"];
    
    self.title = @"Plan a Visit";
    
    // Side bar button code - set action and gesture (swipe)
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // we want to be able to scroll
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320, 700)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [tableData count];
    if ([self tableView:tableView canCollapseSection:section])
    {
        //section is expanded
        if ([expandedSections containsIndex:section])
        {
            // return rows when expanded
            if ( section == 1 ) {
                return 7;
            }
            else {
                return 2;
            }
        }
        
        return 1; // only top row showing
    }
    
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VisitCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if ( [self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            // first row
            cell.textLabel.text = sectionData[indexPath.section]; // only top row showing
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.accessoryView = nil;
        }
        else
        {
            // accordion sub rows
            if (indexPath.section == 1 && indexPath.row == 1)
            {
                cell.userInteractionEnabled = NO;
                cell.textLabel.numberOfLines = 5;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.accessoryView = nil;
            cell.textLabel.text = [[rowData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        }
    }
    else
    {
        // normal non-accordion rows
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = sectionData[indexPath.section];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            // only first row toggles exapand/collapse
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSInteger section = indexPath.section;
            BOOL currentlyExpanded = [expandedSections containsIndex:section];
            NSInteger rows;
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            if (currentlyExpanded)
            {
                rows = [self tableView:tableView numberOfRowsInSection:section];
                [expandedSections removeIndex:section];
                
            }
            else
            {
                [expandedSections addIndex:section];
                rows = [self tableView:tableView numberOfRowsInSection:section];
            }
            
            for (int i=1; i<rows; i++)
            {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                               inSection:section];
                [tmpArray addObject:tmpIndexPath];
            }
            
            if (currentlyExpanded)
            {
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
            }
            else
            {
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
            }
        }
        
        else {
            if (indexPath.row == 3)
            {
                UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"parkingViewController"];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            else if (indexPath.row == 4)
            {
                UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"publicTransitViewController"];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            else if (indexPath.row == 5)
            {
                UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"lowerMainlandViewController"];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            else if (indexPath.row == 6)
            {
                UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"airportViewController"];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            
        }
    }
    else
    {
        if (!indexPath.row)
        {
            // Location Page
            if (indexPath.section == 0)
            {
                UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"locationViewController"];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            // Hours Page
            else if (indexPath.section == 2)
            {
                UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"hoursViewController"];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            // Rates Page
            else if (indexPath.section == 3)
            {
                UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ratesViewController"];
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }
    }
        
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
	if (indexPath.section == 1 && indexPath.row == 1)
    {
		return 120;///it's open
	}
    else
    {
		return 45;///it's closed
	}
    
}


@end
