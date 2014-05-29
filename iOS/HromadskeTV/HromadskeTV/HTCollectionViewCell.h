//
//  HTCollectionViewCell.h
//  HromadskeTV
//
//  Created by comonitos on 5/29/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "PSCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface HTCollectionViewCell : PSCollectionViewCell
{
}
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@end
