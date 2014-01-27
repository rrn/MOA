//
//  ExhibitionsViewController.m
//  MOA
//
//  Created by Marilyn Edgar on 12/8/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "ExhibitionsViewController.h"
#import "ExhibitChildViewController.h"
#import "SWRevealViewController.h"
#import "VisitorInfoViewController.h"
#import "Reachability.h"
#import "Global.h"
#import "Util.h"
#import "Exhibition.h"
#import "CrudOp.h"


@interface ExhibitionsViewController ()

@end

@implementation ExhibitionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"%@", @"initWithNibNameEx is called");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self PullFromRemote];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    // Page View Controller
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    ExhibitChildViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
    //self.description.text = @"Inserted Text";
    //[self checkForNetwork];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(ExhibitChildViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(ExhibitChildViewController *)viewController index];
    
    
    index++;
    
    if (index == 5) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (ExhibitChildViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ExhibitChildViewController *childViewController = [sb instantiateViewControllerWithIdentifier:@"exhibitChildViewController"];
    childViewController.index = index;
    
    return childViewController;
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 5;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

- (void)checkForNetwork
{
    // check if we've got network connectivity
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"google.com"];
    NetworkStatus myStatus = [myNetwork currentReachabilityStatus];
    
    switch (myStatus) {
        case NotReachable:
            NSLog(@"There's no internet connection at all. Display error message now.");
            break;
            
        case ReachableViaWWAN:
            NSLog(@"We have a 3G connection");
            break;
            
        case ReachableViaWiFi:
            NSLog(@"We have WiFi.");
            break;
            
        default:
            break;
    }
}

-(void) PullFromRemote
{
    NSDictionary* jsonDict = [VisitorInfoViewController PullRemoteData:@"http://pluto.moa.ubc.ca/_mobile_app_remoteData.php"];
    // NEEDS TO PERFORM UPDATE IN HERE - UPDATE THE LOCAL DB
    //CrudOp *dbCrud = [[CrudOp alloc] init];
    int rowIndex = 0;
    
    NSEnumerator *mainEnumerator = [jsonDict keyEnumerator];
    id key; NSArray *tableArray;
    NSURL* url;
    
    exhibitionsArray = [[NSMutableArray alloc] init];
    
    while (key = [mainEnumerator nextObject]){
        rowIndex = 1;
        tableArray = [jsonDict objectForKey:key];
        for (NSDictionary *attribute in tableArray){
            NSEnumerator *attEnum = [attribute keyEnumerator];
            id attKey;
            while (attKey = [attEnum nextObject]){
                Exhibition *exhibition = [[Exhibition alloc]init];
                if ([key isEqualToString:@"moa_exhibitions"]) {
                    exhibition.itemID = [NSMutableString stringWithString:[attribute objectForKey:@"itemID"]];
                    exhibition.title = [NSMutableString stringWithString:[attribute objectForKey:@"title"]];
                    exhibition.subtitles = [NSMutableString stringWithString:[attribute objectForKey:@"subtitle"]];
                    url = [NSURL URLWithString:[attribute objectForKey:@"image"]];
                    exhibition.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                    url = [NSURL URLWithString:[attribute objectForKey:@"detailImage"]];
                    exhibition.detailImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                    exhibition.imageCaption = [NSMutableString stringWithString:[attribute objectForKey:@"imageCaption"]];
                    exhibition.activationDate = [Util parseDateString:[attribute objectForKey:@"activationDate"]];
                    exhibition.expiryDate = [Util parseDateString:[attribute objectForKey:@"expiryDate"]];
                    [exhibitionsArray addObject:exhibition];
                }
                break;
                rowIndex++;
            }
        }
    }
}



@end
