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
#import "Utils.h"

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

    if (database == NULL){
        database = [[CrudOp alloc]init];
    }
    [[TagList sharedInstance] setExtraPage:0];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    
    // Set the gesture
    self.tableView.rowHeight=70;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void) viewWillAppear:(BOOL)animated
{
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.ca"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if(internetStatus == NotReachable) {
        internet = NO;
        
        if ([TagList sharedInstance].calendarEvents == NULL){
            [TagList sharedInstance].calendarEvents = [[NSMutableArray alloc]init];
        }
        
        if([[[TagList sharedInstance] calendarEvents]count]==0){
            [[TagList sharedInstance] setCalendarEvents:[database PullFromLocalDB:@"whats_on"]];
        }
    }
    else{
        internet = YES;
        if([[[TagList sharedInstance] calendarEvents]count]==0)
            [TagList loadInformation];
        
        // load image once the screen is shown - only when there is internet!
        if (syncLocalDb == NO) {
            for (int i = 0; i < [[TagList sharedInstance].calendarEvents count]; i++){
                [database updateImageToLocalDB:@"whats_on" :@"image" :[[[[TagList sharedInstance] calendarEvents] objectAtIndex:i] objectForKey:@"image"] :i];
            }
            syncLocalDb = YES;
        }
    }
    
   
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
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    NSDictionary *event = [[[TagList sharedInstance] calendarEvents] objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@",[event objectForKey:@"programType"], [event objectForKey:@"title"], [Utils convertDate:[event objectForKey:@"date"]]];
    
    [self checkInternetConnection];
    if (internet == YES){
        cell.imageView.image = [UIImage imageWithData: [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[event objectForKey:@"image"]]]];
    } else {
        cell.imageView.image = [database loadImageFromDB:@"whats_on" :@"image" :(int)indexPath.row].image;
    }
    
    return cell;
}

-(void) checkInternetConnection
{
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.ca"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    internet = YES;
    
    if(internetStatus == NotReachable) {
        internet = NO;
    }
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
