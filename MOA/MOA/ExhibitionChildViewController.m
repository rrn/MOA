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

- (int)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
    return newSize.height;
}

-(void) prepareForDisplay
{

    int length = 0;
    int cursorPosition = 0;
    
    // title, desc = description, date, image
    
    NSString* title = [[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:selectedTag] objectForKey:@"title"];
    UITextView *titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 75, 300, 10)];
    cursorPosition = 75;
    
    [titleTextView setFont:[UIFont systemFontOfSize:18]];
    titleTextView.text = title;
    titleTextView.textAlignment=NSTextAlignmentCenter;
    titleTextView.userInteractionEnabled = NO;
    titleTextView.scrollEnabled= NO;
    length = [self textViewDidChange:titleTextView];
    
    NSString *imageURLString = [[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:selectedTag] objectForKey:@"image"];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImageView *imageView =[[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
    cursorPosition = cursorPosition + length;
    imageView.frame = CGRectMake(10, cursorPosition + 10, self.view.frame.size.width-20, 214);
    
    cursorPosition = 214+cursorPosition;
    NSString* activationDate = [[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:selectedTag] objectForKey:@"activationDate"];
    UITextView *dateTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, cursorPosition + 10, self.view.frame.size.width-20, 10)];
    
    [dateTextView setFont:[UIFont systemFontOfSize:14]];
    dateTextView.text = activationDate;
    dateTextView.userInteractionEnabled = NO;
    dateTextView.scrollEnabled =NO;
    length = [self textViewDidChange:dateTextView];
    cursorPosition = cursorPosition + length;
    
    NSString* location = [[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:selectedTag] objectForKey:@"imageCaption"];
    UITextView *locationTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, cursorPosition+10, self.view.frame.size.width-20, 10)];
    
    [locationTextView setFont:[UIFont systemFontOfSize:14]];
    locationTextView.text = location;
    locationTextView.userInteractionEnabled = NO;
    locationTextView.scrollEnabled=NO;
    length = [self textViewDidChange:locationTextView];
    cursorPosition = cursorPosition+length;
    
    NSString* desc = [[[[TagList sharedInstance] exhibitionEvents] objectAtIndex:selectedTag] objectForKey:@"Summary"];
    UITextView *descTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, cursorPosition + 10, self.view.frame.size.width-20, 10)];
    
    [descTextView setFont:[UIFont systemFontOfSize:12]];
    descTextView.text = desc;
    descTextView.userInteractionEnabled = NO;
    descTextView.scrollEnabled=NO;
    descTextView.textAlignment = NSTextAlignmentJustified;
    length = [self textViewDidChange:descTextView];
    cursorPosition = cursorPosition + length;

    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scroll.contentSize = CGSizeMake(self.view.frame.size.width, cursorPosition + 75); //why 75? 75 spaces at the bottom to make it look better
    scroll.scrollEnabled = YES;
    [scroll addSubview:imageView];
    [scroll addSubview:titleTextView];
    [scroll addSubview:descTextView];
    [scroll addSubview:locationTextView];
    [scroll addSubview:dateTextView];
    [self.view addSubview:scroll];
}




@end
