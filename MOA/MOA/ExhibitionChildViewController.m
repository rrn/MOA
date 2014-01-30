//
//  ExhibitionChildViewController.m
//  MOA
//
//  Created by Diana Sutandie on 1/30/2014.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import "ExhibitionChildViewController.h"
#import "TagList.h"

@interface ExhibitionChildViewController ()

@end

@implementation ExhibitionChildViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) setSelectedButton :(int)tag {
    // do something
    selectedTag = tag;
}

-(void) prepareForDisplay
{
    // add the title
    NSString* title = [[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:selectedTag] objectForKey:@"title"];
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16]
                   constrainedToSize:CGSizeMake(300, 420)
                       lineBreakMode:NSLineBreakByWordWrapping];
    UITextView *newTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 75, 300, size.height + 25)];
    [newTextView setFont:[UIFont systemFontOfSize:16]];
    newTextView.text = title;
    newTextView.userInteractionEnabled = NO;
    [self.view addSubview:newTextView];

    // set the image
    NSString *imageURLString = [[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:selectedTag] objectForKey:@"image"];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage* image = [UIImage imageWithData:imageData];
    [self.imageView setImage:image];
    

}


- (void)viewDidLoad
{
    [self prepareForDisplay];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
