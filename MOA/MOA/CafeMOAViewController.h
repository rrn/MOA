//
//  CafeMOAViewController.h
//  MOA
//
//  Created by Diana Sutandie on 11/23/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface CafeMOAViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *hours;
@property (nonatomic, weak) IBOutlet UILabel *description;
@property (nonatomic, weak) IBOutlet UIScrollView *scroll;

@end

NSMutableArray* cafeHoursArray;
NSMutableArray* generalTextArray;
