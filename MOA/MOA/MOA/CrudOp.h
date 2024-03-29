//
//  CrudOp.h
//  MOA
//
//  Created by Diana Sutandie on 1/21/2014.
//  Copyright (c) 2014 Museum of Anthropology UBC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface CrudOp : NSObject{
    NSInteger dataId;
    NSString *coltext;
    NSInteger colint;
    double coldbl;
    sqlite3 *db;
    NSFileManager *fileMgr;
    NSString *homeDir;
    NSString *title;
}
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *coltext;
@property (nonatomic,retain) NSString *homeDir;
@property (nonatomic, assign) NSInteger dataId;
@property (nonatomic,assign) NSInteger colint;
@property (nonatomic, assign) double coldbl;
@property (nonatomic,retain) NSFileManager *fileMgr;

-(void)CopyDbToDocumentsFolder;
-(NSString *) GetDocumentDirectory;
-(void)CopyDbToTemporaryFolder;

-(void)InsertRecords:(NSMutableString *)txt :(NSMutableString*)txt2;
-(void)UpdateRecords:(NSString *)txt :(NSMutableString *) utxt :(int)indx :(NSString *)type;
-(void)DeleteRecords:(NSString *)txt;
-(NSMutableArray*) PullFromLocalDB:(NSString*) tableName;



@end
