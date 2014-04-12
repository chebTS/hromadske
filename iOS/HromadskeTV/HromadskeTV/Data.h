//
//  Data.h
//  HromadskeTV
//
//  Created by comonitos on 1/22/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//


typedef enum
{
    HTVVideoCategoryHot,
    HTVVideoCategoryAll,
    HTVVideoCategoryPolitics,
    HTVVideoCategoryEconomics,
    HTVVideoCategorySociety,
    HTVVideoCategoryCulture,
    HTVVideoCategoryWorld
} HTVVideoCategory;


typedef enum
{
    HTVLiveLinkSourceDefault,
    HTVLiveLinkSourceAPI,
    HTVLiveLinkSourceGdata,
} HTVLiveLinkSource;



#import <Foundation/Foundation.h>
#import "Video.h"
#import "Twitt.h"

@interface Data : NSObject
+ (Data *) sharedData;

- (void)updateLivePathTailFromSource:(HTVLiveLinkSource)source withCompletion:(void(^)(NSString *path, BOOL isNew))completion;

- (void)videoForCategory:(HTVVideoCategory)cat completion:(void(^)(NSMutableArray *result))completion;

- (void) youTubeURLFromHromadskeUrl:(NSURL *)url completion:(void(^)(NSString *resultString))completion;

@end
