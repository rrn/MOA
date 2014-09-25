//
//  HoursPage.m
//  MOA
//
//  Created by Marilyn Edgar on 11/23/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "HoursPage.h"
#import "Constants.h"
#import "SWRevealViewController.h"
#import "VisitorInfoViewController.h"
#import "CrudOp.h"
#import "Reachability.h"

@interface HoursPage ()

@end

@implementation HoursPage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    // CONSTANT NUMBER
    hoursFontSize = 14;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"Hours";
    
    // Sidebar menu code
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Side Bar Menu
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor] ];
    
    if (!generalHoursArray || !generalHoursArray.count){
        
        Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
        NetworkStatus internetStatus = [reachability currentReachabilityStatus];
        
        if (internetStatus == NotReachable){
            CrudOp* database = [CrudOp alloc];
            generalHoursArray = [database PullFromLocalDB:@"general_hours"];
        } else {
            [self PullFromRemote];
            [self UpdateLocalDB];
        }
    }
}

-(void)UpdateLocalDB
{
    CrudOp *dbCrud = [[CrudOp alloc] init];
    [dbCrud UpdateLocalDB:@"general_hours" :generalHoursArray];

}

-(void)PullFromRemote
{
    NSDictionary* jsonDict = [VisitorInfoViewController PullRemoteData:@"http://pluto.moa.ubc.ca/_mobile_app_remoteData.php"];
    generalHoursArray = [jsonDict objectForKey:@"general_hours"];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [generalHoursArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Hours";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:MyIdentifier];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Make the subtitle multiline
   // cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-medium" size:18];
    //cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
     cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-light" size:18];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.textLabel.text = [[generalHoursArray objectAtIndex:indexPath.row] objectForKey:@"Day"];
    cell.detailTextLabel.text = [[generalHoursArray objectAtIndex:indexPath.row] objectForKey:@"Hours"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( indexPath.row > 6) {
        // Make the final rows bigger to fit detail text
        return 100;
    }
    return 50;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Museum Hours";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}


@end
