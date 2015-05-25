//
//  Constant.h
//  BuddysIN
//
//  Created by Naveen on 25/05/15.
//  Copyright (c) 2015 Naveen Kumar Dungarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constant : NSObject

//Set color using Hexcode

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//UserDefaults
#define kUSER_EMAIL @"USER_EMAIL"
#define kUSER_NAME @"USER_NAME"
#define kUSER_PROFILE_URL @"USER_PROFILE_URL"

#define kUSER_FB_ID @"USER_FACEBOOK_ID"
#define kUSER_ACCESS_TOKEN @"USER_FB_ACCESS_TOKEN"


#define kUSER_LOGGED_IN @"USER_LOGGED_IN"


extern const NSString * HOSTNAME;
extern NSString * const LOGIN_URL;

@end
