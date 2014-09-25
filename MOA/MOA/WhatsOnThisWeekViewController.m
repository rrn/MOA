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
   [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor colorWithRed:166.0f/255.0f green:206.0f/255.0f blue:57.0f/255.0f alpha:1.0f]];
    
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
        
        if ([[[TagList sharedInstance] calendarEvents]count]==0)
            [TagList loadInformation];
        
        if ([[[TagList sharedInstance] exhibitionEvents]count]==0)
            [TagList loadExhibitionsInformation];
        
        // updateDB in separate thread
        [self performSelectorInBackground:@selector(updateImageToDB) withObject:nil];
    }
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    [super viewWillAppear:animated];
    
   
}

-(void)updateImageToDB
{
    if (syncLocalDb == NO && internet == YES) {
        for (int i = 0; i < [[TagList sharedInstance].calendarEvents count]; i++){
            [database updateImageToLocalDB:@"whats_on" :@"image" :[[[[TagList sharedInstance] calendarEvents] objectAtIndex:i] objectForKey:@"image"] :i];
        }
        syncLocalDb = YES;
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
    
    NSRange rangeToBold = NSMakeRange([[event objectForKey:@"programType"] length], [[event objectForKey:@"title"] length]+1);
    NSRange programRange = NSMakeRange(0, [[event objectForKey:@"programType"] length]);
   // NSRange dateRange = NSMakeRange([[event objectForKey:@"title"] length]+ [[event objectForKey:@"programType"] length] + 1, [[event objectForKey:@"title"] length]+ [[event objectForKey:@"programType"] length] + [[event objectForKey:@"date"] length]);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *eventDateString = [event objectForKey:@"date"];
    NSDate *eventDate = [dateFormatter dateFromString:eventDateString];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:eventDate];
    int weekday = (int)[comps weekday];
    NSString *dayOfTheWeek = [[dateFormatter weekdaySymbols] objectAtIndex:weekday-1];
    
    NSString *cellInfoTemp = [NSString stringWithFormat:@"%@\n%@\n%@, %@",[event objectForKey:@"programType"], [event objectForKey:@"title"], dayOfTheWeek, [Utils convertDate:[event objectForKey:@"date"]]];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:cellInfoTemp];
    
    
    
    NSRange dateRange = NSMakeRange([[event objectForKey:@"title"] length]+ [[event objectForKey:@"programType"] length] + 1, [dayOfTheWeek length] + [[Utils convertDate:[event objectForKey:@"date"]] length] + 3);
    
    
    [attrString beginEditing];
    
    
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor grayColor]
                       range:programRange];
    
    
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor grayColor]
                       range:dateRange];
    
    [attrString addAttribute:NSFontAttributeName
                       //value:[UIFont boldSystemFontOfSize:18]
                       value: [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]
                       range:rangeToBold];
    
    [attrString endEditing];
    
    
    
    

    

    cell.textLabel.attributedText = attrString;
    
    [self checkInternetConnection];
    cell.imageView.contentMode = UIViewContentModeCenter;
    if (!eventImages || ![eventImages count]){
        cell.imageView.contentMode = UIViewContentModeCenter;
        UIImage *cellImage =[database loadImageFromDB:@"whats_on" :@"image" :(int)indexPath.row].image;
        UIImage *borderedImage = [UIImage imageWithCGImage:cellImage.CGImage scale:3 orientation:cellImage.imageOrientation];
        cell.imageView.image = borderedImage;
    } else {
        cell.imageView.image = [eventImages objectAtIndex:indexPath.row];
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
