//
//  UINavigationController+HTVNavigationController.h
//  HromadskeTV
//
//  Created by comonitos on 1/20/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    HTVStatusBarStyleLight,
    HTVStatusBarStyleDark
} HTVStatusBarStyle;

@interface UIViewController (HTVNavigationController)

- (void) setupView;
- (void) updateViewWithStatsBarStyle:(HTVStatusBarStyle)style;

@end
