//
//  VideoPlayerViewController.h
//  TVA2Go
//
//  Created by Alyson Vivattanapa on 11/24/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Social/Social.h"
#import "TAAYouTubeWrapper.h"
#import "GTLYouTube.h"

@interface VideoPlayerViewController : UIViewController

@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;

@property (weak, nonatomic) IBOutlet UIButton *FBPost;

@property (strong, nonatomic) NSArray* videosInPlaylist;

-(IBAction)FBPressed;

@end
