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

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor colorWithRed:237.0f/255.0f green:12.0f/255.0f blue:110.0f/255.0f alpha:1.0f]];
    
}

- (void)viewDidLoad
{
    UIImage *image0 = [UIImage imageNamed:@"01_Weekly_22px.png"];
    UIImage *image2 = [UIImage imageNamed:@"02_Exhibitions_22px.png"];
    UIImage *image1 = [UIImage imageNamed:@"03_Collections02_22px.png"];
    UIImage *image3 = [UIImage imageNamed:@"04_Info_22px.png"];
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    UITabBarItem *item3 = [tabBar.items objectAtIndex:3];
    
    
    
    
    self.tabBarController.tabBar.tintColor = [UIColor blackColor];
    [self.tabBarController.tabBar setTintColor:[UIColor blackColor]];
    
    item0.selectedImage = [image0 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.selectedImage = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.selectedImage = [image3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:28.0f/255.0f green:28.0f/255.0f blue:28.0f/255.0f alpha:1.0f]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:28.0f/255.0f green:28.0f/255.0f blue:28.0f/255.0f alpha:1.0f]];
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    
    // Title Color
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    // Side Bar Menu
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor] ];
    
    //Tab bar
    [self.tabBarController.tabBar setBarTintColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];

    
    


    
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
    NSMutableArray *idTags = [[NSMutableArray alloc] init];
    
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.ca"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
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
            if([[[TagList sharedInstance] objectTypeTags] count]==0){
                [TagList downloadCulturesJson];
                [TagList downloadMaterialsJson];
                [TagList downloadPeopleJson];
                [TagList downloadPlacesJson];
                [TagList downloadObjectJson];
            }
            
//            NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789/- "] invertedSet];
//            
//            if ([searchText rangeOfCharacterFromSet:set].location == NSNotFound){
            NSString *jsonString = [ [NSMutableString alloc]
                                    initWithContentsOfURL:[ [NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.rrncommunity.org/filters/autocomplete_tags.json?filters=held+at+MOA+University+of+British+Columbia,+id+%@",searchText ]]
                                    encoding:NSUTF8StringEncoding
                                    error:nil
                                    ];
            NSData *jsonData = [[jsonString dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
            
            if(jsonData != nil){
            NSDictionary *entireDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            
            NSArray *entireIdTagArrary = [[entireDictionary objectEnumerator] allObjects];
            
            
            for(int i=0; i < [entireIdTagArrary count]; i++){
                
                NSDictionary *temp = [entireIdTagArrary objectAtIndex:i];
                [idTags addObject:[[temp objectForKey:@"name"] capitalizedString]];
                
            }
            }
//            }
        }
    if([allTags count] < 1){
        allTags = [[TagList sharedInstance] objectTypeTags];
        allTags = [[allTags arrayByAddingObjectsFromArray:[[TagList sharedInstance] placesTags]] mutableCopy];
        allTags = [[allTags arrayByAddingObjectsFromArray:[[TagList sharedInstance] materialsTags]] mutableCopy];
        allTags = [[allTags arrayByAddingObjectsFromArray:[[TagList sharedInstance] culturesTags]] mutableCopy];
        allTags = [[allTags arrayByAddingObjectsFromArray:[[TagList sharedInstance] peopleTags]] mutableCopy];
    }
    
    
    searchArray = [[allTags filteredArrayUsingPredicate:predicate] mutableCopy];
    [searchArray addObjectsFromArray:idTags];
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
