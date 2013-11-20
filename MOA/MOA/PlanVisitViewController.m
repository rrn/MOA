//
//  PlanVisitViewController.m
//  MOA
//
//  Created by Marilyn Edgar on 11/16/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "PlanVisitViewController.h"
#import "SWRevealViewController.h"
#import "DBDataList.h"
#import "DBData.h"

@interface PlanVisitViewController ()

@end

@implementation PlanVisitViewController

@synthesize datas;

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
    
    
    
    
    /* // pull data from local database
    DBDataList *data = [[DBDataList alloc]init];
    self.datas = [data getCafeHours];
    NSString *text = [[((DBData *) [self.datas objectAtIndex: 0]).cafeHoursDay stringByAppendingString:@" : "]
                      stringByAppendingString: ((DBData *) [self.datas objectAtIndex: 0]).cafeHoursHours ];
    self.cafeHoursLabel.text = text;
    NSLog(@"%@", text); */

    

    
    // *** CODE TO PULL INFO FROM DB, DO NOT DELETE ***
    /*NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: @"http://localhost/eece419/home.php"]];
    NSError         * e;
    NSData      *remoteData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&e];
    NSString *strResult = [[NSString alloc] initWithData:remoteData encoding:NSUTF8StringEncoding];
    NSData *jsonData = [strResult dataUsingEncoding:NSUTF8StringEncoding];
    
    // generate jsonArray from the data
    e = nil;
    NSString *strPulledData = @"";
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: jsonData options: NSJSONReadingMutableContainers error: &e];
    
    // store the data in our member variable
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", e);
    } else {
        NSDictionary *info;
        //visitorInformationArray = [[NSMutableArray alloc]init];
        int index = 0;
        for(NSDictionary *item in jsonArray) {
            cafeHoursData = item;
            NSEnumerator *enumerator = [cafeHoursData keyEnumerator];
            id key;
            while((key = [enumerator nextObject])){
                strPulledData = @"";
                for (NSDictionary *temp in [cafeHoursData objectForKey:key]){
                    info = temp;
                    NSEnumerator *enumInfo = [info keyEnumerator];
                    id keyInfo;
                    while((keyInfo = [enumInfo nextObject])){
                        strPulledData = [strPulledData stringByAppendingString:((NSString*)[info objectForKey:keyInfo])];
                        if (index != 0) {
                            index = 0;
                            strPulledData = [strPulledData stringByAppendingString:@"\n"];
                        } else {
                            index++;
                            strPulledData = [strPulledData stringByAppendingString:@" :: "];
                        }
                    }
                    
                }
                NSLog(@"%@", strPulledData);
                NSString *parsedData = strPulledData;
                [visitorInformationArray addObject:parsedData];
            }*/

            
            /*// display data
            for (NSDictionary *value in item){
                NSEnumerator *enumerator = [value keyEnumerator];
                id key;
                while((key = [enumerator nextObject])){
                    strCafeHours = [strCafeHours stringByAppendingString:((NSString*)[value objectForKey:key])];
                    if (index  != 0)
                        index = 0;
                    strCafeHours = [strCafeHours stringByAppendingString:@"\n"];
                }
                
           // }
        }
    }
        
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
    //self.cafeHoursLabel.text = strCafeHours;*/
    

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
