//
//  ControllersManager.h
//  HromadskeTV
//
//  Created by comonitos on 1/21/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import <Foundation/Foundation.h>

//controllers
#import "IIViewDeckController.h"
#import "LiveViewController.h"
#import "HTVMenuViewController.h"
#import "HTVWebVC.h"
#import "HTVVideoCollectionVC.h"
#import "HTVTwitterCollection.h"

@interface ControllersManager : NSObject
{
}

+ (ControllersManager *) sharedManager;

- (HTVMenuViewController *) menu;
- (LiveViewController *) live;
- (IIViewDeckController *) deck;


- (void) setNewLiveUrl:(NSURL *)url;

- (void) openMenu;
- (void) closeMenu;

- (UIStoryboard *)storyboard;


- (void)pushToCenterDeckControllerWithURL:(NSString *)url;
- (void)showVideoCollectionController;
- (void)showTwitterCollectionController;

- (void)showLiveViewController;
@end
