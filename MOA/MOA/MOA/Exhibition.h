//
//  Exhibition.h
//  MOA
//
//  Created by Diana Sutandie on 1/26/2014.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Exhibition : NSObject {
    NSString* itemID;
    NSString* title;
    NSString* subtitles;
    NSString* imageCaption;
    NSString* summary;
    NSDate* expiryDate;
    NSDate* activationDate;
    UIImage* image;
    UIImage* detailImage;
}

@property (nonatomic, retain) NSString* itemID;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* subtitles;
@property (nonatomic, retain) NSString* imageCaption;
@property (nonatomic, retain) NSString* summary;
@property (nonatomic, retain) NSDate* expiryDate;
@property (nonatomic, retain) NSDate* activationDate;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) UIImage* detailImage;


@end
