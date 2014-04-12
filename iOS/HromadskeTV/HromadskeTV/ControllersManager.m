//
//  ControllersManager.m
//  HromadskeTV
//
//  Created by comonitos on 1/21/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "ControllersManager.h"
#import "AboutViewController.h"
#import "REActivityViewController.h"
#import <Appirater.h>

#import "UIViewController+HTVNavigationController.h"


@interface ControllersManager()<IIViewDeckControllerDelegate, MFMailComposeViewControllerDelegate>
{
    UIStoryboard *_storyboard;
    MenuViewController *_menu;
    IIViewDeckController *_deck;
    LiveViewController *_live;
    NewsViewController *_news;
    HTVWebVC *_liveTmp;
    REActivityViewController *_sharing;
    UINavigationController *_newsNavigation;
    
}
@property (nonatomic,strong) UIPopoverController *pop;
@property (nonatomic, strong) MFMailComposeViewController *picker;

@end


@implementation ControllersManager

+ (ControllersManager *)sharedManager {
    static ControllersManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[ControllersManager alloc] init];
    });
    
    return __manager;
}


#pragma mark - SETUP
- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
- (void) setup {
    [self initData];
    [self deck];
}
- (void)initData {
    if(!_storyboard) {
        _storyboard = [UIStoryboard storyboardWithName:STORY_BOARD bundle:[NSBundle mainBundle]];
    }
}

#pragma mark - STAFF
- (UIStoryboard *)storyboard
{
    return _storyboard;
}

- (MenuViewController *) menu {
    if (!_menu) {
        _menu = [_storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MenuViewController class])];
    }
    return _menu;
}
- (HTVWebVC *) liveTmp {
    if (!_liveTmp) {
        _liveTmp = [_storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HTVWebVC class])];
        _liveTmp.URL = [NSURL URLWithString:ONLINE_URL];
    }
    return _liveTmp;
}
- (LiveViewController *) live {
    if (!_live) {
        _live = [_storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LiveViewController class])];
    }
    return _live;
}
- (UINavigationController *) newsNavigationController
{
    if (!_newsNavigation) {
        _newsNavigation = [self controllerWithRoot:[self news]];
    }
    return _newsNavigation;
}
- (IIViewDeckController *) deck {
    if (!_deck) {
        _deck = [[IIViewDeckController alloc] initWithCenterViewController:[self controllerWithRoot:[self live]]
                                                        leftViewController:[self menu]
                                                       rightViewController:nil];
        [_deck setLeftSize:LEFT_RIGHT_CONTROLLER_SHIFT];
        [_deck setRightSize:LEFT_RIGHT_CONTROLLER_SHIFT];
        _deck.elastic = NO;
        _deck.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
        _deck.panningMode = IIViewDeckFullViewPanning;
        _deck.delegate = self;
    }
    
    return _deck;
}

- (NewsViewController *) news {
    if (!_news) {
        _news = [_storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([NewsViewController class])];
        _news.delegate = [self menu];
    }
    return _news;

}

#pragma mark - Update methods
- (void) setNewLiveUrl:(NSURL *)url {
    [[self live] setLiveUrl:url];
}

- (void) openMenu {
    [_deck openLeftViewAnimated:YES];
}
- (void) closeMenu {
    [_deck closeLeftViewAnimated:YES];
}

- (UINavigationController *) controllerWithRoot:(UIViewController *)c {
    return [[UINavigationController alloc] initWithRootViewController:c];
}



#pragma mark - SHOW

- (void)showLiveViewController {
    [self showViewController:[self live]];
}


- (void)showNewsViewController {
    _deck.centerController = [self newsNavigationController];
    [self closeMenu];
}

- (void)showAboutViewController {
    [self showViewControllerWithIdentifier:NSStringFromClass([AboutViewController class])];
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
    UIViewController *newCenterVC = nil;
    @try {
        newCenterVC = [[self storyboard] instantiateViewControllerWithIdentifier:identifier];
    }
    @catch (NSException *exception) {
        return;
    }
    @finally {
        if (newCenterVC) {
            [self showViewController:newCenterVC];
        }
    }
}

- (void)showWebViewControllerWithURL:(NSString *)url
{
    HTVWebVC *newCenterVC = nil;
    @try {
        newCenterVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"HTVWebVC"];
    }
    @catch (NSException *exception) {
        return;
    }
    @finally {
        if (newCenterVC) {
            newCenterVC.URL = [NSURL URLWithString:url];
            [self showViewController:newCenterVC];
        }
    }
}

- (void)showViewController:(UIViewController *)c {
    _deck.centerController = [self controllerWithRoot:c];
    [self closeMenu];
}

- (void)showUserVoiceController
{
    [UserVoice presentUserVoiceForumForParentViewController:_deck];
}
- (void)showUserVoiceFeedbackController {
    [UserVoice presentUserVoiceContactUsFormForParentViewController:_deck];
}

- (void)showEmailToHromadskeController
{
    if([MFMailComposeViewController canSendMail]){
        self.picker = [[MFMailComposeViewController alloc] init];
        self.picker.mailComposeDelegate = self;
        [self.picker setToRecipients:@[EMAIL_HROMADSKE_TV]];
        [self.picker setSubject:EMAIL_SUBJECT];
        [self.deck presentViewController:self.picker animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
    else {
        [HTVHelperMethods callCustomAlertWithMessage:EMAIL_ERROR_MESSAGE];
    }
 
}

- (void)showRateInAppStore
{
	[Appirater rateApp];
}



#pragma mark - Sharing
- (void)showSharing
{
    if (IS_IPHONE) {
        [self closeMenu];
        [[self sharing] presentFromRootViewController];
    }
    else {
        _pop = [[UIPopoverController alloc] initWithContentViewController:[self sharing]];
        [self sharing].presentingPopoverController = _pop;
        [[self deck] closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
            if (success) {
                CGFloat shift = 48;
                if (IOS_7) {
                    shift = 68;
                }
                [_pop presentPopoverFromRect:CGRectMake(0, shift, 1, 1) inView:_deck.centerController.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            }
        }];
    }
}
- (REActivityViewController *)sharing
{
    if (!_sharing) {
        REFacebookActivity *facebookActivity = [[REFacebookActivity alloc] init];
        RETwitterActivity *twitterActivity = [[RETwitterActivity alloc] init];
        REVKActivity *vkActivity = [[REVKActivity alloc] initWithClientId:VK_API_KEY];
        REMessageActivity *messageActivity = [[REMessageActivity alloc] init];
        REMailActivity *mailActivity = [[REMailActivity alloc] init];
//        REInstapaperActivity *instapaperActivity = [[REInstapaperActivity alloc] init];
//        REKipptActivity *kipptActivity = [[REKipptActivity alloc] init];
        
        
        // Compile activities into an array, we will pass that array to
        // REActivityViewController on the next step
        //
        NSArray *activities = @[facebookActivity, twitterActivity, vkActivity,
                                messageActivity, mailActivity];
        
        // Create REActivityViewController controller and assign data source
        //
        _sharing = [[REActivityViewController alloc] initWithViewController:[self deck] activities:activities];
        _sharing.userInfo = @{ @"text":[NSString stringWithFormat:@"Я дивлюсь HromadskeTV через цей додаток %@ #HromadskeTV", APP_URL] };
    }
    
    return _sharing;
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


#pragma mark - Email Methods
#pragma mark - MFMailComposeViewControllerDelegate
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
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

@end
