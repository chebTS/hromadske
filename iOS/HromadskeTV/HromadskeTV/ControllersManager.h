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
#import "MenuViewController.h"
#import "NewsViewController.h"


#import "HTVWebVC.h"
#import "YoutubeViewController.h"
#import "HTVTwitterCollection.h"

@interface ControllersManager : NSObject
{
}

+ (ControllersManager *) sharedManager;

- (MenuViewController *)menu;
- (LiveViewController *)live;
- (IIViewDeckController *)deck;
- (NewsViewController *)news;


- (void)setNewLiveUrl:(NSURL *)url;

- (void)openMenu;
- (void)closeMenu;

- (UIStoryboard *)storyboard;


- (void)showWebViewControllerWithURL:(NSString *)url;
- (void)showVideoCollectionController;
- (void)showTwitterCollectionController;

- (void)showLiveViewController;
- (void)showNewsViewController;
- (void)showAboutViewController;
- (void)showSharing;

- (void)showUserVoiceController;
- (void)showUserVoiceFeedbackController;

- (void)showRateInAppStore;
- (void)showEmailToHromadskeController;
@end
