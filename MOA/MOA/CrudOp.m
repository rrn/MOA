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
    
    // this function copies the Database file from project resource directory
    // into Documents folder in iPhone.
    // the reason we need this: database file in resource bundle is read-only
    // we need to update data in local file, thus we need to use writable Documents folder
    
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

-(void)doesTableExist:(NSString*)tableName {
    
    // this function open database connection
    // and checks if the specified table exists in the database
    // by using CREATE IF NO EXIST (...) syntax
    // case 1: table exist - in this case, it will do nothing
    // case 2: table does not exists - it will create the table
    
    // Some debugging hint that may help when we got to "CrudOp::doesTableExist error":
    // 1. Did you modify the code? Does it still have the sqlite3_open and close?
    // 2. Did you specify the right tableName? Table name has to be exactly the same as it is in db.
    // 3. Print return code from sqlite3_prepare_v2 and call [self checkReturncode:rc]
    
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
            NSLog(@"CrudOp::doesTableExist error"); // see documentation on the beginning of function
        }
    }
    
    char* errmsg;
    //sqlite3_trace(cruddb, sqliteCallbackFunc, NULL); // uncomment this for trace
    sqlite3_exec(cruddb, "COMMIT", NULL, NULL, &errmsg);
    if(SQLITE_DONE != sqlite3_step(stmt)){
        NSLog(@"Error while updating. %s", sqlite3_errmsg(cruddb));
    }
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);
    
}

-(void)UpdateLocalDB:(NSString*)tableName :(NSMutableArray*)object {
    
    // This function updates the data in local database.
    // It will check if the specified table exist, and update each rows of the table
    // with new information. Any new information will be inserted to the local database.
    
    NSString *dbPath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"MOA.sqlite"];
    [self isFileValid:dbPath];

    [self doesTableExist:tableName];
    for (int i = 1; i <= [object count]; i++){
        if ([self doesRowExists:tableName :i] == true){
            [self UpdateTable:object :tableName :i];
        } else {
            [self InsertToTable:object :tableName :i];
        }
    }
    
}

-(void)isFileValid :(NSString*)filePath
{
    
    // this function checks if the local database in Documents folder in iPhone is valid or not
    // the validity is checked towards the database in resource bundle.
    // The database file in resource bundle should not be changed, but this function is needed for
    // extra security check.
    // If the local DB file in iPhone is older than the file in resource bundle (last modified date),
    // the file will be erased
    // and replaced with the one from resource bundle. Otherwise, it is still valid.
    
    NSError *error;
    if (![fileMgr fileExistsAtPath:filePath]) {
        [self CopyDbToDocumentsFolder];
    } else {
        
        // compare the dates of sqlite files
        NSDictionary *dbInSimulatorDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
        NSDate *simulatorDBDate =[dbInSimulatorDictionary objectForKey:NSFileModificationDate];
        NSString *bundleDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MOA.sqlite"];
        NSDictionary *bundleDBDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:bundleDBPath error:&error];
        NSDate *bundleDBDate = [bundleDBDictionary objectForKey:NSFileModificationDate];
        
        // if the local DB on the phone is older than the one in resource bundle
        if ([simulatorDBDate compare:bundleDBDate] == NSOrderedAscending) {
            [[NSFileManager defaultManager] removeItemAtPath: filePath error: &error];
            [self CopyDbToDocumentsFolder];
        }
    }
}

