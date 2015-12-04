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
#import "PinnedViewController.h"



@interface VideoPlayerViewController () <UINavigationControllerDelegate, YTPlayerViewDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *watchFullVideoButton;
@property (weak, nonatomic) IBOutlet UIButton *postCommentButton;
@property (weak, nonatomic) IBOutlet UIButton *seeAllCommentsButton;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) PFQuery *query;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) GTLYouTubeVideo *currentVideo;
@property (weak, nonatomic) IBOutlet UILabel *postDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinCountLabel;
@property (weak, nonatomic) IBOutlet YTPlayerView *secondPlayerView;

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@end

@implementation VideoPlayerViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playerView.delegate = self;
    self.secondPlayerView.delegate = self;

    self.secondPlayerView.hidden = YES;
    self.user = [PFUser currentUser];
    [self.seeAllCommentsButton setTitle:@"  See Comments" forState:UIControlStateNormal];
    
    UIBarButtonItem *myPins = [[UIBarButtonItem alloc] initWithTitle:@"My Pins" style:UIBarButtonItemStylePlain target:self action:@selector(myPins)];
    self.navigationItem.rightBarButtonItem = myPins;
    
    self.dislikeButton.layer.cornerRadius = self.dislikeButton.frame.size.width/2;
    self.likeButton.layer.cornerRadius = self.likeButton.frame.size.width/2;
    self.postCommentButton.layer.cornerRadius = self.postCommentButton.frame.size.width/2;
    self.FBPost.layer.cornerRadius = self.FBPost.frame.size.width/2;

    self.seeAllCommentsButton.layer.cornerRadius = self.seeAllCommentsButton.frame.size.width/10;
    self.watchFullVideoButton.layer.cornerRadius = self.watchFullVideoButton.frame.size.width/10;
    [self.dislikeButton addTarget:self action:@selector(dislike) forControlEvents:UIControlEventTouchUpInside];
    [self.likeButton addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self.user fetchInBackground];
    
    self.tableView.hidden = YES;
    if (self.videosInPlaylist != nil) {
        
        
        self.currentVideo = self.videosInPlaylist [arc4random() % (self.videosInPlaylist.count)];
        NSDictionary *playerVars = @{
                                     @"playsinline" : @1,
                                     };
        
        [self.playerView loadWithVideoId:self.currentVideo.identifier playerVars:playerVars];
        [self.playerView playVideo];
        self.navigationItem.title = @"TVA2Go";
        self.titleLabel.text = self.currentVideo.snippet.title;
        NSDate *date = self.currentVideo.snippet.publishedAt.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        NSString *string = [formatter stringFromDate:date];
        self.postDateLabel.text = string;
        [self likeButtonEnabled];
        
    } else {
        
        nil;
    }
        
}

- (void)likeButtonEnabled
{
    if ([self.user[@"pinnedVideos"] containsObject:self.currentVideo.identifier]) {
        self.likeButton.alpha = 0.3;
        self.likeButton.enabled = NO;
        
    } else {
        
        self.likeButton.alpha = 1;
        self.likeButton.enabled = YES;
    }
}


-(void)playerViewDidBecomeReady:(YTPlayerView *)playerView
{
    [playerView playVideo];
    [self.likeButton.layer removeAllAnimations];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.playerView stopVideo];
}



- (void)dislike
{

    [self animateVideoDislike:self.playerView];
    
}

