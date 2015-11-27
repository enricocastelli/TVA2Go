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
@property (weak, nonatomic) IBOutlet UIButton *watchFullVideoButton;
@property (weak, nonatomic) IBOutlet UIButton *postCommentButton;
@property (weak, nonatomic) IBOutlet UIButton *seeAllCommentsButton;

@property (strong, nonatomic) PFQuery *query;

@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    PFQuery *query = [PFQuery queryWithClassName:@"Video"];
    
    [query getObjectInBackgroundWithId:@"0JPB3M5wXp"
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
    
    NSNumber *numberCount = self.videoObject[@"pinCount"];
    
    int intCount = numberCount.intValue + 1;

    NSNumber *newPinCount = [[NSNumber alloc]initWithInt:intCount];
    
    self.videoObject[@"pinCount"] = newPinCount;
    
    
    [self.videoObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.likeButton.alpha = 0;
        } completion:nil];
        PFUser *user = [PFUser currentUser];
        NSMutableArray *userMustableArray = [user[@"pinnedVideos"] mutableCopy];
        [userMustableArray addObject:self.videoObject.objectId];
        [user setObject:[userMustableArray copy] forKey:@"pinnedVideos"];
        [user saveInBackground];
        
    }];
   
   
    
}
//
//    //pin video: n = n+1 something like that
//    //maybe add some animation
//    // & load next video
//    //BIG HEART FADES INTO VIEW, THEN LITTLE HEART ICON FADES OUT A LITTLE AND IS NO LONGER PRESSABLE. THEN COUNTER ADDS +1 TO PARSE, AND loads next video. Send data to Parse.
//    


-(IBAction)FBPressed{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *fbPostSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        NSURL *testURL = [NSURL URLWithString:@"https://www.youtube.com/watch?v=Of5xEVAoWLk"];
        
        [fbPostSheet addURL:testURL];
        
//       [fbPostSheet addURL:self.videoObject[@"shortLink"]];
// ideal code i'd like to get working ^^ edit: but it ain't gonna work like that. Going to have to do something like NSURL *variable = [NSURL URLWithString:self.videoObject[@"shortLink"]]; or something and maybe probably within a block, i.e getObjectInBackgroundWithBlock perhaps.
        
        
        //[fbPostSheet setInitialText:@"This is a Facebook post!"];
        //FB actually doesn't allow pre-selected text anymore, so this doesn't work unless there's a bug, i.e. you are logged into FB in the general settings on your phone but you don't have the FB app installed on your device.
        [self presentViewController:fbPostSheet animated:YES completion:nil];
    } else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't post right now, make sure your device has an internet connection and you have at least one facebook account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        //UIAlertView is deprecated and we should replace with UIAlertController with a preferredStyle of UIAlertControllerStyleAlert
        [alertView show];
    }
}


- (IBAction)watchFullVideo:(id)sender {
    
    FullVideoViewController *f = [[FullVideoViewController alloc] init];
    
    f.video = self.videoObject;
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:
     UIViewAnimationTransitionFlipFromLeft
                           forView:self.navigationController.view cache:NO];
    
    
    [self.navigationController pushViewController:f animated:YES];
    [UIView commitAnimations];
    
}

- (IBAction)postComment:(id)sender {
}


- (IBAction)seeAllComments:(id)sender {
}


@end
