//
//  HTVAppDelegate.m
//  HromadskeTV
//
//  Created by Max Tymchii on 12/3/13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//


#import "HTVAppDelegate.h"
#import "HTVMenuViewController.h"
#import "HTVWebVC.h"
#import "HTVVideoCollectionVC.h"
#import "HTVTwitterCollection.h"
#import "UIViewController+HTVNavigationController.h"

@interface HTVAppDelegate()
@property (nonatomic, strong) UIStoryboard *storyboard;
@property (nonatomic, strong) AFHTTPClient *client;
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
    [self initGoogleAnalytics];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(spinnerStart) name:START_SPINNER object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(spinnerEnd) name:END_SPINNER
                                               object:nil];
   
    
    [self detectInternetStatus];
    [self youtubePath];
    [[GAI sharedInstance].defaultTracker send:[[[GAIDictionaryBuilder createAppView] set:ONLINE_SCREEN
                                                      forKey:kGAIScreenName] build]];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
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
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [self youtubePath];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Updates the device token and registers the token with UA. This won't occur until
    // push is enabled if the outlined process is followed. This call is required.
    [self sendDeviceToken:deviceToken];
}

- (void)sendDeviceToken:(NSData *)token
{
    NSMutableString *deviceToken = [NSMutableString stringWithCapacity:([token length] * 2)];
    const unsigned char *bytes = (const unsigned char *)[token bytes];
    
    for (NSUInteger i = 0; i < [token length]; i++) {
        [deviceToken appendFormat:@"%02X", bytes[i]];
    }
    NSURL *url = [NSURL URLWithString:DEVICE_TOKEN_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    NSDictionary *params = @{@"deviceID" : deviceToken,
                             @"platform": @"ios"};
    
    [httpClient postPath:@"/devices"
              parameters:params
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {

                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     
                 }];

}

- (void)youtubePath
{
    NSURL *url = [NSURL URLWithString:ONLINE_URL_PATH];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient getPath:nil
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                    NSDictionary *result = (NSDictionary *)json;
                    NSString *youtubeLink = [result objectForKey:@"youtube_link"];
                    NSString *youtubeTail = [[youtubeLink componentsSeparatedByString:@"embed/"] lastObject];
                    NSLog(@"Tail %@ ", youtubeTail);
                    NSString *oldLink = [HTVHelperMethods youtubeLink];
                    if (![youtubeTail isEqualToString:oldLink]) {
                        [HTVHelperMethods saveYouTubeLink:youtubeTail];
                        [DELEGATE pushToCenterDeckControllerWithURL:[HTVHelperMethods fullYoutubeLink]];
                    }
                    
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error %@", error);
                }];
}



- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
}


- (void)makeDeckRootViewController
{
    HTVMenuViewController* leftController = [self.storyboard instantiateViewControllerWithIdentifier:@"HTVCategoriesViewController"];
    HTVWebVC *centerController = [self.storyboard instantiateViewControllerWithIdentifier:@"HTVWebVC"];
    centerController.URL = [NSURL URLWithString:ONLINE_URL];
    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:[[UINavigationController alloc] initWithRootViewController:centerController]
                                                                                    leftViewController:leftController
                                                                                   rightViewController:nil];
    [deckController setLeftSize:LEFT_RIGHT_CONTROLLER_SHIFT];
    [deckController setRightSize:LEFT_RIGHT_CONTROLLER_SHIFT];
    deckController.elastic = NO;
    deckController.panningMode = IIViewDeckNoPanning;
    deckController.delegate = self;
    
    self.window.rootViewController = deckController;
}


- (void)showVideoCollectionController
{
    [self showViewControllerWithIdentifier:@"HTVVideoCollectionVC"];
}

- (void)showTwitterCollectionController
{
    [self showViewControllerWithIdentifier:@"HTVTwitterCollection"];
}

- (void)showViewControllerWithIdentifier:(NSString *)identifier
{
    IIViewDeckController *deckVC = (IIViewDeckController *)self.window.rootViewController;
    UIViewController *newCenterVC = nil;
    @try {
        newCenterVC = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        
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

- (void)initGoogleAnalytics
{
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = GA_TIME_INTERVAL;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
    
    // Initialize tracker.
    [[GAI sharedInstance] trackerWithTrackingId:GA_TRACKER_KEY];
}


- (void)detectInternetStatus
{
    self.client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://google.com"]];
    [self.client setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [HTVHelperMethods callCustomAlertWithMessage:NO_INTERNET_COONECTION];
        }
    }];

}

- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString {
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    
    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;
        
        NSString *key = pair[0];
        NSString *value = pair[1];
        
        md[key] = value;
    }
    
    return md;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([[url scheme] isEqualToString:@"hromadsketv"] == NO) return NO;
    
    NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];
    
    NSString *token = d[@"oauth_token"];
    NSString *verifier = d[@"oauth_verifier"];
    
    IIViewDeckController *vcn = (IIViewDeckController *)self.window.rootViewController;
    HTVTwitterCollection *vc = (HTVTwitterCollection *)([vcn.centerController childViewControllers][0]);
    [vc setOAuthToken:token oauthVerifier:verifier];
    
    return YES;
}

#pragma mark - IIViewDeckControllerDelegate
- (void)viewDeckController:(IIViewDeckController*)viewDeckController willOpenViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated {
    IIViewDeckSide _style = (viewDeckSide != IIViewDeckTopSide) ? HTVStatusBarStyleDark : HTVStatusBarStyleLight;
    [self setupStatusBarAnimated:YES style:_style];
}
- (void)viewDeckController:(IIViewDeckController*)viewDeckController willCloseViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated {
    IIViewDeckSide _style = (viewDeckSide != IIViewDeckTopSide) ? HTVStatusBarStyleLight : HTVStatusBarStyleDark;
    [self setupStatusBarAnimated:YES style:_style];
}
- (void) setupStatusBarAnimated:(BOOL)animated style:(HTVStatusBarStyle)style {
    if (IOS_7) {
        UIStatusBarStyle _style = (style == HTVStatusBarStyleDark) ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
        [[UIApplication sharedApplication] setStatusBarStyle:_style animated:animated];
    }
}

@end
