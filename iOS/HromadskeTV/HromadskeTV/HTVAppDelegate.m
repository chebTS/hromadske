//
//  HTVAppDelegate.m
//  HromadskeTV
//
//  Created by Max Tymchii on 12/3/13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//


#import "HTVAppDelegate.h"
#import "HTVCategoriesViewController.h"
#import "HTVWebVC.h"

@interface HTVAppDelegate()
@property (nonatomic, strong) UIStoryboard *storyboard;
@end

@implementation HTVAppDelegate


- (UIStoryboard *)storyboard
{
    if(!_storyboard) {
        _storyboard = [UIStoryboard storyboardWithName:STORY_BOARD bundle:[NSBundle mainBundle]];
    }
    return _storyboard;
}

- (UIWindow *)window
{
    if(!_window) {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return _window;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self makeDeckRootViewController];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(spinnerStart) name:START_SPINNER object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(spinnerEnd) name:END_SPINNER
                                               object:nil];
    
    UAConfig *config = [UAConfig defaultConfig];
    
    // You can also programmatically override the plist values:
    // config.developmentAppKey = @"YourKey";
    // etc.
    
    // Call takeOff (which creates the UAirship singleton)
    [UAirship takeOff:config];
    
    [UAPush shared].notificationTypes = (UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert
                                         );
    [[UAPush shared] registerForRemoteNotifications];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    UA_LINFO(@"APNS device token: %@", deviceToken);
    
    // Updates the device token and registers the token with UA. This won't occur until
    // push is enabled if the outlined process is followed. This call is required.
    [[UAPush shared] registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    UA_LINFO(@"Received remote notification: %@", userInfo);
    
    // Fire the handlers for both regular and rich push
    [[UAPush shared] handleNotification:userInfo applicationState:application.applicationState];
    [UAInboxPushHandler handleNotification:userInfo];
}

- (void)makeDeckRootViewController
{
    HTVCategoriesViewController* leftController = [self.storyboard instantiateViewControllerWithIdentifier:@"HTVCategoriesViewController"];
    HTVWebVC *centerController = [self.storyboard instantiateViewControllerWithIdentifier:@"HTVWebVC"];
    centerController.URL = [NSURL URLWithString:HOME_URL];
    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:[[UINavigationController alloc] initWithRootViewController:centerController]
                                                                                    leftViewController:leftController
                                                                                   rightViewController:nil];
    [deckController setLeftSize:LEFT_RIGHT_CONTROLLER_SHIFT];
    [deckController setRightSize:LEFT_RIGHT_CONTROLLER_SHIFT];
    deckController.elastic = NO;
    deckController.panningMode = IIViewDeckNoPanning;
    
    self.window.rootViewController = deckController;
}



- (void)pushToCenterDeckControllerWithURL:(NSString *)url
{
    IIViewDeckController *deckVC = (IIViewDeckController *)self.window.rootViewController;
    HTVWebVC *newCenterVC = nil;
    @try {
        newCenterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HTVWebVC"];
        ((HTVWebVC *)newCenterVC).URL = [NSURL URLWithString:url];
    }
    @catch (NSException *exception) {
        return;
    }
    @finally {
        if (newCenterVC) {
            UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:newCenterVC];
            deckVC.centerController = navigationVC;
            [deckVC closeLeftViewAnimated:YES];
        }
    }    
}


- (void)spinnerStart
{
    [[HTVHud sharedManager] startHUD];
}

- (void)spinnerEnd
{
    [[HTVHud sharedManager] finishHUD];
}


@end
