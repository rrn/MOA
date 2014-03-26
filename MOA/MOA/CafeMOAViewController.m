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
#import "Reachability.h"
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
        NetworkStatus internetStatus = [reachability currentReachabilityStatus];
        
        if (internetStatus == NotReachable){
            cafeHoursArray = [database PullFromLocalDB:@"cafe_hours"];
            generalTextArray = [database PullFromLocalDB:@"general_text"];
            cafeDescription = [[generalTextArray objectAtIndex:1] objectForKey:@"Description"];
        } else {
            [self PullFromRemote];
            [self UpdateLocalDB];
        }
        
    }
    
    // load photo of cafe here
    UIImageView *cafeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 236)];
    cafeImage.image = [UIImage imageNamed:@"cafe-1.jpg"];
    
    // load cafe description here
    UITextView *cafeText = [[UITextView alloc] initWithFrame:CGRectMake(10, 246, 300.0f, 10)];
    cafeText.text = cafeDescription;
    cafeText.textAlignment = NSTextAlignmentJustified;
    cafeText.font = [UIFont systemFontOfSize:14];
    cafeText.userInteractionEnabled = NO;
    int cursorPos = 246 + [Utils textViewDidChange:cafeText];
    
    // load cafe hours into table
    self.tableView = [self makeTableView:cursorPos+10]; // 10 is space between text and table
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Hours"];
    
    

    
    contentSize = cursorPos; // length of description
   
    [self.view addSubview:cafeImage];
    [self.view addSubview:cafeText];
    [self.view addSubview:self.tableView];
    [self.scroll addSubview:cafeImage];
    [self.scroll addSubview:cafeText];
    [self.scroll addSubview:self.tableView];
    [self.scroll setScrollEnabled:YES];

    self.title = @"Cafe MOA";
    [super viewDidLoad];
}

-(void) UpdateLocalDB
{
    CrudOp *dbCrud = [[CrudOp alloc] init];
    [dbCrud UpdateLocalDB:@"cafe_hours" :cafeHoursArray];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

-(UITableView *)makeTableView:(int) yPos
{
    CGFloat x = 0;
    CGFloat y = yPos;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height - 50;
    CGRect tableFrame = CGRectMake(x, y, width, height);
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    
    tableView.userInteractionEnabled = NO;
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];
    
    return tableView;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *MyIdentifier = @"Hours";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:MyIdentifier];
    }

    NSString *string = [NSString stringWithFormat:@"  %@ \t %@", [[cafeHoursArray objectAtIndex:indexPath.row] objectForKey:@"Day"], [[cafeHoursArray objectAtIndex:indexPath.row] objectForKey:@"Hours"] ];
    UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 290, hoursFontSize+10)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    CGFloat tabInterval = 180.0;
    paragraphStyle.defaultTabInterval = tabInterval;
    NSMutableArray *tabs = [NSMutableArray array];
    [tabs addObject:[[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentLeft location:tabInterval options:nil]];
    paragraphStyle.tabStops = tabs;
    textV.typingAttributes = [NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    textV.font = [UIFont systemFontOfSize:hoursFontSize];
    textV.text = string;
    textV.textColor = [UIColor blackColor];
    textV.editable = NO;
    textV.selectable = NO;
    textV.scrollEnabled = NO;
    [cell.contentView addSubview:textV];
    
    
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
            sectionName = @"";
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
