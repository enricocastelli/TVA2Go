//
//  VideoPlayerViewController.m
//  TVA2Go
//
//  Created by Alyson Vivattanapa on 11/24/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "VideoPlayerViewController.h"

@interface VideoPlayerViewController () <UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UIButton *watchFullVideoButton;

@property (weak, nonatomic) IBOutlet UIButton *postCommentButton;

@property (weak, nonatomic) IBOutlet UIButton *seeAllComments;

@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.playerView loadWithVideoId:@"Of5xEVAoWLk"];

}

- (void)viewWillAppear:(BOOL)animated
{
    [self.playerView playVideo];
}

@end
