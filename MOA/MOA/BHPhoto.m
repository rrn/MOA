//
//  BHPhoto.m
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import "BHPhoto.h"

@interface BHPhoto ()

@property (nonatomic, strong, readwrite) NSURL *imageURL;
@property (nonatomic, strong, readwrite) UIImage *image;
@property (nonatomic, strong, readwrite) NSString *imageName;

@end

@implementation BHPhoto

#pragma mark - Properties

- (UIImage *)image
{
    if (!_image && self.imageURL) {
        NSData *imageData = [NSData dataWithContentsOfURL:self.imageURL];
        UIImage *image = [UIImage imageWithData:imageData scale:[UIScreen mainScreen].scale];
        
        _image = image;
    }else if (!_image && self.imageName){
        UIImage *image = [UIImage imageNamed:_imageName];
        _image = image;
    }
    
    return _image;
}

#pragma mark - Lifecycle

+ (BHPhoto *)photoWithImageURL:(NSURL *)imageURL
{
    return [[self alloc] initWithImageURL:imageURL];
}

+(BHPhoto *)photoWithImageName:(NSString *)imageName
{
    return [[self alloc] initWithImageName:imageName];
}


- (id)initWithImageName:(NSString *)name
{
    self = [super init];
    if (self) {
        self.imageName = name;
    }
    return self;
}


- (id)initWithImageURL:(NSURL *)imageURL
{
    self = [super init];
    if (self) {
        self.imageURL = imageURL;
    }
    return self;
}

@end
