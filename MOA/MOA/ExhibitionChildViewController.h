//
//  ExhibitionChildViewController.h
//  MOA
//
//  Created by Diana Sutandie on 1/30/2014.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CrudOp.h"

typedef enum orientationTypes
{
    ORIENTATION_PORTRAIT,
    ORIENTATION_LANDSCAPE
} Orientation;


@interface ExhibitionChildViewController : UIViewController {
    int selectedTag;
    bool internet;
    CrudOp* database;
    UIScrollView *scroll;
    Orientation screenOrientation;
}

-(void) setSelectedButton :(int)tag;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;

@end

