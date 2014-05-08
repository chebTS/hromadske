//
//  LiveViewController.m
//  HromadskeTV
//
//  Created by comonitos on 1/21/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "LiveViewController.h"
#import "UIViewController+HTVNavigationController.h"

#import "RemoteManager.h"
#import "VideoStream.h"
#import "SourcesManager.h"

#import "SINavigationMenuView.h"

@interface LiveViewController () <UIWebViewDelegate, SINavigationMenuDelegate, SourcesManagerDelefate>
{
	__weak IBOutlet UISegmentedControl *_switcher;
	UIActivityIndicatorView *_indicator;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation LiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupView];
}

- (void) setup {
    self.title = ONLINE_PAGE;
    self.webView.delegate = self;

	_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	UIBarButtonItem *loader = [[UIBarButtonItem alloc] initWithCustomView:_indicator];

    self.navigationItem.rightBarButtonItem = loader;
    
    for (id subview in self.webView.subviews){
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
            ((UIScrollView *)subview).bounces = NO;
    }
	
	[[SourcesManager sharedManager] setDelegate:self];
	[self loadVideoStream];
	[self setupDropDownTable];
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


- (void) loadVideoStream {
	_switcher.selectedSegmentIndex = 0;
	
	VideoStream *stream = [[SourcesManager sharedManager] lastVideoStream];
	
	NSURLRequest *req = [NSURLRequest requestWithURL:[stream url]];
	[self.webView loadRequest:req];
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



@end
