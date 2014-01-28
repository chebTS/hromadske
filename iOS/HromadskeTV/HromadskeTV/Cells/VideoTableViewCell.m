//
//  VideoTableViewCell.m
//  HromadskeTV
//
//  Created by comonitos on 1/22/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "VideoTableViewCell.h"
@interface NSString (StringThatFits)
- (NSString *)stringByDeletingWordsFromStringToFit:(CGRect)rect
                                         withInset:(CGFloat)inset
                                         usingFont:(UIFont *)font;
@end

@implementation NSString (StringThatFits)
- (NSString *)stringByDeletingWordsFromStringToFit:(CGRect)rect
                                         withInset:(CGFloat)inset
                                         usingFont:(UIFont *)font
{
    NSString *result = [self copy];
    CGSize maxSize = CGSizeMake(rect.size.width  - (inset * 2), FLT_MAX);
    CGSize size = [result sizeWithFont:font
                     constrainedToSize:maxSize
                         lineBreakMode:UILineBreakModeWordWrap];
    NSRange range;
    
    if (rect.size.height < size.height)
        while (rect.size.height < size.height) {
            
            range = [result rangeOfString:@" "
                                  options:NSBackwardsSearch];
            
            if (range.location != NSNotFound && range.location > 0 ) {
                result = [result substringToIndex:range.location];
            } else {
                result = [result substringToIndex:result.length - 1];
            }
            
            size = [result sizeWithFont:font
                      constrainedToSize:maxSize
                          lineBreakMode:UILineBreakModeWordWrap];
        }
    
    return result;
}
@end
@implementation VideoTableViewCell

-(void) awakeFromNib {
    if (IOS_7) {
        _title.textContainerInset = UIEdgeInsetsMake(-2, -5, 0, 0);
    } else {
        _title.contentInset = UIEdgeInsetsMake(-2, -5, 0, 0);
    }
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


- (void) setup {
    _title.text = [_title.text stringByDeletingWordsFromStringToFit:_title.bounds withInset:0 usingFont:_title.font];
}

@end
