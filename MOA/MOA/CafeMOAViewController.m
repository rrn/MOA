//
//  CafeMOAViewController.m
//  MOA
//
//  Created by Diana Sutandie on 11/23/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "CafeMOAViewController.h"
#import "SWRevealViewController.h"
#import "VisitorInfoViewController.h"
#import "CrudOp.h"
#import "Utils.h"

@interface CafeMOAViewController ()

@end

@implementation CafeMOAViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{

}

- (void)viewDidLoad
{
    // CONSTANT NUMBER
    hoursFontSize = 14;
    
    // Sidebar menu code
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    

    // check internet connectivity
    CrudOp* database = [CrudOp alloc];
    if (!cafeHoursArray || !cafeHoursArray.count || !generalTextArray || !generalTextArray.count){
        
        Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
        internetStatus = [reachability currentReachabilityStatus];
        
        if (internetStatus == NotReachable){
            cafeHoursArray = [database PullFromLocalDB:@"cafe_hours"];
            generalTextArray = [database PullFromLocalDB:@"general_text"];
            cafeDescription = [[generalTextArray objectAtIndex:1] objectForKey:@"Description"];
        } else {
            [self PullFromRemote];
        }
        
    }
    
    // load photo of cafe here
    UIImageView *cafeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 236)];
    cafeImage.image = [UIImage imageNamed:@"cafe-1.jpg"];
    
    // load cafe description here
    UITextView *cafeText = [[UITextView alloc] initWithFrame:CGRectMake(10, 246, 300.0f, 10)];
    cafeText.text = cafeDescription;
    cafeText.textAlignment = NSTextAlignmentJustified;
    cafeText.font = [UIFont fontWithName:@"HelveticaNeue-light" size:18];
    cafeText.userInteractionEnabled = NO;
    int cursorPos = 246 + [Utils textViewDidChange:cafeText];
    
    // load cafe hours into table
    CGFloat x = 0;
    CGFloat y = cursorPos+10;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height - 50;
    CGRect tableFrame = CGRectMake(x, y, width, height);

    if (!self.tableView){
        self.tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
        self.tableView.userInteractionEnabled = NO;
        self.tableView.scrollEnabled = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView reloadData];
    }
    
    //[self makeTableView:cursorPos+10]; // 10 is space between text and table
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Hours"];
    contentSize = cursorPos; // length of description
   
    [self.view addSubview:cafeImage];
    [self.view addSubview:cafeText];
    [self.view addSubview:self.tableView];
    [self.scroll addSubview:cafeImage];
    [self.scroll addSubview:cafeText];
    [self.scroll addSubview:self.tableView];
    [self.scroll setScrollEnabled:YES];
    
    // Side Bar Menu
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor] ];

    self.title = @"Cafe MOA";
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self performSelectorInBackground:@selector(UpdateLocalDB) withObject:nil];
}

-(void) UpdateLocalDB
{
    if (syncLocalDB == false && internetStatus != NotReachable){
        CrudOp *dbCrud = [[CrudOp alloc] init];
        [dbCrud UpdateLocalDB:@"cafe_hours" :cafeHoursArray];
        syncLocalDB = true;
    } 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *MyIdentifier = @"Hours";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:MyIdentifier];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[cafeHoursArray objectAtIndex:indexPath.row] objectForKey:@"Day"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[cafeHoursArray objectAtIndex:indexPath.row] objectForKey:@"Hours"]];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"Cafe Hours:", @"Cafe Hours:");
            break;
        default:
            break;
    }
    return sectionName;
}


- (void) PullFromRemote
{
    NSDictionary* jsonDict = [VisitorInfoViewController PullRemoteData:@"http://pluto.moa.ubc.ca/_mobile_app_remoteData.php"];
    cafeHoursArray = [jsonDict objectForKey:@"cafe_hours"];
    generalTextArray = [jsonDict objectForKey:@"general_text"];
    cafeDescription = [[generalTextArray objectAtIndex:1] objectForKey:@"Description"];
}

- (int)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
    return newSize.height;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewDidLayoutSubviews {
    
    // we need to know the size of scroll view (dynamically)
    // contentsize contains length of image + descriptiont text
    // add length of table to content size
    contentSize = contentSize + (7*(hoursFontSize+15));
    self.scroll.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
   [self.scroll setContentSize:CGSizeMake(320, contentSize )];
}

@end
