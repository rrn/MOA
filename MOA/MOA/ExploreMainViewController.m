//
//  ExploreMainViewController.m
//  MOA
//
//  Created by Sukhi Mann on 11/3/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "ExploreMainViewController.h"
#import "SWRevealViewController.h"
#import "SearchResultListViewController.h"
#import "TagList.h"
#import "Reachability.h"
#import "TagAdditionViewController.h"

@interface ExploreMainViewController ()

@end

@implementation ExploreMainViewController
{
    NSArray *tableData;
    NSMutableArray* searchArray;
    NSMutableArray *allTags;
    NSIndexPath *selectedPath;
}

@synthesize searchBar;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    tableData = [NSArray arrayWithObjects:@"Object Type", @"Places", @"Cultures", @"Materials", @"People", nil];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    searchArray = [[NSMutableArray alloc] init];
    allTags = [[TagList sharedInstance] objectTypeTags];
    allTags = [[allTags arrayByAddingObjectsFromArray:[[TagList sharedInstance] placesTags]] mutableCopy];
    allTags = [[allTags arrayByAddingObjectsFromArray:[[TagList sharedInstance] materialsTags]] mutableCopy];
    allTags = [[allTags arrayByAddingObjectsFromArray:[[TagList sharedInstance] culturesTags]] mutableCopy];
    allTags = [[allTags arrayByAddingObjectsFromArray:[[TagList sharedInstance] peopleTags]] mutableCopy];

    selectedPath = [[NSIndexPath alloc]init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)filterContentForSearchText: (NSString*) searchText{
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"SELF contains [c] %@", searchText];
    
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.ca"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if([[[TagList sharedInstance] objectTypeTags] count] ==0){
        if(internetStatus == NotReachable) {
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Alert!"
                                  message: @"There is no internet connection, item tags cannot be loaded."
                                  delegate: self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
        else{
            [TagList downloadCulturesJson];
            [TagList downloadMaterialsJson];
            [TagList downloadPeopleJson];
            [TagList downloadPlacesJson];
            [TagList downloadObjectJson];
        }
    }
    if([allTags count] < 1){
        allTags = [[TagList sharedInstance] objectTypeTags];
        allTags = [[allTags arrayByAddingObjectsFromArray:[[TagList sharedInstance] placesTags]] mutableCopy];
        allTags = [[allTags arrayByAddingObjectsFromArray:[[TagList sharedInstance] materialsTags]] mutableCopy];
        allTags = [[allTags arrayByAddingObjectsFromArray:[[TagList sharedInstance] culturesTags]] mutableCopy];
        allTags = [[allTags arrayByAddingObjectsFromArray:[[TagList sharedInstance] peopleTags]] mutableCopy];
    }
    
    
    searchArray = [[allTags filteredArrayUsingPredicate:predicate] mutableCopy];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString];
    return YES;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedPath = indexPath;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [self performSegueWithIdentifier:@"categoriesView" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"alphabeticalView" sender: self];
    }
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
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
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchArray count];
    }
    
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    
    CellIdentifier = @"FilterCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [searchArray objectAtIndex:indexPath.row];
    }else{
        cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"categoriesView"]){
        SearchResultListViewController *view = [segue destinationViewController];
        view.title = [searchArray objectAtIndex:selectedPath.row];
    }
    else{
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TagAdditionViewController *destViewController = segue.destinationViewController;
        destViewController.title = [tableData objectAtIndex:indexPath.row];
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
