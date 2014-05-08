//
//  RadioStream.m
//  HromadskeTV
//
//  Created by comonitos on 5/8/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "RadioStream.h"
static NSString *const kNameKey = @"stream";
static NSString *const kVideoIdKey = @"host";

@implementation RadioStream

+ (instancetype) streamWithDictionary:(NSDictionary *)parameters
{
    RadioStream *stream = [[RadioStream alloc] init];
    stream.name = parameters[kNameKey];
    stream.path = parameters[kVideoIdKey];
	
    return stream;
}

- (NSURL *) url {
    NSString *link =  [NSString stringWithFormat:@"http://%@:1935/live/%@/playlist.m3u8", _path,_name];
    return [NSURL URLWithString:link];
}

@end
