//
//  HTVCategoriesViewController.m
//  HromadskeTV
//
//  Created by Max Tymchii on 12/3/13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//

#import "ControllersManager.h"
#import "UIViewController+HTVNavigationController.h"

typedef enum {
    HTVMenuSectionMain,
    HTVMenuSectionSocial,
    HTVMenuSectionOther,
} HTVMenuSection;
#define  SECTIONS_NUMBER 3


#define MAIN_PAGES          @"Основні сторінки"
#define HTVMenuItemLive     @(0)
#define HTVMenuItemNews     @(1)
#define HTVMenuItemAbout    @(2)

#define SOCIAL_PAGES        @"Сторінки проекту"
#define HTVMenuItemFacebook @(0)
#define HTVMenuItemTwitter  @(1)
#define HTVMenuItemYoutube  @(2)
#define HTVMenuItemGoogle   @(3)

#define OTHER_PAGES         @"Інше"
#define HTVMenuItemShare    @(0)
#define HTVMenuItemFeedback @(1)



@interface HTVMenuViewController ()<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
{
    NSDictionary *_mainPageItems;
    NSDictionary *_socialPageItems;
    NSDictionary *_otherPageItems;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) REActivityViewController *activityVC;
@property (nonatomic, strong) UIPopoverController *popoverVC;
@property (nonatomic, strong) MFMailComposeViewController *picker;
@end

@implementation HTVMenuViewController

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
    [self setupData];
    [self setupView];
}

- (void)setupView {
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = [Utils colorFromHtmlSting:@"#F5F5F5"];
    [_tableView reloadData];
}

#pragma mark - TableView Delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    HTVMenuSection section = indexPath.section;
    NSNumber *row = @(indexPath.row);
        
    switch (section) {
        case HTVMenuSectionMain:
            if (indexPath.row == HTVMenuItemLive.integerValue) {
                [[ControllersManager sharedManager] showLiveViewController];
            } else if (indexPath.row == HTVMenuItemNews.integerValue) {
                [[ControllersManager sharedManager] showNewsViewController];
            } else {
                [[ControllersManager sharedManager] pushToCenterDeckControllerWithURL:_mainPageItems[@(indexPath.row)][1]];
            }

            break;
        case HTVMenuSectionSocial:
            [[GAI sharedInstance].defaultTracker send:[[[GAIDictionaryBuilder createAppView] set:_socialPageItems[@(indexPath.row)][2] forKey:kGAIScreenName] build]];
            if (indexPath.row == HTVMenuItemYoutube.integerValue) {
                [[ControllersManager sharedManager] showVideoCollectionController];
            } else {
                [[ControllersManager sharedManager] pushToCenterDeckControllerWithURL:_socialPageItems[@(indexPath.row)][1]];
            }
            break;
        case HTVMenuSectionOther:
            if ([row isEqualToNumber:HTVMenuItemShare]) {
                [[GAI sharedInstance].defaultTracker send:[[[GAIDictionaryBuilder createAppView] set:SHARE_SCREEN
                                                                                              forKey:kGAIScreenName] build]];
                [self showSharing];
            }
            else if ([row isEqualToNumber:HTVMenuItemFeedback]) {
                [self sendEmailToRecipient];
            }
        break;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , tableView.frame.size.width, 21)];
    sectionView.backgroundColor = [Utils colorFromHtmlSting:@"#B2B2B2"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(9, 2, tableView.frame.size.width, 17)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    
    [sectionView addSubview:label];

    return sectionView;
}

#pragma mark - data source
- (void)setupData
{
    _mainPageItems = @{
                        HTVMenuItemLive : @[ONLINE_PAGE, ONLINE_URL, ONLINE_SCREEN],
                        HTVMenuItemAbout  : @[ABOUT_US_PAGE, ABOUT_US_URL, ABOUT_SCREEN],
                        HTVMenuItemNews : @[HOT_NEWS_PAGE]
                        };
    _socialPageItems = @{
                         HTVMenuItemTwitter : @[TWITTER_PAGE, TWITTER_URL,TWITTER_SCREEN],
                         HTVMenuItemFacebook : @[FB_PAGE, FB_URL, FB_SCREEN],
                         HTVMenuItemYoutube : @[YOUTUBE_PAGE,@"",YOUTUBE_SCREEN],
                         HTVMenuItemGoogle : @[G_PLUS_PAGE, G_PLUS_URL, G_PLUS_SCREEN]};
    _otherPageItems = @{HTVMenuItemShare : @[SHARE_FRIENDS_PAGE],
                        HTVMenuItemFeedback : @[WRITE_TO_DEVELOPER_PAGE]};
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SECTIONS_NUMBER;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HTVMenuSection _section = (HTVMenuSection)section;
    switch (_section) {
        case HTVMenuSectionMain:
            return _mainPageItems.allKeys.count;
        case HTVMenuSectionSocial:
            return _socialPageItems.allKeys.count;
        case HTVMenuSectionOther:
            return _otherPageItems.allKeys.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    HTVMenuSection _section = (HTVMenuSection)section;
    switch (_section) {
        case HTVMenuSectionMain:
            return MAIN_PAGES;
        case HTVMenuSectionSocial:
            return SOCIAL_PAGES;
        case HTVMenuSectionOther:
            return OTHER_PAGES;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleCell"
                                                            forIndexPath:indexPath];
    HTVMenuSection _section = indexPath.section;

    switch (_section) {
        case HTVMenuSectionMain:
            cell.textLabel.text = _mainPageItems[@(indexPath.row)][0];
            break;
        case HTVMenuSectionSocial:
            cell.textLabel.text = _socialPageItems[@(indexPath.row)][0];
            break;
        case HTVMenuSectionOther:
            cell.textLabel.text = _otherPageItems[@(indexPath.row)][0];
            break;
    }
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica Light" size:18];
//    cell.textLabel.textColor = [Utils colorFromHtmlSting:@"#33a9dc"];
    cell.backgroundColor = [Utils colorFromHtmlSting:@"#F5F5F5"];
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
