//
//  HTVProgramsVC.m
//  HromadskeTV
//
//  Created by Max Tymchii on 12/3/13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//

#import "HTVProgramsVC.h"

@interface HTVProgramsVC ()

@end

@implementation HTVProgramsVC

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.URL = [NSURL URLWithString:PROGRAMS_URL];
}

@end
