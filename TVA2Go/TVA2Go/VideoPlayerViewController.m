//
//  VideoPlayerViewController.m
//  TVA2Go
//
//  Created by Alyson Vivattanapa on 11/24/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "FullVideoViewController.h"


@interface VideoPlayerViewController () <UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *watchFullVideoButton;
@property (weak, nonatomic) IBOutlet UIButton *postCommentButton;
@property (weak, nonatomic) IBOutlet UIButton *seeAllCommentsButton;

@property (strong, nonatomic) PFQuery *query;

@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    PFQuery *query = [PFQuery queryWithClassName:@"Video"];
    
    [query getObjectInBackgroundWithId:@"Edm0peyVsA"
                                 block:^(PFObject * _Nullable object, NSError * _Nullable error) {
                                     self.videoObject = object;
                                     [self.playerView loadWithVideoId:self.videoObject[@"videoID"]];

                                 }];
    
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [self.playerView playVideo];
}

- (IBAction)dislike:(id)sender {
    //load next video and put video at end of playlist queue if possible
    //make swipe left animation like Tinder
}

- (IBAction)like:(id)sender {
    //pin video
    //maybe add some animation
    // & load next video
}

- (IBAction)share:(id)sender {
    //share on FB or email
}

- (IBAction)watchFullVideo:(id)sender {
    
    FullVideoViewController *f = [[FullVideoViewController alloc] init];
    
    f.video = self.videoObject;
    
    [self.navigationController pushViewController:f animated:YES];
  

}

- (IBAction)postComment:(id)sender {
}


- (IBAction)seeAllComments:(id)sender {
}


@end
