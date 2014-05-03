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
#import "Harpy.h"
#import <Appirater.h>
#import <AVFoundation/AVFoundation.h>

#import "HTVTwitterCollection.h"
#import "STTwitterAPI.h"

@interface HTVAppDelegate()
{
    NSDate *_lastOpened;
}
@property (nonatomic, strong) STTwitterAPI *twitter;
@end

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
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
	[[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker
							   error:&sessionError];
    [[AVAudioSession sharedInstance] setActive: YES withFlags:0 error:nil];
    
    //Launch urls/twitter if the user came from a push
    NSDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notification) {
        [self handlePush:notification];
    }
    
    self.window.rootViewController = [[ControllersManager sharedManager] deck];

    [self initAnalytics];
	[self initHelpers];
	
    [RemoteManager sharedManager];

    [[GAI sharedInstance].defaultTracker send:[[[GAIDictionaryBuilder createAppView] set:ONLINE_SCREEN forKey:kGAIScreenName] build]];

    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSTimeInterval time = abs([_lastOpened timeIntervalSinceNow]);
    if (time > 1800 || !_lastOpened) {
        [self updateLiveStatus];
        _lastOpened = [NSDate date];
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (application.applicationState != UIApplicationStateActive) {
        [self handlePush:userInfo];
    }
}

- (void)handlePush:(NSDictionary *)userInfo
{
    NSString *url = [userInfo objectForKey:@"u"];
    if (url) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
			[[ControllersManager sharedManager] pushWebViewControllerToLiveWithURL:url];
        });
    }
    else {
        NSString *tweetID = [userInfo objectForKey:@"i"];
        if (tweetID) {
            NSURL *twitterApp = [NSURL URLWithString:[NSString stringWithFormat:@"twitter://status?id=%@", tweetID]];
            if ([[UIApplication sharedApplication] canOpenURL:twitterApp]) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [[UIApplication sharedApplication] openURL:twitterApp];
                });
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^(void){
					NSString *stringURL = [NSString stringWithFormat:@"https://twitter.com/t/status/%@", tweetID];
					[[ControllersManager sharedManager] pushWebViewControllerToLiveWithURL:stringURL];
                });
            }
        }
    }
}

#pragma mark - Stuff
- (void)initAnalytics
{
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = GA_TIME_INTERVAL; // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone]; // Optional: set Logger to VERBOSE for debug information.
    [[GAI sharedInstance] trackerWithTrackingId:GA_TRACKER_KEY]; // Initialize tracker.
}
- (void) initHelpers {
	[Appirater setAppId:APP_STORE_ID];
	[Appirater setDaysUntilPrompt:3];
	[Appirater setUsesUntilPrompt:2];
	[Appirater setSignificantEventsUntilPrompt:-1];
	[Appirater setTimeBeforeReminding:2];
	[Appirater setDebug:NO];

	[Appirater appLaunched:YES];
	
	
    [[Harpy sharedInstance] setAppID:APP_STORE_ID];
    [[Harpy sharedInstance] setAppName:@"HromadskeTV"];
    [[Harpy sharedInstance] setAlertType:HarpyAlertTypeOption];
    [[Harpy sharedInstance] setForceLanguageLocalization:HarpyLanguageRussian];
    [[Harpy sharedInstance] checkVersionDaily];
    
    
    
    UVConfig *config = [UVConfig configWithSite:USER_VOICE_URL];
    [UserVoice initialize:config];
}
- (void) updateLiveStatus {
    [[Data sharedData] updateLivePathTailFromSource:HTVLiveLinkSourceDefault withCompletion:^(NSString *path, BOOL isNew) {
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
    
#if DEBUG
    NSString *platform = @"iodev";
#else
    NSString *platform = @"ios";
#endif
    
    NSDictionary *params = @{@"deviceID" : deviceToken,
                             @"platform": platform};
    
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
