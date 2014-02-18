//
//  RatesPage.h
//  MOA
//
//  Created by Marilyn Edgar on 11/23/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatesPage : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    int hoursFontSize;
}


@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, strong) UITableView *tableView;

@end

NSMutableArray *ratesGeneralArray;
NSMutableArray *ratesGroupArray;