- (void)like
{

    [self animateVideoLike:self.playerView];
    
    if ([self.user[@"pinnedVideos"] containsObject:self.currentVideo.identifier]) {
        
        NSLog(@"Already Pinned");
        
    } else {
        
        
        NSMutableArray *userMustableArray = [self.user[@"pinnedVideos"] mutableCopy];
        
        NSString *stringIdentifier = self.currentVideo.identifier;
        
        [userMustableArray addObject:stringIdentifier];
        
        [self.user setObject:[userMustableArray copy] forKey:@"pinnedVideos"];
        [self.user saveInBackground];
        
        CABasicAnimation *halfTurn;
        halfTurn = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        halfTurn.fromValue = [NSNumber numberWithFloat:0];
        halfTurn.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
        halfTurn.duration = 0.2;
        halfTurn.repeatCount = 100;
        [self.likeButton.layer addAnimation:halfTurn forKey:@"180"];

        [UIView animateWithDuration:1 animations:^{
            self.likeButton.titleLabel.alpha = 0;

            self.likeButton.bounds = CGRectMake(0, 0, self.likeButton.bounds.size.width +50, self.likeButton.bounds.size.width +50);
            self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.7 animations:^{
                self.likeButton.titleLabel.alpha = 1;

                self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStylePlain;
                self.likeButton.bounds = CGRectMake(0, 0, self.likeButton.bounds.size.width -50, self.likeButton.bounds.size.width -50);
            }];

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


- (IBAction)swipeRight:(UISwipeGestureRecognizer *)sender {
    [self like];
}

- (IBAction)swipeLeft:(UISwipeGestureRecognizer *)sender {
    [self dislike];
}

-(IBAction)FBPressed{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *fbPostSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        NSURL *currentURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@", self.currentVideo.identifier]];
        
        [fbPostSheet addURL:currentURL];
  
        [self presentViewController:fbPostSheet animated:YES completion:nil];
    } else
    {
        UIAlertController *sorry = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"You can't post right now, make sure your device has an internet connection and you have at least one facebook account setup" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES
                                     completion:nil];
        }];
        
        [sorry addAction:ok];
        [self presentViewController:sorry animated:YES completion:nil];
        
    }
}


- (IBAction)watchFullVideo:(id)sender {
    
    FullVideoViewController *f = [[FullVideoViewController alloc] init];
    
    f.fullVideo = self.currentVideo;
    f.view.alpha = 0;

    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        f.view.alpha = 1;
    } completion:nil];
    
//    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:.8 initialSpringVelocity:.5 options:UIViewAnimationOptionCurveLinear animations:UIViewAnimationOptionTransitionCrossDissolve completion:nil];
    
//    [UIView beginAnimations:@"View Flip" context:nil];
//    [UIView setAnimationDuration:0.80];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    
//    [UIView setAnimationTransition:
//     UIViewAnimationTransitionFlipFromLeft
//                           forView:self.navigationController.view cache:NO];
    
    
    [self.navigationController pushViewController:f animated:YES];
//    [UIView commitAnimations];
    
}

