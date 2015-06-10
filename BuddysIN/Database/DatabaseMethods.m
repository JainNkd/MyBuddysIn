
#import "DatabaseMethods.h"
#import "Constant.h"
#import "Member.h"

#import <sqlite3.h>

@implementation DatabaseMethods

//Basic Methods
-(BOOL)openDataBase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath=  [documentsDirectory stringByAppendingPathComponent:kDatabaseName];
    
    sqlite3 *database; //Declare a pointer to sqlite database structure
    const char *dbpath = [databasePath UTF8String]; // Convert NSString to UTF-8
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        //Database opened successfully
        return YES;
    } else {
        //Failed to open database
        return NO;
    }
    return NO;
}


-(BOOL)updateDatabase:(const char *)queryStr
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath=  [documentsDirectory stringByAppendingPathComponent:kDatabaseName];
    
    BOOL success = '\0';
    sqlite3 *database;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, queryStr, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            if(SQLITE_DONE != sqlite3_step(compiledStatement))
            {
                NSLog( @"Error while updating data: '%s'", sqlite3_errmsg(database));
                success=FALSE;
            }
            else
            {
                NSLog(@"Data updated");
                success = TRUE;
            }
            sqlite3_reset(compiledStatement);
        }else
        {
            NSLog( @"Error while updating '%s'", sqlite3_errmsg(database));
            success = FALSE;
        }
        sqlite3_finalize(compiledStatement);
        
    }
    sqlite3_close(database);
    
    return success;
}

-(NSString *)getOutputStringForQuery:(const char *)queryString{
    // Setup the database object
    sqlite3 *database;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath=  [documentsDirectory stringByAppendingPathComponent:kDatabaseName];
    
    // Init the animals Array
    NSString *outputString = @"";
    
    // Open the database from the users filessytem
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        // Setup the SQL Statement and compile it for faster access
        //const char *sqlStatement = "select * from States";
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, queryString, -1, &compiledStatement, NULL) == SQLITE_OK) {
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                // Read the data from the result row
                
                outputString = [NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(compiledStatement, 0)];
            }
        }
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
        
    }
    sqlite3_close(database);
    
    return outputString;
    
}

-(NSInteger)getOutputIntForQuery:(const char *)queryString{
    // Setup the database object
    sqlite3 *database;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath=  [documentsDirectory stringByAppendingPathComponent:kDatabaseName];
    
    NSInteger outPutInt = 0;
    
    // Open the database from the users filessytem
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        // Setup the SQL Statement and compile it for faster access
        //const char *sqlStatement = "select * from States";
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, queryString, -1, &compiledStatement, NULL) == SQLITE_OK) {
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                // Read the data from the result row
                
                outPutInt = sqlite3_column_int(compiledStatement, 0);
                
            }
        }
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
        
    }
    sqlite3_close(database);
    
    return outPutInt;
    
}

//Fetch All Buddys Records
+(NSMutableArray *)getAllBuddysRecords{
    NSLog(@"getAllBuddysRecords");
    
    // Setup the database object
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath=  [documentsDirectory stringByAppendingPathComponent:kDatabaseName];
    
    NSMutableArray *shareRecordsArr = [[NSMutableArray alloc] init];
    
    // Open the database from the users filessytem
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        // Setup the SQL Statement and compile it for faster access
        NSString *quertyStr = @"SELECT id,mid,data_type,content,image,video,video_thumb,created,distance,name,email FROM shares";
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, [quertyStr UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                // Read the data from the result row
                Share *shareObj = [Share new];
                
                shareObj.shareID = [NSString stringWithFormat:@"%lld",sqlite3_column_int64(compiledStatement, 0)];
                shareObj.mid = [NSString stringWithFormat:@"%lld",sqlite3_column_int64(compiledStatement, 1)];
                shareObj.dataType = [NSString stringWithFormat:@"%lld",sqlite3_column_int64(compiledStatement, 2)];
                
                
                shareObj.content = [NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(compiledStatement, 3)];
                shareObj.imageName = [NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(compiledStatement, 4)];
                shareObj.videoName = [NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(compiledStatement, 5)];
                shareObj.videoThumbnailName = [NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(compiledStatement, 6)];
                shareObj.createTime = [NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(compiledStatement, 7)];
                shareObj.distance = [NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(compiledStatement, 8)];
                
                Member *memberObj = [Member new];
                
                memberObj.name = [NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(compiledStatement, 9)];
                memberObj.email = [NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(compiledStatement, 10)];
                
                
                if (!memberObj.name)
                    memberObj.name = @"";
                if (!shareObj.content)
                    shareObj.content = @"";
                
                shareObj.imageURL = [NSString stringWithFormat:kShareImageURL,shareObj.mid,shareObj.imageName];
                shareObj.videoThumbnailURL = [NSString stringWithFormat:kShareVideoThumbnailURL,shareObj.mid,shareObj.videoThumbnailName];
                shareObj.videoURL = [NSString stringWithFormat:kShareVideoURL,shareObj.mid,shareObj.videoName];

                shareObj.memberDetail = memberObj;
                
                [shareRecordsArr addObject:shareObj];
            }
        }
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    return shareRecordsArr;
}

