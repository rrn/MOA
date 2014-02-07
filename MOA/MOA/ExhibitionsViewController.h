//
//  ExhibitionsViewController.h
//  MOA
//
//  Created by Marilyn Edgar on 12/8/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface ExhibitionsViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIPageControl* pageControl;
@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property int selectedExhibition;

@end
