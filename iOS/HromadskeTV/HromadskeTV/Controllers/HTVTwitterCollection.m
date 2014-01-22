//
//  HTVTwitterCollection.m
//  HromadskeTV
//
//  Created by Max Tymchii on 1/16/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "HTVTwitterCollection.h"
#import "TwitterCollectionViewCell.h"
#import "Twitt.h"
#import "HTVWebVC.h"

@interface HTVTwitterCollection ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextViewDelegate>
{
    CGSize twitterCellSize;
}
@property (nonatomic, strong) STTwitterAPI *twitter;
@property (nonatomic, strong) NSArray *twittes;
@property (weak, nonatomic) IBOutlet UICollectionView *collection;

@end

@implementation HTVTwitterCollection

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setTwittes:(NSArray *)twittes
{
    _twittes = twittes;
    [self.collection reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collection.delegate = self;
    self.collection.dataSource = self;
    [self loginWithiOS];
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateVideoCellSizeForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Twitter Logic
- (void)loginWithiOS
{
    self.twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
    [_twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        [self getTimeLineInfo];
    } errorBlock:^(NSError *error) {
        [self loginWithSafari];
    }];
    
}

- (void)getTimeLineInfo
{
    [self.twitter getUserTimelineWithScreenName:@"hromadsketv"
                                          count:50
                                   successBlock:^(NSArray *statuses) {
                                       NSLog(@"Results %@", statuses);
                                       self.twittes = [HTVHelperMethods parseArrayFromTwitter:statuses];
                                   } errorBlock:^(NSError *error) {
                                       //                                       NSLog(@"Error %@", error);
                                       //                                       [self loginWithiOS];
                                   }];
    
}

- (void)loginWithSafari
{
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:TWITTER_CONSUMER_KEY
                                                 consumerSecret:TWITTER_CONSUMER_SECRET_KEY];
    
    [_twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {
        NSLog(@"-- url: %@", url);
        NSLog(@"-- oauthToken: %@", oauthToken);
        
        [[UIApplication sharedApplication] openURL:url];
        //        [self getTimeLineInfo];
        
    } oauthCallback:@"HromadskeTV://twitter_access_tokens/"
                    errorBlock:^(NSError *error) {
                        NSLog(@"-- error: %@", error);
                    }];
}

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier {
    
    [_twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
        NSLog(@"-- screenName: %@", screenName);
        [self getTimeLineInfo];
        
    } errorBlock:^(NSError *error) {
        
        NSLog(@"-- %@", [error localizedDescription]);
    }];
}



- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self updateVideoCellSizeForOrientation:toInterfaceOrientation];
}

- (void)updateVideoCellSizeForOrientation:(UIInterfaceOrientation)orientation
{
    twitterCellSize = CGSizeMake(300, 140);
    if (IS_IPHONE) {
        if (IS_IPHONE_5) {
            if (UIInterfaceOrientationIsLandscape(orientation)) {
                twitterCellSize = CGSizeMake(265, 140);
            }
        }
        else {
            if (UIInterfaceOrientationIsLandscape(orientation)) {
                twitterCellSize = CGSizeMake(230, 160);
            }
        }
    }
    else {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            twitterCellSize = CGSizeMake(310, 120);
        }
        else {
           twitterCellSize = CGSizeMake(330, 120);
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
    return self.twittes.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return twitterCellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return [self edgeForCell];
}

- (UIEdgeInsets)edgeForCell
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (IS_IPHONE) {
        if (IS_IPHONE_5) {
            if (UIInterfaceOrientationIsLandscape(orientation)){
                return UIEdgeInsetsMake(10, 12, 10, 12);
            }
        }
        else {
            return UIEdgeInsetsMake(5, 5, 5, 5);
        }
    }
    else
    {
        if (!UIInterfaceOrientationIsLandscape(orientation)) {
            return UIEdgeInsetsMake(10, 30, 10, 30);
        }
        else {
           return UIEdgeInsetsMake(10, 15, 10, 15);
        }
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TwitterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTVTwitterCell"
                                                                     forIndexPath:indexPath];
    Twitt *twitt = self.twittes[indexPath.row];
    cell.twitterText.text = twitt.text;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm dd/MM/yy"];
    NSString* myNiceLookingDate = [dateFormatter stringFromDate:twitt.date];
    cell.twitterInfo.text = [myNiceLookingDate stringByAppendingString:twitt.tags];
    cell.twitterText.delegate = self;
    cell.twitterText.editable = NO;
    cell.twitterText.userInteractionEnabled = NO;
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Twitt *twitt = self.twittes[indexPath.row];
    if (twitt.url) {
        SVModalWebViewController *newCenterVC = [[SVModalWebViewController alloc] initWithAddress:twitt.url];
        [self presentViewController:newCenterVC animated:YES completion:NULL];
    }
   
}



@end
