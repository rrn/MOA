//
//  FromLowerMainland.h
//  MOA
//
//  Created by Diana Sutandie on 11/20/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface FromLowerMainland : UIViewController

@property (nonatomic, weak) IBOutlet UITextView *description;
@property (nonatomic, weak) IBOutlet UIScrollView *scroll;

@end

NSMutableArray *parkingInformationArray;
