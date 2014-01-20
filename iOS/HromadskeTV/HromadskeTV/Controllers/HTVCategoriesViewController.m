//
//  HTVCategoriesViewController.m
//  HromadskeTV
//
//  Created by Max Tymchii on 12/3/13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//

#import "HTVCategoriesViewController.h"
#import "UIViewController+HTVNavigationController.h"

#define SECTION_MAIN    0
#define MAIN_PAGES          @"Основні сторінки"
#define ONLINE_ROW          @(0)
#define HOT_NEWS_ROW        @(1)
#define TWITTER_NEWS_ROW    @(2)
#define HOME_ROW            @(3)
#define VIDEO_ROW           @(4)
#define ABOUT_US_ROW        @(5)


#define SECTION_SOCIAL  1
#define SOCIAL_PAGES        @"Соц. мережі"
#define FB_ROW              @(0)
#define GOOGLE_PLUS         @(1)
#define RSS_ROW             @(2)
#define SHARE_FRIENDS_ROW   @(3)
#define WRITE_TO_DEVELOPER  @(4)

#define  SECTIONS_NUMBER 2



@interface HTVCategoriesViewController ()<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *tableStructure;
@property (nonatomic, strong) NSDictionary *socialNetworks;
@property (nonatomic, strong) REActivityViewController *activityVC;
@property (nonatomic, strong) UIPopoverController *popoverVC;
@property (nonatomic, strong) MFMailComposeViewController *picker;
@end

@implementation HTVCategoriesViewController

- (REActivityViewController *)activityVC
{
    if (!_activityVC) {
        REFacebookActivity *facebookActivity = [[REFacebookActivity alloc] init];
        RETwitterActivity *twitterActivity = [[RETwitterActivity alloc] init];
        REVKActivity *vkActivity = [[REVKActivity alloc] initWithClientId:VK_API_KEY];
        REMessageActivity *messageActivity = [[REMessageActivity alloc] init];
        REMailActivity *mailActivity = [[REMailActivity alloc] init];
        REInstapaperActivity *instapaperActivity = [[REInstapaperActivity alloc] init];
        REKipptActivity *kipptActivity = [[REKipptActivity alloc] init];
        
        
        // Compile activities into an array, we will pass that array to
        // REActivityViewController on the next step
        //
        NSArray *activities = @[facebookActivity, twitterActivity, vkActivity,
                                messageActivity, mailActivity,  instapaperActivity,
                                kipptActivity];
        
        // Create REActivityViewController controller and assign data source
        //
        _activityVC = [[REActivityViewController alloc] initWithViewController:self activities:activities];
        _activityVC.userInfo = @{
                                            @"text":[NSString stringWithFormat:@"Я дивлюсь HromadskeTV через цей додаток %@ #HromadskeTV", APP_URL]
                                            };
    }
    
    return _activityVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - TableView Delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_MAIN) {
        if (indexPath.row == HOT_NEWS_ROW.integerValue) {
            [DELEGATE showVideoCollectionController];
        }
        else {
        [DELEGATE pushToCenterDeckControllerWithURL:self.tableStructure[@(indexPath.row)][1]];
        }
    }
    else if (indexPath.section == SECTION_SOCIAL) {
        if (indexPath.row == SHARE_FRIENDS_ROW.integerValue) {
            [[GAI sharedInstance].defaultTracker send:[[[GAIDictionaryBuilder createAppView] set:SHARE_SCREEN
                                                                                          forKey:kGAIScreenName] build]];
            [self showSharing];
        }
        else if (indexPath.row == WRITE_TO_DEVELOPER.integerValue) {
            [self sendEmailToRecipient];
        }
        else {
            [[GAI sharedInstance].defaultTracker send:[[[GAIDictionaryBuilder createAppView] set:self.socialNetworks[@(indexPath.row)][2]
                                                                                          forKey:kGAIScreenName] build]];
            [DELEGATE pushToCenterDeckControllerWithURL:self.socialNetworks[@(indexPath.row)][1]];
        }        
    }
    
}

