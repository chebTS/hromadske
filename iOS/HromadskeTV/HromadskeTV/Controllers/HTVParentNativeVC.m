//
//  HTVParentNativeVC.m
//  HromadskeTV
//
//  Created by Max Tymchii on 1/16/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "HTVParentNativeVC.h"

@interface HTVParentNativeVC ()

@end

@implementation HTVParentNativeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addMenuButton];
}

- (void)addMenuButton
{
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
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [leftButton setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *negativeSpacerLeft = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    if (IOS_7) {
        negativeSpacerLeft.width = -5;// it was 0 in iOS 6
    }
    else {
        negativeSpacerLeft.width = 0;
    }
    
    
    self.navigationItem.leftBarButtonItems = @[negativeSpacerLeft, leftButton];
    
}


@end
