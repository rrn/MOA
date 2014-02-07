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

- (void)viewDidLoad
{
    // CONSTANT NUMBER
    hoursFontSize = 14;
    
    [self.scroll setScrollEnabled:YES];
    [self.scroll setContentSize:CGSizeMake(320, 700)];
    
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
            cafeDescription = [generalTextArray objectAtIndex:1];
        } else {
            [self PullFromRemote];
        }
        
    }
    
    NSString* descriptionText = cafeDescription;

    self.title = @"Cafe MOA";
    self.description.text = descriptionText;
    self.description.textAlignment = NSTextAlignmentJustified;
    [super viewDidLoad];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    NSString *string= [cafeHoursArray objectAtIndex:indexPath.row];
    UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 290, hoursFontSize+10)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    CGFloat tabInterval = 150.0;
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
    CrudOp *dbCrud = [[CrudOp alloc] init];
    NSMutableString *day, *hours;
    NSMutableString *description, *identifier;
    NSMutableString *temp;
    int rowIndex = 0;
    
    NSEnumerator *mainEnumerator = [jsonDict keyEnumerator];
    id key; NSArray *tableArray;
    while (key = [mainEnumerator nextObject]){
        rowIndex = 1;
        tableArray = [jsonDict objectForKey:key];
        for (NSDictionary *attribute in tableArray){
            if ([key isEqualToString:@"cafe_hours"])
            {
                NSEnumerator *attEnum = [attribute keyEnumerator];
                id attKey;
                while (attKey = [attEnum nextObject]){
                    day = [NSMutableString stringWithString:[attribute objectForKey:@"Day"]];
                    hours = [NSMutableString stringWithString:[attribute objectForKey:@"Hours"]];
                    temp = [NSMutableString stringWithFormat:@"%@ \t: %@\n", day, hours];
                    [cafeHoursArray addObject:temp];
                    [dbCrud UpdateRecords:hours :day :rowIndex :@"cafeHours"];
                    
                    // go to next row
                    attKey = [attEnum nextObject];
                    attKey = [attEnum nextObject];
                    rowIndex++;
                }
            } else if ([key isEqualToString:@"general_text"]) {
                NSEnumerator *attEnum = [attribute keyEnumerator];
                id attKey;
                while (attKey = [attEnum nextObject]){

                    description = [NSMutableString stringWithString:[attribute objectForKey:@"Description"]];
                    identifier = [NSMutableString stringWithString:[attribute objectForKey:@"Identifier"]];
                    if ([identifier isEqualToString:@"Cafe"])
                        cafeDescription = description;
                    else if ([identifier isEqualToString:@"Shop"])
                        shopDescription = description;
                    [dbCrud UpdateRecords:description :identifier :rowIndex :@"generalText"];
                    
                    // go to next row
                    attKey = [attEnum nextObject];
                    attKey = [attEnum nextObject];
                    rowIndex++;
                }
            } else {
                // if it is not general_text or cafe_hours, no need to parse
                break;
            }
        }
    }
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
    int contentSize = [self textViewDidChange:self.description]; // length of description
    contentSize = contentSize + (7*(hoursFontSize+10)) + 290; //length of table + length of image
    contentSize = contentSize + 210; // total spacing between elements
   [self.scroll setContentSize:CGSizeMake(320, contentSize)];
}

@end
