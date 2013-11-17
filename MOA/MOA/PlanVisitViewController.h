//
//  PlanVisitViewController.h
//  MOA
//
//  Created by Marilyn Edgar on 11/16/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanVisitViewController : UIViewController {
    
    NSDictionary *cafeHoursData;
    
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, weak) IBOutlet UILabel *cafeHoursLabel;

@end
