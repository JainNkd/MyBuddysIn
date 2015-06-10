
#import <Foundation/Foundation.h>
#import "Share.h"


@interface DatabaseMethods : NSObject

-(BOOL)openDataBase;
-(BOOL)updateDatabase:(const char *)queryStr;
-(NSString *)getOutputStringForQuery:(const char *)queryString;
-(NSInteger)getOutputIntForQuery:(const char *)queryString;

+(NSMutableArray *)getAllBuddysRecords;
+(BOOL)checkIfBuddysRecordExists:(NSInteger)shareId;
+(void)insertBuddysInfoInDB:(Share *)sharObj;

//-(Account *)getAccountInfo;
//-(Account *)getUserDeviceTokenANDLastLogin;
//-(NSInteger)getMyUserID ;
//-(long long int)getMyPhoneNumber ;
//-(BOOL)checkIfContactExists:(long long int)contactNum;
//
//-(NSMutableArray *)getChatHistoryForUser:(long long int)userPhone ;
//-(NSMutableArray *)getAllLukChatContacts;
//-(NSMutableArray *)getAllOtherContacts;
//+(NSMutableArray *)getAllSentVideoContacts;
//
//-(void)insertAccountInfoToDB:(Account *)accountObj ;
//-(void)updateAccountInfoToDB:(Account *)accountObj;
//-(void)updateMyPhoneNumberInDB:(long long int)phoneNum;
//-(void)insertChatInfoToDB:(Chat *)chatObj;
//-(void)insertContactInfoToDB:(Contact *)contactObj;
//-(void)updateContactInfoToDB:(Contact *)contactObj;
//
//-(void)insertCreatedVideoInfoInDB:(Chat *)chatObj;
//+(NSMutableArray *)getAllCreatedVideos;
//+(NSString*)getVideoLocalURL:(NSString*)videoID;
//
//+(NSMutableArray *)getAllHistoryVideos;
//+(void)insertHistoryVideoInfoInDB:(VideoDetail *)videoDetailObj;
//+(BOOL)checkIfHistoryVideoExists:(NSInteger)videoId;
//
//+(void)insertSingleVideosInfoInDB:(Chat *)chatObj;
//+(NSMutableArray *)getAllSingleVideos:(NSInteger)count;
//+(void)deleteRecordFromDB:(NSInteger)videoID;
@end