#pragma mark - data source
- (NSDictionary *)tableStructure
{
    if (!_tableStructure) {
        _tableStructure = @{
                            ONLINE_ROW : @[@"Громадське онлайн", ONLINE_URL, ONLINE_SCREEN],
                            HOME_ROW : @[@"Головна",HOME_URL, HOME_SCREEN],
                            VIDEO_ROW : @[@"Відеоновини", VIDEO_URL, VIDEO_SCREEN],
                            ABOUT_US_ROW  : @[@"Про проект", ABOUT_US_URL, ABOUT_SCREEN],
                            HOT_NEWS_ROW : @[HOT_NEWS],
                            TWITTER_NEWS_ROW : @[TWITTER_NEWS, TWITTER_URL,TWITTER_SCREEN]
                            };
    }
    return _tableStructure;
}


- (NSDictionary *)socialNetworks
{
    if (!_socialNetworks) {
        _socialNetworks = @{
                            FB_ROW : @[@"Facebook", FB_URL, FB_SCREEN],
                            GOOGLE_PLUS : @[@"G+", G_PLUS_URL, G_PLUS_SCREEN],
                            RSS_ROW : @[@"RSS", RSS_URL, RSS_URL],
                            SHARE_FRIENDS_ROW : @[@"Розповісти друзям"],
                            WRITE_TO_DEVELOPER : @[@"Написати розробнику"]};
    }
    return _socialNetworks;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SECTIONS_NUMBER;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == SECTION_MAIN) {
        return self.tableStructure.allKeys.count;
    }
    else if (section == SECTION_SOCIAL) {
        return self.socialNetworks.allKeys.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == SECTION_MAIN) {
        return MAIN_PAGES;
    }
    else {
        return SOCIAL_PAGES;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleCell"
                                                            forIndexPath:indexPath];
    if (indexPath.section == SECTION_MAIN) {
        cell.textLabel.text = self.tableStructure[@(indexPath.row)][0];
    }
    else if (indexPath.section == SECTION_SOCIAL) {
        cell.textLabel.text = self.socialNetworks[@(indexPath.row)][0];
    }
    
    return cell;
}

#pragma mark - Sharing
- (void)showSharing
{
    if (IS_IPHONE) {
        [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
            if (success) {
                 [self.activityVC presentFromRootViewController];
            }
        }];
    }
    else {
        self.popoverVC = [[UIPopoverController alloc] initWithContentViewController:self.activityVC];
        self.activityVC.presentingPopoverController = self.popoverVC;
        [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
            if (success) {
                CGFloat shift = 48;
                if (IOS_7) {
                    shift = 68;
                }
                [self.popoverVC presentPopoverFromRect:CGRectMake(0, shift, 1, 1) inView:self.viewDeckController.centerController.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            }
        }];
    }
}


#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString * message;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            message = @"Відправку листа скасовано";
            break;
        case MFMailComposeResultSaved:
            message = @"Повідомлення збережено";
            break;
        case MFMailComposeResultSent:
            message = @"Повідомлення відправлено";
            break;
        case MFMailComposeResultFailed:
            message = @"Повідомлення не відправлено";
            break;
        default:
            message = @"Повідомлення не відправлено";
            break;
    }
    [self.picker dismissViewControllerAnimated:YES completion:NULL];
    [HTVHelperMethods callCustomAlertWithMessage:message];
}

#pragma mark - Email
- (void)sendEmailToRecipient
{
    if([MFMailComposeViewController canSendMail]){
        self.picker = [[MFMailComposeViewController alloc] init];
        self.picker.mailComposeDelegate = self;
        [self.picker setToRecipients:@[EMAIL_ADDRESS]];
        [self.picker setSubject:EMAIL_SUBJECT];
        [self presentViewController:self.picker animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
    else {
           [HTVHelperMethods callCustomAlertWithMessage:EMAIL_ERROR_MESSAGE];
    }
}

@end