- (NSMutableArray *) PullFromLocalDB :(NSString*) tableName{
    
    // this function will pull all the data from the specified table in localDB
    // data will be returned in an array of dictionary
    
    NSMutableArray *returnedData = [[NSMutableArray alloc] init];
    
    @try {
        NSString *dbPath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"MOA.sqlite"];
        [self isFileValid:dbPath];
        
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        if(!(sqlite3_open_v2([dbPath UTF8String], &db,SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
        NSString* sqlString = [self getSQLQuery_Select:tableName];
        const char *sql = [sqlString UTF8String];
        
        sqlite3_stmt *sqlStatement;
        int rc = sqlite3_prepare(db, sql, -1, &sqlStatement, NULL);
        [self checkReturnCode:rc];
        
        [self loadDataForTable:sqlStatement :tableName :returnedData];
        
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return returnedData;
    }
}

-(BOOL)doesRowExists:(NSString*) tableName :(int) rowid{
    
    // this function checks if a row with specified rowid exists in tableName table.
    // returns a boolean value
    
    // If you encounter "CrudOp::doesRowExist error", consider these debugging hints:
    // 1. Did you modify the code? Does it still have the sqlite3_open and close?
    // 2. Did you specify the right tableName? Table name has to be exactly the same as it is in db.
    // 3. Print return code from sqlite3_prepare_v2 and call [self checkReturncode:rc]
    
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
            NSLog(@"CrudOp::doesRowExist error");
            [self checkReturnCode:rc]; // refer to docs on the beginning of this function
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
    // this function will update a row with specified rowid in specified tableName
    // with information stored in object.
    // object must be an array of dictionaries.
    
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb;
    
    NSString *crudddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"/MOA.sqlite"];
    const char *dbpath = [crudddatabase UTF8String];
    NSString * sqlString = [self getSQLQuery_Update:tableName];
    const char* sql = [sqlString UTF8String];
    
    if(sqlite3_open(dbpath, &cruddb) == SQLITE_OK)
    {
        if(sqlite3_prepare_v2(cruddb, sql, 267, &stmt, NULL)==SQLITE_OK){
            [self bindUpdateSQLStatement:stmt :object :rowid :tableName];
        }
    }
    
    char* errmsg;
    //sqlite3_trace(cruddb, sqliteCallbackFunc, NULL); // uncomment this for trace
    sqlite3_exec(cruddb, "COMMIT", NULL, NULL, &errmsg);
    
    if(SQLITE_DONE != sqlite3_step(stmt)){
        NSLog(@"Error while updating. %s", sqlite3_errmsg(cruddb));
    }
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);

}

-(void)InsertToTable:(NSMutableArray*)object :(NSString*)tableName :(int)rowid
{
    // this function will insert new row with specified rowid in specified tableName
    // with information stored in object.
    // object must be an array of dictionaries.
    
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
   
    //sqlite3_trace(cruddb, sqliteCallbackFunc, NULL); // uncomment this code to print queries
    if (sqlite3_step(stmt) != SQLITE_DONE)
        NSLog(@"Error %s", sqlite3_errmsg(cruddb));
    
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);
    
}

-(NSString*) getSQLQuery_CheckTable:(NSString*) tableName
{
    // Given the table name, this function returns the associated SQLQuery for checking whether
    // the table exist in local database
    //
    // Note: a query for a table that has same column names with other tables can be reused
    // for more than one table.
    
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

-(NSString*) getSQLQuery_Select:(NSString*) tableName
{
    // Given the table name, this function returns the associated SQLQuery for
    // selecting all information from that table.
    //
    // Note: a query for a table that has same column names with other tables can be reused
    // for more than one table.
    
    NSString* sqlString;
    if ([tableName isEqualToString:@"general_hours"] || [tableName isEqualToString:@"cafe_hours"]) {
        sqlString = [NSString stringWithFormat:@"SELECT Day, Hours FROM %@", tableName];
    } else if([tableName isEqualToString:@"rates_general"] ||[tableName isEqualToString:@"rates_groups"]){
        sqlString = [NSString stringWithFormat:@"SELECT Description, Rate FROM %@", tableName];
    } else if ([tableName isEqualToString:@"parking_and_directions"]){
        sqlString = [NSString stringWithFormat:@"SELECT Heading, Description FROM %@", tableName];
    } else if ([tableName isEqualToString:@"general_text"]){
        sqlString = [NSString stringWithFormat:@"SELECT Identifier, Description FROM %@", tableName];
    } else {
        sqlString = [NSString stringWithFormat:@"Select *"];
    }
    return sqlString;
}

-(NSString*) getSQLQuery_Insert:(NSString*) tableName
{
    // Given the table name, this function returns the associated SQLQuery for
    // inserting new information into that table.
    //
    // Note: a query for a table that has same column names with other tables can be reused
    // for more than one table.
    
    
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
    
    // Given the table name, this function returns the associated SQLQuery for
    // updating certain information from that table.
    //
    // Note: a query for a table that has same column names with other tables can be reused
    // for more than one table.
    
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
    
    // this function determines the right sql INSERT binding statement for given tablename
    // Note: binding function can be reused for more than one table as long as they have same column names
    
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
    // this function contains the code for sql INSERT binding statement for Hours table
    // Note: binding function can be reused for more than one table as long as they have same column names
    
    sqlite3_bind_int(stmt, 1, rowid);
    sqlite3_bind_text(stmt, 2, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Day"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 3, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Hours"]UTF8String], -1, SQLITE_TRANSIENT);
}

