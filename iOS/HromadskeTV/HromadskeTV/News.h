//
//  HTV.h
//  HromadskeTV
//
//  Created by comonitos on 5/28/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *views;
@property (nonatomic) int height;


- (id)initWithDictionary:(NSDictionary *)d;
//- (void)
//- (id)initWithDictionary:(NSDictionary *)d;

@end
