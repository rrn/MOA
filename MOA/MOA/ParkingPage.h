//
//  ParkingPage.h
//  MOA
//
//  Created by Diana Sutandie on 11/19/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface ParkingPage : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, weak) IBOutlet UITextView *description;
@property (nonatomic, weak) IBOutlet UIScrollView *scroll;

@end

NSMutableArray *parkingInformationArray;