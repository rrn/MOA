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
    CGRect imageRect;
    BOOL isImageDisplayed;
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
    
    self.itemNameLabel =[[UILabel alloc] initWithFrame:CGRectMake(screenWidth/20, 10, screenWidth -screenWidth/10, 30)];
    self.itemNameLabel.tag = 2;

    self.idNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/20, 50, screenWidth -screenWidth/10, 30)];
    
    self.idNumberLabel.tag = 1;
    
    imageRect = CGRectMake(screenWidth/20, 90, screenWidth -(2*screenWidth)/20, 200);
    self.displayItemImageView = [[UIImageView alloc] initWithFrame: imageRect];
    self.displayItemImageView.tag = 3;
    self.itemDescriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(screenWidth/20, 300, screenWidth -(2*screenWidth)/20, 200)];
    self.itemDescriptionTextView.scrollEnabled = NO;
    isImageDisplayed = YES;

    
    [[self theScrollView] addSubview:[self itemNameLabel]];
    [[self theScrollView] addSubview:[self idNumberLabel]];
    [[self theScrollView] addSubview:[self displayItemImageView]];
    [[self theScrollView] addSubview:[self itemDescriptionTextView]];
    
    self.displayItemImageView.image = [[UIImage alloc] init];
    _imageLoading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((screenWidth -(2*screenWidth)/20)/2-10, 90, 20, 20)];
    _imageLoading.color = [UIColor grayColor];
    [self.displayItemImageView addSubview:_imageLoading];
    
    [self.view addSubview:[self theScrollView]];
    
    [self pageSetup];
    
    
}

-(void) downloadImage :(NSArray*)digitalObjects{
    _imageLoading.hidden = NO;
    [_imageLoading startAnimating];
    
    NSString *imageUrl = [[NSString stringWithFormat:@"http:%@",[[digitalObjects objectAtIndex:0] objectForKey:@"url"]] stringByReplacingOccurrencesOfString:@"original" withString:@"w800h600"] ;
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageUrl]];
    self.displayItemImageView.image = [UIImage imageWithData:imageData];
    
    [_imageLoading stopAnimating];
    _imageLoading.hidden = YES;
}
-(void) pageSetup
{
    self.displayItemImageView.image = [UIImage imageNamed:@"emptySpace"];
    _titleText.title = [NSString stringWithFormat:@"%i of %i", self.itemNumber+1, self.count];
    int iterator = 0;
    
    NSArray *digitalObjects = [[data objectAtIndex:itemNumber] objectForKey:@"digital_objects"];
    

    
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
            if (!isImageDisplayed) {
                isImageDisplayed = YES;
                [self addImageView];
            }
            [self performSelectorInBackground:@selector(downloadImage:) withObject:digitalObjects];
        }else{
            if (isImageDisplayed) {
                isImageDisplayed = NO;
                [self removeImageView];
            }
        }
    }
    generalDescription2 = [[NSMutableString alloc] initWithFormat:@""];
    [generalDescription2 appendFormat:@"\n"];
    [self generalDescription2Text];
    
    generalDescription3 = [[NSMutableString alloc] initWithFormat:@""];
    [generalDescription3 appendFormat:@"\n"];
    [self generalDescription3Text];


    
    self.displayItemImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.itemNameLabel.text =[[data objectAtIndex:itemNumber] objectForKey:@"name"];
    self.idNumberLabel.text =[[data objectAtIndex:itemNumber] objectForKey:@"identification_number"];
    self.itemNameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.idNumberLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.itemNameLabel.textAlignment = NSTextAlignmentCenter;
    self.idNumberLabel.textAlignment = NSTextAlignmentCenter;
    
    NSArray *institution_notes = [[data objectAtIndex:itemNumber] objectForKey:@"institution_notes"];
    NSString *temp;
    
    
    if([institution_notes count]  > 0){
        for(iterator=0; iterator < [institution_notes count] ; iterator++){
            if([[[[institution_notes objectAtIndex:iterator] objectForKey:@"title"] lowercaseString] isEqualToString:@"description" ] ){
                if ([[[institution_notes objectAtIndex:iterator] objectForKey:@"text"] rangeOfString:@"null"].location ==NSNotFound){
                    temp = [NSString stringWithFormat:@"Description: \n%@", [[institution_notes objectAtIndex:iterator] objectForKey:@"text"]];
                }
            }
        }
    }
    
    if(isImageDisplayed){
        self.itemDescriptionTextView.text= [NSString stringWithFormat:@"%@\n\n %@\n %@", generalDescription2, generalDescription3,temp];

    }else{
        self.itemDescriptionTextView.text= [NSString stringWithFormat:@"%@\n\n %@\n %@",temp, generalDescription2, generalDescription3];

    }
    
    
    
    [self.itemDescriptionTextView sizeToFit];
    
    
    
    self.itemDescriptionTextView.editable = NO;
    
    [self setScrollContentSize];
    
}

