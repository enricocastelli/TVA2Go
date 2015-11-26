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

@interface VideoPlayerViewController : UIViewController

@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;

@property (strong, nonatomic) PFObject *videoObject;





@end
