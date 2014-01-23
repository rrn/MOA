//
//  VisitorInfoViewController.m
//  MOA
//
//  Created by Marilyn Edgar on 11/16/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "VisitorInfoViewController.h"
#import "SWRevealViewController.h"
#import "CrudOp.h"

@interface VisitorInfoViewController ()

-(void) validateJSONString;
@end


@implementation VisitorInfoViewController {
    
    NSArray *sectionData;
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

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    if (section == 0)
        return YES;
    
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.title = @"Visitor Information";
    
    // Sidebar menu code
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // if there is a network,
    // Request Data from sever
    // else, load from DB
    
    [self clearOldData];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: @"http://pluto.moa.ubc.ca/_mobile_app_remoteData.php"]];
    NSError * e;
    NSData *remoteData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&e];
    strRemoteData =[[NSString alloc] initWithData:remoteData encoding:NSUTF8StringEncoding];
    [self validateJSONString]; //sometimes data are returned in HTML form, we need to validate
    NSData *jsonData = [strRemoteData dataUsingEncoding:NSUTF8StringEncoding];
    e = nil; // reset e variable
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];

    if (e) {
        NSLog(@"Error serializing %@", e);
    }
    //NSLog(@"%@",jsonDict);
    
    // NEEDS TO PERFORM UPDATE IN HERE - UPDATE THE LOCAL DB
    CrudOp *dbCrud = [[CrudOp alloc] init];
    NSMutableString *day, *hours;
    NSMutableString *description, *rate;
    NSMutableString *heading, *identifier;
    NSMutableString *temp;
    int rowIndex = 0;
    
    NSEnumerator *mainEnumerator = [jsonDict keyEnumerator];
    id key; NSArray *tableArray;
    while (key = [mainEnumerator nextObject]){
        rowIndex = 1;
        tableArray = [jsonDict objectForKey:key];
        for (NSDictionary *attribute in tableArray){
            NSEnumerator *attEnum = [attribute keyEnumerator];
            id attKey;
            while (attKey = [attEnum nextObject]){
                // attKey going to be rate etc, so need to insert to the array
                
                // GENERAL RATES
                if ([key isEqualToString:@"rates_general"]){
                    description = [NSMutableString stringWithString:[attribute objectForKey:@"Description"]];
                    rate = [NSMutableString stringWithString:[attribute objectForKey:@"Rate"]];
                    temp = [NSMutableString stringWithFormat:@"%@ \t: %@\n", description, rate];
                    [dbCrud UpdateRecords:rate :description : rowIndex :@"rateGeneral"];
                    [ratesGeneralArray addObject:temp];
                    
                // GROUP RATES
                } else if ([key isEqualToString:@"rates_groups"]){
                    description = [NSMutableString stringWithString:[attribute objectForKey:@"Description"]];
                    rate = [NSMutableString stringWithString:[attribute objectForKey:@"Rate"]];
                    temp = [NSMutableString stringWithFormat:@"%@ \t: %@\n", description, rate];
                    [ratesGroupArray addObject:temp];
                    [dbCrud UpdateRecords:rate :description :rowIndex :@"rateGroups"];
                
                // CAFE HOURS
                } else if ([key isEqualToString:@"cafe_hours"]) {
                    day = [NSMutableString stringWithString:[attribute objectForKey:@"Day"]];
                    hours = [NSMutableString stringWithString:[attribute objectForKey:@"Hours"]];
                    temp = [NSMutableString stringWithFormat:@"%@ \t: %@\n", day, hours];
                    [cafeHoursArray addObject:temp];
                    [dbCrud UpdateRecords:hours :day :rowIndex :@"cafeHours"];
                
                // PARKING AND DIRECTIONS
                } else if ([key isEqualToString:@"parking_and_directions"]){
                    description = [NSMutableString stringWithString:[attribute objectForKey:@"Description"]];
                    heading = [NSMutableString stringWithString:[attribute objectForKey:@"Heading"]];
                    [dbCrud UpdateRecords:description :heading :rowIndex :@"parkingDirections"];
                    [parkingInformationArray addObject:description];
                    
                // GENERAL HOURS
                } else if ([key isEqualToString:@"general_hours"]) {
                    day = [NSMutableString stringWithString:[attribute objectForKey:@"Day"]];
                    hours = [NSMutableString stringWithString:[attribute objectForKey:@"Hours"]];
                    temp = [NSMutableString stringWithFormat:@"%@ \t: %@\n", day, hours];
                    [generalHoursArray addObject:temp];
                    [dbCrud UpdateRecords:hours :day :rowIndex :@"generalHours"];
                    
                // GENERAL TEXT
                } else if ([key isEqualToString:@"general_text"]) {
                    description = [NSMutableString stringWithString:[attribute objectForKey:@"Description"]];
                    identifier = [NSMutableString stringWithString:[attribute objectForKey:@"Identifier"]];
                    if ([identifier isEqualToString:@"Cafe"])
                        cafeDescription = description;
                    else if ([identifier isEqualToString:@"Shop"])
                        shopDescription = description;
                    [dbCrud UpdateRecords:identifier :description :rowIndex :@"generalText"];
                }
                
                // increase att key here
                attKey = [attEnum nextObject];
                rowIndex++;
            }
        }
    }
    
    // load from DB here
    
    
    //Accordion
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc] init];
    }
    
    sectionData = [NSArray arrayWithObjects:@"Plan a Visit",@"MOA Shop", @"Cafe MOA", @"Contact Us", nil];
    
    rowData = [NSArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array], [NSMutableArray array],[NSMutableArray array], nil];
    
    [[rowData objectAtIndex:0] addObject:@"Blank"];// 0 : Plan a Visit
    [[rowData objectAtIndex:0] addObject:@"Directions & Parking"];
    [[rowData objectAtIndex:0] addObject:@"Rates"];
    [[rowData objectAtIndex:0] addObject:@"Hours"];
    [[rowData objectAtIndex:1] addObject:@"Blank"];// 1 : MOA Shop
    [[rowData objectAtIndex:1] addObject:@""];
    [[rowData objectAtIndex:2] addObject:@"Blank"];// 2 : Cafe MOA
    [[rowData objectAtIndex:2] addObject:@""];
    [[rowData objectAtIndex:3] addObject:@"Blank"];// 3 : Contact Us
    [[rowData objectAtIndex:3] addObject:@""];
    
}

