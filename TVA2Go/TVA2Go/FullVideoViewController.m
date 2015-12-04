//
//  FullVideoViewController.m
//  TVA2Go
//
//  Created by Alyson Vivattanapa on 11/24/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "FullVideoViewController.h"
#import "PinnedViewController.h"

@interface FullVideoViewController () <UINavigationControllerDelegate, YTPlayerViewDelegate>

@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;

@end

@implementation FullVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playerView.delegate = self;
    
    if (self.fullVideo != nil) {
    
     [self.playerView loadWithVideoId:self.fullVideo.identifier];
    
    } else {
        
        [self.playerView loadWithVideoId:self.parseVideoObject[@"videoID"]];
    }
    
}

- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView
{
    [playerView playVideo];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.playerView stopVideo];
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state
{
    if (state == kYTPlayerStatePlaying) {
        
    }
}





@end
