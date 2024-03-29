//
//  SearchResultListViewController.m
//  MOA
//
//  Created by Sukhi Mann on 11/15/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "SearchResultListViewController.h"
#import "ItemPageController.h"
#import "SWRevealViewController.h"
#import "ItemViewCell.h"
#import "BHAlbumTitleReusableView.h"
#import "TagList.h"
#import "Reachability.h"

static NSString * const PhotoCellIdentifier = @"itemCell";
static NSString * const AlbumTitleIdentifier = @"AlbumTitle";
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface SearchResultListViewController ()

@property (nonatomic, strong) NSMutableArray *albums;
@property (nonatomic, strong) NSOperationQueue *thumbnailQueue;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation SearchResultListViewController
{
    NSMutableArray *itemList;
    NSArray *imageList;
    NSString *Type;
    NSMutableArray *searchArray;
    NSInteger resultSize;
    int itemIterator;
    NSString* catogeryType;
    NSString* searchType;
    UIActivityIndicatorView* loadMoreLoader;
    
}

@synthesize activityLoader;

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
    itemIterator=0;
    //Matching the search text to a category
    Type = @"";
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"SELF matches [c] %@", [self title]];
    searchArray = [[[[TagList sharedInstance] objectTypeTags] filteredArrayUsingPredicate:predicate] mutableCopy];
    if([searchArray count] == 1)
        Type = @"Object Type";
    searchArray = [[[[TagList sharedInstance] placesTags] filteredArrayUsingPredicate:predicate] mutableCopy];
    if([searchArray count] == 1)
        Type = @"Places";
    searchArray = [[[[TagList sharedInstance] culturesTags] filteredArrayUsingPredicate:predicate] mutableCopy];
    if([searchArray count] == 1)
        Type = @"Cultures";
    searchArray = [[[[TagList sharedInstance] materialsTags] filteredArrayUsingPredicate:predicate] mutableCopy];
    if([searchArray count] == 1)
        Type = @"Materials";
    searchArray = [[[[TagList sharedInstance] peopleTags] filteredArrayUsingPredicate:predicate] mutableCopy];
    if([searchArray count] == 1)
        Type = @"People";
    if([Type isEqualToString:@""])
        Type= @"id";
    
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sideBarButton.target = self.revealViewController;
    _sideBarButton.action = @selector(rightRevealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.ca"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if(internetStatus == NotReachable) {
        activityLoader.hidden=YES;
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Alert!"
                              message: @"There is no internet connection, certain features will not be fully functional."
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        [activityLoader startAnimating];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // No explicit autorelease pool needed here.
            // The code runs in background, not strangling
            // the main run loop.
            [self fetchedData];
            dispatch_sync(dispatch_get_main_queue(), ^{
                // This will be called on the main thread, so that
                // you can update the UI, for example.
                [activityLoader stopAnimating];
                activityLoader.hidden =YES;
                
                [self.collectionView reloadData];
                if (resultSize > 10) {
                    [self performSelector:@selector(displayLoadMore) withObject:self afterDelay:.2];
                }
            });
        });
    }
    
    loadMoreLoader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadMoreLoader setHidesWhenStopped:YES];
    [loadMoreLoader setHidden:YES];
    [loadMoreLoader setFrame:CGRectMake(70, 5, 20, 20)];
}

//Code for the loadmore button
-(void) loadMoreButtonPressed:(UIButton*)sender
{
    [sender setSelected:YES];
    [loadMoreLoader startAnimating];
    [self performSelectorInBackground:@selector(downloadMore:) withObject:sender];
}

