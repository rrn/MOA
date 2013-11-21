//
//  VisitorInfoViewController.h
//  MOA
//
//  Created by Marilyn Edgar on 11/16/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface VisitorInfoViewController : UITableViewController {
    NSDictionary *pulledData;
    NSMutableArray *datas;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

NSMutableArray *parkingInformationArray;
NSMutableArray *cafeHoursArray;
NSMutableArray *generalTextArray;
NSMutableArray *ratesGeneralArray;
NSMutableArray *ratesGroupArray;
NSMutableArray *generalHoursArray;