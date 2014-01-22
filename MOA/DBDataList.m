//
//  DBDataList.m
//  MOA
//
//  Created by Diana Sutandie on 11/19/2013.
//  Copyright (c) 2013 Museum of Anthropology UBC. All rights reserved.
//

#import "DBDataList.h"
#import "DBData.h"

@implementation DBDataList

-(NSString *)GetDocumentDirectory{
    fileMgr = [NSFileManager defaultManager];
    homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    return homeDir;
}

- (NSMutableArray *) getCafeHours {
    
    NSMutableArray *cafeHoursData = [[NSMutableArray alloc] init];
    @try {
        //NSFileManager *fileMgr = [NSFileManager defaultManager];
        
        // check if the documents has file or not
        NSString *dbPath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"MOA.sqlite"];
        if (![fileMgr fileExistsAtPath:dbPath]) {
            dbPath = [[NSBundle mainBundle] pathForResource:@"MOA"ofType:@"sqlite"];
            NSLog(@"%@", @"File not found, using bundle");
        }
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        if(!(sqlite3_open_v2([dbPath UTF8String], &db,SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        const char *sql = "SELECT Day, Hours FROM cafe_hours";
        sqlite3_stmt *sqlStatement;
        
        
        int x = sqlite3_prepare(db, sql, -1, &sqlStatement, NULL);
        if(x != SQLITE_OK)
        {
            NSLog(@"%d", x);
            NSLog(@"%s SQLITE_ERROR '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
            NSLog(@"Problem with prepare statement");
        }
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            DBData *data = [[DBData alloc]init];
            
            data.Day = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,0)];
            data.Hours = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
            [cafeHoursData addObject:data];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return cafeHoursData;
    }
}


@end