//Downloads more content as needed
-(void) downloadMore:(UIButton*) sender
{
    if (itemIterator < resultSize) {
        NSString *jsonString = [ [NSString alloc]
                                initWithContentsOfURL:[ [NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.rrnpilot.org/items.json?filters=held+at+MOA:+University+of+British+Columbia,+%@+%@&page=%i", catogeryType,searchType, (itemIterator/10)+1]]
                                encoding:NSUTF8StringEncoding
                                error:nil
                                ];
        NSData* jsonData =[[jsonString dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
        NSDictionary *entireDictionary =[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSMutableArray *temp =[[entireDictionary objectForKey:@"items"] mutableCopy];
        [itemList addObjectsFromArray:temp];
        itemIterator = itemIterator + 10;
    }
    [self createAlbums];
    [[self collectionView] reloadData];
    if(itemIterator < resultSize){
        [self performSelectorOnMainThread:@selector(updateButtonLocation:) withObject:sender waitUntilDone:YES];
    }else{
        [sender removeFromSuperview];
    }
}

//if loadmore button is pressed, button position must be shifted down
-(void) updateButtonLocation:(UIButton*) button
{
    [self performSelector:@selector(showButtonAtNewLocation:) withObject:button afterDelay:.1];
}

-(void)showButtonAtNewLocation:(UIButton*) button
{
    [loadMoreLoader stopAnimating];
    [button setSelected:NO];
    //[self.collectionView addSubview:button];
    [button setFrame:CGRectMake(20, self.collectionView.contentSize.height - 50, self.collectionView.contentSize.width - 40, 30)];
}

//Displays a loading message while loading more info
-(void)displayLoadMore
{
    UIButton* button = [[UIButton alloc] init];
    button.frame = CGRectMake(20, self.collectionView.contentSize.height - 50, self.collectionView.contentSize.width - 40, 30);
    [button setTitle:@"Load More" forState:UIControlStateNormal];
    [button setTitle:@"Loading..." forState:UIControlStateSelected];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    
    [button addSubview:loadMoreLoader];
    
    [button addTarget:self action:@selector(loadMoreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.collectionView addSubview:button];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //    dispatch_async(kBgQueue, ^{
    //        [self performSelectorOnMainThread:@selector(fetchedData:)
    //                               withObject:NULL waitUntilDone:YES];
    //    });
    
}
-(void)fetchedData{
    
    
    [self downloadItemJsonFeed];
    
    //[NSThread sleepForTimeInterval:1.0f];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[ItemViewCell class]
            forCellWithReuseIdentifier:PhotoCellIdentifier];
    
    self.albums = [NSMutableArray array];
    
    
    [self createAlbums];
    
    
    [self.collectionView registerClass:[BHAlbumTitleReusableView class]
            forSupplementaryViewOfKind:BHPhotoAlbumLayoutAlbumTitleKind
                   withReuseIdentifier:AlbumTitleIdentifier];
    
}

//Allocate information from JSON file into relevant positions/variables
-(void) createAlbums
{
    for (NSInteger a = itemIterator-10; a < [itemList count]; a++) {
        BHAlbum *album = [[BHAlbum alloc] init];
        
        NSArray *digitalObjects = [[itemList objectAtIndex:a] objectForKey:@"digital_objects"];
        
        
        if ([digitalObjects count] > 0){
            
            NSString *thumbnailURL70b70 = [[NSString alloc] initWithString:[[digitalObjects objectAtIndex:0] objectForKey:@"thumbnail_url"]];
            NSString *thumbnailURL220b220 = [thumbnailURL70b70 stringByReplacingOccurrencesOfString:@"w70h70c" withString:@"w220h220c"];
            NSURL *imageUrl = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http:%@", thumbnailURL220b220]];
            
            NSURL *photoURL = imageUrl;
            BHPhoto *photo = [BHPhoto photoWithImageURL:photoURL];
            [album addPhoto:photo];
        }
        else
        {
            BHPhoto* photo = [BHPhoto photoWithImageName:@"ImageNotAvailable"];
            [album addPhoto:photo];
        }
        album.name = [NSString stringWithFormat:@"%@", [[itemList objectAtIndex:a] objectForKey:@"name"]];
        //add item country/dates
        if([[[itemList objectAtIndex:a] objectForKey:@"creation_locations"] count] > 0){
            if([[[[[itemList objectAtIndex:a] objectForKey:@"creation_locations"] objectAtIndex:0] objectForKey:@"name"] rangeOfString:@"null"].location == NSNotFound){
                album.country = [[[[itemList objectAtIndex:a] objectForKey:@"creation_locations"] objectAtIndex:0] objectForKey:@"name"];
            }
            else{
                album.country = @"";
            }
        }
        else{
            album.country = @"";
        }
        if([[[itemList objectAtIndex:a] objectForKey:@"creation_events"] count] > 0){
            if([[[[itemList objectAtIndex:a] objectForKey:@"creation_events"] objectAtIndex:0] objectForKey:@"start_year"] != [NSNull null]){
                if([[[[itemList objectAtIndex:a] objectForKey:@"creation_events"] objectAtIndex:0] objectForKey:@"end_year"] != [NSNull null]){
                    if([[[[[itemList objectAtIndex:a] objectForKey:@"creation_events"] objectAtIndex:0] objectForKey:@"start_year"] intValue] !=[[[[[itemList objectAtIndex:a] objectForKey:@"creation_events"] objectAtIndex:0] objectForKey:@"end_year"] intValue]){
                        album.date = [NSString stringWithFormat:@"%i to %i",[[[[[itemList objectAtIndex:a] objectForKey:@"creation_events"] objectAtIndex:0] objectForKey:@"start_year"] intValue], [[[[[itemList objectAtIndex:a] objectForKey:@"creation_events"] objectAtIndex:0] objectForKey:@"end_year"] intValue]];
                    }else{
                        album.date = [NSString stringWithFormat:@"During %i",[[[[[itemList objectAtIndex:a] objectForKey:@"creation_events"] objectAtIndex:0] objectForKey:@"end_year"] intValue]];
                    }
                    
                }else{
                    album.date = [NSString stringWithFormat:@"After %i",[[[[[itemList objectAtIndex:a] objectForKey:@"creation_events"] objectAtIndex:0] objectForKey:@"start_year"] intValue]];
                }
            }
            else{
                if([[[[itemList objectAtIndex:a] objectForKey:@"creation_events"] objectAtIndex:0] objectForKey:@"end_year"] != [NSNull null]){
                    album.date = [NSString stringWithFormat:@"Before %i",[[[[[itemList objectAtIndex:a] objectForKey:@"creation_events"] objectAtIndex:0] objectForKey:@"end_year"] intValue]];
                }
                else{
                    album.date = @"";
                }
                
            }
        }
        else{
            album.date = @"";
        }
        
        [self.albums addObject:album];
        self.thumbnailQueue = [[NSOperationQueue alloc] init];
        self.thumbnailQueue.maxConcurrentOperationCount = 3;
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [itemList count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //return [itemList count];
    BHAlbum *album = self.albums[section];
    return album.photos.count;
}

//Downloads information in JSON format
- (void) downloadItemJsonFeed{
    
    NSInteger tempNumber;
    NSString *tempCatogeryType;
    NSString *temp;
    
    if(self.navigationController.viewControllers.count <3){
        tempNumber = 0;
        temp = [self title];
        tempCatogeryType = Type;
        searchType = [temp stringByReplacingOccurrencesOfString:@"," withString:@""];
        searchType = [searchType stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        
        
    }else{
        tempNumber = self.navigationController.viewControllers.count;
        tempCatogeryType = [[self.navigationController.viewControllers objectAtIndex:tempNumber-2] title];
        temp = [self title];
        searchType = [temp stringByReplacingOccurrencesOfString:@"," withString:@""];
        searchType = [searchType stringByReplacingOccurrencesOfString:@" " withString:@"+"];

    }
    
    
    
    
    if([tempCatogeryType isEqualToString:@"Places"]){
        
        catogeryType = @"made+in";
        
    }
    else if([tempCatogeryType isEqualToString:@"Object Type"]){
        
        catogeryType = @"type";
        
        
    }
    else if([tempCatogeryType isEqualToString:@"Cultures"]){
        
        catogeryType = @"culture";
        
        
        
    }
    else if([tempCatogeryType isEqualToString:@"Materials"]){
        
        catogeryType = @"made+of";
        
        
        
    }
    else if([tempCatogeryType isEqualToString:@"People"]){
        
        catogeryType = @"person";
        
    }
    else if ([tempCatogeryType isEqualToString:@"id"]){
        catogeryType = @"id";
    }
    

    
    NSString *jsonString = [ [NSMutableString alloc]
                            initWithContentsOfURL:[ [NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.rrnpilot.org/items.json?filters=held+at+MOA:+University+of+British+Columbia,+%@+%@", catogeryType,searchType]]
                            encoding:NSUTF8StringEncoding
                            error:nil
                            ];
    NSData *jsonData = [[jsonString dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    
    NSDictionary *entireDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    itemList = [[entireDictionary objectForKey:@"items"] mutableCopy];
    resultSize = [[entireDictionary objectForKey:@"result-count"] intValue];
    itemIterator = 10;
    
    //    for(int b = 10; b < x; b= b+10){
    //        NSString *jsonString = [ [NSString alloc]
    //                                initWithContentsOfURL:[ [NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.rrnpilot.org/items.json?filters=held+at+MOA:+University+of+British+Columbia,+%@+%@&page=%i", catogeryType,searchType,(b/10)+1]]
    //                                encoding:NSUTF8StringEncoding
    //                                error:nil
    //                                ];
    //        NSData* jsonData =[[jsonString dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    //        NSDictionary *entireDictionary =[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    //        NSMutableArray *temp =[[entireDictionary objectForKey:@"items"] mutableCopy];
    //        [itemList addObjectsFromArray:temp];
    //    }
    
}

//Configures cells
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemViewCell *itemCell =
    [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier
                                              forIndexPath:indexPath];
    
    BHAlbum *album = self.albums[indexPath.section];
    BHPhoto *photo = album.photos[indexPath.item];
    
    // load photo images in the background
    __weak SearchResultListViewController *weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        UIImage *image = [photo image];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // then set them via the main queue if the cell is still visible.
            if ([weakSelf.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                ItemViewCell *cell =
                (ItemViewCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
                cell.imageView.image = image;
            }
        });
    }];
    
    [self.thumbnailQueue addOperation:operation];
    
    return itemCell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath;
{
    BHAlbumTitleReusableView *titleView =
    [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                       withReuseIdentifier:AlbumTitleIdentifier
                                              forIndexPath:indexPath];
    
    BHAlbum *album = self.albums[indexPath.section];
    
    //Set cell title
    titleView.titleLabel.numberOfLines=1;
    titleView.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleView.dateLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleView.countryLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleView.titleLabel.text = [NSString stringWithFormat:@"%@", album.name];
    titleView.dateLabel.text =[NSString stringWithFormat:@"%@", album.date];
    titleView.countryLabel.text =[NSString stringWithFormat:@"%@", album.country];
    return titleView;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"item" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *selectedCell = [[self.collectionView indexPathsForSelectedItems] lastObject];
    ItemPageController *destinationViewController = [segue destinationViewController];
    destinationViewController.data = itemList;
    destinationViewController.itemNumber = selectedCell.section;
    destinationViewController.count = self.albums.count;
}

@end
