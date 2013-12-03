//
//  HTVAboutUs.m
//  HromadskeTV
//
//  Created by Max Tymchii on 12/3/13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//

#import "HTVAboutUs.h"

@interface HTVAboutUs ()

@end

@implementation HTVAboutUs

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.URL = [NSURL URLWithString:ABOUT_US_URL];
}



@end
