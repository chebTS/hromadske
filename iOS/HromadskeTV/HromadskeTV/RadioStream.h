//
//  RadioStream.h
//  HromadskeTV
//
//  Created by comonitos on 5/8/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadioStream : NSObject
{
}
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *path;

+ (instancetype) streamWithDictionary:(NSDictionary *)parameters;
- (NSURL *) url;

@end
