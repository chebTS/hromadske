//
//  OnlineStream.m
//  HromadskeTV
//
//  Created by Max Tymchii on 3/6/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "VideoStream.h"
static NSString *const kNameKey = @"name";
static NSString *const kVideoIdKey = @"videoId";

@interface  VideoStream ()
{
}
@end

@implementation VideoStream

+ (instancetype) streamWithDictionary:(NSDictionary *)parameters
{
    VideoStream *stream = [[VideoStream alloc] init];
    stream.name = parameters[kNameKey];
    stream.path = parameters[kVideoIdKey];
    return stream;
}

- (NSURL *) url {
    NSString *link =  [NSString stringWithFormat:@"http://youtube.com/embed/%@?ios=1&autoplay=0&html5=1&controls=0&showinfo=0", _path];
    return [NSURL URLWithString:link];
}

@end
