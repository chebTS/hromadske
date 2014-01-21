//
//  Data.h
//  HromadskeTV
//
//  Created by comonitos on 1/22/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject
+ (Data *) sharedData;

- (void)updateLivePathWithCompletion:(void(^)(NSString *path, BOOL isNew))completion;

@end
