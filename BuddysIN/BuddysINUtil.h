//
//  BuddysINUtil.h
//  BuddysIN
//
//  Created by Naveen on 25/05/15.
//  Copyright (c) 2015 Naveen Kumar Dungarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface BuddysINUtil : NSObject

//Alert Methos
+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelBtnTitle:(NSString *)cancelTitle otherBtnTitle:(NSString *)otherTitle delegate:(id)sender tag:(NSInteger)alertTag;

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message;


+(id)nullValue:(id)val;

//File methods
+(BOOL)fileExist:(NSString*)fileName;
+(NSString*)localFileUrl:(NSString*)fileName;

//Internet connectivity Methods
+(BOOL)reachable;
+(BOOL)isWiFiConnected;


@end
