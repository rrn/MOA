//
//  SplashScreen.m
//  MOA
//
//  Created by Sukhi Mann on 11/14/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "SplashScreen.h"

@interface SplashScreen ()

@end

@implementation SplashScreen

@synthesize activityLoader;
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
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [activityLoader startAnimating];
    
    dispatch_async(kBgQueue, ^{
        [self performSelectorOnMainThread:@selector(fetchedData:)
        withObject:NULL waitUntilDone:YES];
       });
    
    UIViewController *test = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [self presentViewController:test animated:YES completion:NULL];
}

-(void)fetchedData:(NSData *)responseData{
    [TagList downloadCulturesJson];
    [TagList downloadMaterialsJson];
    [TagList downloadPeopleJson];
    [TagList downloadPlacesJson];
    [TagList downloadObjectJson];
    [NSThread sleepForTimeInterval:2.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
