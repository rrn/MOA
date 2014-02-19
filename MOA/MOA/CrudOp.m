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

-(void)doesTableExist:(NSString*)tableName {
    
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt = nil;
    sqlite3 *cruddb;
    
    NSString *dbFile = [self.GetDocumentDirectory stringByAppendingString:@"/MOA.sqlite"];
    const char *dbFilePath = [dbFile UTF8String];
    NSString* sqlString = [self getSQLQuery_CheckTable:tableName];
    const char* sql = [sqlString UTF8String];
    
    if(sqlite3_open(dbFilePath, &cruddb) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(cruddb, sql, 267, &stmt, NULL)!=SQLITE_OK){
            NSLog(@"Error while executing check");
        }
    }
    
    char* errmsg;
    //sqlite3_trace(cruddb, sqliteCallbackFunc, NULL);
    sqlite3_exec(cruddb, "COMMIT", NULL, NULL, &errmsg);
    if(SQLITE_DONE != sqlite3_step(stmt)){
        NSLog(@"Error while updating. %s", sqlite3_errmsg(cruddb));
    }
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);
    
}

-(void)UpdateLocalDB:(NSString*)tableName :(NSMutableArray*)object {
    
    NSError *error;
    NSString *dbPath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"MOA.sqlite"];
    
    // if file does not exist in documents,
    // copy the file from bundle
    // otherwise, check the version of both files and copy the most recent version to iPhone
    
    if (![fileMgr fileExistsAtPath:dbPath]) {
        [self CopyDbToDocumentsFolder];
    } else {
        
        // compare the dates of sqlite files
        NSDictionary *dbInSimulatorDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:dbPath error:&error];
        NSDate *simulatorDBDate =[dbInSimulatorDictionary objectForKey:NSFileModificationDate];
        NSString *bundleDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MOA.sqlite"];
        NSDictionary *bundleDBDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:bundleDBPath error:&error];
        NSDate *bundleDBDate = [bundleDBDictionary objectForKey:NSFileModificationDate];
        
        // if the local DB on the phone
        // is older than the one in the program
        if ([simulatorDBDate compare:bundleDBDate] == NSOrderedAscending) {
            [[NSFileManager defaultManager] removeItemAtPath: dbPath error: &error];
            [self CopyDbToDocumentsFolder];
        }
    }

    // code for updating starts here
    // check if table exists. if not, create 1
    // upsert the rows.
    
    [self doesTableExist:tableName];
    for (int i = 1; i <= [object count]; i++){
        if ([self doesRowExists:tableName :i] == true){
            [self UpdateTable:object :tableName :i];
        } else {
            [self InsertToTable:object :tableName :i];
            
        }
    }
    
}

-(BOOL)doesRowExists:(NSString*) tableName :(int) rowid{
    
    // this function checks if a row with specified rowid exists in tableName table.
    // returns a boolean value
    
    BOOL rowExists = false;
    sqlite3_stmt *stmt = nil;
    sqlite3 *cruddb;
    NSString *crudddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"/MOA.sqlite"];
    const char *dbpath = [crudddatabase UTF8String];
    
    NSString * sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE rowid = '%i'", tableName, rowid];
    const char* sql = [sqlString UTF8String];
    
    if(sqlite3_open(dbpath, &cruddb) == SQLITE_OK)
    {
        int rc = sqlite3_prepare_v2(cruddb, sql, -1, &stmt, NULL);
        if(rc==SQLITE_OK) {
            if (sqlite3_step(stmt)==SQLITE_ROW)
                rowExists=YES;
            else
                rowExists=NO;
        } else {
            // sqlite3_prepare_v2 returns error code, print stack trace
            [self checkReturnCode:rc];
        }
    }
    
    char* errmsg;
    //sqlite3_trace(cruddb, sqliteCallbackFunc, NULL);
    sqlite3_exec(cruddb, "COMMIT", NULL, NULL, &errmsg);
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);
    return rowExists;
}

