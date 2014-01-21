//
//  ExploreMainViewController.h
//  MOA
//
//  Created by Sukhi Mann on 11/3/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExploreMainViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property IBOutlet UISearchBar *searchBar;

@end
