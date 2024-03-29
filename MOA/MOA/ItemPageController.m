//
//  ItemPageController.m
//  MOA
//
//  Created by Sukhi Mann on 11/18/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "ItemPageController.h"
#import "SWRevealViewController.h"
#import "Reachability.h"

@interface ItemPageController ()
@property (strong, nonatomic)  UILabel *idNumberLabel;
@property (strong, nonatomic)  UILabel *itemNameLabel;
@property (strong, nonatomic)  UITextView *itemDescriptionTextView;
@property (strong, nonatomic)  UIImageView *displayItemImageView;
@property (strong, nonatomic)  UIBarButtonItem *titleText;
@property (strong, nonatomic)  UIBarButtonItem *nextItem;
@property (strong, nonatomic)  UIBarButtonItem *previousItem;
@property (strong, nonatomic) UIActivityIndicatorView* imageLoading;
@end

@implementation ItemPageController
{
    NSMutableString *generalDescription2;
    NSMutableString *generalDescription3;
}

@synthesize data, itemNumber, count;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)previousItem:(id)sender{
    if(itemNumber>0){
        self.itemNumber--;
        [self pageSetup];
        [_nextItem setEnabled:YES];
        if(itemNumber==0)
            [_previousItem setEnabled:NO];
    }
}

-(IBAction)nextItem:(id)sender{
    if(itemNumber<count){
        self.itemNumber++;
        [self pageSetup];
        [_previousItem setEnabled:YES];
        if(itemNumber+1==count)
            [_nextItem setEnabled:NO];
    }
}

-(IBAction)backButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.\
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sideBarButton.target = self.revealViewController;
    _sideBarButton.action = @selector(rightRevealToggle:);
    
    _nextItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(nextItem:)];
    _previousItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(previousItem:)];
    _titleText = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    _titleText.tintColor=[UIColor blackColor];
    
    if(itemNumber==0)
        [_previousItem setEnabled:NO];
    if(itemNumber+1==count)
        [_nextItem setEnabled:NO];
    
    self.navigationItem.rightBarButtonItems = @[_sideBarButton, _nextItem, _titleText, _previousItem];
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    float screenWidth =[UIScreen mainScreen].bounds.size.width;
    
    self.itemNameLabel =[[UILabel alloc] initWithFrame:CGRectMake(screenWidth/20, 10, screenWidth -screenWidth/20, 30)];
    self.idNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/20, 50, screenWidth -screenWidth/20, 30)];
    self.displayItemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/20, 90, screenWidth -(2*screenWidth)/20, 200)];
    self.itemDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(screenWidth/20, 300, screenWidth -(2*screenWidth)/20, 200)];
    self.itemDescriptionTextView.scrollEnabled = NO;
    
    [[self theScrollView] addSubview:[self itemNameLabel]];
    [[self theScrollView] addSubview:[self idNumberLabel]];
    [[self theScrollView] addSubview:[self displayItemImageView]];
    [[self theScrollView] addSubview:[self itemDescriptionTextView]];
    float bottom_inset = self.tabBarController.tabBar.frame.size.height;
    
    self.displayItemImageView.image = [[UIImage alloc] init];
    _imageLoading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((screenWidth -(2*screenWidth)/20)/2-10, 90, 20, 20)];
    _imageLoading.color = [UIColor grayColor];
    [self.displayItemImageView addSubview:_imageLoading];
    
    self.theScrollView.contentInset=UIEdgeInsetsMake(0.0, 0.0, bottom_inset,0.0);
    
    [self.view addSubview:[self theScrollView]];
    
    [self pageSetup];
    
    
}

-(void) downloadImage :(NSArray*)digitalObjects{
    _imageLoading.hidden = NO;
    [_imageLoading startAnimating];
    
    NSString *imageUrl = [NSString stringWithFormat:@"http:%@",[[digitalObjects objectAtIndex:0] objectForKey:@"url"]];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageUrl]];
    self.displayItemImageView.image = [UIImage imageWithData:imageData];
    
    [_imageLoading stopAnimating];
    _imageLoading.hidden = YES;
}
-(void) pageSetup
{
    self.displayItemImageView.image = [UIImage imageNamed:@"emptySpace"];
    _titleText.title = [NSString stringWithFormat:@"%i of %i", self.itemNumber+1, self.count];
    
    NSArray *digitalObjects = [[data objectAtIndex:itemNumber] objectForKey:@"digital_objects"];
    
    generalDescription2 = [[NSMutableString alloc] initWithFormat:@""];
    [generalDescription2 appendFormat:@"\n"];
    [self generalDescription2Text];
    
    generalDescription3 = [[NSMutableString alloc] initWithFormat:@""];
    [generalDescription3 appendFormat:@"\n"];
    [self generalDescription3Text];
    
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.ca"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if(internetStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Alert!"
                              message: @"There is no internet connection, item image cannot load."
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        if([digitalObjects count] > 0){
            //http was dropped from feed so needed to be appended at front
            [self performSelectorInBackground:@selector(downloadImage:) withObject:digitalObjects];
        }
    }


    
    self.displayItemImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.itemNameLabel.text =[[data objectAtIndex:itemNumber] objectForKey:@"name"];
    self.idNumberLabel.text =[[data objectAtIndex:itemNumber] objectForKey:@"identification_number"];
    
    NSArray *institution_notes = [[data objectAtIndex:itemNumber] objectForKey:@"institution_notes"];
    
    
    self.itemDescriptionTextView.text= [NSString stringWithFormat:@"Description:\n%@\n\n %@\n %@",[[institution_notes objectAtIndex:0] objectForKey:@"text"], generalDescription2, generalDescription3];
    
    
    
    [self.itemDescriptionTextView sizeToFit];
    
    float height = self.itemNameLabel.frame.size.height + self.idNumberLabel.frame.size.height + self.displayItemImageView.frame.size.height + self.itemDescriptionTextView.frame.size.height+40;
    
    self.itemDescriptionTextView.editable = NO;
    
    [self.theScrollView setContentSize:CGSizeMake(self.theScrollView.frame.size.width, height)];
}

