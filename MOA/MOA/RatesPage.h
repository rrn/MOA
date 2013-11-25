//
//  RatesPage.h
//  MOA
//
//  Created by Marilyn Edgar on 11/23/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatesPage : UIViewController

@property (nonatomic, weak) IBOutlet UITextView *description;
@property (nonatomic, weak) IBOutlet UIScrollView *scroll;

@end

NSMutableArray *ratesGeneralArray;
NSMutableArray *ratesGroupArray;