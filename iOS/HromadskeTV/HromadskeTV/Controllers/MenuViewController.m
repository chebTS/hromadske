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
#import <Appirater.h>

typedef enum {
    HTVMenuSectionMain,
    HTVMenuSectionSocial,
    HTVMenuSectionOther,
} HTVMenuSection;
#define  SECTIONS_NUMBER 3


#define MAIN_PAGES          @"Основні"
#define HTVMenuItemLive     @(0)
#define HTVMenuItemNews     @(1)
#define HTVMenuItemAbout    @(2)

#define SOCIAL_PAGES        @"Сторінки проекту"
#define HTVMenuItemFacebook @(0)
#define HTVMenuItemTwitter  @(1)
#define HTVMenuItemYoutube  @(2)
#define HTVMenuItemGoogle   @(3)

#define OTHER_PAGES         @"Інше"
#define HTVMenuItemIdeas    @(0)
#define HTVMenuItemFeedback @(1)
#define HTVMenuItemEmail    @(2)
#define HTVMenuItemRate     @(3)
#define HTVMenuItemShare    @(4)




@interface MenuViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSDictionary *_mainPageItems;
    NSDictionary *_socialPageItems;
    NSDictionary *_otherPageItems;
    
    NSString *_newsCategory;
	__weak IBOutlet UIButton *_ratingStar;
}
- (IBAction)handleRating:(id)sender;

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
    
    _tableView.backgroundColor = [Utils colorFromHtmlSting:@"#252323"];
	_tableView.separatorColor = [Utils colorFromHtmlSting:@"#292929"];
    [_tableView reloadData];
	
	NSNumber *rated = [[NSUserDefaults standardUserDefaults] objectForKey:IS_RATED_IN_STORE];
	if (!rated || [rated boolValue] == NO) {
		[self setRaingActive:NO];
	} else {
		[self setRaingActive:YES];
	}
}

- (IBAction) handleRating:(id)sender {
	
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:IS_RATED_IN_STORE];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[self setRaingActive:YES];
	[[ControllersManager sharedManager] showRateInAppStore];
}
- (void) setRaingActive:(BOOL)yes {
	UIImage *img = [UIImage imageNamed:@"settings-rating-star"];
	if (yes) {
		img = [UIImage imageNamed:@"settings-rating-star-active"];
	}
	[_ratingStar setImage:img forState:UIControlStateNormal];
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
            else if ([row isEqualToNumber:HTVMenuItemEmail]) {
                [[ControllersManager sharedManager] showEmailToHromadskeController];
            }
            else if ([row isEqualToNumber:HTVMenuItemRate]) {
				[self handleRating:nil];
            }
            break;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , tableView.frame.size.width, 21)];
    sectionView.backgroundColor = [Utils colorFromHtmlSting:@"#ec6a13"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(9, 2, tableView.frame.size.width, 17)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:12];
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

    _otherPageItems = @{HTVMenuItemIdeas : @[ADD_IDEAS],
                        HTVMenuItemFeedback : @[WRITE_TO_DEVELOPER_PAGE],
                        HTVMenuItemEmail : @[WRITE_TO_EDITORIAL_OFFICE],
                        HTVMenuItemRate : @[RATE_IN_APP_STORE],
                        HTVMenuItemShare : @[SHARE_FRIENDS_PAGE]};
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
    
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
	if (_section == HTVMenuSectionMain) {
		cell.textLabel.textColor = [Utils colorFromHtmlSting:@"#FFFFFF"];
	} else {
		cell.textLabel.textColor = [Utils colorFromHtmlSting:@"#999999"];
	}
    cell.backgroundColor = [Utils colorFromHtmlSting:@"#252323"];
	
    return cell;
}


#pragma mark - NewsViewControllerDelagate
- (void) newsViewController:(NewsViewController *)vc didChangeItem:(HTVVideoCategory)category {
    _newsCategory = [NewsViewController nameForCategory:category];
    [_tableView reloadData];
}

@end
