//
//  CrudOp.m
//  MOA
//
//  Created by Diana Sutandie on 1/21/2014.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import "CrudOp.h"

@implementation CrudOp
@synthesize  coldbl;
@synthesize colint;
@synthesize coltext;
@synthesize dataId;
@synthesize fileMgr;
@synthesize homeDir;
@synthesize title;


void sqliteCallbackFunc(void *foo, const char* statement) {
    NSLog(@"=> %s", statement);
}

-(NSString *)GetDocumentDirectory{
    fileMgr = [NSFileManager defaultManager];
    homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    return homeDir;
}

-(void)CopyDbToDocumentsFolder{
    NSError *err=nil;
    
    fileMgr = [NSFileManager defaultManager];
    
    NSString *dbpath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MOA.sqlite"];
    
    NSString *copydbpath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"MOA.sqlite"];
    
    [fileMgr removeItemAtPath:copydbpath error:&err];
    if(![fileMgr copyItemAtPath:dbpath toPath:copydbpath error:&err])
    {
        UIAlertView *tellErr = [[UIAlertView alloc] initWithTitle:title message:@"Unable to copy database." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [tellErr show];
        
    }
    
}

-(void)CopyDbToTemporaryFolder{
    NSError *err=nil;
    
    fileMgr = [NSFileManager defaultManager];
    
    NSString *dbpath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"MOA.sqlite"];
    NSString *renameDbPath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"MOA1.sqlite"];
    
    BOOL result = [fileMgr moveItemAtPath:dbpath toPath:renameDbPath error:&err];
    if(!result)
        NSLog(@"Error: %@", err);
    
    NSString *copydbpath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MOA1.sqlite"];
    
    [fileMgr removeItemAtPath:copydbpath error:&err];
    if(![fileMgr copyItemAtPath:renameDbPath toPath:copydbpath error:&err])
    {
        UIAlertView *tellErr = [[UIAlertView alloc] initWithTitle:title message:@"Unable to copy database." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [tellErr show];
        
    }
}

-(void)InsertRecords:(NSMutableString *) txt :(NSMutableString*) txt2 {
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb;
    
    [self CopyDbToDocumentsFolder];
    NSString *dbPath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"MOA.sqlite"];
    BOOL success = [fileMgr fileExistsAtPath:dbPath];
    
    if(!success)
    {
        NSLog(@"Cannot locate database file '%@'.", dbPath);
    }
    if(!(sqlite3_open_v2([dbPath UTF8String], &cruddb,SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK))
    {
        NSLog(@"An error has occured.");
    }
    int rc;
    if ((rc =sqlite3_prepare_v2(cruddb, "INSERT into cafe_hours VALUES (?,?)", -1, &stmt, NULL)) != SQLITE_OK){
        NSLog(@"%d", rc );
        NSLog(@"Error %s", sqlite3_errmsg(cruddb));
    };
    sqlite3_bind_text(stmt, 1, [txt UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 2, [txt2 UTF8String], -1, SQLITE_TRANSIENT);
    NSLog(@"Error %s", sqlite3_errmsg(cruddb));
    
    if (sqlite3_step(stmt) != SQLITE_DONE) 
        NSLog(@"Error %s", sqlite3_errmsg(cruddb));
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);
    
}

