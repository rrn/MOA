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
#import "Utils.h"

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
    //CrudOp* database = [CrudOp alloc];
    if (!database || database == NULL){
        database = [CrudOp alloc];
    }
   
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.ca"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    internet = YES;
    
    if(internetStatus == NotReachable) {
        internet = NO;
        
        if ([TagList sharedInstance].exhibitionEvents == NULL){
            [TagList sharedInstance].exhibitionEvents = [[NSMutableArray alloc]init];
        }
        
        if (![TagList sharedInstance].exhibitionEvents || ![[TagList sharedInstance].exhibitionEvents count])
            [[TagList sharedInstance] setExhibitionEvents:[database PullFromLocalDB:@"moa_exhibitions"]];
        
    } else {
        internet = YES;
        [database UpdateLocalDB:@"moa_exhibitions" :[[TagList sharedInstance].exhibitionEvents mutableCopy]];

    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self adjustViewsForOrientation:orientation];

    
    [carousel reloadData];
    carousel.type = iCarouselTypeRotary;
    carousel.scrollEnabled = FALSE;
    
    if (deviceOrientation == ORIENTATION_LANDSCAPE)
        scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50,self.carousel.frame.size.width, self.carousel.frame.size.height)];
    else
        scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,self.carousel.frame.size.width, self.carousel.frame.size.height)];
    [scroll setContentSize:CGSizeMake(self.carousel.frame.size.width, 300+50)];
    [scroll addSubview:carousel];
    scroll.userInteractionEnabled = YES;
    scroll.delaysContentTouches = NO;
    scroll.canCancelContentTouches = NO;
    [self.view addSubview:scroll];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.cancelsTouchesInView = NO;
    [[self view] addGestureRecognizer:tapGesture];
    
    // swipe by 1 item at a time only
    UISwipeGestureRecognizer *forwardRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftMethod)];
    UISwipeGestureRecognizer *backwardsRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightMethod)];
    
    [forwardRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [backwardsRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:forwardRecognizer];
    [[self view] addGestureRecognizer:backwardsRecognizer];
    [super viewDidLoad];

    // Sidebar button code
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self checkInternetConnection];
}

-(void) viewDidAppear:(BOOL)animated
{
    // load image once the screen is shown - only when there is internet!
    if (syncLocalDB == NO && internet == YES) {
        for (int i = 0; i < [[TagList sharedInstance].exhibitionEvents count]; i++){
            [database updateImageToLocalDB:@"moa_exhibitions" :@"image" :[[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:i] objectForKey:@"image"] :i];
            [database updateImageToLocalDB:@"moa_exhibitions" :@"detailImage" :[[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:i] objectForKey:@"detailImage"] :i];
        }
        syncLocalDB = YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldReceiveTouch:(UITouch *)touch
{
    
    if ([touch.view isKindOfClass:[UIScrollView class]]){
        return YES;
    }
    
    else return NO;
}

-(void)swipeRightMethod
{
    [carousel scrollByNumberOfItems:1 duration:0.5];
}

-(void)swipeLeftMethod
{
    [carousel scrollByNumberOfItems:-1 duration:0.5];
}

-(void)handleTap:(UITapGestureRecognizer*)sender
{
    self.selectedExhibition = (int)[carousel currentItemIndex];
    [self performSegueWithIdentifier:@"ExhibitionChild" sender:self];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ExhibitionChild"])
    {
        ExhibitionChildViewController *vc = [segue destinationViewController];
        [vc setSelectedButton:self.selectedExhibition];
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
    self.selectedExhibition = (int)index;
    [self performSegueWithIdentifier:@"ExhibitionChild" sender:self];
}

// this behaves like tableCell
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    int width = 300.0f;
    int height = 300.0f;
    
    if (view == nil)
    {
        int cursorPosition = 0;
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        view.layer.backgroundColor = [UIColor whiteColor].CGColor;
        view.layer.borderColor = [UIColor colorWithRed:0.9333 green:0.9333 blue:0.9333 alpha:1.0].CGColor;
        view.layer.borderWidth = 2.0f;
        
        //show the image
        NSString *imageURL = [[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:index] objectForKey:@"image"];
        UIImageView* buttonImage;
        
        [self checkInternetConnection];
        if (internet == YES) {
            UIImage* image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
            buttonImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,width, 200)];
            [buttonImage setImage:image];
        } else {
            buttonImage = [database loadImageFromDB:@"moa_exhibitions" :@"image" :(int)index];
        }
        buttonImage.exclusiveTouch = YES;
        [view addSubview:buttonImage];
        
        UITextView *nameTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 210, width, 10)];
        nameTextView.text = [[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:index] objectForKey:@"title"];
        [nameTextView setFont:[UIFont boldSystemFontOfSize:14]];
        nameTextView.textAlignment= NSTextAlignmentCenter;
        nameTextView.userInteractionEnabled = NO;
        nameTextView.scrollEnabled= NO;
        cursorPosition = 210 + [Utils textViewDidChange:nameTextView];
        [view addSubview:nameTextView];
        
        NSString *startDate = [Utils convertDate:[[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:index] objectForKey:@"activationDate"]];
        NSString *endDate = [Utils convertDate:[[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:index] objectForKey:@"expiryDate"]];
        UITextView *dateTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, cursorPosition, width, 10)];
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

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self adjustViewsForOrientation:toInterfaceOrientation];
}
- (void) adjustViewsForOrientation:(UIInterfaceOrientation)orientation {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
               deviceOrientation = ORIENTATION_LANDSCAPE;
        carousel.frame = CGRectMake(0, 0, screenHeight, screenWidth);
        scroll.frame = CGRectMake (0, 50, screenHeight, screenWidth);
        }
    else if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        deviceOrientation = ORIENTATION_PORTRAIT;
        carousel.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        scroll.frame = CGRectMake(0,0, screenWidth, screenHeight);
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
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

-(void) checkInternetConnection
{
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.ca"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    internet = YES;
    
    if(internetStatus == NotReachable) {
        internet = NO;
    }
}

@end
