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

@end
