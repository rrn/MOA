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
    //if (section>0)
    return YES;
    
    //return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc] init];
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    sectionData = [NSArray arrayWithObjects:@"Location",@"Directions & Parking", @"Hours", @"Rates", nil];
    
    rowData = [NSArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array], [NSMutableArray array],[NSMutableArray array], nil];
    
    NSArray *location;
    location = [NSArray arrayWithObjects:@"Blank", @"Label1", nil];
    
    [[rowData objectAtIndex:0] addObject:@"Blank"];  // 0 : location
    [[rowData objectAtIndex:0] addObject:@"Museum of Anthropology at University of British Columbia 6393 NW Marine Drive Vancouver BC"];
    [[rowData objectAtIndex:1] addObject:@"Blank"];         // 1 : directions and parking
    [[rowData objectAtIndex:1] addObject:@"Label2"];
    [[rowData objectAtIndex:1] addObject:@"Get Directions to MOA"];
    [[rowData objectAtIndex:1] addObject:@"Parking"];
    [[rowData objectAtIndex:1] addObject:@"Public Transit"];
    [[rowData objectAtIndex:1] addObject:@"From Vancouver and Lower Mainland"];
    [[rowData objectAtIndex:1] addObject:@"From Vancouver International Airport"];
    [[rowData objectAtIndex:2] addObject:@"Blank"];      // 2 : hours
    [[rowData objectAtIndex:2] addObject:@"Label8"];
    [[rowData objectAtIndex:3] addObject:@"Blank"];     // 3 : rates
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
    if (!indexPath.row)
    {
        // first row
        cell.textLabel.text = sectionData[indexPath.section]; // only top row showing
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.textLabel.text = [[rowData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if (indexPath.section == 0 && indexPath.row == 1){
            cell.textLabel.numberOfLines = 5;
        }
        
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        //NSLog(@"Row Data Array: %@", [[rowData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]);

        
//        if (indexPath.section == 1 ){
//            cell.textLabel.text = @"button TExt ";
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
//        
//        else {
//            if (indexPath.section == 0 ) {
//                if (indexPath.row == 0) {
//                    cell.textLabel.text = locationData;
//                }
//            }
//            
//            else {
//                cell.textLabel.text = @"Some Detail";
//            }
//            
//            
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
        
        // all other rows
        cell.accessoryView = nil;
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
            if(indexPath.row == 3)
            {
                UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"parkingViewController"];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            
            
        }
    }
}

@end
