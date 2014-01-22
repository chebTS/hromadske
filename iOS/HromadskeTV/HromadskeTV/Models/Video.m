//
//  HTVVideo.m
//  HromadskeTV
//
//  Created by Max Tymchii on 1/16/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "Video.h"

@implementation Video

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (Video *)videoWithDictionary:(NSDictionary *)dictionary
{
    Video *video = [Video new];
    video.thumbnail = dictionary[@"media$group"][@"media$thumbnail"][0][@"url"];
    video.title = dictionary[@"title"][@"$t"];
    video.date = dictionary[@"updated"][@"$t"];
    NSString *tail = [HTVHelperMethods yotubeTailFromString:dictionary[@"media$group"][@"media$player"][0][@"url"]];

    video.url = tail;
    return video;
}
@end
