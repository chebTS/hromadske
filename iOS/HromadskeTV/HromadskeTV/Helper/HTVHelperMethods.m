//
//  HTVHelperMethods.m
//  HromadskeTV
//
//  Created by Max Tymchii on 12/12/13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//

#import "HTVHelperMethods.h"
#import "YoutubeViewController.h"
#import "Video.h"
#import "Twitt.h"
#import "OnlineStream.h"

#define YOUTUBE_KEY @"youtube"
@implementation HTVHelperMethods


+ (void)callCustomAlertWithMessage:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:APP_NAME
                                message:message delegate:nil
                      cancelButtonTitle:@"Добре"
                      otherButtonTitles: nil] show];
}


+ (void)saveHromadskeOnlineWithParameters:(NSDictionary *)parameters key:(NSString *)key
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:parameters forKey:key];
    [prefs synchronize];
}

+ (OnlineStream *)onlineStreamForKey:(NSString *)key
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = [prefs objectForKey:key];
    if (parameters) {
        return [OnlineStream onlineStreamWithParameters:parameters];
    }
    return nil;
}

+ (NSString *)keyForOnlineWithPosition:(int)position
{
    return [kHromadskeOnlineKey stringByAppendingString:@(position).description];
}

+ (NSString *)youtubeLiveLinkTail
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *youtubeLink = [prefs objectForKey:YOUTUBE_KEY];
    if (youtubeLink) {
        return youtubeLink;
    }
    return @"";
}


+ (void)saveYoutubeLiveLinkTail:(NSString *)newLink
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:newLink forKey:YOUTUBE_KEY];
    [prefs synchronize];
}

+ (NSString *)fullYoutubeLink
{
//    http://www.youtube.com/watch?v=%@&autoplay=0&ios=1
    NSString *link =  [NSString stringWithFormat:@"http://youtube.com/embed/%@?ios=1&autoplay=0&html5=1&controls=0&showinfo=0", [HTVHelperMethods youtubeLiveLinkTail]];
    return link;
}

+ (void)fetchNewDataFromYoutubeForController:(YoutubeViewController *)controller
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[HTVHud sharedManager] startHUD];
    });
    NSURL *url = [NSURL URLWithString:@"http://gdata.youtube.com/feeds/api/users/HromadskeTV"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@"uploads?alt=json"
                                                      parameters:nil];
    NSLog(@"%@", request);
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        NSDictionary *result = (NSDictionary *)JSON;
                                                       [controller setVideos:[HTVHelperMethods parseDictionaryFromYoutube:result[@"feed"][@"entry"]]];
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [[HTVHud sharedManager] finishHUD];
                                                        });
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        NSLog(@"Error %@", error);
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [[HTVHud sharedManager] finishHUD];
                                                        });
                                                    }];
    
    [operation start];
}


+ (NSArray *)parseDictionaryFromYoutube:(NSArray *)dictionary
{
    NSMutableArray *videos = @[].mutableCopy;
    for (NSDictionary *item in dictionary) {
        [videos addObject:[Video videoWithDictionary:item]];
    }
    return videos;
}

+ (NSArray *)parseArrayFromTwitter:(NSArray *)array
{
    NSMutableArray *twittes = @[].mutableCopy;
    for (NSDictionary *twittDict in array) {
        [twittes addObject:[Twitt initWithDictionary:twittDict]];
    }
    return twittes;
}

+ (NSString *)yotubeTailFromString:(NSString *)path
{
    NSArray *components = [path componentsSeparatedByString:@"="];
    NSString *tail = nil;
    if (components.count > 1) {
        tail = components[1];
        tail = [tail componentsSeparatedByString:@"&"][0];
    } else {
        NSArray *embedComponents = [path componentsSeparatedByString:@"embed/"];
        tail = embedComponents[1];
    }
    return tail;
}



@end
