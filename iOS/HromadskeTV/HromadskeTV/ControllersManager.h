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
#import "NewsViewController.h"


#import "HTVWebVC.h"
#import "YoutubeViewController.h"
#import "HTVTwitterCollection.h"

@interface ControllersManager : NSObject
{
}

+ (ControllersManager *) sharedManager;

- (HTVMenuViewController *) menu;
- (LiveViewController *) live;
- (IIViewDeckController *) deck;
- (NewsViewController *) news;


- (void) setNewLiveUrl:(NSURL *)url;

- (void) openMenu;
- (void) closeMenu;

- (UIStoryboard *)storyboard;


- (void)pushToCenterDeckControllerWithURL:(NSString *)url;
- (void)showVideoCollectionController;
- (void)showTwitterCollectionController;

- (void)showLiveViewController;
- (void)showNewsViewController;

- (void)showUserVoiceController;
- (void)showUserVoiceFeedbackController;
@end
