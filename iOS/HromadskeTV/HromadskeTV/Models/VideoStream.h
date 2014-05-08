//
//  OnlineStream.h
//  HromadskeTV
//
//  Created by Max Tymchii on 3/6/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoStream : NSObject
{
}
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *path;

+ (instancetype) streamWithDictionary:(NSDictionary *)parameters;
- (NSURL *) url;

@end
