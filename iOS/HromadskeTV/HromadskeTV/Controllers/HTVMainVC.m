//
//  HTVMainVC.m
//  HromadskeTV
//
//  Created by Max Tymchii on 12/3/13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//

#import "HTVMainVC.h"

@interface HTVMainVC ()

@end

@implementation HTVMainVC


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.URL = [NSURL URLWithString:HOME_URL];
}


@end
