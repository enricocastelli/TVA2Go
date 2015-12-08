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
#import "TVA2Go-Swift.h"


@interface VideoPlayerViewController () <UINavigationControllerDelegate, YTPlayerViewDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *watchFullVideoButton;
@property (weak, nonatomic) IBOutlet UIButton *seeAllCommentsButton;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) PFQuery *query;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) GTLYouTubeVideo *currentVideo;
@property (weak, nonatomic) IBOutlet UILabel *postDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinCountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *instructions;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *postCommentButton;

@property (weak, nonatomic) IBOutlet UITextField *textFieldComment;

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) PFFile *imageFile;

@property (strong, nonatomic) PFFile *videoFile;

@property (strong, nonatomic) NSArray *arrayOfCommentObjects;

@end

@implementation VideoPlayerViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playerView.delegate = self;
    
    [self.tableView setDelegate:self];
    
    [self.tableView setDataSource:self];

    [self.seeAllCommentsButton setTitle:@"  Comments" forState:UIControlStateNormal];
    
    UIBarButtonItem *myPins = [[UIBarButtonItem alloc] initWithTitle:@"My Pins" style:UIBarButtonItemStylePlain target:self action:@selector(myPins)];
    self.navigationItem.rightBarButtonItem = myPins;
    
    self.dislikeButton.layer.cornerRadius = self.dislikeButton.frame.size.width/2;
    self.likeButton.layer.cornerRadius = self.likeButton.frame.size.width/2;
    self.FBPost.layer.cornerRadius = self.FBPost.frame.size.width/2;

    self.seeAllCommentsButton.layer.cornerRadius = self.seeAllCommentsButton.frame.size.width/10;
    self.watchFullVideoButton.layer.cornerRadius = self.watchFullVideoButton.frame.size.width/10;
    [self.dislikeButton addTarget:self action:@selector(dislike) forControlEvents:UIControlEventTouchUpInside];
    [self.likeButton addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.user = [PFUser currentUser];
    
    self.instructions.hidden = NO;
    
    [self.playerView removeWebView];

    UIButton *title = [UIButton buttonWithType:UIButtonTypeSystem];
    title.tintColor = [UIColor whiteColor];
    UIFont * font = [UIFont fontWithName:@"Helvetica Neue" size:20];
    
    title.titleLabel.font = font;
    
    [self.user fetchInBackground];
    
    self.tableView.hidden = YES;
    if (self.videosInPlaylist != nil) {
        
        
        self.currentVideo = self.videosInPlaylist [arc4random() % (self.videosInPlaylist.count)];
        NSDictionary *playerVars = @{
                                     @"playsinline" : @1,
                                     };
        
        [self.playerView loadWithVideoId:self.currentVideo.identifier playerVars:playerVars];
        [self.playerView playVideo];
        [title setTitle:@"TVA2Go" forState:UIControlStateNormal];
        self.navigationItem.titleView = title;
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

//- (void)toolbarButtonsEnabled
//{
//    if ([PFUser currentUser]) {
//        self.cameraButton.enabled = YES;
//        self.textFieldComment.enabled = YES;
//        self.postCommentButton.enabled = YES;
//    } else {
//        self.toolbar.alpha = 0.5;
////        self.cameraButton.enabled = NO;
////        self.textFieldComment.enabled = NO;
////        self.postCommentButton.enabled = NO;
//    }
//}

- (void)likeButtonEnabled
{
    if ([PFUser currentUser]) {
    if ([self.user[@"pinnedVideos"] containsObject:self.currentVideo.identifier]) {
        self.likeButton.alpha = 0.3;
        self.likeButton.enabled = NO;
        
    } else {
        
        self.likeButton.alpha = 1;
        self.likeButton.enabled = YES;
    }
    } else {
        self.likeButton.alpha = 0.3;
        self.likeButton.enabled = NO;

    }
}


- (UIColor *)playerViewPreferredWebViewBackgroundColor:(YTPlayerView *)playerView;
{
    return [UIColor blackColor];
}


-(void)playerViewDidBecomeReady:(YTPlayerView *)playerView
{
    [playerView playVideo];
    [self.likeButton.layer removeAllAnimations];
    if (self.playerView.currentTime == 10) {
        
        NSDictionary *playerVars = @{
                                     @"playsinline" : @1,
                                     };
        
        self.currentVideo = self.videosInPlaylist [arc4random() % (self.videosInPlaylist.count)];
        [playerView loadWithVideoId:self.currentVideo.identifier playerVars:playerVars];
        [playerView playVideo];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.playerView stopVideo];
    self.tableView.hidden = YES;
    self.toolbar.hidden = YES;
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state
{
    if (state == kYTPlayerStatePlaying) {
        self.instructions.hidden = YES;
    }
}


- (void)dislike
{

    [self animateVideoDislike:self.playerView];
    }

- (void)like
{
    [self animateVideoLike:self.playerView];

    self.query = [PFQuery queryWithClassName:@"Video"];
    [self.query whereKey:@"videoID" containsString:self.currentVideo.identifier];
    [self.query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
       
        if (number) {
            
            [self.query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
              
                int pinCount = [[object objectForKey:@"pinCount"] intValue];
                pinCount = pinCount + 1;
                object[@"pinCount"] = [NSNumber numberWithInt:pinCount];
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    [self likeAlready];

                }];
            }];
        } else {
            
            PFObject *current = [PFObject objectWithClassName:@"Video"];
            
            NSURL *url = [NSURL URLWithString:self.currentVideo.snippet.thumbnails.standard.url];
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            PFFile *ima = [PFFile fileWithData:data];
            
            current[@"thumbnail"] = ima;

            
            current[@"description"] = self.currentVideo.snippet.descriptionProperty;
            current[@"title"] = self.currentVideo.snippet.title;
            current[@"videoID"] = self.currentVideo.identifier;
            current[@"youtubeDate"] = self.currentVideo.snippet.publishedAt.date;
            current[@"pinCount"] = [NSNumber numberWithInt:1];
            
            [current saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [self likeAlready];
            }];
            
        }
    }];
    
    
}

