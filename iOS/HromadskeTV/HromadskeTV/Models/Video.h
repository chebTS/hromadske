//
//  HTVVideo.h
//  HromadskeTV
//
//  Created by Max Tymchii on 1/16/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DDXMLElement;

@interface Video : NSObject
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *date;

+ (Video *)videoWithDictionary:(NSDictionary *)dictionary;
+ (Video *)videoWithNode:(DDXMLElement *)node;
@end
