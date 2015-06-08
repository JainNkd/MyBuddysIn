//
//  AppDelegate.m
//  BuddysIN
//
//  Created by Naveen on 24/05/15.
//  Copyright (c) 2015 Naveen Kumar Dungarwal. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "HomeViewController.h"
#import "Constant.h"
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //facebook
    [FBLoginView class];
    
    //Location Pop up
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];
    
    
    
    //Set navigation
//    UINavigationBar* navAppearance = [UINavigationBar appearance];
//    [navAppearance setBarTintColor:UIColorFromRGB(0xffcd00)];
//    
//    UINavigationBar *navbar = [UINavigationBar appearance];
//    [navbar setTintColor:[UIColor blackColor]];
    
    //Check Login or not
    NSUserDefaults *defualt = [NSUserDefaults standardUserDefaults];
    BOOL isLoggedIn = [defualt boolForKey:kUSER_LOGGED_IN];
    
    if(isLoggedIn)
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
       
        ViewController *loginView = [mainStoryboard instantiateViewControllerWithIdentifier:@"ViewController"];
       
        UINavigationController* navView = [[UINavigationController alloc]initWithRootViewController:loginView];
        self.window.rootViewController = navView;
        [self.window makeKeyAndVisible];
        
    }
    else{
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        HomeViewController *homeView = [mainStoryboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        UINavigationController* navView = [[UINavigationController alloc]initWithRootViewController:homeView];
        self.window.rootViewController = navView;
        [self.window makeKeyAndVisible];
    }


    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
