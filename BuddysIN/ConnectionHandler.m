

#import "ConnectionHandler.h"
#import "JSON.h"
#import "AppDelegate.h"
#import <AdSupport/ASIdentifierManager.h>
#import "AFJSONRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFHTTPClient.h"
#import "Constant.h"
#import "BuddysINUtil.h"

@implementation ConnectionHandler

@synthesize delegate;


+ (ConnectionHandler *)sharedInstance
{
    // the instance of this class is stored here
    static ConnectionHandler *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        myInstance.baseUrl = [NSURL URLWithString:kServerURL];
    }
    // return the instance of this class
    return myInstance;
}

-(BOOL)hasConnectivity {
    
    //Reachability * reach = [Reachability reachabilityWithHostName:kServerURL];
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus  status = [reach currentReachabilityStatus ];
    
   // NSLog(@"hasConnectivity: %u",status);
    if( status == ReachableViaWiFi )
    {
        return YES;
    }
    else if(status == ReachableViaWWAN)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - AFNetwork

-(void)makePOSTRequestPath:(NSString *)path parameters:(NSDictionary *)parameters
{
   // NSLog(@"parameters: %@",parameters);
    
    if (![self hasConnectivity]) {
        [BuddysINUtil showAlertWithTitle:@"No Connectivity" message:@"Please check the Internet Connnection"];
        return;
    }
    
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [appDelegate.httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    [appDelegate.httpClient setDefaultHeader:@"Accept" value:@"text/json"];
    [appDelegate.httpClient setDefaultHeader:@"Accept" value:@"text/html"];
    [appDelegate.httpClient setDefaultHeader:@"Content-type" value:@"application/json"];

    [appDelegate.httpClient setParameterEncoding:AFFormURLParameterEncoding];
    
    [appDelegate.httpClient postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
         
      /*   if (operation.response.statusCode == 200) {//able to get results here */
             NSString *responseString = [operation responseString]; //[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             //NSLog(@"Request Successful, response '%@'", responseString);
 
         NSError *error;
         NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData: [responseString dataUsingEncoding:NSUTF8StringEncoding]
                                                                      options: NSJSONReadingMutableContainers
                                                                        error: &error];
         
             if ([path isEqualToString:kRegistrationURL]) {
                 
                 NSDictionary *usersdict = [responseDict objectForKey:@"fbc"];
                 NSInteger statusInt = [[usersdict objectForKey:@"status"] integerValue]; // 1 = INSERTED, 2= UPDATED

                // NSLog(@"Request Successful, RegistrationURL response '%@'", responseString);
                [self.delegate connHandlerClient:self didSucceedWithResponseStatus:statusInt];
             }
             else if ([path isEqualToString:kNearByUserURL]) {
             
             // NSLog(@"Request Successful, kNearByUserURL response '%@'", responseString);
             [self.delegate connHandlerClient:self didSucceedWithResponseString:responseString forPath:kNearByUserURL];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"[HTTPClient Error]: %@", error);
         [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
         
         //delegate
         [self.delegate connHandlerClient:self didFailWithError:error];
         
     }];
    
}

//-(void)makePOSTVideoShareAtPath:(NSURL *)path parameters:(NSDictionary *)parameters {
//    
//    if (![self hasConnectivity]) {
//        [BuddysINUtil showAlertWithTitle:@"No Connectivity" message:@"Please check the Internet Connnection"];
//        return;
//    }
//    
//    NSData *videoData = [NSData dataWithContentsOfURL:path];
//    UIImage *imageObj = [self generateThumbImage:path];
//    NSData *imageData = UIImagePNGRepresentation(imageObj);
//
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//
//    [appDelegate.httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
//    [appDelegate.httpClient setDefaultHeader:@"Accept" value:@"application/json"];
//    [appDelegate.httpClient setDefaultHeader:@"Accept" value:@"text/json"];
//    [appDelegate.httpClient setDefaultHeader:@"Accept" value:@"text/html"];
//    [appDelegate.httpClient setDefaultHeader:@"Content-type" value:@"application/json"];
//    [appDelegate.httpClient setParameterEncoding:AFFormURLParameterEncoding];
//
//    NSMutableURLRequest *afRequest = [appDelegate.httpClient multipartFormRequestWithMethod:@"POST" path:kShareVideoURL parameters:parameters constructingBodyWithBlock:^(id <AFMultipartFormData>formData)
//                                      {
//                                          [formData appendPartWithFileData:videoData name:kShareFILE fileName:@"filename.mov" mimeType:@"video/quicktime"];
//                                          [formData appendPartWithFileData:imageData name:kShareThumbnailFILE fileName:@"thumbnail" mimeType:@"image/png"];
//                                      }];
//    
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:afRequest];
//    
//    [operation setUploadProgressBlock:^(NSInteger bytesWritten,NSInteger totalBytesWritten,NSInteger totalBytesExpectedToWrite)
//     {
//         NSLog(@"Sent %lld of %lld bytes", (long long int)totalBytesWritten,(long long int)totalBytesExpectedToWrite);
//     }];
//    
//    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
//        NSString *responseString = [operation responseString];
//       // if ([path isEqualToString:kShareVideoURL]) {
//           // NSLog(@"Request Successful, ShareVideo response '%@'", responseString);
//            [self parseShareVideoResponse:responseString fromURL:kShareVideoURL ];
//       // }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
//    {
//        NSLog(@"[AFHTTPRequestOperation Error]: %@", error);
//        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
//        //delegate
//        [self.delegate connHandlerClient:self didFailWithError:error];
//    }];
//    
//    [operation start];
//    
//}

-(UIImage *)generateThumbImage : (NSURL *)url
{
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    imageGenerator.maximumSize = CGSizeMake(320.0f,320.0f);
    CMTime time = [asset duration];
    time.value = 0001;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:thumbnail];
    imageView.frame = CGRectMake(0,0,320,320);
    return imageView.image;
}

#pragma mark - Parse data


-(void)parseVideoUploadResponse:(NSString *)responseString fromURL:(NSString *)urlPath{
    NSLog(@"parseVideoUploadResponse : %@ for URL:%@",responseString,urlPath);
    
    [self.delegate connHandlerClient:self didSucceedWithResponseString:responseString forPath:urlPath];
}

-(void)parseShareVideoResponse:(NSString *)responseString fromURL:(NSString *)urlPath{
       NSLog(@"parseShareVideoResponse : %@ for URL:%@",responseString,urlPath);
    
    [self.delegate connHandlerClient:self didSucceedWithResponseString:responseString forPath:urlPath];
}

-(void)parseNearByBuddysResponse:(NSString *)responseString fromURL:(NSString *)urlPath{
    NSLog(@"parseShareVideoResponse : %@ for URL:%@",responseString,urlPath);
    
    [self.delegate connHandlerClient:self didSucceedWithResponseString:responseString forPath:urlPath];
}


@end
