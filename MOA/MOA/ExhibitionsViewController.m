//
//  ExhibitionsViewController.m
//  MOA
//
//  Created by Marilyn Edgar on 12/8/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "ExhibitionsViewController.h"
#import "SWRevealViewController.h"
#import "Reachability.h"
#import "TagList.h"
#import "ExhibitionChildViewController.h"
#import "Utils.h"
#import "ConvertDate.h"

@interface ExhibitionsViewController ()
@property (strong, nonatomic)  UIImageView *displayItemImageView;

@end

@implementation ExhibitionsViewController

@synthesize carousel;

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
    carousel.type = iCarouselTypeRotary;
    [super viewDidLoad];
    
	
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    
    // Set the gesture
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.ca"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if(internetStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Alert!"
                              message: @"There is no internet connection, item image cannot load."
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ExhibitionChild"])
    {
        ExhibitionChildViewController *vc = [segue destinationViewController];
        [vc setSelectedButton:self.selectedExhibition];
    }
}

- (void) aMethod:(id) sender
{
    //todo
    UIButton* button = (UIButton*)sender;
    self.selectedExhibition = [button tag];
    
    [self performSegueWithIdentifier:@"ExhibitionChild" sender:self];
}

- (NSString*) convertDate:(NSString*) short_date
{
    //conver short date to long date
    NSArray* components = [short_date componentsSeparatedByString:@"-"];
    
    NSString *year = [components objectAtIndex:0];
    NSString *month_numeric = [components objectAtIndex:1];
    NSString *month_string = [self convertMonthToString:month_numeric];
    NSString *day = [components objectAtIndex:2];
    
    NSString *long_date = [NSString stringWithFormat:@"%@ %d, %@", month_string, day.intValue, year];

    return long_date;
}

- (NSString*) convertMonthToString:(NSString*) month_numeric
{
    switch (month_numeric.intValue)
    {
        case 1:
            return @"January";
        case 2:
            return @"February";
        case 3:
            return @"March";
        case 4:
            return @"April";
        case 5:
            return @"May";
        case 6:
            return @"June";
        case 7:
            return @"July";
        case 8:
            return @"August";
        case 9:
            return @"September";
        case 10:
            return @"October";
        case 11:
            return @"November";
        case 12:
            return @"December";
        
        default: return @"January";
    }
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [[[TagList sharedInstance] exhibitionEvents] count];
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    self.selectedExhibition = index;
    [self performSegueWithIdentifier:@"ExhibitionChild" sender:self];
}

// this behaves like tableCell
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    if (view == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0,0,200.0f, 200.0f);
        
        int cursorPosition = 0;
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300.0f, 300.0f)];
        view.layer.backgroundColor = [UIColor whiteColor].CGColor;
        view.layer.borderColor = [UIColor grayColor].CGColor;
        view.layer.borderWidth = 2.0f;
        
        NSString *imageURL = [[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:index] objectForKey:@"image"];
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageURL]];
        UIImageView *buttonImage =[[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
        [view addSubview:buttonImage];
        
        UITextView *nameTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 210, 300.0f, 10)];
        nameTextView.text = [[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:index] objectForKey:@"title"];
        [nameTextView setFont:[UIFont boldSystemFontOfSize:14]];
        nameTextView.textAlignment= NSTextAlignmentCenter;
        nameTextView.userInteractionEnabled = NO;
        nameTextView.scrollEnabled= NO;
        cursorPosition = 210 + [Utils textViewDidChange:nameTextView];
        [view addSubview:nameTextView];
        
        NSString *startDate = [self convertDate:[[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:index] objectForKey:@"activationDate"]];
        NSString *endDate = [self convertDate:[[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:index] objectForKey:@"expiryDate"]];
        UITextView *dateTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, cursorPosition, 300.0f, 10)];
        NSString *date = [NSString stringWithFormat:@"%@ to %@", startDate, endDate];
        dateTextView.text = date;
        [dateTextView setFont:[UIFont systemFontOfSize:14]];
        dateTextView.userInteractionEnabled = NO;
        dateTextView.scrollEnabled = NO;
        dateTextView.textAlignment = NSTextAlignmentCenter;
        [Utils textViewDidChange:dateTextView];
        [view addSubview:dateTextView];
        
        view.contentMode = UIViewContentModeCenter;

    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }

    
    return view;
}

- (void)dealloc
{
    carousel.delegate = nil;
    carousel.dataSource = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)checkForNetwork
//{
//    // check if we've got network connectivity
//    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"google.com"];
//    NetworkStatus myStatus = [myNetwork currentReachabilityStatus];
//    
//    switch (myStatus) {
//        case NotReachable:
//            NSLog(@"There's no internet connection at all. Display error message now.");
//            break;
//            
//        case ReachableViaWWAN:
//            NSLog(@"We have a 3G connection");
//            break;
//            
//        case ReachableViaWiFi:
//            NSLog(@"We have WiFi.");
//            break;
//            
//        default:
//            break;
//    }
//}

@end
