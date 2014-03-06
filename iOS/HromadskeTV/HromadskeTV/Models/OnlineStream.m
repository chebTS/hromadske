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

+ (instancetype)onlineStreamParameters:(NSDictionary *)parameters
{
    OnlineStream *stream = [[OnlineStream alloc] init];
    stream.name = parameters[kNameKey];
    stream.liveTailPath = parameters[kVideoIdKey];
    return stream;
}
@end
