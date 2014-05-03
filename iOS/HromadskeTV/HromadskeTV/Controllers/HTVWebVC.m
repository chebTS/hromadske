//
//  HTVWebVC.m
//  HromadskeTV
//
//  Created by Max Tymchii on 12/3/13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//

#import "HTVWebVC.h"
#import "UIViewController+HTVNavigationController.h"

@interface HTVWebVC ()
{
	UIActivityIndicatorView *_indicator;
}
@end

@implementation HTVWebVC

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsOpenInChrome | SVWebViewControllerAvailableActionsMailLink;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
	//    [self updateToolbarItems];
	
	_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	UIBarButtonItem *loader = [[UIBarButtonItem alloc] initWithCustomView:_indicator];
    self.navigationItem.rightBarButtonItem = loader;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
	[_indicator startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[_indicator stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[_indicator stopAnimating];
}


@end