-(void)UpdateTable :(NSMutableArray*)object :(NSString*)tableName :(int) rowid
{
    // for each table containing hours - use this function
    // example: cafe_hours, general_hours
    
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb;
    
    NSString *crudddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"/MOA.sqlite"];
    const char *dbpath = [crudddatabase UTF8String];
    
    NSString * sqlString = [self getSQLQuery_Update:tableName];
    const char* sql = [sqlString UTF8String];
    //const char *sql = "update cafe_hours Set Hours = ?, Day=? Where rowid=?";
    
    if(sqlite3_open(dbpath, &cruddb) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(cruddb, sql, 267, &stmt, NULL)==SQLITE_OK){
            [self bindUpdateSQLStatement:stmt :object :rowid :tableName];
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

-(void)InsertToTable:(NSMutableArray*)object :(NSString*)tableName :(int)rowid
{
    // for each table containing hours - use this function
    // example: cafe_hours, general_hours
    
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb;
    
    NSString *dbPath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"MOA.sqlite"];
    BOOL success = [fileMgr fileExistsAtPath:dbPath];
    NSString * sqlString = [self getSQLQuery_Insert:tableName];
    const char* sql = [sqlString UTF8String];
    
    if(!success)
        NSLog(@"Cannot locate database file '%@'.", dbPath);
    
    if(!(sqlite3_open_v2([dbPath UTF8String], &cruddb,SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK))
        NSLog(@"An error has occured.");

    int rc;
    if ((rc =sqlite3_prepare_v2(cruddb, sql, -1, &stmt, NULL)) != SQLITE_OK){
        NSLog(@"%d", rc );
        NSLog(@"Error %s", sqlite3_errmsg(cruddb));
    };
    [self bindInsertSQLStatement:stmt :object :rowid :tableName];
   
    
    //sqlite3_trace(cruddb, sqliteCallbackFunc, NULL);
    if (sqlite3_step(stmt) != SQLITE_DONE)
        NSLog(@"Error %s", sqlite3_errmsg(cruddb));
    
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);
    
}

-(NSString*) getSQLQuery_CheckTable:(NSString*) tableName
{
    NSString* sqlString;
    if ([tableName isEqualToString:@"general_hours"] || [tableName isEqualToString:@"cafe_hours"]) {
        sqlString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(rowid INT, Day TEXT, Hours TEXT)", tableName];
    } else if ([tableName isEqualToString:@"rates_general"] || [tableName isEqualToString:@"rates_groups"]) {
        sqlString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(rowid INT, Description TEXT, Rates TEXT)", tableName];
    } else if ([tableName isEqualToString:@"parking_and_directions"]){
        sqlString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(rowid INT, Heading TEXT, Description TEXT)", tableName];
    } else if ([tableName isEqualToString:@"general_text"]){
        sqlString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(rowid INT, Identifier TEXT, Description TEXT)", tableName];
    } else {
        sqlString = [NSString stringWithFormat:@"Select *"];
    }
    return sqlString;
}

-(NSString*) getSQLQuery_Insert:(NSString*) tableName
{
    NSString* sqlString;
    if ([tableName isEqualToString:@"general_hours"] || [tableName isEqualToString:@"cafe_hours"]) {
        sqlString = [NSString stringWithFormat:@"INSERT INTO %@ (rowid, Day, Hours) VALUES (?,?,?)", tableName];
    } else if ([tableName isEqualToString:@"rates_general"] || [tableName isEqualToString:@"rates_groups"]) {
        sqlString = [NSString stringWithFormat:@"INSERT INTO %@ (rowid, Description, Rates) VALUES (?,?,?)", tableName];
    } else if ([tableName isEqualToString:@"parking_and_directions"]){
        sqlString = [NSString stringWithFormat:@"INSERT INTO %@ (rowid, Heading, Description) VALUES (?,?,?)", tableName];
    } else if ([tableName isEqualToString:@"general_text"]){
        sqlString = [NSString stringWithFormat:@"INSERT INTO %@ (rowid, Identifier, Description) VALUES (?,?,?)", tableName];
    } else {
        sqlString = [NSString stringWithFormat:@"Select *"];
    }
    return sqlString;
}


