//
//  HTVVideoNewsVC.m
//  HromadskeTV
//
//  Created by Max Tymchii on 12/3/13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//

#import "HTVVideoNewsVC.h"

@interface HTVVideoNewsVC ()

@end

@implementation HTVVideoNewsVC

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.URL = [NSURL URLWithString:VIDEO_URL];
}


@end
