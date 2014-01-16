//
//  HTVTwitt.h
//  HromadskeTV
//
//  Created by Max Tymchii on 1/16/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HTVTwitt;
@interface HTVTwitt : NSObject
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *author;
+ (HTVTwitt *)initWithDictionary:(NSDictionary *)dictionary;
@end
