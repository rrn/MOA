//
//  SearchResultListViewController.m
//  MOA
//
//  Created by Sukhi Mann on 11/15/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "SearchResultListViewController.h"

@interface SearchResultListViewController ()

@end

@implementation SearchResultListViewController
{
    NSArray *itemList;
    NSArray *imageList;
}

@synthesize theCollectionView;

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
    [self downloadItemJsonFeed];
    
    
    [[self theCollectionView] setBackgroundColor:[UIColor whiteColor]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return [itemList count];
}

- (void) downloadItemJsonFeed{
    
   NSInteger tempNumber = self.navigationController.viewControllers.count;
    NSString *tempCatogeryType = [[self.navigationController.viewControllers objectAtIndex:tempNumber-3] title];
    NSString *searchType = [self title];
   
    NSString *catogeryType = [[NSString alloc]init];
    
    if([tempCatogeryType isEqualToString:@"Places"]){
        
       catogeryType = @"locations";
        
    }
    else if([tempCatogeryType isEqualToString:@"Object Type"]){
        
        catogeryType = @"type";
        
        
    }
    else if([tempCatogeryType isEqualToString:@"Cultures"]){
        
        catogeryType = @"cultures";
        
        
        
    }
    else if([tempCatogeryType isEqualToString:@"Materials"]){
        
        catogeryType = @"materials";
        
        
        
    }
    else if([tempCatogeryType isEqualToString:@"People"]){
        
        catogeryType = @"people";
        
        
    }

    NSString *jsonString = [ [NSString alloc]
                            initWithContentsOfURL:[ [NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.rrnpilot.org/items.json?filters=held+at+MOA:+University+of+British+Columbia,+%@+%@", catogeryType,searchType]]
                            encoding:NSUTF8StringEncoding
                            error:nil
                            ];
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *entireDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];

    itemList = [entireDictionary objectForKey:@"items"];
    
    
    
    

    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
   
    cell.backgroundColor = [UIColor redColor];
    
    cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSArray *digitalObjects = [[itemList objectAtIndex:indexPath.row] objectForKey:@"digital_objects"];
    NSLog(@"%@", digitalObjects);
    if ([digitalObjects count] > 0){
    NSString *imageUrl = [[digitalObjects objectAtIndex:0] objectForKey:@"thumbnail_url"];
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageUrl]];
    UIImageView *thumbnailImage = [[UIImageView alloc] initWithImage:[UIImage imageWithData: imageData]];
        thumbnailImage.frame = CGRectMake((cell.contentView.frame.size.width - 100)/2, 0, 100 , 100);
    [cell addSubview:thumbnailImage];
    }
    NSString *itemName = [NSString stringWithFormat:@"%@: %@", [self title], [[itemList objectAtIndex:indexPath.row] objectForKey:@"identification_number"]];
    
    UILabel *nameTextBox = [[UILabel alloc] init];
    nameTextBox.frame = CGRectMake(0, 110, cell.contentView.frame.size.width , 30);
    nameTextBox.text = @"";
    nameTextBox.text = itemName;
     [nameTextBox setFont:[UIFont systemFontOfSize:10]];
    
    [cell addSubview:nameTextBox];
    
    return cell;
}

@end
