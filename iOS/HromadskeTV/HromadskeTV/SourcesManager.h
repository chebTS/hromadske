//
//  SourcesManager.h
//  HromadskeTV
//
//  Created by comonitos on 5/8/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoStream.h"
#import "RadioStream.h"

@protocol SourcesManagerDelefate;

@interface SourcesManager : NSObject
{
}

@property (nonatomic, assign) id <SourcesManagerDelefate> delegate;
@property (nonatomic) int selectedVideoIndex;
@property (nonatomic) int selectedRadioIndex;

+ (instancetype) sharedManager;

- (NSArray *) videoSources;
- (NSArray *) radioSources;

- (void) updateSources;
- (void) updateSourcesWithCompletion:(void(^)(void))completion;

- (VideoStream *)lastVideoStream;
- (RadioStream *)lastRadioStream;
@end

@protocol SourcesManagerDelefate <NSObject>

@required
- (void) sourcesManagerdidUpdateSources:(SourcesManager *)manager withNewStatus:(BOOL)yes;

@end
