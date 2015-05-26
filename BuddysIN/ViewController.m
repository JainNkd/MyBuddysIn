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

#import "ConnectionHandler.h"

@interface ViewController ()
{
    BOOL isNeedToLogin;
}

@end

@implementation ViewController


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.loginButton.delegate=self;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.loginButton.delegate=nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    //Set Delegate and facebook Permission
    
    [self.loginButton setFrame:CGRectMake(self.loginButton.frame.origin.x, self.loginButton.frame.origin.y,320,100)];
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
    
    if(email.length ==0)
        email = @"";
    
    //    For local
    //        if(isNeedToLogin)
    //        {
    //            [SharedAppDelegate setSideMenu];
    //            [[NSUserDefaults standardUserDefaults]setBool:TRUE forKey:kUSER_LOGGED_IN];
    //        }
    
    //For server
    if(isNeedToLogin){
        isNeedToLogin = FALSE;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:kAPIKeyValue forKey:kAPIKey];
        [dict setValue:kAPISecretValue forKey:kAPISecret];
        [dict setValue:email forKey:@"email"];
        [dict setValue:name forKey:@"name"];

        
        ConnectionHandler *connHandler = [[ConnectionHandler alloc] init];
        connHandler.delegate = self;
        [connHandler makePOSTRequestPath:kRegistrationURL parameters:dict];
        }
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    NSLog(@"You are logged out");
    isNeedToLogin = FALSE;
}


-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
}



#pragma mark - Connection

-(void)connHandlerClient:(ConnectionHandler *)client didSucceedWithResponseStatus:(NSUInteger)status {
  NSLog(@"didSucceedWithResponseStatus:");
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

}

-(void)connHandlerClient:(ConnectionHandler *)client didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError:%@",[error localizedDescription]);
    [self resetFacebookInfo];
    [BuddysINUtil showAlertWithTitle:@"Error" message:[error localizedDescription] cancelBtnTitle:@"Accept" otherBtnTitle:nil delegate:nil tag:0];
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