-(NSString*) getSQLQuery_Update:(NSString*) tableName
{
    NSString* sqlString;
    if ([tableName isEqualToString:@"general_hours"] || [tableName isEqualToString:@"cafe_hours"]) {
        sqlString = [NSString stringWithFormat:@"update %@ Set Day= ?, Hours=? Where rowid=?", tableName];
    } else if ([tableName isEqualToString:@"rates_general"] || [tableName isEqualToString:@"rates_groups"]) {
         sqlString = [NSString stringWithFormat:@"update %@ Set Description=?, Rate=? Where rowid=?", tableName];
    } else if ([tableName isEqualToString:@"parking_and_directions"]){
         sqlString = [NSString stringWithFormat:@"update %@ Set Heading=?, Description=? Where rowid=?", tableName];
    } else if ([tableName isEqualToString:@"general_text"]){
         sqlString = [NSString stringWithFormat:@"update %@ Set Identifier=?, Description=? Where rowid=?", tableName];
    } else {
        sqlString = [NSString stringWithFormat:@"Select *"];
    }
    return sqlString;
}

-(void) bindInsertSQLStatement:(sqlite3_stmt*)stmt :(NSMutableArray*)object :(int)rowid :(NSString*) tableName
{
    if ([tableName isEqualToString:@"general_hours"] || [tableName isEqualToString:@"cafe_hours"]) {
        [self bindInsertSQLStatement_Hours:stmt :object :rowid];
    } else if ([tableName isEqualToString:@"rates_general"] || [tableName isEqualToString:@"rates_groups"])
        [self bindInsertSQLStatement_Rates:stmt :object :rowid];
    else if ([tableName isEqualToString:@"parking_and_directions"]){
        [self bindInsertSQLStatement_Parking:stmt :object :rowid];
    } else if ([tableName isEqualToString:@"general_text"]){
        [self bindInsertSQLStatement_GeneralText:stmt :object :rowid];
    }
}

-(void) bindInsertSQLStatement_Hours:(sqlite3_stmt*)stmt :(NSMutableArray*)object :(int)rowid
{
    sqlite3_bind_int(stmt, 1, rowid);
    sqlite3_bind_text(stmt, 2, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Day"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 3, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Hours"]UTF8String], -1, SQLITE_TRANSIENT);
}

-(void) bindInsertSQLStatement_Rates:(sqlite3_stmt*)stmt :(NSMutableArray*)object :(int)rowid
{
    sqlite3_bind_int(stmt, 1, rowid);
    sqlite3_bind_text(stmt, 2, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Description"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 3, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Rates"]UTF8String], -1, SQLITE_TRANSIENT);
}

-(void) bindInsertSQLStatement_Parking:(sqlite3_stmt*)stmt :(NSMutableArray*)object :(int)rowid
{
    sqlite3_bind_int(stmt, 1, rowid);
    sqlite3_bind_text(stmt, 2, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Heading"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 3, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Description"]UTF8String], -1, SQLITE_TRANSIENT);
}

-(void) bindInsertSQLStatement_GeneralText:(sqlite3_stmt*)stmt :(NSMutableArray*)object :(int)rowid
{
    sqlite3_bind_int(stmt, 1, rowid);
    sqlite3_bind_text(stmt, 2, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Identifier"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 3, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Description"]UTF8String], -1, SQLITE_TRANSIENT);
}