- (IBAction)postComment:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Post a comment!"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];

    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Write your comment here :) Or click the camera button to post a photo or video response!";
        
    
    }];
    
    UIAlertAction *takeAPhotoOrVideo = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        self.imagePicker = [[UIImagePickerController alloc] init];
        
        self.imagePicker.allowsEditing = YES;
        
        self.imagePicker.delegate = self;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            NSArray *availableTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            self.imagePicker.mediaTypes = availableTypes;
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
            self.imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
        } else {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        [self presentViewController:self.imagePicker animated:YES completion: NULL];
    }];

    [takeAPhotoOrVideo setValue:[[UIImage imageNamed:@"cameraButton.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    
    [alert addAction:takeAPhotoOrVideo];
    alert.view.tintColor = [UIColor whiteColor];
    
      [self presentViewController:alert animated:YES completion:nil];

    
// didFinishPickingMediaWithInfo example when writing code to save media to Parse and then pass to table view.
//    - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//    {
//        
//        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//        
//        AddLekkerViewController *addLekkerViewController = [[AddLekkerViewController alloc]init];
//        
//        addLekkerViewController.photo = image;
//        
//        [self dismissViewControllerAnimated:YES completion:NULL];
//        
//        [self.navigationController pushViewController:addLekkerViewController animated:YES];
//    }
    
}


- (IBAction)seeAllComments:(id)sender {
    if (self.tableView.hidden == YES) {
        self.tableView.hidden = NO;
        self.tableView.alpha = 0.95;
        [UIView animateWithDuration:0.6 animations:^{
            self.tableView.frame = CGRectMake(0, -900, self.tableView.frame.size.width, self.tableView.frame.size.height);
        }];
        [self.seeAllCommentsButton setTitle:@"  Hide Comments" forState:UIControlStateNormal];
        self.watchFullVideoButton.hidden = YES;
    } else {
        [UIView animateWithDuration:1 animations:^{
            self.tableView.frame = CGRectMake(0, -900, self.tableView.frame.size.width, self.tableView.frame.size.height);
        }];
        [self.seeAllCommentsButton setTitle:@"  See Comments" forState:UIControlStateNormal];
        self.watchFullVideoButton.hidden = NO;
        
        self.tableView.hidden = YES;
    }
}

- (void)myPins
{
    
    if ([PFUser currentUser]){
    PinnedViewController *p = [[PinnedViewController alloc]init];
   [self.navigationController pushViewController:p animated:YES];
    } else {
        UIAlertController *notLogin = [UIAlertController alertControllerWithTitle:@"You are not logged in" message:@"Log in to pin videos" preferredStyle:UIAlertControllerStyleAlert];
       
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [notLogin addAction:cancel];
        [self presentViewController:notLogin animated:YES completion:nil];
    }
}

- (void)animateVideoLike:(YTPlayerView *)playerView
{
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         playerView.center = CGPointMake(playerView.center.x +800, playerView.center.y);
                         playerView.transform = CGAffineTransformMakeRotation(1.5);
                     }
                     completion:^(BOOL finished) {
                         
                         playerView.alpha = 0;
                         [playerView.layer removeAllAnimations];
                         playerView.transform = CGAffineTransformMakeRotation(0);
                         
                         NSDictionary *playerVars = @{
                                                      @"playsinline" : @1,
                                                      };
                         
                         self.currentVideo = self.videosInPlaylist [arc4random() % (self.videosInPlaylist.count)];
                         [playerView loadWithVideoId:self.currentVideo.identifier playerVars:playerVars];
                         [playerView playVideo];
                         
                         UIButton *title = [UIButton buttonWithType:UIButtonTypeSystem];
                         title.tintColor = [UIColor whiteColor];
                         UIFont * font = [UIFont fontWithName:@"Helvetica Neue" size:20];
                         
                         title.titleLabel.font = font;
                         [title setTitle:[NSString stringWithFormat:@"%@" , self.currentVideo.snippet.title] forState:UIControlStateNormal];
                         self.navigationItem.titleView = title;
                         self.titleLabel.text = self.currentVideo.snippet.title;
                         
                         NSDate *date = self.currentVideo.snippet.publishedAt.date;
                         NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                         formatter.dateStyle = NSDateFormatterMediumStyle;
                         NSString *string = [formatter stringFromDate:date];
                         self.postDateLabel.text = string;
                         
                         [self likeButtonEnabled];
                         
                         [UIView animateWithDuration:3 animations:^{
                             
                             playerView.alpha = 1;
                         }];
                     }];
    
}

- (void)animateVideoDislike:(YTPlayerView *)playerView
{
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         playerView.center = CGPointMake(playerView.center.x -800, playerView.center.y);
                         playerView.transform = CGAffineTransformMakeRotation(1.5);
                     }
                     completion:^(BOOL finished) {
                         
                         playerView.alpha = 0;
                         [playerView.layer removeAllAnimations];
                         playerView.transform = CGAffineTransformMakeRotation(0);
                         
                         NSDictionary *playerVars = @{
                                                      @"playsinline" : @1,
                                                      };
                         
                         self.currentVideo = self.videosInPlaylist [arc4random() % (self.videosInPlaylist.count)];
                         [playerView loadWithVideoId:self.currentVideo.identifier playerVars:playerVars];
                         [playerView playVideo];
                         
                         UIButton *title = [UIButton buttonWithType:UIButtonTypeSystem];
                         title.tintColor = [UIColor whiteColor];
                         UIFont * font = [UIFont fontWithName:@"Helvetica Neue" size:20];
                         
                         title.titleLabel.font = font;
                         [title setTitle:[NSString stringWithFormat:@"%@" , self.currentVideo.snippet.title] forState:UIControlStateNormal];
                         self.navigationItem.titleView = title;
                          self.titleLabel.text = self.currentVideo.snippet.title;
                         
                             NSDate *date = self.currentVideo.snippet.publishedAt.date;
                             NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                             formatter.dateStyle = NSDateFormatterMediumStyle;
                             NSString *string = [formatter stringFromDate:date];
                             self.postDateLabel.text = string;
                         
                         [self likeButtonEnabled];

                         
                         
                         [UIView animateWithDuration:3 animations:^{
                             
                             playerView.alpha = 1;
                         }];
                     }];
    
}



@end
