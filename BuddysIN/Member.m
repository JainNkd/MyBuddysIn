//
//  Member.m
//  BuddysIN
//
//  Created by Naveen on 04/06/15.
//  Copyright (c) 2015 Naveen Kumar Dungarwal. All rights reserved.
//

#import "Member.h"

@implementation Member
@synthesize email,lat,lon,name;

-(Member*)initWithDict:(NSDictionary*)memberDict
{
    if(self == [super init])
    {
        self.email = [memberDict valueForKey:@"email"];
        self.lat = [memberDict valueForKey:@"lat"];
        self.lon = [memberDict valueForKey:@"lon"];
        self.name = [memberDict valueForKey:@"name"];
        
    }
    return self;
}

@end
