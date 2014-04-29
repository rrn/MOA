//
//  WhatsOnThisWeekViewController.h
//  MOA
//
//  Created by Diana Sutandie on 11/7/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CrudOp.h"
#import "Global.h"

@interface WhatsOnThisWeekViewController : UITableViewController{
    CrudOp* database;
    bool internet;
    bool syncLocalDb;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

BOOL selectIt;
NSMutableArray* eventImages;
