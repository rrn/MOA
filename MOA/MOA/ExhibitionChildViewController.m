//
//  ExhibitionChildViewController.m
//  MOA
//
//  Created by Diana Sutandie on 1/30/2014.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import "ExhibitionChildViewController.h"
#import "TagList.h"
#import "Utils.h"

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

-(void) setSelectedButton :(int)tag {
    // do something
    selectedTag = tag;
}

- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width andSize: (int)fontSize
{
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setFont:[UIFont systemFontOfSize:fontSize]];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
    
}


-(void) prepareForDisplay
{

    int length = 0;
    int cursorPosition = 0;
    
    NSString* title = [[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:selectedTag] objectForKey:@"title"];
    UITextView *titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 75, 300, 10)];
    cursorPosition = 75;
    
    [titleTextView setFont:[UIFont boldSystemFontOfSize:18]];
    titleTextView.text = title;
    titleTextView.textAlignment=NSTextAlignmentCenter;
    titleTextView.userInteractionEnabled = NO;
    titleTextView.scrollEnabled= NO;
    length = [Utils textViewDidChange:titleTextView];
    
    NSString *imageURLString = [[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:selectedTag] objectForKey:@"image"];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImageView *imageView =[[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
    cursorPosition = cursorPosition + length;
    imageView.frame = CGRectMake(10, cursorPosition + 10, self.view.frame.size.width-20, 214);
    
    cursorPosition = 214+cursorPosition;
    NSString* subtitle = [[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:selectedTag] objectForKey:@"subtitle"];
    UITextView *subtitleTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, cursorPosition + 10, self.view.frame.size.width-20, 10)];
    
    [subtitleTextView setFont:[UIFont systemFontOfSize:14]];
    subtitleTextView.text = subtitle;
    subtitleTextView.userInteractionEnabled = NO;
    subtitleTextView.scrollEnabled =NO;
    length = [Utils textViewDidChange:subtitleTextView];
    cursorPosition = cursorPosition + length;
    
    NSString* imageCaption = [[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:selectedTag] objectForKey:@"imageCaption"];
    UITextView *imageCaptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, cursorPosition+10, self.view.frame.size.width-20, 10)];
    
    [imageCaptionTextView setFont:[UIFont italicSystemFontOfSize:14]];
    imageCaptionTextView.text = imageCaption;
    imageCaptionTextView.userInteractionEnabled = NO;
    imageCaptionTextView.scrollEnabled=NO;
    length = [Utils textViewDidChange:imageCaptionTextView];
    cursorPosition = cursorPosition+length;
    
    NSString* desc = [[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:selectedTag] objectForKey:@"Summary"];
    UITextView *descTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, cursorPosition + 10, self.view.frame.size.width-20, 10)];
    
    [descTextView setFont:[UIFont systemFontOfSize:12]];
    descTextView.text = desc;
    descTextView.userInteractionEnabled = NO;
    descTextView.scrollEnabled=NO;
    descTextView.textAlignment = NSTextAlignmentJustified;
    length = [Utils textViewDidChange:descTextView];
    cursorPosition = cursorPosition + length;

    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scroll.contentSize = CGSizeMake(self.view.frame.size.width, cursorPosition + 75); //why 75? 75 spaces at the bottom to make it look better
    scroll.scrollEnabled = YES;
    [scroll addSubview:imageView];
    [scroll addSubview:titleTextView];
    [scroll addSubview:descTextView];
    [scroll addSubview:imageCaptionTextView];
    [scroll addSubview:subtitleTextView];
    [self.view addSubview:scroll];
}




@end
