//
//  ItemPageController.h
//  MOA
//
//  Created by Sukhi Mann on 11/18/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemPageController : UIViewController

@property NSArray* data;
@property NSInteger itemNumber;
@property (weak, nonatomic) IBOutlet UIScrollView *theScrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;
@property NSInteger count;


@end