-(void) bindInsertSQLStatement_Rates:(sqlite3_stmt*)stmt :(NSMutableArray*)object :(int)rowid
{
    // this function contains the code for sql INSERT binding statement for Rates table
    // Note: binding function can be reused for more than one table as long as they have same column names
    
    sqlite3_bind_int(stmt, 1, rowid);
    sqlite3_bind_text(stmt, 2, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Description"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 3, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Rates"]UTF8String], -1, SQLITE_TRANSIENT);
}

-(void) bindInsertSQLStatement_Parking:(sqlite3_stmt*)stmt :(NSMutableArray*)object :(int)rowid
{
    // this function contains the code for sql INSERT binding statement for Parking table
    // Note: binding function can be reused for more than one table as long as they have same column names
    
    sqlite3_bind_int(stmt, 1, rowid);
    sqlite3_bind_text(stmt, 2, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Heading"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 3, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Description"]UTF8String], -1, SQLITE_TRANSIENT);
}

-(void) bindInsertSQLStatement_GeneralText:(sqlite3_stmt*)stmt :(NSMutableArray*)object :(int)rowid
{
    // this function contains the code for sql INSERT binding statement for Rates table
    // Note: binding function can be reused for more than one table as long as they have same column names
    
    sqlite3_bind_int(stmt, 1, rowid);
    sqlite3_bind_text(stmt, 2, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Identifier"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 3, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Description"]UTF8String], -1, SQLITE_TRANSIENT);
}

-(void) bindUpdateSQLStatement:(sqlite3_stmt*)stmt :(NSMutableArray*)object :(int)rowid :(NSString*) tableName
{
    // this function determines the right sql UPDATE binding statement for given tablename
    // Note: binding function can be reused for more than one table as long as they have same column names
    
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
    // this function contains the code for sql UPDATE binding statement for Hours table
    // Note: binding function can be reused for more than one table as long as they have same column names
    
    sqlite3_bind_text(stmt, 1, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Day"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 2, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Hours"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 3, rowid);
}

-(void) bindUpdateSQLStatement_Rates:(sqlite3_stmt*)stmt :(NSMutableArray*)object :(int)rowid
{
    
    // this function contains the code for sql UPDATE binding statement for Rates table
    // Note: binding function can be reused for more than one table as long as they have same column names
    
    sqlite3_bind_text(stmt, 1, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Description"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 2, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Rate"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 3, rowid);
}

-(void) bindUpdateSQLStatement_Parking:(sqlite3_stmt*)stmt :(NSMutableArray*)object :(int)rowid
{
    
    // this function contains the code for sql UPDATE binding statement for Parking table
    // Note: binding function can be reused for more than one table as long as they have same column names
    
    sqlite3_bind_text(stmt, 1, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Heading"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 2, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Description"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 3, rowid);
}

