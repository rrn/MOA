//
//  AboutViewController.h
//  MOA
//
//  Created by Marilyn Edgar on 2014-03-07.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController

@property NSString* description;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

NSMutableArray *generalTextArray;
