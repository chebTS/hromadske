//
//  HTVVideo.m
//  HromadskeTV
//
//  Created by Max Tymchii on 1/16/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "HTVVideo.h"

@implementation HTVVideo

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (HTVVideo *)initWithDictionary:(NSDictionary *)dictionary
{
    HTVVideo *video = [HTVVideo generateInstance];
    video.thumbnail = dictionary[@"media$group"][@"media$thumbnail"][0][@"url"];
    video.title = dictionary[@"title"][@"$t"];
    video.date = dictionary[@"updated"][@"$t"];
    NSString *tail = [HTVHelperMethods yotubeTailFromString:dictionary[@"media$group"][@"media$player"][0][@"url"]];

    video.url = tail;
    return video;
}



+ (HTVVideo *)generateInstance
{
    return [[HTVVideo alloc] init];
}
@end