- (void)likeAlready {
    
    if ([self.user[@"pinnedVideos"] containsObject:self.currentVideo.identifier]) {
        
        NSLog(@"Already Pinned");
        
    } else {
        
        
        NSMutableArray *userMustableArray = [self.user[@"pinnedVideos"] mutableCopy];
        
        NSString *stringIdentifier = self.currentVideo.identifier;
        
        [userMustableArray addObject:stringIdentifier];
        
        [self.user setObject:[userMustableArray copy] forKey:@"pinnedVideos"];
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                
                [UIView animateWithDuration:1 animations:^{
                    self.likeButton.titleLabel.alpha = 0;
                    
                    self.likeButton.bounds = CGRectMake(0, 0, self.likeButton.bounds.size.width +5, self.likeButton.bounds.size.width +5);
                    self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.7 animations:^{
                        self.likeButton.titleLabel.alpha = 1;
                        
                        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStylePlain;
                        self.likeButton.bounds = CGRectMake(0, 0, self.likeButton.bounds.size.width -5, self.likeButton.bounds.size.width -5);
                    }];
                    
                }];
            }
        }];
        
        
    }
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
        
        NSURL *currentURL = self.playerView.videoUrl;
        
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
    
    FullVideoSwift *f = [[FullVideoSwift alloc] initWithNibName:@"FullVideoViewController" bundle:nil];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfCommentObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    PFObject *commentObject = self.arrayOfCommentObjects[indexPath.row];
    
    cell.textLabel.text = commentObject[@"stringComment"];
    cell.detailTextLabel.text = commentObject[@"username"];
    PFFile *file = commentObject[@"imageComment"];
    [file getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        UIImage *image = [UIImage imageWithData:data];
        cell.imageView.image = image;
        cell.textLabel.text = commentObject[@"stringComment"];
        cell.detailTextLabel.text = commentObject[@"username"];

    }];
    
    return cell;
}

