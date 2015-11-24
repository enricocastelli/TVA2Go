//
//  VideoPlayerViewController.m
//  TVA2Go
//
//  Created by Alyson Vivattanapa on 11/24/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "VideoPlayerViewController.h"

@interface VideoPlayerViewController ()

@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.playerView loadWithVideoId:@"Of5xEVAoWLk"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
