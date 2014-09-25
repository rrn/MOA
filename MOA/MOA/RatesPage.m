//
//  RatesPage.m
//  MOA
//
//  Created by Marilyn Edgar on 11/23/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "RatesPage.h"
#import "SWRevealViewController.h"
#import "VisitorInfoViewController.h"
#import "CrudOp.h"
#import "Reachability.h"

@interface RatesPage ()

@end

@implementation RatesPage

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Rates";
    
    // Sidebar menu code
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Side Bar Menu
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor] ];
    
    CrudOp* database = [CrudOp alloc];
    if (!ratesGeneralArray || !ratesGeneralArray.count ||
        !ratesGroupArray || !ratesGroupArray.count){
        
        Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
        NetworkStatus internetStatus = [reachability currentReachabilityStatus];
        
        if (internetStatus == NotReachable){
            ratesGeneralArray = [database PullFromLocalDB:@"rates_general"];
            ratesGroupArray = [database PullFromLocalDB:@"rates_groups"];
        } else {
            [self PullFromRemote];
            [self UpdateLocalDB];
        }
    }
    
}


-(void) UpdateLocalDB
{
    CrudOp *dbCrud = [[CrudOp alloc] init];
    [dbCrud UpdateLocalDB:@"rates_general" :ratesGeneralArray];
    [dbCrud UpdateLocalDB:@"rates_groups" :ratesGroupArray];
}


-(void)PullFromRemote
{
    NSDictionary* jsonDict = [VisitorInfoViewController PullRemoteData:@"http://pluto.moa.ubc.ca/_mobile_app_remoteData.php"];
    ratesGeneralArray = [jsonDict objectForKey:@"rates_general"];
    ratesGroupArray = [jsonDict objectForKey:@"rates_groups"];
    
    
    // TODO:
    // After pulling, needs to update
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [ratesGeneralArray count];
    } else {
        return [ratesGroupArray count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Rates";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:MyIdentifier];
        
    }
    
    // Make title and subtitle multiline
    cell.textLabel.numberOfLines = 0;
    //cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-medium" size:18];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines = 0;
    //cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-light" size:18];
    
        //[self.description setFont:[UIFont fontWithName:@"HelveticaNeue-light" size:18]];
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.textLabel.text =[[ratesGeneralArray objectAtIndex:indexPath.row] objectForKey:@"Description"];
        cell.detailTextLabel.text =[[ratesGeneralArray objectAtIndex:indexPath.row] objectForKey: @"Rate"];
    } else if (indexPath.section == 1){
        cell.textLabel.text = [[ratesGroupArray objectAtIndex:indexPath.row] objectForKey:@"Description"];
        cell.detailTextLabel.text = [[ratesGroupArray objectAtIndex:indexPath.row] objectForKey: @"Rate"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // possibly: dynamic length
    if ((indexPath.section == 0 && (indexPath.row == 2 || indexPath.row == 4)) ||
        (indexPath.section == 1 && indexPath.row == 3)) {
        // Make these rows bigger to fit text
        return 88;
    }
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"General Rates";
            break;
        case 1:
            sectionName = @"Group Rates";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
