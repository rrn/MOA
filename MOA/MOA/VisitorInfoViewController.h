//
//  VisitorInfoViewController.h
//  MOA
//
//  Created by Diana Sutandie on 11/5/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisitorInfoViewController : UIViewController {

    NSDictionary *cafeHoursData;
    
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, weak) IBOutlet UILabel *cafeHoursLabel;

@end
