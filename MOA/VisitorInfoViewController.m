//
//  VisitorInfoViewController.m
//  MOA
//
//  Created by Marilyn Edgar on 11/16/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "VisitorInfoViewController.h"
#import "SWRevealViewController.h"

@interface VisitorInfoViewController ()

@end


@implementation VisitorInfoViewController


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

    
    self.title = @"Visitor Information";
    
    // Sidebar menu code
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: @"http://localhost/eece419/home.php"]];
    NSError         * e;
    NSData      *remoteData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&e];
    NSString *strResult = [[NSString alloc] initWithData:remoteData encoding:NSUTF8StringEncoding];
    NSData *jsonData = [strResult dataUsingEncoding:NSUTF8StringEncoding];
    e = nil;
    NSString *strPulledData = @"";
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: jsonData options: NSJSONReadingMutableContainers error: &e];
    
    // regarding visitor Information data:
    // [0] : cafe hours
    // [1] : parking and directions
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", e);
    } else {
        NSDictionary *info;
        NSString *tableName = @"";
        NSString *keyName = @"";
        //visitorInformationArray = [[NSMutableArray alloc]init];
        int index = 0;
        for(NSDictionary *item in jsonArray) {
            pulledData = item;
            NSEnumerator *enumerator = [pulledData keyEnumerator];
            id key;
            while((key = [enumerator nextObject])){
                strPulledData = @"";
                for (NSDictionary *temp in [pulledData objectForKey:key]){
                    info = temp;
                    NSEnumerator *enumInfo = [info keyEnumerator];
                    id keyInfo;
                    while((keyInfo = [enumInfo nextObject])){
                        strPulledData = [strPulledData stringByAppendingString:((NSString*)[info objectForKey:keyInfo])];
                        if (index != 0) {
                            index = 0;
                            strPulledData = [strPulledData stringByAppendingString:@"\n"];
                        } else {
                            index++;
                            strPulledData = [strPulledData stringByAppendingString:@" : "];
                        }
                        
                        // put info to the right local storage
                        if ([tableName isEqualToString:@"Parking"])
                        {
                            [parkingInformationArray addObject:(NSString*)[info objectForKey:keyInfo]];
                            tableName = @"Default";
                        }
                        
                        // check each table
                        keyName = (NSString*)[info objectForKey:keyInfo];
                        if ([keyName isEqualToString:@"Parking"] ||
                            [keyName isEqualToString:@"Public Transit "] ||
                            [keyName isEqualToString:@"From Vancouver and the Lower Mainland"] ||
                            [keyName isEqualToString:@"From Vancouver International Airport"])
                        {
                            tableName = @"Parking";
                        }
                    }
                }
                NSLog(@"%@", strPulledData);
                NSString *parsedData = strPulledData;
                [visitorInformationArray addObject:parsedData];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
