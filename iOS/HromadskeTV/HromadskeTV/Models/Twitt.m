//
//  HTVTwitt.m
//  HromadskeTV
//
//  Created by Max Tymchii on 1/16/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "Twitt.h"
#import <STTwitter/NSDateFormatter+STTwitter.h>

@implementation Twitt
+ (Twitt *)initWithDictionary:(NSDictionary *)dictionary
{
    Twitt *twitt = [[Twitt alloc] init];
    NSDateFormatter *df = [NSDateFormatter stTwitterDateFormatter];
    NSString *dateString = [dictionary valueForKey:@"created_at"];
    NSDate *date = [df dateFromString:dateString];
    twitt.date = date;
    twitt.text = dictionary[@"text"];
    twitt.tags = [Twitt tagsFromDictionary:dictionary];
    twitt.url = dictionary[@"entities"][@"media"][0][@"url"];
    return twitt;
}

+ (NSString *)tagsFromDictionary:(NSDictionary *)dictionary
{
    NSMutableString* result = @" ".mutableCopy;
    for (NSDictionary *tags in dictionary[@"entities"][@"hashtags"]) {
        NSString *string = [NSString stringWithFormat:@"#%@", tags[@"text"]];
        [result appendString:string];
    }
    return result;
}
@end
