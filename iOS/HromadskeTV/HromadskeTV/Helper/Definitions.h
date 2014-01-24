#import "HTVAppDelegate.h"
#import "HTVHelperMethods.h"

#define DELEGATE ((HTVAppDelegate *)([[UIApplication sharedApplication] delegate]))
#define IOS_7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 ? YES : NO)
#define NSLog(...)

#define APP_NAME @"HromadskeTV"
#define EMAIL_ADDRESS @"hromadsketv@ukr.net"
#define EMAIL_SUBJECT @"Поради та пропозиції"
#define NO_INTERNET_COONECTION @"Будь-ласка, впевніться, що у Вас доступна мережа Internet"

#define EMAIL_ERROR_MESSAGE NSLocalizedString (@"Неможливо надіслати повідомлення. Не налаштовано надсилання почтових повідомлень.", @"Alert error when problem with email configuration")

#define DEVICE_TOKEN_URL @"http://hrom.fedr.co"

#define USER_VOICE_URL @"hromadsketv.uservoice.com"
#define APP_URL @"http://appstore.com/fredcox/hromadsketv"
#define VK_API_KEY @"4038987"
#define START_SPINNER @"Start spinner"
#define END_SPINNER @"End spinner"
#define  GA_TIME_INTERVAL 60
#define  GA_TRACKER_KEY @"UA-46233904-1"

#define TWITTER_CONSUMER_KEY @"ZrwdZEFmZUXi3RTlJ6657Q"
#define TWITTER_CONSUMER_SECRET_KEY	@"UpJZYsqtUXurZSbz2Rjyo2s2IQdWrNs8zsMlmGeZM"
#define TWITTER_ACCESS_APP_KEY @"581677616-jZamn159Gd29ZtXP2yOmK67b8AzXHIFeJnEFviNR"
#define TWITTER_ACCESS_APP_SECRET_KEY @"1e5V6s7Soq1oHCJijmUbEnhSVd1zemhtl9jIiRQzOnedt"


#define LEFT_RIGHT_CONTROLLER_SHIFT IS_IPHONE ? 50.0 : 500
#define IS_IPHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds ].size.height == HEIGHT_IPHONE_5)

#define STORY_BOARD (IS_IPHONE ? @"Main_iPhone" : @"Main_iPad")

#define HOME_URL               @"http://hromadske.tv"
#define ONLINE_URL_PATH HOME_URL @"/youtube?new"
#define ONLINE_URL  [HTVHelperMethods fullYoutubeLink]  
#define VIDEO_URL     HOME_URL @"/video"
#define INTERVIEW_URL HOME_URL @"/interview"
#define PROGRAMS_URL  HOME_URL @"/programs"
#define ABOUT_US_URL  HOME_URL @"/about"
#define YOUTUBE_URL            @"http://www.youtube.com/user/HromadskeTV/featured"

#define TWITTER_URL @"https://twitter.com/HromadskeTV"
#define FB_URL      @"https://www.facebook.com/hromadsketv"
#define G_PLUS_URL  @"https://plus.google.com/+HromadskeTvUkraine/posts"
#define RSS_URL     @"http://hromadske.tv/rss"

#define ONLINE_SCREEN @"Online"
#define HOME_SCREEN @"Home"
#define VIDEO_SCREEN @"Video"
#define INTERVIEW_SCREEN @"Interview"
#define PROGRAMS_SCREEN @"Programs"
#define ABOUT_SCREEN @"About"
#define HOT_NEWS_SCREEN @"Hot News"
#define TWITTER_SCREEN @"TWITTER"
#define FB_SCREEN @"Facebook"
#define G_PLUS_SCREEN @"G+"
#define YOUTUBE_SCREEN @"Youtube"
#define SHARE_SCREEN @"Share"
#define EMAIL_SCREEN @"Email"

#define ONLINE_PAGE @"Громадське online"
#define ABOUT_US_PAGE @"Про проект"
#define HOT_NEWS_PAGE @"Новини"
#define TWITTER_PAGE @"Twitter"
#define FB_PAGE @"Facebook"
#define G_PLUS_PAGE @"Google+"
#define YOUTUBE_PAGE @"Youtube"
#define SHARE_FRIENDS_PAGE @"Розповісти друзям"
#define ADD_IDEAS @"Додати пропозицію"
#define WRITE_TO_DEVELOPER_PAGE @"Написати розробникам"





#define URL_BASE                        @"http://hromadske.tv"
#define URL_PATH_VIDEO_ALL              @"video/rss"
#define URL_PATH_VIDEO_INVASTIGATIONS   @"slidstvo.info/rss"
#define URL_PATH_VIDEO_H2O              @"h2o/rss"
#define URL_PATH_VIDEO_GUESTS           @"starring/rss"


#define URL_HROMADSKE_YOUTUBE           @"http://www.youtube.com/user/HromadskeTV/featured"
#define URL_HROMADSKE_HELP              @"http://hromadske.tv/donate?"
