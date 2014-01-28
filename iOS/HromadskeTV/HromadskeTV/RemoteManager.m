//
//  RemoteManager.m
//  HromadskeTV
//
//  Created by comonitos on 1/22/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "RemoteManager.h"

@implementation RemoteManager


+ (RemoteManager *) sharedManager {
    static RemoteManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[RemoteManager alloc] init];
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showRemoteActivity) name:START_SPINNER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideRemoteActivity) name:END_SPINNER
                                               object:nil];
}




- (void)showRemoteActivity {
    [[HTVHud sharedManager] startHUD];
}
- (void)hideRemoteActivity {
    [[HTVHud sharedManager] finishHUD];
}

@end
