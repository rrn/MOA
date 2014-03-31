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
    sqlite3 *db;
    NSFileManager *fileMgr;
    NSString *homeDir;
}

-(void)CopyDbToDocumentsFolder;
-(NSString *) GetDocumentDirectory;
-(NSMutableArray*) PullFromLocalDB:(NSString*) tableName;
-(void)UpdateLocalDB:(NSString*)tableName :(NSMutableArray*)object;
-(void)doesTableExist:(NSString*)tableName;

-(void) updateImagePath:(NSString*)tableName :(NSString*)attributeName :(NSString*)path :(int)rowid;
-(NSString*) getImagePath:(NSString*)tableName :(NSString*)attributeName :(int)rowid;
-(void) updateImageToLocalDB:(NSString*)tableName :(NSString*)attributeName :(NSString*)imageURL :(int)index;
-(UIImageView*) loadImageFromDB:(NSString*)tableName :(NSString*)attributeName :(int)index;


@end
