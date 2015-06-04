//
//  Share.h
//  BuddysIN
//
//  Created by Naveen on 04/06/15.
//  Copyright (c) 2015 Naveen Kumar Dungarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Member.h"

@interface Share : NSObject

@property(nonatomic,strong)NSString *memberID,*mid,*content,*imageURL,*videoURL,*videoThumbnail,*lat,*lon,*dataType,*distance;

@end
