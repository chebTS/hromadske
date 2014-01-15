//
//  HTVHelperMethods.h
//  HromadskeTV
//
//  Created by Max Tymchii on 12/12/13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTVHelperMethods : NSObject


+ (void)callCustomAlertWithMessage:(NSString *)message;
+ (NSString *)youtubeLink;
+ (void)saveYouTubeLink:(NSString *)newLink;
+ (NSString *)fullYoutubeLink;
@end
