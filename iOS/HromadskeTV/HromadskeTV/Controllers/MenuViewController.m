//
//  HTVCategoriesViewController.m
//  HromadskeTV
//
//  Created by Max Tymchii on 12/3/13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//

#import "ControllersManager.h"
#import "UIViewController+HTVNavigationController.h"
#import "NewsViewController.h"

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
#define HTVMenuItemIdeas    @(1)
#define HTVMenuItemFeedback @(2)



@interface MenuViewController ()<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
{
    NSDictionary *_mainPageItems;
    NSDictionary *_socialPageItems;
    NSDictionary *_otherPageItems;
    
    NSString *_newsCategory;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupData];
    [self setupView];
    _newsCategory = [NewsViewController nameForCategory:HTVVideoCategoryHot];
}

- (void)setupView {
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
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
                [[ControllersManager sharedManager] showAboutViewController];
            }

            break;
        case HTVMenuSectionSocial:
            [[GAI sharedInstance].defaultTracker send:[[[GAIDictionaryBuilder createAppView] set:_socialPageItems[@(indexPath.row)][2] forKey:kGAIScreenName] build]];
            [[ControllersManager sharedManager] showWebViewControllerWithURL:_socialPageItems[@(indexPath.row)][1]];
            break;
        case HTVMenuSectionOther:
            if ([row isEqualToNumber:HTVMenuItemShare]) {
                [[GAI sharedInstance].defaultTracker send:[[[GAIDictionaryBuilder createAppView] set:SHARE_SCREEN
                                                                                              forKey:kGAIScreenName] build]];
                [[ControllersManager sharedManager] showSharing];
            }
            else if ([row isEqualToNumber:HTVMenuItemIdeas]) {
                [[ControllersManager sharedManager] showUserVoiceController];
            } else if ([row isEqualToNumber:HTVMenuItemFeedback]) {
                [[ControllersManager sharedManager] showUserVoiceFeedbackController];
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
                         HTVMenuItemYoutube : @[YOUTUBE_PAGE,URL_HROMADSKE_YOUTUBE,YOUTUBE_SCREEN],
                         HTVMenuItemGoogle : @[G_PLUS_PAGE, G_PLUS_URL, G_PLUS_SCREEN]};
    _otherPageItems = @{HTVMenuItemShare : @[SHARE_FRIENDS_PAGE],
                        HTVMenuItemIdeas : @[ADD_IDEAS],
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
    int row = indexPath.row;
    switch (_section) {
        case HTVMenuSectionMain:
            if (row == HTVMenuItemNews.intValue) {
                cell.textLabel.text = _newsCategory;
            } else {
                cell.textLabel.text = _mainPageItems[@(row)][0];
            }
            break;
        case HTVMenuSectionSocial:
            cell.textLabel.text = _socialPageItems[@(row)][0];
            break;
        case HTVMenuSectionOther:
            cell.textLabel.text = _otherPageItems[@(row)][0];
            break;
    }
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica Light" size:18];
//    cell.textLabel.textColor = [Utils colorFromHtmlSting:@"#33a9dc"];
    cell.backgroundColor = [Utils colorFromHtmlSting:@"#F5F5F5"];
    return cell;
}


#pragma mark - NewsViewControllerDelagate
- (void) newsViewController:(NewsViewController *)vc didChangeItem:(HTVVideoCategory)category {
    _newsCategory = [NewsViewController nameForCategory:category];
    [_tableView reloadData];
}

@end
