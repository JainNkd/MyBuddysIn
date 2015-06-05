//
//  Share.m
//  BuddysIN
//
//  Created by Naveen on 04/06/15.
//  Copyright (c) 2015 Naveen Kumar Dungarwal. All rights reserved.
//

#import "Share.h"
#import "Constant.h"


@implementation Share
@synthesize lon,imageURL,lat,shareID,mid,videoURL,videoThumbnailName,content,dataType,distance,imageName,videoThumbnailURL,videoName,createTime,memberDetail;

-(Share*)initWithDict:(NSDictionary*)dataDict
{
    if(self == [super init])
    {
        NSDictionary *shareDict = [dataDict objectForKey:@"shares"];
        NSDictionary *distanceDict = [dataDict objectForKey:@"0"];
        NSDictionary *memberDict = [dataDict objectForKey:@"members"];
        
        self.shareID = [shareDict valueForKey:@"id"];
        self.mid = [shareDict valueForKey:@"mid"];
        self.content = [shareDict valueForKey:@"content"];
        self.imageName = [shareDict valueForKey:@"image"];
        self.videoThumbnailName = [shareDict valueForKey:@"videothumb"];
        self.videoName = [shareDict valueForKey:@"video"];
        self.lat = [shareDict valueForKey:@"lat"];
        self.lon = [shareDict valueForKey:@"lon"];
        self.dataType = [shareDict valueForKey:@"data_type"];
        self.createTime = [shareDict valueForKey:@"created"];
        
        
        self.imageURL = [NSString stringWithFormat:kShareImageURL,mid,imageName];
        self.videoThumbnailURL = [NSString stringWithFormat:kShareVideoThumbnailURL,mid,videoThumbnailName];
        self.videoURL = [NSString stringWithFormat:kShareVideoURL,mid,videoName];
        
        self.distance = [distanceDict valueForKey:@"distance"];
        
        self.memberDetail = [[Member alloc]initWithDict:memberDict];
        
    }
    return self;
}
@end
