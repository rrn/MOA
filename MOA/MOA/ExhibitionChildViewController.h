//
//  ExhibitionChildViewController.h
//  MOA
//
//  Created by Diana Sutandie on 1/30/2014.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExhibitionChildViewController : UIViewController {
    int selectedTag;
}

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

-(void) setSelectedButton :(int)tag;

@end

