//
//  ExhibitionsViewController.h
//  MOA
//
//  Created by Marilyn Edgar on 12/8/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExhibitionsViewController : UIViewController {
    int selectedExhibition;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIScrollView *theScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl* pageControl;

@end
