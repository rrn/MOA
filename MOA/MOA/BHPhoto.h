//
//  BHPhoto.h
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHPhoto : NSObject

@property (nonatomic, strong, readonly) NSURL *imageURL;
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, strong, readonly) NSString *imageName;
+ (BHPhoto *)photoWithImageURL:(NSURL *)imageURL;
+(BHPhoto *)photoWithImageName:(NSString *)imageName;

- (id)initWithImageURL:(NSURL *)imageURL;

@end
