//
//  TagAdditionViewController.h
//  MOA
//
//  Created by Sukhi Mann on 11/14/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagList.h"

@interface TagAdditionViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *tagTable;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;

@end
