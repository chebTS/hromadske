//
//  RemoteManager.h
//  HromadskeTV
//
//  Created by comonitos on 1/22/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemoteManager : NSObject
+ (RemoteManager *) sharedManager;

- (void)showRemoteActivity;
- (void)hideRemoteActivity;

@end
