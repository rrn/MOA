//
//  MOAShopViewController.h
//  MOA
//
//  Created by Diana Sutandie on 11/23/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface MOAShopViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, weak) IBOutlet UILabel *description;
@property (nonatomic, weak) IBOutlet UIScrollView *scroll;

-(void)LoadAndUpdateData;
-(void)PullFromRemote;

@end

NSMutableArray* generalTextArray;
NSMutableString* shopDescription;
