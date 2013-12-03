//
//  HTVCategoriesViewController.m
//  HromadskeTV
//
//  Created by Max Tymchii on 12/3/13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//

#import "HTVCategoriesViewController.h"

#define SECTION_MAIN    0
#define MAIN_PAGES          @"Основні сторінки"
#define HOME_ROW            @(0)
#define VIDEO_ROW           @(1)
#define INTERVIEW_ROW       @(2)
#define PROGRAMS_ROW        @(3)
#define ABOUT_US_ROW        @(4)
#define YOUTUBE_ROW         @(5)

#define SECTION_SOCIAL  1
#define SOCIAL_PAGES        @"Соц. мережі"
#define TWITTER_ROW         @(0)
#define FB_ROW              @(1)
#define GOOGLE_PLUS         @(2)
#define RSS_ROW             @(3)

#define  SECTIONS_NUMBER 2



@interface HTVCategoriesViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *tableStructure;
@property (nonatomic, strong) NSDictionary *socialNetworks;
@end

@implementation HTVCategoriesViewController

- (NSDictionary *)tableStructure
{
    if (!_tableStructure) {
        _tableStructure = @{
                            HOME_ROW : @[@"Головна",HOME_URL],
                            VIDEO_ROW : @[@"Відеоновини",VIDEO_URL],
                            INTERVIEW_ROW : @[@"Інтерв'ю", INTERVIEW_URL],
                            PROGRAMS_ROW : @[@"Програми", PROGRAMS_URL],
                            ABOUT_US_ROW  : @[@"Про проект", ABOUT_US_URL],
                            YOUTUBE_ROW : @[@"YouTube канал", YOUTUBE_URL]
                            };
    }
    return _tableStructure;
}


- (NSDictionary *)socialNetworks
{
    if (!_socialNetworks) {
        _socialNetworks = @{TWITTER_ROW: @[@"Twitter", TWITTER_URL],
                            FB_ROW : @[@"Facebook", FB_URL],
                            GOOGLE_PLUS : @[@"G+", G_PLUS_URL],
                            RSS_ROW : @[@"RSS", RSS_URL]};
    }
    return _socialNetworks;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - TableView Delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SECTIONS_NUMBER;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == SECTION_MAIN) {
       return self.tableStructure.allKeys.count;
    }
    else if (section == SECTION_SOCIAL) {
        return self.socialNetworks.allKeys.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == SECTION_MAIN) {
        return MAIN_PAGES;
    }
    else {
        return SOCIAL_PAGES;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleCell"
                                                            forIndexPath:indexPath];
    if (indexPath.section == SECTION_MAIN) {
         cell.textLabel.text = self.tableStructure[@(indexPath.row)][0];
    }
    else if (indexPath.section == SECTION_SOCIAL) {
        cell.textLabel.text = self.socialNetworks[@(indexPath.row)][0];
    }
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_MAIN) {
        [DELEGATE pushToCenterDeckControllerWithURL:self.tableStructure[@(indexPath.row)][1]];
    }
    else if (indexPath.section == SECTION_SOCIAL) {
       [DELEGATE pushToCenterDeckControllerWithURL:self.socialNetworks[@(indexPath.row)][1]];
    }
    
}

@end
