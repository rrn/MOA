//
//  DBDataList.h
//  MOA
//
//  Created by Diana Sutandie on 11/19/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sqlite3.h>

@interface DBDataList : NSObject {
    sqlite3 *db;
}

- (NSMutableArray *) getCafeHours;

@end
