//
//  HTVAppDelegate.h
//  HromadskeTV
//
//  Created by Max Tymchii on 12/3/13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTVAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)spinnerStart;
- (void)spinnerEnd;
- (void)pushToCenterDeckControllerWithURL:(NSString *)url;
@end
