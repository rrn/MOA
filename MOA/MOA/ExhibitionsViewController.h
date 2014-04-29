//
//  ExhibitionsViewController.h
//  MOA
//
//  Created by Marilyn Edgar on 12/8/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "CrudOp.h"
#import "Global.h"
#import "ExhibitionChildViewController.h"

@interface ExhibitionsViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>{
    CrudOp* database;
    bool internet;
    bool syncLocalDB;
    Orientation deviceOrientation;
    UIScrollView* scroll;
};

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIPageControl* pageControl;
@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property int selectedExhibition;

@end

NSMutableArray *exhibitionImages;