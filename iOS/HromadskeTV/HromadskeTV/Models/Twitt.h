//
//  HTVTwitt.h
//  HromadskeTV
//
//  Created by Max Tymchii on 1/16/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Twitt;
@interface Twitt : NSObject
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *tags;
@property (nonatomic, strong) NSString *url;
+ (Twitt *)initWithDictionary:(NSDictionary *)dictionary;
@end
