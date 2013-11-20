//
//  ItemLayout.h
//  MOA
//
//  Created by Sukhi Mann on 11/19/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <UIKit/UIKit.h>
UIKIT_EXTERN NSString * const BHPhotoAlbumLayoutAlbumTitleKind;

@interface ItemLayout : UICollectionViewLayout

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;
@property (nonatomic) CGFloat titleHeight;

@end
