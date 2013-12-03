//
//  HTVParentVC.m
//  HromadskeTV
//
//  Created by Max Tymchii on 12/3/13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//

#import "HTVParentVC.h"

@interface HTVParentVC ()

@end

@implementation HTVParentVC
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsOpenInChrome | SVWebViewControllerAvailableActionsMailLink;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *sliderButtonImage = [UIImage imageNamed:@"logo"];
    CGSize sliderSize = sliderButtonImage.size;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, (44 - sliderSize.height)/2,
                                                                  sliderSize.width,
                                                                  sliderSize.height)];
    [button setBackgroundImage:sliderButtonImage
                      forState:UIControlStateNormal];
    
    [button addTarget:self.viewDeckController
               action:@selector(toggleLeftView)
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithCustomView:button];
    [leftButon setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *negativeSpacerLeft = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
    if (IOS_7) {
        negativeSpacerLeft.width = -15;// it was 0 in iOS 6
    }
    else {
        negativeSpacerLeft.width = 0;
    }
    
    
    self.navigationItem.leftBarButtonItems = @[negativeSpacerLeft, leftButon];
}

@end
