//
//  PlanVisitViewController.m
//  MOA
//
//  Created by Marilyn Edgar on 11/16/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "PlanVisitViewController.h"
#import "SWRevealViewController.h"

@interface PlanVisitViewController ()

@end

@implementation PlanVisitViewController

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
	
    self.title = @"Plan a Visit";
    
    // Side bar button code - set action and gesture (swipe)
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Get the info from DB
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: @"http://localhost/eece419/home.php"]];
    NSError         * e;
    NSData      *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&e];
    NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData *jsonData = [strResult dataUsingEncoding:NSUTF8StringEncoding];
    
    // generate jsonArray from the data
    e = nil;
    NSString *strCafeHours = @"";
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: jsonData options: NSJSONReadingMutableContainers error: &e];
    
    // store the data in our member variable
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", e);
    } else {
        int index = 0;
        for(NSDictionary *item in jsonArray) {
            cafeHoursData = item;
            
            // display data
            NSEnumerator *enumerator = [cafeHoursData keyEnumerator];
            id key;
            while((key = [enumerator nextObject])){
                strCafeHours = [strCafeHours stringByAppendingString:((NSString*)[cafeHoursData objectForKey:key])];
                if (index  != 0)
                    index = 0;
                strCafeHours = [strCafeHours stringByAppendingString:@"\n"];
            }
        }
        NSLog(@"%@", strCafeHours);
    }
    self.cafeHoursLabel.text = strCafeHours;
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    // release any instance variable to avoid memory leak
    
    
}

@end
