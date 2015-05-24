//
//  ViewController.m
//  BuddysIN
//
//  Created by Naveen on 24/05/15.
//  Copyright (c) 2015 Naveen Kumar Dungarwal. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    BOOL isNeedToLogin;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set Delegate and facebook Permission
    self.loginButton.delegate = self;
    self.loginButton.readPermissions = @[@"public_profile",@"email",@"user_friends"];
    
    //Set login button image
    [self.loginButton addSubview:self.fbButton];
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - FBLoginView Delegate method implementation

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    NSLog(@"You are logged in.");
    isNeedToLogin = TRUE;
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    NSLog(@"User Details %@", user);
    
    NSString *fbId = user.objectID;
    NSString *email = [user objectForKey:@"email"];
    NSString *name = user.first_name;
    NSString *thumbnailUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",fbId];
    
    NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    NSLog(@"fbAccessToken..%@",fbAccessToken);
    
    //Set user facebook facebook details
//    [[NSUserDefaults standardUserDefaults]setValue:email forKey:kUSER_EMAIL];
//    [[NSUserDefaults standardUserDefaults]setValue:fbId forKey:kUSER_FB_ID];
//    [[NSUserDefaults standardUserDefaults]setValue:name forKey:kUSER_NAME];
//    [[NSUserDefaults standardUserDefaults]setValue:thumbnailUrl forKey:kUSER_PROFILE_URL];
//    [[NSUserDefaults standardUserDefaults]setValue:fbAccessToken forKey:kUSER_ACCESS_TOKEN];
//    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSDictionary *loginDict = [[NSDictionary alloc]initWithObjectsAndKeys:email,@"email",fbAccessToken,@"fb_oAuth_Token",fbId,@"fb_id",name,@"name",thumbnailUrl,@"thumb_url",nil];
    
    //    For local
    //        if(isNeedToLogin)
    //        {
    //            [SharedAppDelegate setSideMenu];
    //            [[NSUserDefaults standardUserDefaults]setBool:TRUE forKey:kUSER_LOGGED_IN];
    //        }
    
    //For server
    if(isNeedToLogin){
        isNeedToLogin = false;
//        [self loginServerCall:loginDict];
    }
}



-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    NSLog(@"You are logged out");
    isNeedToLogin = FALSE;
}


-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
}

//User login facebook server POST call
//-(void)loginServerCall:(NSDictionary*)loginDict
//{
//    
//    //Login Reauest to server
//    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:LOGIN_URL,HOSTNAME]]];
//    
//    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:loginDict
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:&error];
//    
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:jsonData];
//    
//    [NSURLConnection sendAsynchronousRequest:request queue:backgroundQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
//        if (error)
//        {
//            NSLog(@"error%@",[error localizedDescription]);
//            dispatch_async(dispatch_get_main_queue()
//                           , ^(void) {
//                               [self resetFacebookInfo];
//                               [ManamUtil showAlertWithTitle:@"Error" message:[error localizedDescription] cancelBtnTitle:@"Accept" otherBtnTitle:nil delegate:nil tag:0];
//                           });
//        }
//        else
//        {
//            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"result....%@",result);
//            
//            NSError *jsonParsingError = nil;
//            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
//            
//            if (jsonParsingError) {
//                NSLog(@"JSON ERROR: %@", [jsonParsingError localizedDescription]);
//            } else {
//                NSDictionary *responseDict = (NSDictionary*)object;
//                BOOL isLogin = [[ManamUtil nullValue:[responseDict valueForKey:@"response"]] boolValue];
//                
//                NSLog(@"isLogin..%d",isLogin);
//                
//                
//                dispatch_async(dispatch_get_main_queue()
//                               , ^(void) {
//                                   if(isLogin){
//                                       
//                                       NSArray *loginArr = (NSArray*)[ManamUtil nullValue:[responseDict valueForKey:@"data"]];
//                                       NSDictionary *loginDict;
//                                       if(loginArr.count == 1)
//                                           loginDict = [loginArr objectAtIndex:0];
//                                       else
//                                           loginDict= [ManamUtil nullValue:[responseDict valueForKey:@"data"]];
//                                       
//                                       NSString *status = [ManamUtil nullValue:[loginDict valueForKey:kUSER_STATUS]];
//                                       [[NSUserDefaults standardUserDefaults]setValue:[ManamUtil nullValue:[loginDict valueForKey:kUSER_ID]] forKey:kUSER_ID];
//                                       [[NSUserDefaults standardUserDefaults]setValue:status forKey:kUSER_STATUS];
//                                       [[NSUserDefaults standardUserDefaults]setBool:[[ManamUtil nullValue:[loginDict valueForKey:kIS_USER_ONLINE]]boolValue] forKey:kIS_USER_ONLINE];
//                                       [[NSUserDefaults standardUserDefaults]setBool:TRUE forKey:kUSER_LOGGED_IN];
//                                       
//                                       [SharedAppDelegate setSideMenu];
//                                   }
//                                   else
//                                   {
//                                       [self resetFacebookInfo];
//                                       [ManamUtil showAlertWithTitle:@"Error" message:@"Something is wrong try again."
//                                                      cancelBtnTitle:@"Accept" otherBtnTitle:nil delegate:nil tag:0];
//                                   }
//                               });
//            }
//        }
//        
//        
//    }];
//    
//}

-(void)resetFacebookInfo
{
    [FBSession.activeSession closeAndClearTokenInformation];
    FBSession.activeSession = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
