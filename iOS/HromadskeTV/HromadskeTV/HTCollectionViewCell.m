//
//  HTCollectionViewCell.m
//  HromadskeTV
//
//  Created by comonitos on 5/29/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "HTCollectionViewCell.h"
#import "News.h"

@implementation HTCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void) awakeFromNib {
	[Utils addRoundedCornersOfView:self withRadious:3];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void) collectionView:(PSCollectionView *)collectionView fillCellWithObject:(id)object atIndex:(NSInteger)index {
	News *news = (News *)object;
	
	_title.text = news.title;
	_description.text = news.description;
	_type.text = news.type;
	[_views setTitle:news.views forState:UIControlStateNormal];
	[self.thumbnail setImageWithURL:[NSURL URLWithString:news.thumbnail] placeholderImage:[UIImage imageNamed:@"placeholder-image"]];
	
	if (news.height == 0) {
		_title.font = [UIFont systemFontOfSize:12];
		[_title sizeToFit];
		_title.font = [UIFont systemFontOfSize:11];
		_description.font = [UIFont systemFontOfSize:10];
		[_description sizeToFit];
		_description.font = [UIFont systemFontOfSize:9];
		
		news.height = 200 + 20 + _title.frame.size.height + _description.frame.size.height;
	}
}

@end
