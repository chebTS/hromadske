//
//  HTVVideo.m
//  HromadskeTV
//
//  Created by Max Tymchii on 1/16/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "Video.h"
#import <AFKissXMLRequestOperation.h>

@implementation Video

@synthesize description = _description;

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
    video.description = dictionary[@"media$description"][@"$t"];
    NSString *str = [[dictionary[@"updated"][@"$t"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] stringByReplacingOccurrencesOfString:@".000Z" withString:@" +0000"];
    video.date = [Utils dateFromString:str withFormat:@"yyyy-MM-d hh:mm:ss ZZZZ"];

    NSString *tail = [HTVHelperMethods yotubeTailFromString:dictionary[@"media$group"][@"media$player"][0][@"url"]];

    video.url = tail;
    return video;
}

+ (Video *)videoWithNode:(DDXMLElement *)node {
    Video *video = [Video new];
    
    NSArray *nodes = [node children];
    for ( DDXMLElement *_node in nodes) {
        NSString *name = [_node name];
        NSString *val = [_node stringValue];
        if ([name isEqualToString:@"title"]) {
            video.title = val;
        } else if ([name isEqualToString:@"link"]) {
            video.url = val;
        } else if ([name isEqualToString:@"description"]) {
            video.description = val;
        } else if ([name isEqualToString:@"pubDate"]) {
            video.date = [Utils dateFromString:val withFormat:@"ccc, d LLL yyyy hh:mm:ss Z"];
        } else if ([name isEqualToString:@"enclosure"]) {
            video.thumbnail = [[_node attributeForName:@"url"] stringValue];
        }
    }

    return video;
}
@end