-(void) bindUpdateSQLStatement:(sqlite3_stmt*)stmt :(NSMutableArray*)object :(int)rowid :(NSString*) tableName
{
    if ([tableName isEqualToString:@"general_hours"] || [tableName isEqualToString:@"cafe_hours"]) {
        [self bindUpdateSQLStatement_Hours:stmt :object :rowid];
    } else if ([tableName isEqualToString:@"rates_general"] || [tableName isEqualToString:@"rates_groups"])
        [self bindUpdateSQLStatement_Rates:stmt :object :rowid];
    else if ([tableName isEqualToString:@"parking_and_directions"]){
        [self bindUpdateSQLStatement_Parking:stmt :object :rowid];
    } else if ([tableName isEqualToString:@"general_text"]){
        [self bindUpdateSQLStatement_GeneralText:stmt :object :rowid];
    }
}

-(void) bindUpdateSQLStatement_Hours:(sqlite3_stmt*)stmt :(NSMutableArray*)object :(int)rowid
{
    sqlite3_bind_text(stmt, 1, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Day"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 2, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Hours"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 3, rowid);
}

-(void) bindUpdateSQLStatement_Rates:(sqlite3_stmt*)stmt :(NSMutableArray*)object :(int)rowid
{
    sqlite3_bind_text(stmt, 1, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Description"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 2, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Rate"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 3, rowid);
}

-(void) bindUpdateSQLStatement_Parking:(sqlite3_stmt*)stmt :(NSMutableArray*)object :(int)rowid
{
    sqlite3_bind_text(stmt, 1, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Heading"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 2, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Description"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 3, rowid);
}

-(void) bindUpdateSQLStatement_GeneralText:(sqlite3_stmt*)stmt :(NSMutableArray*)object :(int)rowid
{
    sqlite3_bind_text(stmt, 1, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Identifier"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 2, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Description"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 3, rowid);
}

-(void)checkReturnCode: (int)rc{
    if(rc != SQLITE_OK)
    {
        NSLog(@"Problem with prepare statement at PullFromLocalDB, rc = %d", rc);
        NSLog(@"%s SQLITE_ERROR '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
}

- (NSMutableArray *) PullFromLocalDB :(NSString*) tableName{
    
    
    NSMutableString *data1, *data2;
    NSMutableString *temp;
    NSMutableArray *returnedData = [[NSMutableArray alloc] init];
    @try {
        //NSFileManager *fileMgr = [NSFileManager defaultManager];
        
        // check if the documents has file or not
        NSError *error;
        NSString *dbPath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"MOA.sqlite"];
        if (![fileMgr fileExistsAtPath:dbPath]) {
            //dbPath = [[NSBundle mainBundle] pathForResource:@"MOA"ofType:@"sqlite"];
            [self CopyDbToDocumentsFolder];
            //NSLog(@"%@", @"File not found, using bundle");
        } else {
            // compare the dates of sqlite files
            NSDictionary *dbInSimulatorDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:dbPath error:&error];
            NSDate *simulatorDBDate =[dbInSimulatorDictionary objectForKey:NSFileModificationDate];
            NSString *bundleDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MOA.sqlite"];
            NSDictionary *bundleDBDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:bundleDBPath error:&error];
            NSDate *bundleDBDate = [bundleDBDictionary objectForKey:NSFileModificationDate];
            // if the local DB on the phone
            // is older than the one in the program
            if ([simulatorDBDate compare:bundleDBDate] == NSOrderedAscending) {
            //NSLog(@"SQLite in Document is earlier than SQLite in Bundle. Replacing . . .");
            [[NSFileManager defaultManager] removeItemAtPath: dbPath error: &error];
            [self CopyDbToDocumentsFolder];
        }
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
            saveDataInDefaultFormat = 0;
        } else if ([tableName isEqualToString:@"general_hours"]){
            sql = "SELECT Day, Hours FROM general_hours";
            saveDataInDefaultFormat = 1;
        } else if ([tableName isEqualToString:@"parking_and_directions"]) {
            sql = "SELECT Heading, Description FROM parking_and_directions";
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
