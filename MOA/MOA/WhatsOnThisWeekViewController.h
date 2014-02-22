//
//  WhatsOnThisWeekViewController.h
//  MOA
//
//  Created by Diana Sutandie on 11/7/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CrudOp.h"

@interface WhatsOnThisWeekViewController : UITableViewController{
    CrudOp* database;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

BOOL selectIt;
