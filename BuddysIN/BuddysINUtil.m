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
@end
