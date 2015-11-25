//
//  FullVideoViewController.m
//  TVA2Go
//
//  Created by Alyson Vivattanapa on 11/24/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "FullVideoViewController.h"

@interface FullVideoViewController ()

@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;

@end

@implementation FullVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.playerView loadWithVideoId:self.video[@"videoID"]];

    
}

@end
