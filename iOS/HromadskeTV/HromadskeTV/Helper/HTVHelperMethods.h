//
//  HTVHelperMethods.h
//  HromadskeTV
//
//  Created by Max Tymchii on 12/12/13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YoutubeViewController;
@interface HTVHelperMethods : NSObject


+ (void)callCustomAlertWithMessage:(NSString *)message;
+ (NSString *)youtubeLiveLinkTail;
+ (void)saveYoutubeLiveLinkTail:(NSString *)newLink;
+ (NSString *)fullYoutubeLink;
+ (NSArray *)parseDictionaryFromYoutube:(NSDictionary *)dictionary;
+ (void)fetchNewDataFromYoutubeForController:(YoutubeViewController *)controller;
+ (NSString *)yotubeTailFromString:(NSString *)string;
+ (NSArray *)parseArrayFromTwitter:(NSArray *)twittes;
@end
