//
//  OnlineStream.m
//  HromadskeTV
//
//  Created by Max Tymchii on 3/6/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "OnlineStream.h"

@interface  OnlineStream ()
@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) NSString *liveTailPath;
@end

@implementation OnlineStream

+ (instancetype)onlineStreamWithParameters:(NSDictionary *)parameters
{
    OnlineStream *stream = [[OnlineStream alloc] init];
    stream.name = parameters[kNameKey];
    stream.liveTailPath = parameters[kVideoIdKey];
    return stream;
}

+ (NSArray *)allOnlineStreams
{
    NSMutableArray *allStreams = @[].mutableCopy;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int position = 0;
    NSDictionary *parameters = nil;
    do {
        NSString *key = [HTVHelperMethods keyForOnlineWithPosition:position];
        parameters = [prefs valueForKey:key];
        if (parameters) {
            [allStreams addObject:[OnlineStream onlineStreamWithParameters:parameters]];
        }
        position++;
    } while (parameters);
    return allStreams;
}
@end
