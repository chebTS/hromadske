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
    UIBarButtonItem *item =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.navigationItem.rightBarButtonItem = item;
    
    if (IOS_7)
    {
        [item setTintColor:[UIColor whiteColor]];
    }

    
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
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:req];
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
