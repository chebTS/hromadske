//
//  HTVCategoriesViewController.m
//  HromadskeTV
//
//  Created by Max Tymchii on 12/3/13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//

#import "HTVCategoriesViewController.h"


#define HOME_ROW            @(0)
#define VIDEO_ROW           @(1)
#define INTERVIEW_ROW       @(2)
#define PROGRAMS_ROW        @(3)
#define ABOUT_US_ROW        @(4)


@interface HTVCategoriesViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *tableStructure;
@end

@implementation HTVCategoriesViewController

- (NSDictionary *)tableStructure
{
    if (!_tableStructure) {
        _tableStructure = @{
                            HOME_ROW : @[@"Головна",@"HTVMainVC"],
                            VIDEO_ROW : @[@"Відеоновини",@"HTVVideoNewsVC"],
                            INTERVIEW_ROW : @[@"Інтерв'ю", @"HTVInterviewVC"],
                            PROGRAMS_ROW : @[@"Програми", @"HTVProgramsVC"],
                            ABOUT_US_ROW  : @[@"Про проект", @"HTVAboutUs"]
                            };
    }
    return _tableStructure;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableStructure.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleCell"
                                                            forIndexPath:indexPath];
    cell.textLabel.text = self.tableStructure[@(indexPath.row)][0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [DELEGATE pushToCenterDeckController:self.tableStructure[@(indexPath.row)][1]];
}

@end