//
//  VideoPlayerViewController.m
//  TVA2Go
//
//  Created by Alyson Vivattanapa on 11/24/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "TAAYouTubeWrapper.h"
#import "PinnedViewController.h"
#import "TVA2Go-Swift.h"


@interface VideoPlayerViewController () <YTPlayerViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *watchFullVideoButton;
@property (weak, nonatomic) IBOutlet UIButton *seeAllCommentsButton;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) PFQuery *query;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *act;

@property (strong, nonatomic) GTLYouTubeVideo *currentVideo;
@property (weak, nonatomic) IBOutlet UILabel *postDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinCountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *instructions;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *postCommentButton;

@property (weak, nonatomic) IBOutlet UITextField *textFieldComment;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@property (strong, nonatomic) NSArray *arrayOfCommentObjects;
@property (nonatomic) CGRect tableViewOriginal;

@end

@implementation VideoPlayerViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableViewOriginal = self.tableView.frame;

    [self setButtons];
    [self settingDelegate];
    self.act.hidden = YES;




    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.user = [PFUser currentUser];
    self.watchFullVideoButton.hidden = NO;
    self.instructions.hidden = NO;
    [self setNav];

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [self.user fetchInBackground];

    [self.textFieldComment resignFirstResponder];
    [self ifVideo];
    
}

- (void)settingDelegate
{
    self.textFieldComment.delegate = self;
    self.playerView.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.textFieldComment resignFirstResponder];
    self.tableView.frame = self.tableViewOriginal;
    [self.playerView stopVideo];
    self.tableView.hidden = YES;
    self.toolbar.hidden = YES;
}


- (void)setNav
{
    UIBarButtonItem *myPins = [[UIBarButtonItem alloc] initWithTitle:@"My Pins" style:UIBarButtonItemStylePlain target:self action:@selector(myPins)];
    self.navigationItem.rightBarButtonItem = myPins;
    
    self.navigationItem.title = @"TVA2Go";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}


- (void)toolbarButtonsEnabled
{
    if ([PFUser currentUser]) {
        self.textFieldComment.enabled = YES;
        self.postCommentButton.enabled = YES;
        self.cancelButton.enabled = YES;

    } else {
        self.textFieldComment.enabled = NO;
        self.postCommentButton.enabled = NO;
        self.cancelButton.enabled = NO;
    }
}

- (void)ifVideo{
    if (self.videosInPlaylist != nil) {
        
        
        self.currentVideo = self.videosInPlaylist [arc4random() % (self.videosInPlaylist.count)];
        NSDictionary *playerVars = @{
                                     @"playsinline" : @1,
                                     };
        
        [self.playerView loadWithVideoId:self.currentVideo.identifier playerVars:playerVars];
        [self.playerView playVideo];

        self.titleLabel.text = self.currentVideo.snippet.title;
        NSDate *date = self.currentVideo.snippet.publishedAt.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        NSString *string = [formatter stringFromDate:date];
        self.postDateLabel.text = string;
        [self likeButtonEnabled];
        [self callQuery];

        
    } else {
        
        nil;
    }
}

- (void)callQuery
{
    self.query = [PFQuery queryWithClassName:@"Video"];
    [self.query whereKey:@"videoID" containsString:self.currentVideo.identifier];
    [self.query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        NSString *pinString = [NSString stringWithFormat:@"Pinned %@ times", object[@"pinCount"]];
        self.pinCountLabel.text = pinString;
    }];
    
}

- (void)setButtons
{
    self.likeButton.layer.cornerRadius = self.likeButton.frame.size.width/2;
    self.FBPost.layer.cornerRadius = self.FBPost.frame.size.width/2;
    
    self.seeAllCommentsButton.layer.cornerRadius = self.seeAllCommentsButton.frame.size.width/13;
    self.watchFullVideoButton.layer.cornerRadius = self.watchFullVideoButton.frame.size.width/13;
    [self.likeButton addTarget:self action:@selector(likeAlready) forControlEvents:UIControlEventTouchUpInside];
}


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

 
    [self.query whereKey:@"videoID" containsString:self.currentVideo.identifier];
    [self.query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
       
        if (number) {
            
            [self.query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
              
                int pinCount = [[object objectForKey:@"pinCount"] intValue];
                pinCount = pinCount + 1;
                object[@"pinCount"] = [NSNumber numberWithInt:pinCount];
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
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
            }];
            
        }
    }];
    
    
}

- (void)likeAlready {
    
    [self animateVideoLike:self.playerView];

    if ([self.user[@"pinnedVideos"] containsObject:self.currentVideo.identifier]) {
        
        NSLog(@"Already Pinned");
        
    } else {
        
        [self like];
        NSMutableArray *userMustableArray = [self.user[@"pinnedVideos"] mutableCopy];
        
        NSString *stringIdentifier = self.currentVideo.identifier;
        
        [userMustableArray addObject:stringIdentifier];
        
        [self.user setObject:[userMustableArray copy] forKey:@"pinnedVideos"];
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                self.likeButton.alpha = 0.3;

                self.likeButton.enabled = NO;
                
            }
        }];
        
        
    }
}

- (IBAction)swipeRight:(UISwipeGestureRecognizer *)sender {
    [self likeAlready];
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
    
    FullVideoSwift *f = [[FullVideoSwift alloc] initWithNibName:@"FullSwiftViewController" bundle:nil];
    
    f.fullVideo = self.currentVideo;
    f.view.alpha = 0;

    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        f.view.alpha = 1;
    } completion:nil];
    
    [self.navigationController pushViewController:f animated:YES];
    
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
    
    self.act.hidden = NO;
    [self.act startAnimating];
    
    [self toolbarButtonsEnabled];
    self.tableView.hidden = NO;
    self.toolbar.hidden = NO;
    self.tableView.alpha = 0.95;
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    
    [query whereKey:@"videoID" equalTo:self.currentVideo.identifier];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.arrayOfCommentObjects = objects;
        [self.tableView reloadData];
        self.act.hidden = YES;
        [self.act stopAnimating];
        
    }];
    
    
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
                         [self callQuery];
                         
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

                         [self callQuery];

                         
                         
                         [UIView animateWithDuration:3 animations:^{
                             
                             playerView.alpha = 1;
                         }];
                     }];
    
}


- (IBAction)postComment:(id)sender {
    
    if ([PFUser currentUser]) {
        
        PFObject *comment = [PFObject objectWithClassName:@"Comments"];
        if (self.textFieldComment.text != nil) {
            [comment setObject:self.textFieldComment.text forKey:@"stringComment"];
        } else {
            nil;
        }
        
        [comment setObject:self.user.username forKey:@"username"];
        
        [comment saveInBackground];
        
    } else {
        nil;
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.textFieldComment resignFirstResponder];
}

- (void)alertControllerBackgroundTapped

{
    [self dismissViewControllerAnimated: YES
                             completion: nil];
}

- (IBAction)cancel:(id)sender {
    [self.textFieldComment resignFirstResponder];
    self.textFieldComment.text = @"";

    
    [self.seeAllCommentsButton setTitle:@"  Comments" forState:UIControlStateNormal];
    self.tableView.hidden = YES;
    self.toolbar.hidden = YES;
}

@end
