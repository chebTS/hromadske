//
//  UINavigationController+HTVNavigationController.m
//  HromadskeTV
//
//  Created by comonitos on 1/20/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "UIViewController+HTVNavigationController.h"

@implementation UIViewController (HTVNavigationController)

- (void) setupView {
    [self setupNavigationBar];
    [self setupStatusBarAnimated:NO style:HTVStatusBarStyleLight];
    [self addMenuButton];
}

- (void) setupNavigationBar {
    if (IOS_7) {
        NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] initWithDictionary:self.navigationController.navigationBar.titleTextAttributes];
        [textAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
        
        self.navigationController.navigationBar.titleTextAttributes = textAttributes;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = [Utils colorFromHtmlSting:@"#ec6a13"];
    } else {
        self.navigationController.navigationBar.tintColor = [Utils colorFromHtmlSting:@"#ec6a13"];
    }
	self.navigationController.navigationBar.translucent = NO;
}

- (void)addMenuButton
{
    int count = self.navigationController.viewControllers.count;
    if (count > 1) {
        return;
    }
    
    UIImage *sliderButtonImage = [UIImage imageNamed:@"nav-bar-menu-icon"];
    CGSize sliderSize = sliderButtonImage.size;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,
                                                                  sliderSize.width,
                                                                  sliderSize.height)];
    [button setImage:sliderButtonImage
            forState:UIControlStateNormal];
    [button addTarget:self.viewDeckController
               action:@selector(toggleLeftView)
     forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [leftButton setTintColor:[UIColor clearColor]];
    
    UIBarButtonItem *negativeSpacerLeft = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    if (IOS_7) {
        negativeSpacerLeft.width = -5;// it was 0 in iOS 6
    }
    else {
        negativeSpacerLeft.width = 5;
    }
    
    
    self.navigationItem.leftBarButtonItems = @[negativeSpacerLeft, leftButton];
    
}



- (void) updateViewWithStatsBarStyle:(HTVStatusBarStyle)style {
    [self setupStatusBarAnimated:YES style:style];
}
- (void) setupStatusBarAnimated:(BOOL)animated style:(HTVStatusBarStyle)style {
    if (IOS_7) {
        UIStatusBarStyle _style = (style == HTVStatusBarStyleDark) ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
        [[UIApplication sharedApplication] setStatusBarStyle:_style animated:animated];
    }
}

@end
