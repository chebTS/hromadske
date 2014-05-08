//
//  SourcesManager.m
//  HromadskeTV
//
//  Created by comonitos on 5/8/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "SourcesManager.h"

static NSString *const kVideoStreamsResponceKey = @"streams";
static NSString *const kRadioStreamsResponceKey = @"radio";

static NSString *const kVideoIndexKey = @"kVideoIndexKey";
static NSString *const kRadioIndexKey = @"kRadioIndexKey";
static NSString *const kLastStreamsResponceKey = @"kLastStreamsResponceKey";

@interface SourcesManager()
{
	int _lastRadioSelectedIndex;
	int _lastVideoSelectedIndex;
	
	NSMutableArray *_radioSources;
	NSMutableArray *_videoSources;

	NSString *_lastServerResponce;
	
	BOOL _isUpdateRequired;
}

@end

@implementation SourcesManager

+ (instancetype) sharedManager {
	static SourcesManager *__manager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		__manager = [[SourcesManager alloc] init];
	});
	
	return __manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
		_radioSources = [NSMutableArray array];
		_videoSources = [NSMutableArray array];
		
		_lastVideoSelectedIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:kVideoIndexKey] intValue];
		_lastRadioSelectedIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:kRadioIndexKey] intValue];
		
		_lastServerResponce = [[NSUserDefaults standardUserDefaults] objectForKey:kLastStreamsResponceKey];
		_isUpdateRequired =  YES;
		
		if (_lastServerResponce) {
			NSData *data = [_lastServerResponce dataUsingEncoding:NSUTF8StringEncoding];
			[self processServerResponce:data];

			if (_isUpdateRequired && _delegate) {
				[_delegate sourcesManagerdidUpdateSources:self withNewStatus:_isUpdateRequired];
			}
		}
		
    }
    return self;
}

- (NSArray *) videoSources
{
	return _videoSources;
}
- (NSArray *) radioSources
{
	return _radioSources;
}

- (void) setSelectedVideoIndex:(int) index {
	_lastVideoSelectedIndex = index;
	[self saveStreamingData];
}
- (void) setSelectedRadioIndex:(int) index {
	_lastRadioSelectedIndex = index;
	[self saveStreamingData];
}

- (VideoStream *)lastVideoStream {
	if (_videoSources.count > _lastVideoSelectedIndex) {
		return [_videoSources objectAtIndex:_lastVideoSelectedIndex];
	}
	return nil;
}
- (RadioStream *)lastRadioStream {
	if (_radioSources.count > _lastRadioSelectedIndex) {
		return [_radioSources objectAtIndex:_lastRadioSelectedIndex];
	}
	return nil;
}
#pragma mark - Saving
- (void) saveStreamingData {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject:[NSNumber numberWithInt:_lastVideoSelectedIndex] forKey:kVideoIndexKey];
	[defaults setObject:[NSNumber numberWithInt:_lastRadioSelectedIndex] forKey:kRadioIndexKey];
	
	[defaults setObject:_lastServerResponce forKey:kLastStreamsResponceKey];
	
	[defaults synchronize];
}
#pragma mark - Updating
- (void) updateSources {
	[self updateSourcesWithCompletion:nil];
}

- (void)updateSourcesWithCompletion:(void(^)(void))completion {
    
	//url = [NSURL URLWithString:URL_BASE_GDATA];
	//path = URL_GDATA_PATH_ONLINE;
    NSURL *url = [NSURL URLWithString:FREDY_BASE_URL];
    NSString *path = URL_PATH_STREAMS;
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (!responseObject) {
			if (completion) {
				completion();
			}
            return;
        }

        
		_lastServerResponce = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		[self saveStreamingData];

        [self processServerResponce:responseObject];;
		
		[_delegate sourcesManagerdidUpdateSources:self withNewStatus:_isUpdateRequired];
        
        if (completion) {
            completion();
        }
		
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

		[_delegate sourcesManagerdidUpdateSources:self withNewStatus:_isUpdateRequired];

        if (completion) {
            completion();
        }
    }];
}

- (void) processServerResponce:(id)response {

    NSError *error = nil;
	
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:&error];
	
    NSArray *videos = json[kVideoStreamsResponceKey];
	[_videoSources removeAllObjects];

    for (int i = 0; i < videos.count; i++) {
		VideoStream *newStream = [VideoStream streamWithDictionary:[videos objectAtIndex:i]];
		if (_lastVideoSelectedIndex == i) {
			_isUpdateRequired = ![[[self lastVideoStream] path] isEqualToString:newStream.path];
		}
		[_videoSources addObject:newStream];
    }

	NSArray *radios = json[kRadioStreamsResponceKey];
	[_radioSources removeAllObjects];
    for (int i = 0; i < radios.count; i++) {
		[_radioSources addObject:[RadioStream streamWithDictionary:[radios objectAtIndex:i]]];
    }
}

//- (NSString *) tailFromGdataAPI:(id)response {
//	//    NSString *str = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
//    
//    NSError *error = nil;
//    id json = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:&error];
//    NSDictionary *result = (NSDictionary *)json;
//    NSString *youtubeLink = [result[@"feed"][@"entry"] firstObject][@"content"][@"src"];
//    NSString *youtubeTailDirty = [[youtubeLink componentsSeparatedByString:@"live/videos/"] lastObject];
//    NSString *youtubeTail = [[youtubeTailDirty componentsSeparatedByString:@"?"] firstObject];
//    [HTVHelperMethods clearLiveLinks];
//    [HTVHelperMethods saveHromadskeOnlineWithParameters:@{kNameKey : @"Громадське Online",
//                                                          kVideoIdKey : youtubeTail}
//												 chanel:[HTVHelperMethods keyForOnlineWithPosition:0]];
//    return youtubeTail;
//}
@end
