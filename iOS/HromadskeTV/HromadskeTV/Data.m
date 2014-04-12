//
//  Data.m
//  HromadskeTV
//
//  Created by comonitos on 1/22/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "Data.h"
#import <AFKissXMLRequestOperation.h>
#import "TFHpple.h"
static NSString *const kStreamsKey = @"streams";

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


#pragma mark - videos from rss
- (void)videoForCategory:(HTVVideoCategory)cat completion:(void(^)(NSMutableArray *result))completion {
    NSURL *url = [NSURL URLWithString:URL_BASE];
    NSString *path = nil;
    switch (cat) {
        case HTVVideoCategoryHot:
            path = URL_PATH_NEWS_ALL;
            break;
        case HTVVideoCategoryAll:
            path = URL_PATH_NEWS_ALL;
            break;
        case HTVVideoCategoryCulture:
            path = URL_PATH_NEWS_CULTURE;
            break;
        case HTVVideoCategoryEconomics:
            path = URL_PATH_NEWS_ECOMONICS;
            break;
        case HTVVideoCategoryPolitics:
            path = URL_PATH_NEWS_POLITICS;
            break;
        case HTVVideoCategorySociety:
            path = URL_PATH_NEWS_SOCIETY;
            break;
        case HTVVideoCategoryWorld:
            path = URL_PATH_NEWS_WORLD;
            break;
    }
    
    if (cat == HTVVideoCategoryHot) {
        [self youtubeVideosCompletion:^(NSMutableArray *videos) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(videos);
                }
            });
        }];
        return;
    } else {
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
}

- (void) youtubeVideosCompletion:(void(^)(NSMutableArray *result))completion
{
    NSURL *url = [NSURL URLWithString:@"http://gdata.youtube.com/feeds/api/users/HromadskeTV"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@"uploads?alt=json"
                                                      parameters:nil];
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        NSMutableArray * videos = [self videosFromYouTube:JSON[@"feed"][@"entry"]];
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            if (completion) {
                                                                completion(videos);
                                                            }
                                                        });
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            NSLog(@"%@", error);
                                                            if (completion) {
                                                                completion(nil);
                                                            }
                                                        });
                                                    }];
    
    [operation start];
}


- (void) youTubeURLFromHromadskeUrl:(NSURL *)url completion:(void(^)(NSString *resultString))completion {
    
    NSString *path = [url.absoluteString componentsSeparatedByString:URL_BASE][1];
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:URL_BASE]];
//    [client registerHTTPOperationClass:[AFHTTPRequestOperation class]];
//    [client setDefaultHeader:@"Content-type" value:@"text/plain"];
//    [client setDefaultHeader:@"Accept" value:@"text/plain"];
//    
//    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:path parameters:nil];
//    AFKissXMLRequestOperation *op = [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument) {
//        NSArray *array = [XMLDocument nodesForXPath:@".video_player //iframe" error:nil];
//        NSString *str = [[array[0] attributeForName:@"src"] stringValue];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (completion) {
//                completion([NSURL URLWithString:str]);
//            }
//        });
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (completion) {
//                completion(nil);
//            }
//        });
//    }];
//    
//    [AFKissXMLRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/rss+xml", nil]];
//    [client enqueueHTTPRequestOperation:op];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:URL_BASE]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];

    [httpClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:responseObject];
        
        NSString *tutorialsXpathQueryString = @"//div[@class='video_player']/iframe";
        NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
		if (tutorialsNodes.count == 0 ) {
			if (completion) {
				completion(nil);
			}
			return;
		}
        TFHppleElement *elem = tutorialsNodes[0];
        NSString *str = [elem description];
        
        NSString *address = [str componentsSeparatedByString:@"nodeContent = \"//"][1];
        NSString *cleanAddress = [address componentsSeparatedByString:@"?"][0];
        NSString *httpString = [NSString stringWithFormat:@"http://%@",cleanAddress];

        if (completion) {
            completion(httpString);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error %@", error);
        if (completion) {
            completion(nil);
        }
    }];
}


#pragma mark - fabricators
- (NSMutableArray *) videosWithNodes:(NSArray *)array {
    NSMutableArray *videos = [NSMutableArray array];
    for(DDXMLElement* resultElement in array)
    {
        [videos addObject:[Video videoWithNode:resultElement]];
    }
    return videos;
}
- (NSMutableArray *) videosFromYouTube:(NSArray *)array {
    NSMutableArray *videos = [NSMutableArray array];
    for (NSDictionary *item in array) {
        [videos addObject:[Video videoWithDictionary:item]];
    }
    return videos;
}

#pragma mark - online links
- (void)updateLivePathTailFromSource:(HTVLiveLinkSource)source withCompletion:(void(^)(NSString *path, BOOL isNew))completion {
    HTVLiveLinkSource _source = (source == HTVLiveLinkSourceDefault) ? HTVLiveLinkSourceAPI : source;
    
    NSURL *url = nil;
    NSString *path = nil;
    switch (_source) {
        case HTVLiveLinkSourceAPI:
            url = [NSURL URLWithString:FREDY_BASE_URL];
            path = URL_PATH_STREAM;
            break;
        case HTVLiveLinkSourceGdata:
            url = [NSURL URLWithString:URL_BASE_GDATA];
            path = URL_GDATA_PATH_ONLINE;
            break;
    }
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *tail = nil;
        switch (_source) {
            case HTVLiveLinkSourceAPI:
                tail = [self tailFromHromadskeAPI:responseObject];
                break;
            case HTVLiveLinkSourceGdata:
                tail = [self tailFromGdataAPI:responseObject];
                break;
        }
        
        if (!tail) {
            [self updateLivePathTailFromSource:HTVLiveLinkSourceGdata withCompletion:^(NSString *_path, BOOL _isNew) {
                if (completion) {
                    completion(_path,_isNew);
                }
            }];
            return;
        }
        
        BOOL needUpdate = NO;
        NSString *oldLink = [HTVHelperMethods youtubeLiveLinkTail];
        if (![tail isEqualToString:oldLink]) {
            [HTVHelperMethods saveYoutubeLiveLinkTail:tail];
            needUpdate = YES;
        }
        
        if (completion) {
            completion(tail,needUpdate);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil,NO);
        }
    }];
}

- (NSString *) tailFromHromadskeAPI:(id)response {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:&error];
    [HTVHelperMethods clearLiveLinks];
    NSArray *result = ((NSDictionary *)json)[kStreamsKey];
    for (int i = 0; i < result.count; i++) {
        [HTVHelperMethods saveHromadskeOnlineWithParameters:result[i]
                                                        chanel:[HTVHelperMethods keyForOnlineWithPosition:i]];
    }
    
    NSString *youtubeTail = result[0][kVideoIdKey];
    
    return youtubeTail;
}

- (NSString *) tailFromGdataAPI:(id)response {
//    NSString *str = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:&error];
    NSDictionary *result = (NSDictionary *)json;
    NSString *youtubeLink = [result[@"feed"][@"entry"] firstObject][@"content"][@"src"];
    NSString *youtubeTailDirty = [[youtubeLink componentsSeparatedByString:@"live/videos/"] lastObject];
    NSString *youtubeTail = [[youtubeTailDirty componentsSeparatedByString:@"?"] firstObject];
    [HTVHelperMethods clearLiveLinks];
    [HTVHelperMethods saveHromadskeOnlineWithParameters:@{kNameKey : @"Громадське Online",
                                                          kVideoIdKey : youtubeTail}
                                                    chanel:[HTVHelperMethods keyForOnlineWithPosition:0]];
    return youtubeTail;
}


@end

