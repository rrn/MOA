//
//  DBData.h
//  MOA
//
//  Created by Diana Sutandie on 11/19/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBData : NSObject {
    NSString *Day;
    NSString *Hours;
}

@property (nonatomic, retain) NSString *Day;
@property (nonatomic, retain) NSString *Hours;

@end