- (void) generalDescription2Text
{
    NSArray *itemTypes = [[data objectAtIndex:itemNumber] objectForKey:@"item_types"];
    NSArray *creators = [[data objectAtIndex:itemNumber] objectForKey:@"creators"];
    NSArray *cultures = [[data objectAtIndex:itemNumber] objectForKey:@"cultures"];
    NSArray *creationLocations = [[data objectAtIndex:itemNumber] objectForKey:@"creation_locations"];
    NSArray *institutionTags = [[data objectAtIndex:itemNumber] objectForKey:@"institution_tags"];
    
    //Only add the Field Name and corresponding value if it not null in the feed
    if([itemTypes count] >0){
        if ([[[itemTypes objectAtIndex:0] objectForKey:@"name"] rangeOfString:@"null"].location ==NSNotFound){
            [generalDescription2 appendFormat:@"Object Type: %@\n", [[itemTypes objectAtIndex:0] objectForKey:@"name"]];
        }
    }
    if([creators count]  > 0){
        if ([[[creators objectAtIndex:0] objectForKey:@"first_name"] rangeOfString:@"null"].location ==NSNotFound){
            [generalDescription2 appendFormat:@"Created By: %@ %@\n", [[creators objectAtIndex:0] objectForKey:@"first_name"], [[creators objectAtIndex:0] objectForKey:@"last_name"]];
        }
    }
    
    if([cultures count]  > 0){
        if ([[[cultures objectAtIndex:0] objectForKey:@"name"] rangeOfString:@"null"].location ==NSNotFound){
            [generalDescription2 appendFormat:@"Culture: %@\n", [[cultures objectAtIndex:0] objectForKey:@"name"]];
        }
    }
    
    if([creationLocations count]  > 0){
        if ([[[creationLocations objectAtIndex:0] objectForKey:@"name"] rangeOfString:@"null"].location ==NSNotFound){
            [generalDescription2 appendFormat:@"Place Made: %@\n", [[creationLocations objectAtIndex:0] objectForKey:@"name"]];
        }
    }
    
    if([institutionTags count]  > 2){
        if ([[[institutionTags objectAtIndex:2] objectForKey:@"name"] rangeOfString:@"null"].location ==NSNotFound){
            [generalDescription2 appendFormat:@"Museum Location: %@\n", [[institutionTags objectAtIndex:2] objectForKey:@"text"]];
        }
    }
}

- (void) generalDescription3Text
{
    NSArray *materials = [[data objectAtIndex:itemNumber] objectForKey:@"materials"];
    NSArray *institutionNotes = [[data objectAtIndex:itemNumber] objectForKey:@"institution_notes"];
    
    //Only add the Field Name and corresponding value if it not null in the feed
    if([materials count] >0){
        if ([[[materials objectAtIndex:0] objectForKey:@"name"] rangeOfString:@"null"].location ==NSNotFound){
            [generalDescription3 appendFormat:@"Materials: %@\n", [[materials objectAtIndex:0] objectForKey:@"name"]];
        }
    }
    if([institutionNotes count]  > 0){
        if ([[[institutionNotes objectAtIndex:0] objectForKey:@"text"] rangeOfString:@"null"].location ==NSNotFound){
            [generalDescription3 appendFormat:@"History of Use: %@\n", [[institutionNotes objectAtIndex:0] objectForKey:@"text"]];
        }
    }
    
    if([institutionNotes count]  > 1){
        if ([[[institutionNotes objectAtIndex:1] objectForKey:@"text"] rangeOfString:@"null"].location ==NSNotFound){
            [generalDescription3 appendFormat:@"Narrative: %@\n", [[institutionNotes objectAtIndex:1] objectForKey:@"text"]];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