//Check buddys Record exist in DB
+(BOOL)checkIfBuddysRecordExists:(NSInteger)shareId {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath=  [documentsDirectory stringByAppendingPathComponent:kDatabaseName];
    
    BOOL isVideoExist = NO;
    sqlite3 *database;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        sqlite3_stmt    *compiledstatement;
        NSString *quertyStrGetFav = [NSString stringWithFormat:@"SELECT id FROM shares WHERE id = '%ld'",(long)shareId];
        const char *quertyGetFav = [quertyStrGetFav UTF8String];
        if(sqlite3_prepare_v2(database, quertyGetFav, -1, &compiledstatement, NULL) == SQLITE_OK) {
            while(sqlite3_step(compiledstatement) == SQLITE_ROW) {
                isVideoExist = YES;
            }
        }
        sqlite3_finalize(compiledstatement);
    }
    sqlite3_close(database);
    
    return isVideoExist;
}

//Insert buddys record in database

+(void)insertBuddysInfoInDB:(Share *)sharObj {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath=  [documentsDirectory stringByAppendingPathComponent:kDatabaseName];
    
    sqlite3 *database;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        sqlite3_stmt    *statement;
        NSString *querySQL = @"INSERT INTO shares (id,mid,data_type,content,image,video,video_thumb,created,distance,name,email) VALUES (?,?,?,?,?,?,?,?,?,?,?); ";
        NSLog(@"query: %@", querySQL);
        const char *query_stmt = [querySQL UTF8String];
        
        // preparing a query compiles the query so it can be re-used.
        if(sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_int64(statement, 1, [sharObj.shareID integerValue]);
            sqlite3_bind_int64(statement, 2, [sharObj.mid integerValue]);
            sqlite3_bind_int64(statement, 3, [sharObj.dataType integerValue]);
            
            sqlite3_bind_text(statement, 4, [sharObj.content UTF8String], -1, SQLITE_STATIC);
            sqlite3_bind_text(statement, 5, [sharObj.imageName UTF8String], -1, SQLITE_STATIC);
            sqlite3_bind_text(statement, 6, [sharObj.videoName UTF8String], -1, SQLITE_STATIC);
            sqlite3_bind_text(statement, 7, [sharObj.videoThumbnailName UTF8String], -1, SQLITE_STATIC);
            sqlite3_bind_text(statement, 8, [sharObj.createTime UTF8String], -1, SQLITE_STATIC);
            sqlite3_bind_text(statement, 9, [sharObj.distance UTF8String], -1, SQLITE_STATIC);
            sqlite3_bind_text(statement, 10, [sharObj.memberDetail.name UTF8String], -1, SQLITE_STATIC);
            sqlite3_bind_text(statement, 11, [sharObj.memberDetail.email UTF8String], -1, SQLITE_STATIC);
            
            if(SQLITE_DONE != sqlite3_step(statement))
            {
                NSLog( @"Error while inserting chatObj: '%s'", sqlite3_errmsg(database));
            }
            else
            {
                // NSLog(@"chatObj with ID: %ld inserted: ",(long)chatObj.chatId);
            }
            sqlite3_reset(statement);
        }else
        {
            NSLog( @"Error while inserting chatObj '%s'", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
        
    }
    sqlite3_close(database);
    
}


@end
