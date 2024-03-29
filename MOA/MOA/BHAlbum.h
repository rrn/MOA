//
//  BHAlbum.h
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BHPhoto;

@interface BHAlbum : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong, readonly) NSArray *photos;

- (void)addPhoto:(BHPhoto *)photo;
- (void)addPhotoI:(UIImage *)photo;
- (BOOL)removePhoto:(BHPhoto *)photo;

@end
