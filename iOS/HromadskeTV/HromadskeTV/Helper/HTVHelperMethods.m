//
//  HTVHelperMethods.m
//  HromadskeTV
//
//  Created by Max Tymchii on 12/12/13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//

#import "HTVHelperMethods.h"

@implementation HTVHelperMethods


+ (void)callCustomAlertWithMessage:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:APP_NAME
                                message:message delegate:nil
                      cancelButtonTitle:@"Добре"
                      otherButtonTitles: nil] show];
}

@end