-(void) bindUpdateSQLStatement_GeneralText:(sqlite3_stmt*)stmt :(NSMutableArray*)object :(int)rowid
{
    // this function contains the code for sql UPDATE binding statement for GeneralText table
    // Note: binding function can be reused for more than one table as long as they have same column names
    
    sqlite3_bind_text(stmt, 1, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Identifier"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 2, [[(NSDictionary*)[object objectAtIndex:rowid-1] objectForKey:@"Description"]UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 3, rowid);
}

-(void)checkReturnCode: (int)rc{
    if(rc != SQLITE_OK)
    {
        NSLog(@"Problem with prepare statement at CrudOp, rc = %d", rc);
        NSLog(@"%s SQLITE_ERROR '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
}


-(void)loadDataForTable:(sqlite3_stmt*) sqlStatement :(NSString*)tableName :(NSMutableArray*)data
{
    // this function determines the right sql query for SELECTING data from a given table name
    // Note: sql query can be reused for more than one table as long as they have same column names
    
    if ([tableName isEqualToString:@"general_hours"] || [tableName isEqualToString:@"cafe_hours"]) {
        [self loadData_Hours:sqlStatement :data];
    } else if ([tableName isEqualToString:@"rates_general"] || [tableName isEqualToString:@"rates_groups"])
        [self loadData_Rates:sqlStatement :data];
    else if ([tableName isEqualToString:@"parking_and_directions"]){
        [self loadData_Parking:sqlStatement :data];
    } else if ([tableName isEqualToString:@"general_text"]){
        [self loadData_GeneralText:sqlStatement :data];
    }
}

-(void)loadData_Hours:(sqlite3_stmt*) sqlStatement :(NSMutableArray*)data
{
    // this function contains the right sql query for SELECTING data from Hours table
    // all data will be stored into NSMutableArray data array in the form of array of dictionaries.
    // Note: sql query can be reused for more than one table as long as they have same column names
    
    while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSMutableString stringWithString:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,0)]] forKey:@"Day"];
        [dict setObject:[NSMutableString stringWithString:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)]] forKey:@"Hours"];
        
        [data addObject:dict];
    }
}

-(void)loadData_Rates:(sqlite3_stmt*) sqlStatement :(NSMutableArray*)data
{
    // this function contains the right sql query for SELECTING data from Rates table
    // all data will be stored into NSMutableArray data array in the form of array of dictionaries.
    // Note: sql query can be reused for more than one table as long as they have same column names
    
    while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSMutableString stringWithString:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,0)]] forKey:@"Description"];
        [dict setObject:[NSMutableString stringWithString:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)]] forKey:@"Rate"];
        
        [data addObject:dict];
    }
}

-(void)loadData_Parking:(sqlite3_stmt*) sqlStatement :(NSMutableArray*)data
{
    // this function contains the right sql query for SELECTING data from Parking table
    // all data will be stored into NSMutableArray data array in the form of array of dictionaries.
    // Note: sql query can be reused for more than one table as long as they have same column names
    
    while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSMutableString stringWithString:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,0)]] forKey:@"Heading"];
        [dict setObject:[NSMutableString stringWithString:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)]] forKey:@"Description"];
        
        [data addObject:dict];
    }
}

-(void)loadData_GeneralText:(sqlite3_stmt*) sqlStatement :(NSMutableArray*)data
{
    // this function contains the right sql query for SELECTING data from General Text table
    // all data will be stored into NSMutableArray data array in the form of array of dictionaries.
    // Note: sql query can be reused for more than one table as long as they have same column names
    
    while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSMutableString stringWithString:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,0)]] forKey:@"Identifier"];
        [dict setObject:[NSMutableString stringWithString:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)]] forKey:@"Description"];
        
        [data addObject:dict];
    }
}



@end
