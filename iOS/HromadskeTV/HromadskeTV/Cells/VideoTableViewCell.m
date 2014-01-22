//
//  VideoTableViewCell.m
//  HromadskeTV
//
//  Created by comonitos on 1/22/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "VideoTableViewCell.h"

@implementation VideoTableViewCell

-(void) awakeFromNib {
    
}

-(void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if(highlighted)
    {
        self.contentView.backgroundColor = [Utils colorFromHtmlSting:@"#DBDCDE"];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}
- (void) setHighlighted:(BOOL)highlighted {
    [self setHighlighted:highlighted animated:NO];
}
- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [self setHighlighted:selected animated:animated];
}
- (void) setSelected:(BOOL)selected {
    [self setHighlighted:selected];
}

@end
