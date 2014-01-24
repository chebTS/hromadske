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
    HTVVideoCategoryInvestigation,
    HTVVideoCategoryH2o,
    HTVVideoCategoryGuests,
} HTVVideoCategory;




#import <Foundation/Foundation.h>
#import "Video.h"
#import "Twitt.h"

@interface Data : NSObject
+ (Data *) sharedData;

- (void)updateLivePathWithCompletion:(void(^)(NSString *path, BOOL isNew))completion;

- (void)videoForCategory:(HTVVideoCategory)cat completion:(void(^)(NSMutableArray *result))completion;
@end
