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

@interface NewsViewController ()<SINavigationMenuDelegate>

@end

@implementation NewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
    SINavigationMenuView *menu = [[SINavigationMenuView alloc] initWithFrame:frame title:@"Всі відео"];
    [menu displayMenuInView:self.navigationController.view];
    menu.items = @[@"Всі відео", @"Слідство.Інфо", @"H2O", @"Гості студії"];
    menu.delegate = self;
    self.navigationItem.titleView = menu;
}

- (void) viewWillAppear:(BOOL)animated {
    [self setupView];
}


- (void)didSelectItemAtIndex:(NSUInteger)index
{
    NSLog(@"did selected item at index %d", index);
}

@end
