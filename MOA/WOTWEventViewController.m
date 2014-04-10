//
//  WOTWEventViewController.m
//  MOA
//
//  Created by Donald Cheng on 1/28/2014.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import "WOTWEventViewController.h"
#import "SWRevealViewController.h"
#import "Reachability.h"
#import "TagList.h"

@interface WOTWEventViewController ()
@property (strong, nonatomic) UIActivityIndicatorView* imageLoading;
@property (strong, nonatomic)  UILabel *eventTitle;
@property (strong, nonatomic)  UILabel *programType;
@property (strong, nonatomic)  UILabel *time;
@property (strong, nonatomic)  UITextView *itemDescriptionTextView;
@property (strong, nonatomic)  UIImageView *displayItemImageView;


@end

@implementation WOTWEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@synthesize index;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (database == NULL || !database){
        database = [[CrudOp alloc] init];
    }
    
	// Do any additional setup after loading the view.
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sideBarButton.target = self.revealViewController;
    _sideBarButton.action = @selector(rightRevealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    CGRect scrollFrame;
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        //iphone 5
        scrollFrame.origin = self.theScrollView.frame.origin;
        scrollFrame.size = CGSizeMake(self.theScrollView.frame.size.width, 440);
    }
    else{
        //other iphones
        scrollFrame.origin = self.theScrollView.frame.origin;
        scrollFrame.size = CGSizeMake(self.theScrollView.frame.size.width, 352);
    }
    self.theScrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
    
    float screenWidth =[UIScreen mainScreen].bounds.size.width;
    
    self.programType =[[UILabel alloc] initWithFrame:CGRectMake(screenWidth/20, 10, screenWidth -screenWidth/10, 30)];
    self.eventTitle= [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/20, 50, screenWidth -screenWidth/10, 30)];
    self.time =[[UILabel alloc] initWithFrame:CGRectMake(screenWidth/20, 90, screenWidth -screenWidth/10, 30)];
    self.displayItemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/20, 130, screenWidth -(2*screenWidth)/20, 200)];
    self.itemDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(screenWidth/20, 340, screenWidth -(2*screenWidth)/20, 200)];
    self.itemDescriptionTextView.scrollEnabled = NO;
    
    
    
    [[self theScrollView] addSubview:[self programType]];
    [[self theScrollView] addSubview:[self eventTitle]];
    [[self theScrollView] addSubview:[self time]];
    [[self theScrollView] addSubview:[self displayItemImageView]];
    [[self theScrollView] addSubview:[self itemDescriptionTextView]];
    
    self.displayItemImageView.image = [[UIImage alloc] init];
    _imageLoading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((screenWidth -(2*screenWidth)/20)/2-10, 90, 20, 20)];
    _imageLoading.color = [UIColor grayColor];
    [self.displayItemImageView addSubview:_imageLoading];
    
    [self.view addSubview:[self theScrollView]];
    
    [self pageSetup];
    
}

-(void) downloadImage :(NSString*)imageURL{
    _imageLoading.hidden = NO;
    [_imageLoading startAnimating];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageURL]];
    self.displayItemImageView.image = [UIImage imageWithData:imageData];
    
    [_imageLoading stopAnimating];
    _imageLoading.hidden = YES;
}
-(void) pageSetup
{
    self.displayItemImageView.image = [UIImage imageNamed:@"emptySpace"];
    
    NSString *imageURL = [[[[TagList sharedInstance] calendarEvents] objectAtIndex:index] objectForKey:@"image"];
    
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.ca"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if(internetStatus == NotReachable) {
        self.displayItemImageView.image = [database loadImageFromDB:@"whats_on" :@"image" :(int)index].image;
    }
    else{
        [self performSelectorInBackground:@selector(downloadImage:) withObject:imageURL];
    }
    
    
    self.displayItemImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.programType.text =[[[[TagList sharedInstance] calendarEvents] objectAtIndex:index] objectForKey:@"programType"];
    self.eventTitle.text=[[[[TagList sharedInstance] calendarEvents] objectAtIndex:index] objectForKey:@"title"];
    self.time.text=[[[[TagList sharedInstance] calendarEvents] objectAtIndex:index] objectForKey:@"time"];
    self.itemDescriptionTextView.text= [NSString stringWithFormat:@"%@", [[[[TagList sharedInstance] calendarEvents] objectAtIndex:index] objectForKey:@"description"]];
    self.eventTitle.font = [UIFont boldSystemFontOfSize:16.0f];
    self.programType.font = [UIFont boldSystemFontOfSize:16.0f];
    self.time.font = [UIFont boldSystemFontOfSize:16.0f];
    
    self.eventTitle.textAlignment = NSTextAlignmentCenter;
    self.programType.textAlignment = NSTextAlignmentCenter;
    self.time.textAlignment = NSTextAlignmentCenter;
    
    
    [self.itemDescriptionTextView sizeToFit];

    float height = self.programType.frame.size.height + self.eventTitle.frame.size.height + self.displayItemImageView.frame.size.height + self.itemDescriptionTextView.frame.size.height + self.time.frame.size.height+50;

    
    
    self.itemDescriptionTextView.editable = NO;
    
    [self.theScrollView setContentSize:CGSizeMake(self.theScrollView.frame.size.width, height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
