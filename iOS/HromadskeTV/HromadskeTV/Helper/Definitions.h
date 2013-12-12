#import "HTVAppDelegate.h"
#define DELEGATE ((HTVAppDelegate *)([[UIApplication sharedApplication] delegate]))
#define IOS_7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 ? YES : NO)
#define NSLog(...)

#define APP_NAME @"HromadskeTV"
#define EMAIL_ADDRESS @"Samback@ukr.net"
#define EMAIL_SUBJECT @"Поради та пропозиції"
#define NO_INTERNET_COONECTION @"Будь-ласка, впевніться, що у Вас доступна мережа Internet"

#define EMAIL_ERROR_MESSAGE NSLocalizedString (@"Неможливо надіслати повідомлення. Не налаштовано надсилання почтових повідомлень.", @"Alert error when problem with email configuration")

#define DEVICE_TOKEN_URL @"http://hrom.fedr.co/devices"
#define APP_URL @"http://itunes.apple.com/app/id774631543"
#define VK_API_KEY @"4038987"
#define START_SPINNER @"Start spinner"
#define END_SPINNER @"End spinner"
#define  GA_TIME_INTERVAL 60
#define  GA_TRACKER_KEY @"UA-46233904-1"



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

#define HOME_SCREEN @"Home"
#define VIDEO_SCREEN @"Video"
#define INTERVIEW_SCREEN @"Interview"
#define PROGRAMS_SCREEN @"Programs"
#define ABOUT_SCREEN @"About"
#define YOUTUBE_SCREEN @"Youtube"
#define TWITTER_SCREEN @"TWITTER"
#define FB_SCREEN @"Facebook"
#define G_PLUS_SCREEN @"G+"
#define SHARE_SCREEN @"Share"
#define EMAIL_SCREEN @"Email"
