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
    NSArray *itemList;
    NSArray *imageList;
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
    
    
    
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sideBarButton.target = self.revealViewController;
    _sideBarButton.action = @selector(rightRevealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
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
        });
    });

    
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

    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    [self.collectionView registerClass:[ItemViewCell class]
            forCellWithReuseIdentifier:PhotoCellIdentifier];
    
    self.albums = [NSMutableArray array];
    
    
    
    for (NSInteger a = 0; a < [itemList count]; a++) {
        BHAlbum *album = [[BHAlbum alloc] init];
        
        NSArray *digitalObjects = [[itemList objectAtIndex:a] objectForKey:@"digital_objects"];
        
        
        if ([digitalObjects count] > 0){
            NSURL *imageUrl = [[NSURL alloc] initWithString:[[digitalObjects objectAtIndex:0] objectForKey:@"thumbnail_url"]];
            
            // there are up to 25 photos available to load from the code repository
            NSURL *photoURL = imageUrl;
            BHPhoto *photo = [BHPhoto photoWithImageURL:photoURL];
            [album addPhoto:photo];
        }
        else
        {
            NSURL *imageUrl = [[NSURL alloc] initWithString:@"http://miacreative.com/ESW/Images/WHITE-BOX-MID.png"];
            BHPhoto *photo = [BHPhoto photoWithImageURL:imageUrl];
            [album addPhoto:photo];
        }
        album.name = [NSString stringWithFormat:@"%@: %@", [[itemList objectAtIndex:a] objectForKey:@"name"], [[itemList objectAtIndex:a] objectForKey:@"identification_number"]];
        
        [self.albums addObject:album];
        self.thumbnailQueue = [[NSOperationQueue alloc] init];
        self.thumbnailQueue.maxConcurrentOperationCount = 3;
        
    }
    [self.collectionView registerClass:[BHAlbumTitleReusableView class]
            forSupplementaryViewOfKind:BHPhotoAlbumLayoutAlbumTitleKind
                   withReuseIdentifier:AlbumTitleIdentifier];

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.albums.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    //return [itemList count];
    BHAlbum *album = self.albums[section];
    return album.photos.count;
}

- (void) downloadItemJsonFeed{
    
    NSInteger tempNumber = self.navigationController.viewControllers.count;
    NSString *tempCatogeryType = [[self.navigationController.viewControllers objectAtIndex:tempNumber-3] title];
    NSString *searchType = [self title];
    
    NSString *catogeryType = [[NSString alloc]init];
    
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
    
    searchType = [searchType stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSString *jsonString = [ [NSString alloc]
                            initWithContentsOfURL:[ [NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.rrnpilot.org/items.json?filters=held+at+MOA:+University+of+British+Columbia,+%@+%@", catogeryType,searchType]]
                            encoding:NSUTF8StringEncoding
                            error:nil
                            ];
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *entireDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    itemList = [entireDictionary objectForKey:@"items"];
    
    
}

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
    
    titleView.titleLabel.text = album.name;
    
    return titleView;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"item" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *selectedCell = [[self.collectionView indexPathsForSelectedItems] lastObject];
    ItemPageController *destinationViewController = [segue destinationViewController];
    destinationViewController.data = itemList;
    destinationViewController.itemNumber = selectedCell.row;
}

@end
