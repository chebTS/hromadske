//
//  HTVInterviewVC.m
//  HromadskeTV
//
//  Created by Max Tymchii on 12/3/13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//

#import "HTVInterviewVC.h"

@interface HTVInterviewVC ()

@end

@implementation HTVInterviewVC
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.URL = [NSURL URLWithString:INTERVIEW_URL];
}


@end