-(void)UpdateRecords:(NSString *)txt :(NSMutableString *)utxt :(int)indx :(NSString *)type{
    
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb;
    
    //[self CopyDbToDocumentsFolder];
    
    
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"MOA.sqlite"];
    const char *dbpath = [cruddatabase UTF8String];
    
    const char *sql= "";
    if ([type isEqualToString:@"generalHours"]){
        sql = "update general_hours Set Hours = ?, Day=? Where rowid=?";
    } else if ([type isEqualToString:@"cafeHours"]){
        sql = "update cafe_hours Set Hours=?, Day=? Where rowid=?";
    } else if ([type isEqualToString:@"generalText"]){
        sql = "update general_text Set description=?, identifier=? Where rowid=?";
    } else if ([type isEqualToString:@"rateGeneral"]){
        sql = "update rates_general Set rate=?, description=? Where rowid=?";
    } else if ([type isEqualToString:@"rateGroups"]){
        sql = "update rates_groups Set rate=?, description=? Where rowid=?";
    } else if ([type isEqualToString:@"parkingDirections"]){
        sql = "update parking_and_directions Set Description=?, heading=? Where rowid=?";
    }
    
    
    if(sqlite3_open(dbpath, &cruddb) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(cruddb, sql, 267, &stmt, NULL)==SQLITE_OK){
            sqlite3_bind_text(stmt, 1, [txt UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(stmt, 2, [utxt UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(stmt, 3, indx);
        }
    }
    char* errmsg;
    // uncomment this for trace
    //sqlite3_trace(cruddb, sqliteCallbackFunc, NULL);
    sqlite3_exec(cruddb, "COMMIT", NULL, NULL, &errmsg);
    
    if(SQLITE_DONE != sqlite3_step(stmt)){
        NSLog(@"Error while updating. %s", sqlite3_errmsg(cruddb));
    }
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);
 
    
}
-(void)DeleteRecords:(NSString *)txt{
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb;
    
    //insert
    const char *sql = "Delete from data where coltext=?";
    
    //Open db
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"MOA.sqlite"];
    sqlite3_open([cruddatabase UTF8String], &cruddb);
    sqlite3_prepare_v2(cruddb, sql, 1, &stmt, NULL);
    sqlite3_bind_text(stmt, 1, [txt UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);
    
}

-(void)checkReturnCode: (int)rc{
    if(rc != SQLITE_OK)
    {
        NSLog(@"Problem with prepare statement at PullFromLocalDB, rc = %d", rc);
        //NSLog(@"%s SQLITE_ERROR '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
}

- (NSMutableArray *) PullFromLocalDB :(NSString*) tableName{
    
    
    NSMutableString *data1, *data2;
    NSMutableString *temp;
    NSMutableArray *returnedData = [[NSMutableArray alloc] init];
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
        
        const char *sql;
        int saveDataInDefaultFormat;
        
        if ([tableName isEqualToString:@"cafe_hours"]){
            sql = "SELECT Day, Hours FROM cafe_hours";
            saveDataInDefaultFormat = 1;
        } else if ([tableName isEqualToString:@"general_text"]){
            sql = "SELECT Identifier, Description FROM general_text";
        } else if ([tableName isEqualToString:@"general_hours"]){
            sql = "SELECT Day, Hours FROM general_hours";
            saveDataInDefaultFormat = 1;
        } else if ([tableName isEqualToString:@"parking_and_directions"]) {
            sql = "SELECT Heading, Descriptions FROM parking_and_directions";
        } else if ([tableName isEqualToString:@"rates_general"]){
            sql = "SELECT Description, Rate FROM rates_general";
            saveDataInDefaultFormat = 1;
        } else if ([tableName isEqualToString:@"rates_groups"]){
            sql = "SELECT Description, Rate FROM rates_groups";
            saveDataInDefaultFormat = 1;
        } else {
            sql = "";
        }
    
        sqlite3_stmt *sqlStatement;
        int rc = sqlite3_prepare(db, sql, -1, &sqlStatement, NULL);
        [self checkReturnCode:rc];
        
        if (saveDataInDefaultFormat == 1){
            while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
                
                data1 = [NSMutableString stringWithString:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,0)]];
                data2 = [NSMutableString stringWithString:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)]];
                temp = [NSMutableString stringWithFormat:@"%@ \t: %@\n", data1, data2];
                
                [returnedData addObject:temp];
            }
        } else {
            while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
                
                data1 = [NSMutableString stringWithString:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,0)]];
                data2 = [NSMutableString stringWithString:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)]];
                //temp = [NSMutableString stringWithFormat:@"%@ \t: %@\n", data1, data2];
                
                [returnedData addObject:data2];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return returnedData;
    }
}



@end
