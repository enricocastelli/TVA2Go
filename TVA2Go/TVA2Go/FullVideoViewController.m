//
//  FullVideoViewController.m
//  TVA2Go
//
//  Created by Alyson Vivattanapa on 11/24/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "FullVideoViewController.h"

@interface FullVideoViewController () <UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;

@end

@implementation FullVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlString = self.video[@"longLink"];
//    
//    [self.playerView loadVideoByURL:urlString startSeconds: suggestedQuality:@"medium"];
    [self.playerView loadWithVideoId:self.video[@"videoID"]];

    
}

@end
