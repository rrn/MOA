//
//  TagAdditionViewController.m
//  MOA
//
//  Created by Sukhi Mann on 11/14/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "TagAdditionViewController.h"

@interface TagAdditionViewController ()

@end

@implementation TagAdditionViewController

{
    NSMutableArray *characterList;
}

@synthesize tagTable;

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
    self.tagTable.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
    characterList = [[NSMutableArray alloc] init];
    [self readItemJson:[self title]];
    

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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [characterList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [characterList objectAtIndex:indexPath.row];
    return cell;
}

- (void)readItemJson:(NSString *)operation{
    
    NSInteger tempNumber = self.navigationController.viewControllers.count;
    NSString *previousTitle = [[self.navigationController.viewControllers objectAtIndex:tempNumber-2] title];
    
  
    NSArray *entireTagArrary = [[NSArray alloc] init];
    if([previousTitle isEqualToString:@"Places"]){
        
        entireTagArrary = [[TagList sharedInstance] placesTags];
        
    }
    else if([previousTitle isEqualToString:@"Object Type"]){
        
        entireTagArrary = [[TagList sharedInstance] objectTypeTags];
        
    }
    else if([previousTitle isEqualToString:@"Cultures"]){
        
        entireTagArrary = [[TagList sharedInstance] culturesTags];
        
    }
    else if([previousTitle isEqualToString:@"Materials"]){
        
        entireTagArrary = [[TagList sharedInstance] materialsTags];
        
    }
    else if([previousTitle isEqualToString:@"People"]){
        
        entireTagArrary = [[TagList sharedInstance] peopleTags];
        
    }
    
    for(int i=0; i < [entireTagArrary count]; i++){
       
        if(![[[entireTagArrary objectAtIndex:i] lowercaseString] hasPrefix:self.title.lowercaseString] && [characterList count] > 0){
            [tagTable reloadData];
            return;
        }
        
        if([[[entireTagArrary objectAtIndex:i] lowercaseString] hasPrefix:self.title.lowercaseString]){
            
            [characterList addObject:[entireTagArrary objectAtIndex:i]];
            
        }
    }
    
    [tagTable reloadData];
    return;
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
