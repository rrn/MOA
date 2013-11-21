//
//  AppDelegate.h
//  MOA
//
//  Created by Sukhi Mann on 11/3/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
- (void)remoteDBDataInitialization;

@end

NSMutableArray *visitorInformationArray;
NSMutableArray *parkingInformationArray;
NSMutableArray *cafeHoursArray;

