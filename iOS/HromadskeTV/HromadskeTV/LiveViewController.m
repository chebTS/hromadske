//
//  LiveViewController.m
//  HromadskeTV
//
//  Created by comonitos on 1/21/14.
//  Copyright (c) 2014 Max Tymchii. All rights reserved.
//

#import "LiveViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface LiveViewController ()
{
    MPMoviePlayerController *_videoController;
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
}


- (void) setup {
    _videoController = [[MPMoviePlayerController alloc] initWithContentURL:nil];
    _videoController.view.frame = self.view.bounds;
    _videoController.controlStyle = MPMovieControlStyleNone;
    _videoController.shouldAutoplay = NO;
    _videoController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_videoController prepareToPlay];
    [self.view addSubview:_videoController.view];
}

@end
