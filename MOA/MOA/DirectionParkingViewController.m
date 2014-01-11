//
//  DirectionParkingViewController.m
//  MOA
//
//  Created by Diana Sutandie on 11/19/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "DirectionParkingViewController.h"

@interface DirectionParkingViewController ()

@end

@implementation DirectionParkingViewController {
        NSArray *rowData;
}

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

    self.title = @"Directions & Parking";
    
    NSString *locationInfo = @"MOA is located on the campus of the University of British Columbia, 20 minutes from downtown Vancouver. Museum of Anthropology at University of British Columbia 6393 NW Marine Drive Vancouver BC";
    
    rowData = [NSArray arrayWithObjects:locationInfo, @"From YVR", @"From Lower Mainland", @"Public Transit", @"Parking", nil];
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DirParkCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.row == 0)
    {
        cell.userInteractionEnabled = NO;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = rowData[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
	if (indexPath.row == 0)
    {
		return 240;///it's open
	}
    else
    {
		return 45;///it's closed
	}
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"airportViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == 2)
    {
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"lowerMainlandViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == 3)
    {
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"publicTransitViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == 4)
    {
        UIViewController *viewController = [self.storyboard                                            instantiateViewControllerWithIdentifier:@"parkingViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

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
