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
#import "SINavigationMenuView.h"
#import "OnlineStream.h"

@interface LiveViewController () <UIWebViewDelegate, SINavigationMenuDelegate>
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
//    UIBarButtonItem *item =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];

    self.navigationItem.rightBarButtonItem = loader;
    
//    if (IOS_7)
//    {
//        [item setTintColor:[UIColor whiteColor]];
//    }

    
    for (id subview in self.webView.subviews){
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
            ((UIScrollView *)subview).bounces = NO;
    }
}

- (void) refresh {
    [self.webView reload];
}

- (void)setLiveUrl:(NSURL *)url {
    
    if(![self.webView.request.URL.absoluteString isEqualToString:url.absoluteString])
    {
        [self setupDropDownTable];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:req];

		_switcher.selectedSegmentIndex = 0;
    }
}
- (void) loadVideoStream {
	NSURLRequest *req = [NSURLRequest requestWithURL:	[NSURL URLWithString:[HTVHelperMethods fullYoutubeLink]]];
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

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
	[_indicator startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {

	[webView stringByEvaluatingJavaScriptFromString:@"var meta = document.createElement('meta');meta.name = 'viewport';meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0, minimal-ui';document.getElementsByTagName('head')[0].appendChild(meta);"];
	
	[_indicator stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[_indicator stopAnimating];
}

#pragma mark - SINavigationMenu methods

- (void)setupDropDownTable
{
    CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
    OnlineStream *currentStream = [HTVHelperMethods onlineStreamForKey:[HTVHelperMethods  keyForOnlineWithPosition:[HTVHelperMethods defaultLiveChanel]]];

    //Set in which view we will display a menu
    SINavigationMenuView *menu = [[SINavigationMenuView alloc] initWithFrame:frame title:currentStream.name];
    [menu displayMenuInView:self.view];
    
    menu.items = [[OnlineStream allOnlineStreams] valueForKey:@"name"];
    menu.delegate = self;
    self.navigationItem.titleView = menu;
}


- (void)didSelectItemAtIndex:(NSUInteger)index
{
    [HTVHelperMethods saveDefaultLiveChanelPosition:index];
    [self setLiveUrl:[NSURL URLWithString:[HTVHelperMethods fullYoutubeLink]]];
}
@end
