//
//  NewsViewController.h
//  HromadskeTV
//
//  Created by comonitos on 1/22/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"

@class NewsViewController;

@protocol NewsViewControllerDelagate <NSObject>
@required
- (void) newsViewController:(NewsViewController *)vc didChangeItem:(HTVVideoCategory)category;
@end


@interface NewsViewController : UIViewController
{
}
@property (nonatomic,assign) id <NewsViewControllerDelagate>delegate;

+ (NSString *) nameForCategory:(HTVVideoCategory)cat;

@end