-(void) clearOldData {
    
    [generalHoursArray removeAllObjects];
    [parkingInformationArray removeAllObjects];
    [generalTextArray removeAllObjects];
    [cafeHoursArray removeAllObjects];
    [ratesGeneralArray removeAllObjects];
    [ratesGroupArray removeAllObjects];

}

-(void) validateJSONString{
    
    // sometimes remote data are returned in HTML form, and
    // we cannot remove HTML tags by stripping all the tags using regular expression
    // since the body of JSON contains HTML tags
    // so we have to do manually by removing beginning and end HTML tags
    
    NSMutableString *strToValidate = [strRemoteData copy];
    
    //remove the initial html tag
    if ([strToValidate rangeOfString:@"<body>"].location == NSNotFound) {
        NSLog(@"Data is Good: Returned JSON String does not have end HTML tags");
    } else {
        int startingOffset = [strToValidate rangeOfString:@"{"].location;
        strToValidate = [[strToValidate substringFromIndex:startingOffset] copy];
    }
    
    //remove the end tag
    if ([strToValidate rangeOfString:@"</body>"].location == NSNotFound){
        NSLog(@"Data is Good: Returned JSON String does not have end HTML tags");
    } else {
        int endingOffset = [strToValidate rangeOfString:@"</body>"].location;
        strToValidate = [[strToValidate substringWithRange:NSMakeRange(0, endingOffset)] copy];
    }
    
    strRemoteData = strToValidate;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self tableView:tableView canCollapseSection:section])
    {
        //section is expanded
        if ([expandedSections containsIndex:section])
        {
            if ( section == 0 )
            {
                return 4;
            }
            else
            {
                return 2;
            }
        }
        //only top row showing
        return 1;
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
            if (!indexPath.section)
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.text = sectionData[indexPath.section]; // only top row showing
            cell.accessoryView = nil;
        }
        else
        {
            // accordion sub rows
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    //Action when an accordion section cell is clicked (collapsable)
    {
        if (!indexPath.row)
        //Action when the section header cell is clicked (toggle expand/collapse)
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
        else
        //Action when an accordion row cell is clicked
        {
            if (indexPath.row == 1)
            {
                UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"directionParkingViewController"];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            else if (indexPath.row == 2)
            {
                UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ratesViewController"];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            else if (indexPath.row == 3)
            {
                UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"hoursViewController"];
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }
    }
    else
    //Action when a non-accordion cell is clicked
    {
        if (!indexPath.row)
        {
            // MOA Shop
            if (indexPath.section == 1)
            {
                UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ShopViewController"];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            // Cafe MOA
            else if (indexPath.section == 2)
            {
                UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CafeViewController"];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            // Contact Us
            else if (indexPath.section == 3)
            {
                UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactViewController"];
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }

    }
    
}




@end
