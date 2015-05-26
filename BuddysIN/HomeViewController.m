//
//  HomeViewController.m
//  BuddysIN
//
//  Created by Naveen on 25/05/15.
//  Copyright (c) 2015 Naveen Kumar Dungarwal. All rights reserved.
//

#import "HomeViewController.h"
#import "Constant.h"
#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.nameLabel.text = [[NSUserDefaults standardUserDefaults]valueForKey:kUSER_NAME];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logOutButtonAction:(UIButton *)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
    FBSession.activeSession = nil;
    
    [[NSUserDefaults standardUserDefaults]setBool:FALSE forKey:kUSER_LOGGED_IN];
    ViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    [self.navigationController pushViewController:loginView animated:YES];
    
}
@end
