//
//  ContactUsViewController.m
//  MOA
//
//  Created by Diana Sutandie on 11/23/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "ContactUsViewController.h"
#import "SWRevealViewController.h"
#import "DBDataList.h"
#import "DBData.h"
#import "CrudOp.h"

@interface ContactUsViewController ()

-(NSMutableArray*) contactsDataArray;

@end

@implementation ContactUsViewController

-(NSMutableArray*) contactsDataArray
{
    static NSMutableArray* theArray = nil;
    if (theArray == nil)
    {
        theArray = [[NSMutableArray alloc] init];
        [theArray addObject:@"Recorded msg(24hr)  \t604.822.5087"];
        [theArray addObject:@"Reception  \t604.822.5932"];
        [theArray addObject:@"Email   \tinfo@moa.ubc.ca"];
        [theArray addObject:@"Fax \t604.822.2974"];
        [theArray addObject:@"Web \twww.moa.ubc.ca"];
    }
    return theArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    
    
    self.title = @"Contact Us";
    
    DBDataList *myCafeData = [[DBDataList alloc]init];
    visitorInformationArray = [myCafeData getCafeHours];
    
    
    // Sidebar menu code
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [super viewDidLoad];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    //Region *region = [regions objectAtIndex:section];
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *MyIdentifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    NSString *string= [self.contactsDataArray objectAtIndex:indexPath.row];
    CGSize stringSize = [string sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(320, 9999) lineBreakMode:UILineBreakModeWordWrap];
    
    UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 290, stringSize.height+10)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    CGFloat tabInterval = 150.0;
    paragraphStyle.defaultTabInterval = tabInterval;
    NSMutableArray *tabs = [NSMutableArray array];
    [tabs addObject:[[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentLeft location:tabInterval options:nil]];
    paragraphStyle.tabStops = tabs;
    textV.typingAttributes = [NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    textV.font = [UIFont systemFontOfSize:15.0];
    textV.text = string;
    textV.textColor = [UIColor blackColor];
    textV.scrollEnabled = NO;
    textV.editable = NO;
    switch (indexPath.row) {
        case 0:
            textV.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
            break;
        case 1:
            textV.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
            break;
        case 2:
            textV.dataDetectorTypes = UIDataDetectorTypeLink;
            break;
        case 4:
            textV.dataDetectorTypes = UIDataDetectorTypeLink;
        default:
            break;
    }
    [cell.contentView addSubview:textV];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
