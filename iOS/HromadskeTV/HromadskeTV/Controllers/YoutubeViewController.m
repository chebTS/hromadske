//
//  HTVVideoCollectionVC.m
//  HromadskeTV
//
//  Created by Max Tymchii on 1/16/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "YoutubeViewController.h"
#import "VideoCollectionViewCell.h"
#import "Video.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIViewController+HTVNavigationController.h"

#define VIDEO_IMAGE_PLACE_HOLDER @"placeHolder"

@interface YoutubeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    CGSize videoCellSize;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (nonatomic, strong) NSArray *videos;
@end

@implementation YoutubeViewController


- (void)setVideos:(NSArray *)videos
{
    _videos = videos;
    [self.collection reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self setupView];

    self.collection.delegate = self;
    self.collection.dataSource = self;
    self.title = YOUTUBE_PAGE;
    [HTVHelperMethods fetchNewDataFromYoutubeForController:self];
	// Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateVideoCellSizeForOrientation:[UIApplication sharedApplication].statusBarOrientation];
   
                   
    
    [[GAI sharedInstance].defaultTracker send:[[[GAIDictionaryBuilder createAppView] set:HOT_NEWS_SCREEN
                                                                                  forKey:kGAIScreenName] build]];

    
}



- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self updateVideoCellSizeForOrientation:toInterfaceOrientation];
}

- (void)updateVideoCellSizeForOrientation:(UIInterfaceOrientation)orientation
{
    videoCellSize = CGSizeMake(240, 180);
    if (IS_IPHONE) {
        if (!IS_IPHONE_5) {
            if (UIInterfaceOrientationIsLandscape(orientation)) {
                videoCellSize = CGSizeMake(220, 165);
            }
        }
    }
    
    [self.collection reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.videos.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return videoCellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (IS_IPHONE) {
        if (IS_IPHONE_5) {
            if (UIInterfaceOrientationIsLandscape(orientation)){
                return UIEdgeInsetsMake(10, 30, 10,30);
            }
        }
        else {
            return UIEdgeInsetsMake(10, 15, 10, 15);
        }
    }
    else
    {
        if (!UIInterfaceOrientationIsLandscape(orientation)) {
            return UIEdgeInsetsMake(20, 10, 20, 10);
        }
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTVVideoCell" forIndexPath:indexPath];
    Video *video = self.videos[indexPath.item];
    cell.title.text = video.title;
    [cell.thumbnail sd_setImageWithURL:[NSURL URLWithString:video.thumbnail]
                      placeholderImage:[UIImage imageNamed:VIDEO_IMAGE_PLACE_HOLDER] completed:nil];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Video *video = self.videos[indexPath.item];
    NSLog(@"path %@", video.url);
    XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:video.url];
    [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
}




@end
