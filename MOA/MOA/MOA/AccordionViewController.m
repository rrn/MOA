//
//  AccordionViewController.m
//  MOA
//
//  Created by Marilyn Edgar on 11/19/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "AccordionViewController.h"

@interface AccordionViewController ()

@end

@implementation AccordionViewController
{
    NSArray *sectionData;
    NSArray *tableData;//mark to remove
    
    NSString *locationData;

}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIImageView* imageView = [[UIImageView alloc] initWithImage:
//                              [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Supporting Files/IMAGE/plan_a_vist" ofType:@"jpg"]]];
//    return imageView;
//}

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
    
    locationData = @"Museum of Anthropology at University of British Columbia 6393 NW Marine Drive Vancouver BC";

    
//    tableData = [NSArray arrayWithObjects:@"1",@"2", @"3", @"4", nil];
    
    self.title = @"Plan a Visit";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
//	if (sectionopen[indexPath.row]) {
//		return 240;///it's open
//	} else {
//		return 45;///it's closed
//	}
//    
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VisitCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    
    
    // Configure the cell...
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            // first row
            cell.textLabel.text = sectionData[indexPath.section]; // only top row showing
        }
        else
        {
            if (indexPath.section == 1 ){
                cell.textLabel.text = @"button TExt ";
            }
            
            else {
                if (indexPath.section == 0 ) {
                    if (indexPath.row == 0) {
                        cell.textLabel.text = locationData;
                    }
                }
                
                else {
                    cell.textLabel.text = @"Some Detail";
                }
                
                
                cell.accessoryType = UITableViewCellAccessoryNone;
            }

            // all other rows
            //cell.textLabel.text = detailText:indexPath.section and:indexPath.row;
            cell.accessoryView = nil;
            //cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else
    {
        cell.accessoryView = nil;
        cell.textLabel.text = @"Normal Cell";
        
    }
    
    return cell;
    
//    cell.textLabel.text = [sectionData objectAtIndex:indexPath.row];
//    return cell;
    
}

//- (NSString *)detailText:(NSInteger)sectionIndex and:(NSInteger)rowIndex
//{
//    if (sectionIndex == 0) {
//        return locationData;
//    }
//}

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
    }
}
//    
//    bool currentlySelected = YES;
//    
//    //check if closing the currently open
//    if ( sectionopen[indexPath.row]) {
//        currentlySelected = NO;
//    }
//    
//	///turn them all off
//	sectionopen[0]=NO;
//	sectionopen[1]=NO;
//	sectionopen[2]=NO;
//	sectionopen[3]=NO;
//    
//	///open this one
//	sectionopen[indexPath.row]=currentlySelected;
//    
//	///animate the opening and expand the row
//	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
