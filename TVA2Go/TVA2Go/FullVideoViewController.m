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
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;


@end

@implementation FullVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playerView.delegate = self;
    
    if (self.fullVideo != nil) {
    
     [self.playerView loadWithVideoId:self.fullVideo.identifier];
        self.titleLabel.text = self.fullVideo.snippet.title;
        NSDate *date = self.fullVideo.snippet.publishedAt.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        NSString *string = [formatter stringFromDate:date];
        self.dateLabel.text = string;
        self.textView.text = self.fullVideo.snippet.descriptionProperty;
    
    } else {
        
        [self.playerView loadWithVideoId:self.parseVideoObject[@"videoID"]];
          self.titleLabel.text = self.parseVideoObject[@"title"];
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
