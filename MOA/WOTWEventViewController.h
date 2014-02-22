//
//  WOTWEventViewController.h
//  MOA
//
//  Created by Donald Cheng on 1/28/2014.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CrudOp.h"

@interface WOTWEventViewController : UIViewController{
    CrudOp* database;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;
@property (strong, nonatomic) IBOutlet UIScrollView *theScrollView;
@property NSInteger index;

@end