- (IBAction)seeAllComments:(id)sender {
    if (self.tableView.hidden == YES) {
//        [self toolbarButtonsEnabled];
        self.tableView.hidden = NO;
        self.toolbar.hidden = NO;
        self.tableView.alpha = 0.95;
        [UIView animateWithDuration:0.6 animations:^{
            self.tableView.frame = CGRectMake(0, -900, self.tableView.frame.size.width, self.tableView.frame.size.height);
            self.toolbar.frame = CGRectMake(0, -900, self.toolbar.frame.size.width, self.toolbar.frame.size.height);
        }];
        [self.seeAllCommentsButton setTitle:@"  Hide Comments" forState:UIControlStateNormal];
        self.watchFullVideoButton.hidden = YES;
        
        PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
        
        [query whereKey:@"videoID" equalTo:self.currentVideo.identifier];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            self.arrayOfCommentObjects = objects;
            [self.tableView reloadData];
        }];
        
        
    } else {
        [UIView animateWithDuration:1 animations:^{
            self.tableView.frame = CGRectMake(0, -900, self.tableView.frame.size.width, self.tableView.frame.size.height);
                self.toolbar.frame = CGRectMake(0, -900, self.toolbar.frame.size.width, self.toolbar.frame.size.height);
        }];
        [self.seeAllCommentsButton setTitle:@"  Comments" forState:UIControlStateNormal];
        self.watchFullVideoButton.hidden = NO;
        
        self.tableView.hidden = YES;
        self.toolbar.hidden = YES;

    }
}

- (void)myPins
{
    
    if ([PFUser currentUser]){
    PinnedViewController *p = [[PinnedViewController alloc]init];
   [self.navigationController pushViewController:p animated:YES];
    } else {
        UIAlertController *notLogin = [UIAlertController alertControllerWithTitle:@"You are not logged in!" message:@"Log in to pin videos" preferredStyle:UIAlertControllerStyleAlert];
       
        
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
                         
                         self.titleLabel.text = self.currentVideo.snippet.title;
                         
                         NSDate *date = self.currentVideo.snippet.publishedAt.date;
                         NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                         formatter.dateStyle = NSDateFormatterMediumStyle;
                         NSString *string = [formatter stringFromDate:date];
                         self.postDateLabel.text = string;
                         
                         [self likeButtonEnabled];
                         
                         [UIView animateWithDuration:3.5 animations:^{
                             
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

- (IBAction)addStringComment:(id)sender {
}


- (IBAction)addPhotoOrVideoComment:(id)sender {
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.allowsEditing = YES;
    self.imagePicker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray *availableTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        self.imagePicker.mediaTypes = availableTypes;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        self.imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    } else {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *infoImage = info[UIImagePickerControllerMediaType];
    if ([infoImage isEqualToString:@"public.image"]) {
        UIImage *image = info[UIImagePickerControllerEditedImage];
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        PFFile *file = [PFFile fileWithData:data];
        self.imageFile = file;
        
        [self dismissViewControllerAnimated:YES completion:NULL];
    
    } else {
    
        NSURL *commentVideoUrl = info[UIImagePickerControllerMediaURL];
        NSData *data = [NSData dataWithContentsOfURL:commentVideoUrl];
        PFFile *file = [PFFile fileWithData:data];
        self.videoFile = file;
        [[NSFileManager defaultManager] removeItemAtPath:[commentVideoUrl path] error:nil];
        
        [self dismissViewControllerAnimated:YES completion:NULL];
    
    }
    
}

- (IBAction)postComment:(id)sender {
    
    if ([PFUser currentUser]) {
        
        PFObject *comment = [PFObject objectWithClassName:@"Comments"];
        if (self.textFieldComment.text != nil) {
            [comment setObject:self.textFieldComment.text forKey:@"stringComment"];
        } else {
            nil;
        }
        
        if (self.imageFile != nil) {
            [comment setObject:self.imageFile forKey:@"imageComment"];
        } else {
            nil;
        }
        
        if (self.videoFile != nil) {
            [comment setObject:self.videoFile forKey:@"videoComment"];
        } else {
            nil;
        }
        
        [comment setObject:self.user.username forKey:@"username"];
        
        [comment saveInBackground];
        
    } else {
        nil;
    }

}
//- (void)alertControllerBackgroundTapped
//
//{
//    [self dismissViewControllerAnimated: YES
//                             completion: nil];
//}

@end
