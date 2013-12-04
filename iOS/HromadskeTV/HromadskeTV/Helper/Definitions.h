#import "HTVAppDelegate.h"
#define DELEGATE ((HTVAppDelegate *)([[UIApplication sharedApplication] delegate]))
#define IOS_7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 ? YES : NO)
//#define NSLog(...)

#define APP_URL @"http://google.com"
#define VK_API_KEY @"4038987"
#define START_SPINNER @"Start spinner"
#define END_SPINNER @"End spinner"



#define LEFT_RIGHT_CONTROLLER_SHIFT IS_IPHONE ? 100.0 : 500
#define IS_IPHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds ].size.height == HEIGHT_IPHONE_5)

#define STORY_BOARD (IS_IPHONE ? @"Main_iPhone" : @"Main_iPad")

#define HOME_URL               @"http://hromadske.tv"
#define VIDEO_URL     HOME_URL @"/video"
#define INTERVIEW_URL HOME_URL @"/interview"
#define PROGRAMS_URL  HOME_URL @"/programs"
#define ABOUT_US_URL  HOME_URL @"/about"
#define YOUTUBE_URL            @"http://www.youtube.com/user/HromadskeTV/featured"

#define TWITTER_URL @"https://twitter.com/HromadskeTV"
#define FB_URL      @"https://www.facebook.com/hromadsketv"
#define G_PLUS_URL  @"https://plus.google.com/+HromadskeTvUkraine/posts"
#define RSS_URL     @"http://hromadske.tv/rss"
