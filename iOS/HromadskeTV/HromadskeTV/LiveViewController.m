//
//  LiveViewController.m
//  HromadskeTV
//
//  Created by comonitos on 1/21/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "LiveViewController.h"
#import "UIViewController+HTVNavigationController.h"
#import "UIViewController+ScrollingNavbar.h"

#import "RemoteManager.h"
#import "VideoStream.h"
#import "SourcesManager.h"
#import "Data.h"

#import <PSCollectionView.h>
#import "HTCollectionViewCell.h"

#import "SINavigationMenuView.h"

@interface LiveViewController () <UIWebViewDelegate, SINavigationMenuDelegate, SourcesManagerDelefate,PSCollectionViewDelegate,PSCollectionViewDataSource,UIScrollViewDelegate>
{
	__weak IBOutlet UISegmentedControl *_switcher;
	UIActivityIndicatorView *_indicator;
	
	NSMutableArray *_news;

//	PSCollectionView *_collectionView;
	UIWebView *_webView;
}
@property (weak, nonatomic) IBOutlet PSCollectionView *collectionView;
@end

@implementation LiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
	
	[[Data sharedData] hotNewsCompletion:^(NSMutableArray *news) {
		_news = news;
		[_collectionView reloadData];
	}];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupView];
}
- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self showNavBarAnimated:NO];
}

- (void) setup {
    self.title = ONLINE_PAGE;
	_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
    _webView.delegate = self;

	_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	UIBarButtonItem *loader = [[UIBarButtonItem alloc] initWithCustomView:_indicator];

    self.navigationItem.rightBarButtonItem = loader;
    
    for (id subview in _webView.subviews){
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
            ((UIScrollView *)subview).bounces = NO;
    }
	
	[[SourcesManager sharedManager] setDelegate:self];
	[self loadVideoStream];
	[self setupDropDownTable];
	[self setupCollectionView];

//	[self followScrollView:_collectionView];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
	[_indicator startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {

	[webView stringByEvaluatingJavaScriptFromString:@"var meta = document.createElement('meta');meta.name = 'viewport';meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0, minimal-ui';document.getElementsByTagName('head')[0].appendChild(meta);"];
	if (_switcher.selectedSegmentIndex == 1) {
		NSString *url = [[[[SourcesManager sharedManager] lastRadioStream] url] absoluteString];
		[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setURL('%@');",url]];
	}
	
	[_indicator stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[_indicator stopAnimating];
}

#pragma mark - SINavigationMenu methods

- (void)setupDropDownTable
{
    CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);

    VideoStream *currentStream = [[SourcesManager sharedManager] lastVideoStream];

    SINavigationMenuView *menu = [[SINavigationMenuView alloc] initWithFrame:frame title:currentStream.name];
    [menu displayMenuInView:self.view];
    
    menu.items = [[[SourcesManager sharedManager] videoSources] valueForKey:@"name"];
    menu.delegate = self;
    self.navigationItem.titleView = menu;
}

- (void) setupCollectionView
{
	_collectionView.delegate = self; // This is for UIScrollViewDelegate
	_collectionView.collectionViewDelegate = self;
	_collectionView.collectionViewDataSource = self;
	_collectionView.backgroundColor = [Utils colorFromHtmlSting:@"#e9e9e9"];
	_collectionView.autoresizingMask = ~UIViewAutoresizingNone;
	_collectionView.numColsPortrait = 2;
	_collectionView.numColsLandscape = 3;

	CGRect frame = _webView.frame;
	frame.size.height = 190;
	UIView *header = [[UIView alloc] initWithFrame:frame];
	[header addSubview:_webView];
	
	_collectionView.headerView = header;
}


- (void) loadVideoStream {
	_switcher.selectedSegmentIndex = 0;
	
	VideoStream *stream = [[SourcesManager sharedManager] lastVideoStream];
	
	NSURLRequest *req = [NSURLRequest requestWithURL:[stream url]];
	[_webView loadRequest:req];
}
- (void) loadAudioStream {
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"liveAudio.html"];
    NSURL *url = [NSURL fileURLWithPath:path isDirectory:NO];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (IBAction)handleSwitch:(UISegmentedControl *)sender {
	switch (sender.selectedSegmentIndex) {
		case 0:
			[self loadVideoStream];
			break;
		case 1:
			[self loadAudioStream];
			break;
		default:
			break;
	}
}

- (void)didSelectItemAtIndex:(NSUInteger)index
{
	[[SourcesManager sharedManager] setSelectedVideoIndex:(int)index];
	
	[self loadVideoStream];
}

#pragma mark - SourcesManagerDelefate 
- (void) sourcesManagerdidUpdateSources:(SourcesManager *)manager withNewStatus:(BOOL)yes {
	if (yes) {
		[self loadVideoStream];
	}
	[self setupDropDownTable];
}


#pragma mark - PSCollectionView
- (Class)collectionView:(PSCollectionView *)collectionView cellClassForRowAtIndex:(NSInteger)index {
    return [HTCollectionViewCell class];
}

- (UIView *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index {
	HTCollectionViewCell *cell = (HTCollectionViewCell *)[collectionView dequeueReusableViewForClass:[HTCollectionViewCell class]];
	if (!cell) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HTCollectionViewCell" owner:self options:nil];
        cell = (HTCollectionViewCell *)[nib objectAtIndex:0];
	}
	News *news = [_news objectAtIndex:index];
	[cell collectionView:collectionView fillCellWithObject:news atIndex:index];
	
    return cell;
}

- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView {
    return _news.count;
}

- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index {
	News *news = [_news objectAtIndex:index];
	if (news.height == 0) {
		[self collectionView:collectionView cellForRowAtIndex:index];
	}
    return news.height;
}

@end
