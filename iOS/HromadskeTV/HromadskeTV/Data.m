//
//  Data.m
//  HromadskeTV
//
//  Created by comonitos on 1/22/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "Data.h"

@implementation Data
+ (Data *)sharedData {
    static Data *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[Data alloc] init];
    });
    
    return __manager;
}


#pragma mark - SETUP
- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
- (void) setup {
    [self startNetworkTracker];
}


- (void) startNetworkTracker
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://google.com"]];
    [client setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [HTVHelperMethods callCustomAlertWithMessage:NO_INTERNET_COONECTION];
        }
    }];
    
}

- (void)updateLivePathWithCompletion:(void(^)(NSString *path, BOOL isNew))completion {
    NSURL *url = [NSURL URLWithString:ONLINE_URL_PATH];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient getPath:nil parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSDictionary *result = (NSDictionary *)json;
        NSString *youtubeLink = [result objectForKey:@"youtube_link"];
        NSString *youtubeTail = [[youtubeLink componentsSeparatedByString:@"embed/"] lastObject];
        
        BOOL needUpdate = NO;
        NSString *oldLink = [HTVHelperMethods youtubeLink];
        if (![youtubeTail isEqualToString:oldLink]) {
            [HTVHelperMethods saveYouTubeLink:youtubeTail];
            needUpdate = YES;
        }

        if (completion) {
            completion(youtubeTail,needUpdate);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error %@", error);
        if (completion) {
            completion(nil,NO);
        }
    }];
}
@end
