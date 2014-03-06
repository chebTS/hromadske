//
//  OnlineStream.h
//  HromadskeTV
//
//  Created by Max Tymchii on 3/6/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnlineStream : NSObject
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *liveTailPath;

+ (instancetype)onlineStreamWithParameters:(NSDictionary *)parameters;
@end
