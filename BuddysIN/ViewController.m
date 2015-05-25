//
//  ViewController.m
//  BuddysIN
//
//  Created by Naveen on 24/05/15.
//  Copyright (c) 2015 Naveen Kumar Dungarwal. All rights reserved.
//

#import "ViewController.h"
#import "TermsViewController.h"
#import "HomeViewController.h"
#import "Constant.h"
#import "BuddysINUtil.h"

@interface ViewController ()
{
    BOOL isNeedToLogin;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    //Set Delegate and facebook Permission
    self.loginButton.delegate = self;
    self.loginButton.readPermissions = @[@"public_profile",@"email",@"user_friends"];
    
    //Set login button image
    [self.loginButton addSubview:self.fbImageBG];
    [self.loginButton addSubview:self.fbLBL];
    
    UIColor *redcolor = UIColorFromRGB(0xB40000);
    
    //Set Cell Text Msg
    NSDictionary * wordToColorMapping = [[NSDictionary alloc]initWithObjectsAndKeys:[UIColor blackColor],@"BY REGISTERING WITH OUR SERVICE,    YOU AGREE TO OUR ",redcolor,@"TERMS OF SERVICE.",nil];  //an NSDictionary of NSString => UIColor pairs
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@""];
    
    NSArray* keyArr = [NSArray arrayWithObjects:@"BY REGISTERING WITH OUR SERVICE,    YOU AGREE TO OUR ",@"TERMS OF SERVICE.",nil];
    
    for (NSString * word in keyArr) {
        UIColor * color = [wordToColorMapping objectForKey:word];
        NSDictionary * attributes = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
        NSAttributedString * subString = [[NSAttributedString alloc] initWithString:word attributes:attributes];
        [string appendAttributedString:subString];
    }
    
    self.termsLBL.attributedText = string;
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
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
    [[NSUserDefaults standardUserDefaults]setValue:email forKey:kUSER_EMAIL];
    [[NSUserDefaults standardUserDefaults]setValue:fbId forKey:kUSER_FB_ID];
    [[NSUserDefaults standardUserDefaults]setValue:name forKey:kUSER_NAME];
    [[NSUserDefaults standardUserDefaults]setValue:thumbnailUrl forKey:kUSER_PROFILE_URL];
    [[NSUserDefaults standardUserDefaults]setValue:fbAccessToken forKey:kUSER_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSString *apiKey = @"AiK58j67";
    NSString *apiSecret = @"a#9rJkmbOea90-";
    NSDictionary *loginDict = [[NSDictionary alloc]initWithObjectsAndKeys:email,@"email",apiKey,@"api_key",name,@"name",apiSecret,@"api_secret",nil];
    
    //    For local
    //        if(isNeedToLogin)
    //        {
    //            [SharedAppDelegate setSideMenu];
    //            [[NSUserDefaults standardUserDefaults]setBool:TRUE forKey:kUSER_LOGGED_IN];
    //        }
    
    //For server
    if(isNeedToLogin){
        isNeedToLogin = false;
        [self loginServerCall:loginDict];
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
-(void)loginServerCall:(NSDictionary*)loginDict
{
    
    //Login Reauest to server
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:LOGIN_URL,HOSTNAME]]];
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:loginDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"text/html" forHTTPHeaderField:@"Accept"];

    [request setHTTPBody:jsonData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:backgroundQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (error)
        {
            NSLog(@"error%@",[error localizedDescription]);
            dispatch_async(dispatch_get_main_queue()
                           , ^(void) {
                               [self resetFacebookInfo];
                               [BuddysINUtil showAlertWithTitle:@"Error" message:[error localizedDescription] cancelBtnTitle:@"Accept" otherBtnTitle:nil delegate:nil tag:0];
                           });
        }
        else
        {
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"result....%@",result);
            
            NSError *jsonParsingError = nil;
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            
            if (jsonParsingError) {
                NSLog(@"JSON ERROR: %@", [jsonParsingError localizedDescription]);
            } else {
                NSDictionary *responseDict = (NSDictionary*)object;
                NSDictionary *fbcDict = [responseDict valueForKey:@"fbc"];
                NSInteger status = [[fbcDict valueForKey:@"status"] integerValue];
                NSLog(@"isLogin..%d",status);
                
                
                dispatch_async(dispatch_get_main_queue()
                               , ^(void) {
                                   if(status == 1){
                                       
                                       [[NSUserDefaults standardUserDefaults]setBool:TRUE forKey:kUSER_LOGGED_IN];
                                       HomeViewController *homeView = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
            
                                       [self.navigationController pushViewController:homeView animated:YES];
                                   }
                                   else
                                   {
                                       [self resetFacebookInfo];
                                       [BuddysINUtil showAlertWithTitle:@"Error" message:@"Something is wrong try again."
                                                      cancelBtnTitle:@"Accept" otherBtnTitle:nil delegate:nil tag:0];
                                   }
                               });
            }
        }
        
        
    }];
    
}

-(void)resetFacebookInfo
{
    [FBSession.activeSession closeAndClearTokenInformation];
    FBSession.activeSession = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)termsButtonClicked:(UIButton *)sender {
    
    TermsViewController *termsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
    [self.navigationController pushViewController:termsVC animated:YES];
}

@end
