//
//  ItemPageController.m
//  MOA
//
//  Created by Sukhi Mann on 11/18/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "ItemPageController.h"
#import "SWRevealViewController.h"

@interface ItemPageController ()
@property (strong, nonatomic)  UILabel *idNumberLabel;
@property (strong, nonatomic)  UILabel *itemNameLabel;
@property (strong, nonatomic)  UITextView *itemDescriptionTextView;
@property (strong, nonatomic)  UIImageView *displayItemImageView;
@end

@implementation ItemPageController

@synthesize data, itemNumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.\
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sideBarButton.target = self.revealViewController;
    _sideBarButton.action = @selector(rightRevealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    float screenWidth =[UIScreen mainScreen].bounds.size.width;

    self.itemNameLabel =[[UILabel alloc] initWithFrame:CGRectMake(screenWidth/20, 10, screenWidth -screenWidth/20, 30)];
    self.idNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/20, 50, screenWidth -screenWidth/20, 30)];
    self.displayItemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/20, 90, screenWidth -(2*screenWidth)/20, 200)];
    self.itemDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(screenWidth/20, 300, screenWidth -(2*screenWidth)/20, 200)];
    self.itemDescriptionTextView.scrollEnabled = NO;
    
    
    NSArray *digitalObjects = [[data objectAtIndex:itemNumber] objectForKey:@"digital_objects"];
    NSString *imageUrl = [[digitalObjects objectAtIndex:0] objectForKey:@"url"];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageUrl]];
    
    self.displayItemImageView.image = [[UIImage alloc] initWithData:imageData];
    self.displayItemImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.itemNameLabel.text =[[data objectAtIndex:itemNumber] objectForKey:@"name"];
    self.idNumberLabel.text =[[data objectAtIndex:itemNumber] objectForKey:@"identification_number"];
    
    NSArray *institution_notes = [[data objectAtIndex:itemNumber] objectForKey:@"institution_notes"];
    
    self.itemDescriptionTextView.text= [NSString stringWithFormat:@"%@",[[institution_notes objectAtIndex:0] objectForKey:@"text"]];
    
    [[self theScrollView] addSubview:[self itemNameLabel]];
    [[self theScrollView] addSubview:[self idNumberLabel]];
    [[self theScrollView] addSubview:[self displayItemImageView]];
    [[self theScrollView] addSubview:[self itemDescriptionTextView]];
    
    [self.itemDescriptionTextView sizeToFit];
    
    float height = self.itemNameLabel.frame.size.height + self.idNumberLabel.frame.size.height + self.displayItemImageView.frame.size.height + self.itemDescriptionTextView.frame.size.height+40;
    

    float bottom_inset = self.tabBarController.tabBar.frame.size.height;
    
    self.theScrollView.contentInset=UIEdgeInsetsMake(64.0, 0.0, bottom_inset,0.0);

    [self.view addSubview:[self theScrollView]];

    [self.theScrollView setContentSize:CGSizeMake(self.theScrollView.frame.size.width, height)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
