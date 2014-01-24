//
//  Data.m
//  HromadskeTV
//
//  Created by comonitos on 1/22/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "Data.h"
#import <AFKissXMLRequestOperation.h>

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



- (void)videoForCategory:(HTVVideoCategory)cat completion:(void(^)(NSMutableArray *result))completion {
    NSURL *url = [NSURL URLWithString:URL_BASE];
    NSString *path = nil;
    switch (cat) {
        case HTVVideoCategoryAll:
            path = URL_PATH_VIDEO_ALL;
            break;
        case HTVVideoCategoryInvestigation:
            path = URL_PATH_VIDEO_INVASTIGATIONS;
            break;
        case HTVVideoCategoryH2o:
            path = URL_PATH_VIDEO_H2O;
            break;
        case HTVVideoCategoryGuests:
            path = URL_PATH_VIDEO_GUESTS;
            break;
    }
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [client setDefaultHeader:@"Content-type" value:@"text/plain"];
    [client setDefaultHeader:@"Accept" value:@"text/plain"];
    
    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:path parameters:nil];
    AFKissXMLRequestOperation *op = [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument) {
        NSLog(@"%@", XMLDocument);
        NSArray *array = [XMLDocument nodesForXPath:@"//item" error:nil];
        NSMutableArray *videos = [self videosWithNodes:array];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(videos);
            }
        });
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@", error);
            if (completion) {
                completion(nil);
            }
        });
    }];

    [AFKissXMLRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/rss+xml", nil]];
    [client enqueueHTTPRequestOperation:op];
}

- (NSMutableArray *) videosWithNodes:(NSArray *)array {
    NSMutableArray *videos = [NSMutableArray array];
    for(DDXMLElement* resultElement in array)
    {
        [videos addObject:[Video videoWithNode:resultElement]];
    }
    return videos;
}
@end

