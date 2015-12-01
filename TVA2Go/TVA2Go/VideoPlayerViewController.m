//
//  VideoPlayerViewController.m
//  TVA2Go
//
//  Created by Alyson Vivattanapa on 11/24/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "TAAYouTubeWrapper.h"
#import "FullVideoViewController.h"



@interface VideoPlayerViewController () <UINavigationControllerDelegate, YTPlayerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *watchFullVideoButton;
@property (weak, nonatomic) IBOutlet UIButton *postCommentButton;
@property (weak, nonatomic) IBOutlet UIButton *seeAllCommentsButton;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) PFQuery *query;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) GTLYouTubeVideo *currentVideo;

@end

@implementation VideoPlayerViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playerView.delegate = self;
    self.user = [PFUser currentUser];
    [self.seeAllCommentsButton setTitle:@"See Comments" forState:UIControlStateNormal];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    UIButton *title = [UIButton buttonWithType:UIButtonTypeSystem];
    title.tintColor = [UIColor whiteColor];
    UIFont * font = [UIFont fontWithName:@"Helvetica Neue" size:20];
    
    title.titleLabel.font = font;
    
    [self.user fetchInBackground];
    
    self.tableView.hidden = YES;
    if (self.videosInPlaylist != nil) {
        
        
        self.currentVideo = self.videosInPlaylist [arc4random() % (self.videosInPlaylist.count)];
        
        [self.playerView loadWithVideoId:self.currentVideo.identifier];
        
        [self.playerView playVideo];
        [title setTitle:[NSString stringWithFormat:@"%@" , self.currentVideo.snippet.title] forState:UIControlStateNormal];
        self.navigationItem.titleView = title;
        
    } else {
        
        nil;
    }
    
    if ([self.user[@"pinnedVideos"] containsObject:self.currentVideo.identifier]) {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.likeButton.alpha = 0;
        }];;
        
    } else {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.likeButton.alpha = 1;
        }];
        
    }
        
}

- (IBAction)dislike:(id)sender {
    //load next video and put video at end of playlist queue if possible
    //make swipe left animation like Tinder
}

- (IBAction)like:(id)sender {
    
    
    if ([self.user[@"pinnedVideos"] containsObject:self.currentVideo.identifier]) {
        
        NSLog(@"Already Pinned");
        
    } else {
        
        
        NSMutableArray *userMustableArray = [self.user[@"pinnedVideos"] mutableCopy];
        
        NSString *stringIdentifier = self.currentVideo.identifier;
        
        [userMustableArray addObject:stringIdentifier];
        
        [self.user setObject:[userMustableArray copy] forKey:@"pinnedVideos"];
        [self.user saveInBackground];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.likeButton.alpha = 0;
        }];
        
    }
    
    self.query = [PFQuery queryWithClassName:@"Video"];
    [self.query whereKey:@"videoID" containsString:self.currentVideo.identifier];
    [self.query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        if (number != 0) {
            
            [self.query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
              
                int pinCount = [[object objectForKey:@"pinCount"] intValue];
                pinCount = pinCount + 1;
                object[@"pinCount"] = [NSNumber numberWithInt:pinCount];
                [object saveInBackground];
            }];
        } else {
            
            PFObject *current = [PFObject objectWithClassName:@"Video"];
            
            NSURL *url = [NSURL URLWithString:self.currentVideo.snippet.thumbnails.standard.url];
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            PFFile *ima = [PFFile fileWithData:data];
            
            current[@"thumbnail"] = ima;
            
            current[@"videoID"] = self.currentVideo.identifier;
            
            current[@"pinCount"] = [NSNumber numberWithInt:0];
            
            int pinCount = [[current objectForKey:@"pinCount"] intValue];
            pinCount = pinCount + 1;
            current[@"pinCount"] = [NSNumber numberWithInt:pinCount];
            
            [current saveInBackground];
        }
    }];
    
    
}


//- (IBAction)swipeRight:(UISwipeGestureRecognizer *)sender {
//    NSLog(@"swiped right");
//    if ([self.user[@"pinnedVideos"] containsObject:self.currentVideo.identifier]) {
//        
//        NSLog(@"Already Pinned");
//        
//    } else {
//        
//        
//        NSMutableArray *userMustableArray = [self.user[@"pinnedVideos"] mutableCopy];
//        
//        NSString *stringIdentifier = self.currentVideo.identifier;
//        
//        [userMustableArray addObject:stringIdentifier];
//        
//        [self.user setObject:[userMustableArray copy] forKey:@"pinnedVideos"];
//        [self.user saveInBackground];
//        
//        [UIView animateWithDuration:0.5 animations:^{
//            self.likeButton.alpha = 0;
//        }];
//        
//    }
//    
//    self.query = [PFQuery queryWithClassName:@"Video"];
//    [self.query whereKey:@"videoID" containsString:self.currentVideo.identifier];
//    [self.query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
//        if (number != 0) {
//            
//            [self.query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
//                
//                int pinCount = [[object objectForKey:@"pinCount"] intValue];
//                pinCount = pinCount + 1;
//                object[@"pinCount"] = [NSNumber numberWithInt:pinCount];
//                [object saveInBackground];
//            }];
//        } else {
//            
//            PFObject *current = [PFObject objectWithClassName:@"Video"];
//            
//            NSURL *url = [NSURL URLWithString:self.currentVideo.snippet.thumbnails.standard.url];
//            NSData *data = [NSData dataWithContentsOfURL:url];
//            
//            PFFile *ima = [PFFile fileWithData:data];
//            
//            current[@"thumbnail"] = ima;
//            
//            current[@"videoID"] = self.currentVideo.identifier;
//            
//            current[@"pinCount"] = [NSNumber numberWithInt:0];
//            
//            int pinCount = [[current objectForKey:@"pinCount"] intValue];
//            pinCount = pinCount + 1;
//            current[@"pinCount"] = [NSNumber numberWithInt:pinCount];
//            
//            [current saveInBackground];
//        }
//    }];
//    
//    
//}
//
//- (IBAction)swipeLeft:(UISwipeGestureRecognizer *)sender {
//    NSLog(@"swiped left");
//}

-(IBAction)FBPressed{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *fbPostSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        NSURL *currentURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@", self.currentVideo.identifier]];
        
        [fbPostSheet addURL:currentURL];
  
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
    
    f.video = self.currentVideo;
    
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
    
    if (self.tableView.hidden == YES) {
    self.tableView.hidden = NO;
    self.tableView.alpha = 0.95;
    [UIView animateWithDuration:0.6 animations:^{
        self.tableView.frame = CGRectMake(0, -900, self.tableView.frame.size.width, self.tableView.frame.size.height);
    }];
        [self.seeAllCommentsButton setTitle:@"Hide Comments" forState:UIControlStateNormal];
    } else {
        [UIView animateWithDuration:1 animations:^{
            self.tableView.frame = CGRectMake(0, -900, self.tableView.frame.size.width, self.tableView.frame.size.height);
        }];
        [self.seeAllCommentsButton setTitle:@"See Comments" forState:UIControlStateNormal];
        self.tableView.hidden = YES;
    }
}

@end
