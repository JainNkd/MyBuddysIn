//
//  BuddysINUtil.m
//  BuddysIN
//
//  Created by Naveen on 25/05/15.
//  Copyright (c) 2015 Naveen Kumar Dungarwal. All rights reserved.
//

#import "BuddysINUtil.h"
#import <UIKit/UIKit.h>

@implementation BuddysINUtil

#pragma mark - Alerts

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self cancelButtonTitle:@"Accept" otherButtonTitles:nil];
    
    [alert show];
}

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelBtnTitle:(NSString *)cancelTitle otherBtnTitle:(NSString *)otherTitle delegate:(id)sender tag:(NSInteger)alertTag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:sender cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle,nil];
    alert.tag = alertTag;
    
    [alert show];
}

//check null value
+(id)nullValue:(id)val{
    if(val == [NSNull null])
        return nil;
    else
        return val;
    
}

//Check file in document directory
+(BOOL)fileExist:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *localURL = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:localURL])
        return YES;
    else
        return NO;
    
}

+(NSString*)localFileUrl:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *localURL = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    return localURL;
}

//Internect Connectivity
//Creating AlertView when Missing Network connectivity
+(BOOL)reachable
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable)
    {
        return NO;
    }
    return YES;
}

+(BOOL)isWiFiConnected
{
    Reachability *r = [Reachability reachabilityForLocalWiFi];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == ReachableViaWiFi)
    {
        return YES;
    }
    return NO;
}

@end
