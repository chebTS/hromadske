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

@interface LiveViewController () <UIWebViewDelegate>
{
    __weak IBOutlet UIWebView *_webView;
}

@end

@implementation LiveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setup];
}

- (void) viewWillAppear:(BOOL)animated {
    [self setupView];
}

- (void) setup {
    self.title = ONLINE_PAGE;
    _webView.delegate = self;
    
    for (id subview in _webView.subviews){
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
            ((UIScrollView *)subview).bounces = NO;
    }
}


- (void)setLiveUrl:(NSURL *)url {
    
    if(![_webView.request.URL.absoluteString isEqualToString:url.absoluteString])
    {
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:req];
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

@end
