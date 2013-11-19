//
//  PlanVisitViewController.h
//  MOA
//
//  Created by Marilyn Edgar on 11/16/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBDataList.h"

@interface PlanVisitViewController : UIViewController {
    
    NSDictionary *cafeHoursData;
    NSMutableArray *datas;
    
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, weak) IBOutlet UILabel *cafeHoursLabel;
@property (nonatomic, retain) NSMutableArray *datas;


@end
