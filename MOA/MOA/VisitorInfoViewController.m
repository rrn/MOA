//
//  VisitorInfoViewController.m
//  MOA
//
//  Created by Diana Sutandie on 11/5/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "VisitorInfoViewController.h"
#import "SWRevealViewController.h"

@interface VisitorInfoViewController ()

@end

@implementation VisitorInfoViewController

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

   
    self.title = @"Visitor Information";
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Get the info from DB
    // need to handle all possible risks (from the website)
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: @"http://localhost/eece419/home.php"]];
    NSError         * e;
    NSData      *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&e];
    NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData *jsonData = [strResult dataUsingEncoding:NSUTF8StringEncoding];
    
    e = nil;
    NSString *strCafeHours = @"";
    
    // generate jsonArray from the data
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: jsonData options: NSJSONReadingMutableContainers error: &e];
    
    //NSString *temp = @""; // temporary string to make arrange display format
    // store the data in our member variable
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", e);
    } else {
        int index = 0;
        for(NSDictionary *item in jsonArray) {
            cafeHoursData = item;
            //NSLog(@"Item: %@", item);
            
            // display data
            NSEnumerator *enumerator = [cafeHoursData keyEnumerator];
            id key;
            // separate the key and value
            while((key = [enumerator nextObject])){
                //temp = (NSString*)key + @" : " + [cafeHoursData objectForKey:key];
                
                strCafeHours = [strCafeHours stringByAppendingString:((NSString*)[cafeHoursData objectForKey:key])];
                if (index  != 0)
                    index = 0;
                    strCafeHours = [strCafeHours stringByAppendingString:@"\n"];
                
            }
           
        }
         NSLog(@"%@", strCafeHours);
    }
    self.cafeHoursLabel.text = strCafeHours;
    
    
    //NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];

    
    // parse JSON using the API
    
    //NSEnumerator *enumerator = [dict keyEnumerator];
    
    //id key;
    //NSString *day = @"";
    //NSString *hours = @"";
    //NSString *temp = @"";
    /*
    for (id key in dict)
    {
        id value = [dict objectForKey:key];
        NSLog(@"%@", value);
        NSLog(@"1");
        //[value doSomething];
    }*/
    /*while ((key = [enumerator nextObject])){
        
        temp = [dict objectForKey:key];
        NSLog(@"1");
        NSLog(@"%@", temp);
        /*if ([temp rangeOfString:@"Day"].location != NSNotFound) {
            //day = [temp substringWithRange:NSMakeRange(6, [temp length] - 6)];
            NSLog(@"found a day");
        } else {
            NSLog(@"not a day");
        }*/
        //NSLog(@"%@", [dict objectForKey: key]);
        
    //}
    

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
