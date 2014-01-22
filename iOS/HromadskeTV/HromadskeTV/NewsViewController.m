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
#import "Data.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NewsViewController ()<SINavigationMenuDelegate,UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UITableView *_table;
    NSMutableArray *_cache;
    HTVVideoCategory _currentCategory;
}
@end

@implementation NewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setup];
    [self didSelectItemAtIndex:HTVVideoCategoryAll];
}

- (void) viewWillAppear:(BOOL)animated {
    [self setupView];
}
- (void) setup {
    _cache = [NSMutableArray arrayWithObjects:[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil];

    CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
    SINavigationMenuView *menu = [[SINavigationMenuView alloc] initWithFrame:frame title:@"Всі відео"];
    [menu displayMenuInView:self.navigationController.view];
    menu.items = @[@"Всі відео", @"Слідство.Інфо", @"H2O", @"Гості студії"];
    menu.delegate = self;
    self.navigationItem.titleView = menu;
    
    
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
    HTVVideoCategory cat = _currentCategory = index;
    
    [[Data sharedData] videoForCategory:cat completion:^(NSArray *result) {
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
    int row = indexPath.row;
    Video *video = [[self dataSource] objectAtIndex:row];
    static NSString *ident = @"VideoCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    cell.textLabel.text = video.title;
    [cell.imageView setImageWithURL:[NSURL URLWithString:video.thumbnail]
                   placeholderImage:[UIImage imageNamed:@"Icon-40"]];
    
    return cell;
}


#pragma mark - TABLE VIEW Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

@end
