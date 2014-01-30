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

@interface ExhibitionsViewController ()
@property (strong, nonatomic)  UIImageView *displayItemImageView;

@end

@implementation ExhibitionsViewController

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
	
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    
    // Set the gesture
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    
    //[self checkForNetwork];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    float screenWidth = self.theScrollView.frame.size.width;
    
    //code to add a new button
    
    
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
    else{
        if([[[TagList sharedInstance] exhibitionEvents] count] ==0){
            [TagList loadInformation];
        }
        
        for(int i=0; i < [[[TagList sharedInstance] exhibitionEvents] count]; i++)
        {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake((i*screenWidth) + screenWidth/20, 10, screenWidth -(2*screenWidth)/20, self.theScrollView.frame.size.height);
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 210, button.frame.size.width, 30)];
            UILabel *startDateLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 250, button.frame.size.width, 30)];
            UILabel *endDateLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 290, button.frame.size.width, 30)];
            
            startDateLabel.text =[[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:i] objectForKey:@"activationDate"];
            endDateLabel.text =[[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:i] objectForKey:@"expiryDate"];
            nameLabel.text =[[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:i] objectForKey:@"title"];
            [button addTarget:self
                       action:@selector(aMethod:)
             forControlEvents:UIControlEventTouchDown];
            NSString *imageURL = [[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:i] objectForKey:@"image"];
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageURL]];
            UIImageView *buttonImage =[[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
            buttonImage.frame = CGRectMake(0, 0, button.frame.size.width, 200);
            [button setTag:i];
            [button addSubview:buttonImage];
            [button addSubview:nameLabel];
            [button addSubview:startDateLabel];
            [button addSubview:endDateLabel];
            [self.theScrollView addSubview:button];
            
        }
        
        
        
        [self.theScrollView setContentSize:CGSizeMake(self.theScrollView.frame.size.width*[[[TagList sharedInstance] exhibitionEvents] count],  0)];
        
        self.theScrollView.pagingEnabled=YES;
        self.theScrollView.clipsToBounds=NO;
    }    
}



- (void) aMethod:(id) sender
{
    //todo
    UIButton* button = (UIButton*)sender;
    int i = [button tag];
    NSLog(@"%d",i);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
