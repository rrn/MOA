//
//  CafeMOAViewController.h
//  MOA
//
//  Created by Diana Sutandie on 11/23/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "Reachability.h"

@interface CafeMOAViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    int hoursFontSize;
    int contentSize;
    BOOL syncLocalDB;
    NetworkStatus internetStatus;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, weak) IBOutlet UIScrollView *scroll;
@property (nonatomic, retain) UITableView *tableView;



@end

NSMutableArray* cafeHoursArray;
NSMutableArray* generalTextArray;
NSMutableString* cafeDescription;
