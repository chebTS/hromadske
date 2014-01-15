//
//  HTVHelperMethods.m
//  HromadskeTV
//
//  Created by Max Tymchii on 12/12/13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//

#import "HTVHelperMethods.h"
#define YOUTUBE_KEY @"youtube"
@implementation HTVHelperMethods


+ (void)callCustomAlertWithMessage:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:APP_NAME
                                message:message delegate:nil
                      cancelButtonTitle:@"Добре"
                      otherButtonTitles: nil] show];
}

+ (NSString *)youtubeLink
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *youtubeLink = [prefs objectForKey:YOUTUBE_KEY];
    if (youtubeLink) {
        return youtubeLink;
    }
    return @"";
}

+ (void)saveYouTubeLink:(NSString *)newLink
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:newLink forKey:YOUTUBE_KEY];
    [prefs synchronize];
}

+ (NSString *)fullYoutubeLink
{
    NSString *link =  [NSString stringWithFormat:@"http://youtube.com/embed/%@", [HTVHelperMethods youtubeLink]];
    return link;
}

@end
