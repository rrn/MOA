//
//  TagList.h
//  MOA
//
//  Created by Sukhi Mann on 11/14/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagList : NSObject

@property (strong, nonatomic) NSMutableArray *objectTypeTags;
@property (strong, nonatomic) NSMutableArray *placesTags;
@property (strong, nonatomic) NSMutableArray *culturesTags;
@property (strong, nonatomic) NSMutableArray *materialsTags;
@property (strong, nonatomic) NSMutableArray *peopleTags;

+ (TagList *)sharedInstance;

+(void) downloadObjectJson;
+(void) downloadMaterialsJson;
+(void) downloadPlacesJson;
+(void) downloadCulturesJson;
+(void) downloadPeopleJson;

@end
