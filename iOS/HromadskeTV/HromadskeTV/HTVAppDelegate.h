//
//  HTVAppDelegate.h
//  HromadskeTV
//
//  Created by Max Tymchii on 12/3/13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTwitterAPI.h"
#import "IIViewDeckController.h"

@interface HTVAppDelegate : UIResponder <UIApplicationDelegate, IIViewDeckControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) STTwitterAPI *twitter;
- (void)spinnerStart;
- (void)spinnerEnd;
- (void)pushToCenterDeckControllerWithURL:(NSString *)url;
- (void)showVideoCollectionController;
- (void)showTwitterCollectionController;
@end
