//
//  BuddysINUtil.h
//  BuddysIN
//
//  Created by Naveen on 25/05/15.
//  Copyright (c) 2015 Naveen Kumar Dungarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuddysINUtil : NSObject

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelBtnTitle:(NSString *)cancelTitle otherBtnTitle:(NSString *)otherTitle delegate:(id)sender tag:(NSInteger)alertTag;

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message;


+(id)nullValue:(id)val;
@end
