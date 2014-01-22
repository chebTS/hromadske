//
//  ControllersManager.m
//  HromadskeTV
//
//  Created by comonitos on 1/21/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "ControllersManager.h"


#import "UIViewController+HTVNavigationController.h"


@interface ControllersManager()<IIViewDeckControllerDelegate>
{
    UIStoryboard *_storyboard;
    HTVMenuViewController *_menu;
    IIViewDeckController *_deck;
    LiveViewController *_live;
    NewsViewController *_news;
    HTVWebVC *_liveTmp;
}


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

- (HTVMenuViewController *) menu {
    if (!_menu) {
        _menu = [_storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HTVMenuViewController class])];
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
- (IIViewDeckController *) deck {
    if (!_deck) {
        _deck = [[IIViewDeckController alloc] initWithCenterViewController:[self controllerWithRoot:[self live]]
                                                        leftViewController:[self menu]
                                                       rightViewController:nil];
        [_deck setLeftSize:LEFT_RIGHT_CONTROLLER_SHIFT];
        [_deck setRightSize:LEFT_RIGHT_CONTROLLER_SHIFT];
        _deck.elastic = NO;
        _deck.panningMode = IIViewDeckFullViewPanning;
        _deck.delegate = self;
    }
    
    return _deck;
}

- (NewsViewController *) news {
    if (!_news) {
        _news = [_storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([NewsViewController class])];
    }
    return _news;

}

- (void) openMenu {
    [_deck openLeftViewAnimated:YES];
}
- (void) closeMenu {
    [_deck closeLeftViewAnimated:YES];
}


#pragma mark - Update methods
- (void) setNewLiveUrl:(NSURL *)url {
    [[self live] setLiveUrl:url];
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
        newCenterVC = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    }
    @catch (NSException *exception) {
        return;
    }
    @finally {
        if (newCenterVC) {
            [self showViewConteroller:newCenterVC];
        }
    }
}

- (void)pushToCenterDeckControllerWithURL:(NSString *)url
{
    HTVWebVC *newCenterVC = nil;
    @try {
        newCenterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HTVWebVC"];
    }
    @catch (NSException *exception) {
        return;
    }
    @finally {
        if (newCenterVC) {
            newCenterVC.URL = [NSURL URLWithString:url];
            [self showViewConteroller:newCenterVC];
        }
    }
}

- (void)showLiveViewController {
    [self showViewConteroller:_live];
}


- (void)showNewsViewController {
    [self showViewConteroller:[self news]];
}

- (void) showViewConteroller:(UIViewController *)c {
    _deck.centerController = [self controllerWithRoot:c];
    [self closeMenu];
}


- (UINavigationController *) controllerWithRoot:(UIViewController *)c {
    return [[UINavigationController alloc] initWithRootViewController:c];
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


@end
