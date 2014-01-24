//
//  AboutViewController.m
//  HromadskeTV
//
//  Created by comonitos on 1/24/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "AboutViewController.h"
#import "UIViewController+HTVNavigationController.h"
#import "HTVWebVC.h"
#import "ControllersManager.h"

@interface AboutViewController ()
{
    __weak IBOutlet UIWebView *_webView;
}
- (IBAction)handleShare:(id)sender;
- (IBAction)handleHelp:(id)sender;
@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = ABOUT_US_PAGE;
    [self setupView];
    [self loadWebView];
}

- (void) loadWebView {
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"about.html"];
    NSURL *url = [NSURL fileURLWithPath:path isDirectory:NO];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}
- (IBAction)handleShare:(id)sender {
    [[ControllersManager sharedManager] showSharing];
}

- (IBAction)handleHelp:(id)sender {
    HTVWebVC *c = [[[ControllersManager sharedManager] storyboard] instantiateViewControllerWithIdentifier:NSStringFromClass([HTVWebVC class])];
    c.URL = [NSURL URLWithString:URL_HROMADSKE_HELP];
    [self.navigationController pushViewController:c animated:YES];
}
@end
