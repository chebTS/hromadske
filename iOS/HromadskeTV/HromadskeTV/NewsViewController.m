//
//  NewsViewController.m
//  HromadskeTV
//
//  Created by comonitos on 1/22/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "NewsViewController.h"
#import "SINavigationMenuView.h"
#import "UIViewController+HTVNavigationController.h"
#import "VideoTableViewCell.h"
#import "HTVWebVC.h"
#import "ControllersManager.h"
#import "RemoteManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NewsViewController ()<SINavigationMenuDelegate,UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UITableView *_table;
    NSMutableArray *_cache;
    HTVVideoCategory _currentCategory;
	SINavigationMenuView *_menu;
}
@end

@implementation NewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setup];
    [self setupView];
    [self didSelectItemAtIndex:HTVVideoCategoryAll];
	
	for (UIControl *control in _menu.subviews) {
		if ([control isKindOfClass:[UIControl class]]) {
			[control beginTrackingWithTouch:nil withEvent:nil];
			[control sendActionsForControlEvents:UIControlEventTouchUpInside];
			[control cancelTrackingWithEvent:nil];
		}
	}
}

- (void) viewWillAppear:(BOOL)animated {
	[[RemoteManager sharedManager] hideRemoteActivity];
}
- (void) setup {
    _cache = [NSMutableArray arrayWithObjects:[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil];

    CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
    _menu = [[SINavigationMenuView alloc] initWithFrame:frame title:[NewsViewController categories][0]];
    [_menu displayMenuInView:self.navigationController.view];
    _menu.items = [NewsViewController categories];
    _menu.delegate = self;
    self.navigationItem.titleView = _menu;
    
    
    if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
        [_table setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (NSArray *) dataSource {
    NSArray *source = [_cache objectAtIndex:_currentCategory];
    return ([source isKindOfClass:[NSArray class]]) ? source : nil;
}


- (void)didSelectItemAtIndex:(NSUInteger)index
{
    HTVVideoCategory cat = _currentCategory = (HTVVideoCategory)index;
    
    if ([_delegate respondsToSelector:@selector(newsViewController:didChangeItem:)]) {
        [_delegate newsViewController:self didChangeItem:_currentCategory];
    }

    if (_cache[_currentCategory] == [NSNull null]) {
        [[RemoteManager sharedManager] showRemoteActivity];
    } else {
        [_table reloadData];
    }
    
    [[Data sharedData] videoForCategory:cat completion:^(NSArray *result) {
        [[RemoteManager sharedManager] hideRemoteActivity];

        if (result.count > 0) {
            [_cache replaceObjectAtIndex:cat withObject:result];
        }
        
        [_table reloadData];
    }];
}



#pragma mark - TABLE VIEW Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self dataSource] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.row;
    Video *video = [[self dataSource] objectAtIndex:row];
    static NSString *ident = @"VideoTableViewCell";

    VideoTableViewCell *cell = (VideoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ident];
    cell.title.text = video.title;
    cell.date.text = [Utils stringHumanRecognizableFromDate:video.date];
	
	if (_currentCategory != HTVVideoCategoryHot) {
		cell.accessoryType = UITableViewCellAccessoryDetailButton;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
    [cell.thumbnail sd_setImageWithURL:[NSURL URLWithString:video.thumbnail]
                   placeholderImage:[UIImage imageNamed:@"placeholder-image"]];
    [cell setup];
    
    
    return cell;
}


#pragma mark - TABLE VIEW Delegate
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    Video *v = _cache[_currentCategory][indexPath.row];

	HTVWebVC *c = [[[ControllersManager sharedManager] storyboard] instantiateViewControllerWithIdentifier:NSStringFromClass([HTVWebVC class])];
	c.URL = [NSURL URLWithString:v.url];
	[self.navigationController pushViewController:c animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
    Video *v = _cache[_currentCategory][indexPath.row];

    if (_currentCategory == HTVVideoCategoryHot) {
        XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:v.url];
        [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
    } else {
        [[RemoteManager sharedManager] showRemoteActivity];

        [[Data sharedData] youTubeURLFromHromadskeUrl:[NSURL URLWithString:v.url] completion:^(NSString *resultURL) {

            [[RemoteManager sharedManager] hideRemoteActivity];
            
            if (resultURL) {
                NSString *tail = [HTVHelperMethods yotubeTailFromString:resultURL];
                XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:tail];
                [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
            } else {
                HTVWebVC *c = [[[ControllersManager sharedManager] storyboard] instantiateViewControllerWithIdentifier:NSStringFromClass([HTVWebVC class])];
                c.URL = [NSURL URLWithString:v.url];
                [self.navigationController pushViewController:c animated:YES];
            }

        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}


+ (NSArray *) categories {
    return @[@"Гарячі відео", @"Усі новини", @"Політика", @"Економіка", @"Суспільство",@"Культура",@"Світ"];
}
+ (NSString *) nameForCategory:(HTVVideoCategory)cat {
    NSArray *ar = [NewsViewController categories];
    return ar[cat];
}

@end
