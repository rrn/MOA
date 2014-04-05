//
//  SearchResultListViewController.h
//  MOA
//
//  Created by Sukhi Mann on 11/15/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemLayout.h"
#import "BHAlbum.h"
#import "BHPhoto.h"

@interface SearchResultListViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;
@property (weak, nonatomic) IBOutlet ItemLayout *itemViewLayout;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoader;

@end
