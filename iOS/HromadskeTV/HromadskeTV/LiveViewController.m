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
//    UIBarButtonItem *item =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
//    self.navigationItem.rightBarButtonItem = item;
    
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
    [[RemoteManager sharedManager] showRemoteActivity];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[RemoteManager sharedManager] hideRemoteActivity];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[RemoteManager sharedManager] hideRemoteActivity];
}

#pragma mark - SINavigationMenu methods

- (void)setupDropDownTable
{
    CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
    OnlineStream *currentStream = [HTVHelperMethods onlineStreamForKey:[HTVHelperMethods  keyForOnlineWithPosition:[HTVHelperMethods defaultLiveChanel]]];
    SINavigationMenuView *menu = [[SINavigationMenuView alloc] initWithFrame:frame title:currentStream.name];
    //Set in which view we will display a menu
    [menu displayMenuInView:self.view];
    //Create array of items
    
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