-(void) addImageView
{
    [self.theScrollView addSubview:self.displayItemImageView];
    NSArray* views = [self.theScrollView subviews];
    for (UIView* singleView in views)
    {
        if (singleView.tag != 1 && singleView.tag != 2 && singleView.tag != 3) {
            [singleView setFrame:CGRectMake(singleView.frame.origin.x, singleView.frame.origin.y + imageRect.size.height, singleView.frame.size.width, singleView.frame.size.height)];
        }
    }
    [self setScrollContentSize];
}
-(void) removeImageView
{
    [self.displayItemImageView removeFromSuperview];
    NSArray* views = [self.theScrollView subviews];
    for (UIView* singleView in views)
    {
        if (singleView.tag != 1 && singleView.tag != 2) {
            [singleView setFrame:CGRectMake(singleView.frame.origin.x, singleView.frame.origin.y - imageRect.size.height, singleView.frame.size.width, singleView.frame.size.height)];
        }
    }

    [self setScrollContentSize];
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
    if([creators count] >0){
        if ([[[creators objectAtIndex:0] objectForKey:@"name"] rangeOfString:@"null"].location ==NSNotFound){
            for(int x = 0; x < [creators count]; x++){
                if(x==0){
                    if(x==([creators count]-1)){
                        [generalDescription2 appendFormat:@"Creators: %@\n",[[creators objectAtIndex:x] objectForKey:@"name"]];
                    }
                    else{
                        [generalDescription2 appendFormat:@"Creators: %@, ",[[creators objectAtIndex:x] objectForKey:@"name"]];
                    }
                    
                }
                else{
                    if(x==([creators count]-1))
                    {
                        [generalDescription2 appendFormat:@"%@\n",[[creators objectAtIndex:x] objectForKey:@"name"]];
                    }
                    else{
                        [generalDescription2 appendFormat:@"%@, ",[[creators objectAtIndex:x] objectForKey:@"name"]];
                    }
                }
                
            }
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
    
    if([[[data objectAtIndex:itemNumber] objectForKey:@"creation_events"] count] > 0){
        if([[[[data objectAtIndex:itemNumber] objectForKey:@"creation_events"] objectAtIndex:0] objectForKey:@"start_year"] != [NSNull null]){
            if([[[[data objectAtIndex:itemNumber] objectForKey:@"creation_events"] objectAtIndex:0] objectForKey:@"end_year"] != [NSNull null]){
                if([[[[[data objectAtIndex:itemNumber] objectForKey:@"creation_events"] objectAtIndex:0] objectForKey:@"start_year"] intValue] !=[[[[[data objectAtIndex:itemNumber] objectForKey:@"creation_events"] objectAtIndex:0] objectForKey:@"end_year"] intValue]){
                    [generalDescription2 appendFormat:@"Date Made: %i to %i",[[[[[data objectAtIndex:itemNumber] objectForKey:@"creation_events"] objectAtIndex:0] objectForKey:@"start_year"] intValue], [[[[[data objectAtIndex:itemNumber] objectForKey:@"creation_events"] objectAtIndex:0] objectForKey:@"end_year"] intValue]];
                }else{
                    [generalDescription2 appendFormat:@"Date Made: During %i",[[[[[data objectAtIndex:itemNumber] objectForKey:@"creation_events"] objectAtIndex:0] objectForKey:@"end_year"] intValue]];
                }
                
            }else{
                [generalDescription2 appendFormat:@"Date Made: After %i",[[[[[data objectAtIndex:itemNumber] objectForKey:@"creation_events"] objectAtIndex:0] objectForKey:@"start_year"] intValue]];
            }
        }
        else{
            if([[[[data objectAtIndex:itemNumber] objectForKey:@"creation_events"] objectAtIndex:0] objectForKey:@"end_year"] != [NSNull null]){
                [generalDescription2 appendFormat:@"Date Made: Before %i",[[[[[data objectAtIndex:itemNumber] objectForKey:@"creation_events"] objectAtIndex:0] objectForKey:@"end_year"] intValue]];
            }
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
    NSMutableString *materialsList = [[NSMutableString alloc] init];
    int iterator=0;
    
    //Only add the Field Name and corresponding value if it not null in the feed
    if([materials count] >0){
        if ([[[materials objectAtIndex:0] objectForKey:@"name"] rangeOfString:@"null"].location ==NSNotFound){
            for(int x = 0; x < [materials count]; x++){
                if(x==0){
                    if(x==([materials count]-1)){
                        [materialsList setString:[NSString stringWithFormat:@"Materials: %@\n",[[materials objectAtIndex:x] objectForKey:@"name"]]];
                    }
                    else{
                        [materialsList setString:[NSString stringWithFormat:@"Materials: %@, ",[[materials objectAtIndex:x] objectForKey:@"name"]]];
                    }
            
                }
                else{
                    if(x==([materials count]-1))
                    {
                        [materialsList appendString:[NSString stringWithFormat:@"%@\n",[[materials objectAtIndex:x] objectForKey:@"name"]]];
                    }
                    else{
                        [materialsList appendString:[NSString stringWithFormat:@"%@, ",[[materials objectAtIndex:x] objectForKey:@"name"]]];
                    }
                }
             
            }
            [generalDescription3 appendFormat:@"%@", materialsList];
        }
    }
    if([institutionNotes count]  > 0){
        for(iterator=0; iterator < [institutionNotes count] ; iterator++){
            if([[[[institutionNotes objectAtIndex:iterator] objectForKey:@"title"] lowercaseString] isEqualToString:@"history of use" ] ){
                if ([[[institutionNotes objectAtIndex:iterator] objectForKey:@"text"] rangeOfString:@"null"].location ==NSNotFound){
                    [generalDescription3 appendFormat:@"History of Use: %@\n", [[institutionNotes objectAtIndex:iterator] objectForKey:@"text"]];
                }
            }
            if([[[[institutionNotes objectAtIndex:iterator] objectForKey:@"title"] lowercaseString] isEqualToString:@"narrative" ] ){
                if ([[[institutionNotes objectAtIndex:iterator] objectForKey:@"text"] rangeOfString:@"null"].location ==NSNotFound){
                    [generalDescription3 appendFormat:@"Narrative: %@\n", [[institutionNotes objectAtIndex:iterator] objectForKey:@"text"]];
                }
            }
        }
    }
}

-(void) setScrollContentSize
{
    float height = self.itemNameLabel.frame.size.height + self.idNumberLabel.frame.size.height + self.itemDescriptionTextView.frame.size.height + 40;
    
    if (isImageDisplayed) {
        height = height + self.displayItemImageView.frame.size.height;
    }
    
    [self.theScrollView setContentSize:CGSizeMake(self.theScrollView.frame.size.width, height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
