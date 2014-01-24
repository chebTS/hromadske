//
//  HTVAppDelegate.m
//  HromadskeTV
//
//  Created by Max Tymchii on 12/3/13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//


#import "HTVAppDelegate.h"
#import "ControllersManager.h"
#import "Data.h"
#import "RemoteManager.h"

#import "HTVTwitterCollection.h"

@implementation HTVAppDelegate

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
    self.window.rootViewController = [[ControllersManager sharedManager] deck];

    [self initAnalytics];
    [self updateLiveStatus];
    [RemoteManager sharedManager];

    [[GAI sharedInstance].defaultTracker send:[[[GAIDictionaryBuilder createAppView] set:ONLINE_SCREEN forKey:kGAIScreenName] build]];

    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [self updateLiveStatus];
}

#pragma mark - Stuff
- (void)initAnalytics
{
    UVConfig *config = [UVConfig configWithSite:USER_VOICE_URL];
    [UserVoice initialize:config];

    
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = GA_TIME_INTERVAL; // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone]; // Optional: set Logger to VERBOSE for debug information.
    [[GAI sharedInstance] trackerWithTrackingId:GA_TRACKER_KEY]; // Initialize tracker.
}

- (void) updateLiveStatus {
    [[Data sharedData] updateLivePathWithCompletion:^(NSString *path, BOOL isNew) {
        [[ControllersManager sharedManager] setNewLiveUrl:[NSURL URLWithString:[HTVHelperMethods fullYoutubeLink]]];
    }];
}


#pragma mark - push
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
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


#pragma mark - Scheme
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


@end
