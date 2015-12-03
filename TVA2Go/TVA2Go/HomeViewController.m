//
//  HomeViewController.m
//  TVA2Go
//
//  Created by Alyson Vivattanapa on 11/24/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "HomeViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "PinnedViewController.h"
#import "MostPinnedTableViewController.h"
#import "VideoPlayerViewController.h"
#import "TAAYouTubeWrapper.h"
#import "GTLYouTube.h"
#import "LoadingEffect.h"


@interface HomeViewController () <UINavigationControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *inspireButton;
@property (weak, nonatomic) IBOutlet UIButton *laughButton;
@property (weak, nonatomic) IBOutlet UIButton *smartButton;
@property (weak, nonatomic) IBOutlet UIButton *randomButton;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *successLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic) VideoPlayerViewController *v;
@property (strong, nonatomic) NSArray *objects;

@end

@implementation HomeViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.barTintColor = [UIColor colorWithRed:0.18823 green:0.7215 blue:0.94117 alpha:1];
    self.navigationController.toolbar.tintColor = [UIColor whiteColor];

    self.undoButton.frame = CGRectMake(81, 190, 46, 46);

    PFUser *user = [PFUser currentUser];
    if (user){
    [self toolbarLogout];
    } else {
    [self toolbarLogin];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.v = [[VideoPlayerViewController alloc] init];

    self.loginButton.layer.cornerRadius = self.loginButton.bounds.size.width/2.0;
    self.undoButton.layer.cornerRadius = self.undoButton.bounds.size.width/2.0;
        self.signupButton.layer.cornerRadius = self.signupButton.bounds.size.width/2.0;
            self.goButton.layer.cornerRadius = self.goButton.bounds.size.width/2.0;
      self.cancelButton.layer.cornerRadius = self.cancelButton.bounds.size.width/2.0;
    
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
}


- (IBAction)inspireMe:(id)sender {
    
    
    [self makeRotate:self.logo.layer];


    [TAAYouTubeWrapper videosForPlaylist:@"MADE BY TVA" forUser:@"TVAcademyNL" onCompletion:^(BOOL succeeded, NSArray *videos, NSError *error) {
        
        
        self.v.videosInPlaylist = videos;
        self.v.view.alpha = 0;
        
        self.navigationController.navigationBar.alpha = 0;
        [UIView animateWithDuration:0.5
                         animations:^{
                             [self.navigationController pushViewController:self.v animated:NO];
                             [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
                             self.v.view.alpha = 1.0;
                             self.navigationController.navigationBar.alpha = 1.0;
                         }];
    }
    ];

}

- (IBAction)makeMeLaugh:(id)sender {

    [self makeRotate:self.logo.layer];

    [TAAYouTubeWrapper videosForPlaylist:@"AWESOME AFTERTALKS" forUser:@"TVAcademyNL" onCompletion:^(BOOL succeeded, NSArray *videos, NSError *error) {
        self.v.videosInPlaylist = videos;

        self.v.view.alpha = 0;
        
        self.navigationController.navigationBar.alpha = 0;
        [UIView animateWithDuration:0.5
                         animations:^{
                             [self.navigationController pushViewController:self.v animated:NO];
                             [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
                             self.v.view.alpha = 1.0;
                             self.navigationController.navigationBar.alpha = 1.0;
                             
                         }];
    }];

}

- (IBAction)makeMeSmarter:(id)sender {
    [self makeRotate:self.logo.layer];

    [TAAYouTubeWrapper videosForPlaylist:@"Algemeen" forUser:@"TVAcademyNL" onCompletion:^(BOOL succeeded, NSArray *videos, NSError *error) {
        self.v.videosInPlaylist = videos;
        self.v.view.alpha = 0;
        self.navigationController.navigationBar.alpha = 0;
        [UIView animateWithDuration:0.5
                         animations:^{
                             [self.navigationController pushViewController:self.v animated:NO];
                             [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
                             self.v.view.alpha = 1.0;
                             self.navigationController.navigationBar.alpha = 1.0;
                             
                         }];
    }];
    

}

- (IBAction)random:(id)sender
{
    [self makeRotate:self.logo.layer];
 
    [TAAYouTubeWrapper videosForUser:@"TVAcademyNL" onCompletion:^(BOOL succeeded, NSArray *videos, NSError *error) {
        
        self.v.videosInPlaylist = videos;
        self.v.view.alpha = 0;
        self.navigationController.navigationBar.alpha = 0;
        [UIView animateWithDuration:0.5 animations:^{
            self.view.alpha = 0;
            [self.navigationController pushViewController:self.v animated:NO];
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
            self.v.view.alpha = 1.0;
            self.navigationController.navigationBar.alpha = 1.0;
        } completion:^(BOOL finished) {
            self.view.alpha = 1;
        }];
    }];
    
    
}
- (void) myPins
{
    PFUser *user = [PFUser currentUser];
    if (user){
    PinnedViewController *p = [[PinnedViewController alloc] init];
        p.view.alpha = 0;
        self.navigationController.navigationBar.alpha = 0;
        [UIView animateWithDuration:0.5
                         animations:^{
                             [self.navigationController pushViewController:p animated:NO];
                             [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
                             p.view.alpha = 1.0;
                             self.navigationController.navigationBar.alpha = 1.0;
                         }];
    } else {
    [self notLogin];
    }
}

- (void) login
{
    [self loginFade];
    [UIView animateWithDuration:1.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.logo.frame = CGRectMake(81, 900, 158, 156);
        self.loginButton.alpha = 1;
        self.undoButton.alpha = 1;
        self.signupButton.alpha = 1;
    } completion:nil];
}

- (void) logout
{
    [PFUser logOutInBackground];
    [self toolbarLogin];
//    self.loginButton.alpha = 1;
}

- (void) mostPinned
{
    MostPinnedTableViewController *m = [[MostPinnedTableViewController alloc] init];
    m.view.alpha = 0;
    self.navigationController.navigationBar.alpha = 0;
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.navigationController pushViewController:m animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
                         m.view.alpha = 1.0;
                         self.navigationController.navigationBar.alpha = 1.0;
                     }];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
}

- (void)toolbarLogout
{
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIImage *pins = [UIImage imageNamed:@"Pin small light"];
    UIBarButtonItem *myPins = [[UIBarButtonItem alloc] initWithImage:pins style:UIBarButtonItemStylePlain target:self action:@selector(myPins)];
    UIBarButtonItem *logout = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    UIImage *search = [UIImage imageNamed:@"Search"];

    UIBarButtonItem *mostPinned = [[UIBarButtonItem alloc] initWithImage:search style:UIBarButtonItemStylePlain target:self action:@selector(mostPinned)];
    
    
    self.toolbarItems = @[myPins, space, logout, space, mostPinned];
}

- (void)toolbarLogin
{
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *myPins = [[UIBarButtonItem alloc] initWithTitle:@"My Pins" style:UIBarButtonItemStylePlain target:self action:@selector(myPins)];
    UIBarButtonItem *login = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(login)];
    UIBarButtonItem *mostPinned = [[UIBarButtonItem alloc] initWithTitle:@"Most Pinned" style:UIBarButtonItemStylePlain target:self action:@selector(mostPinned)];
    
    
    self.toolbarItems = @[myPins, space, login, space, mostPinned];
}


- (void)notLogin
{
    UIAlertController *notLogin = [UIAlertController alertControllerWithTitle:@"You are not logged in" message:@"Log in to pin videos" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *login = [UIAlertAction actionWithTitle:@"Log in" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self login];
    }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

    [notLogin addAction:login];
    [notLogin addAction:cancel];
    [self presentViewController:notLogin animated:YES completion:nil];

}

- (void)loginFade
{
    self.inspireButton.alpha = 0;
    self.laughButton.alpha = 0;
    self.smartButton.alpha = 0;
    self.randomButton.alpha = 0;
    self.navigationController.toolbarHidden = YES;
    self.usernameField.hidden = NO;
    self.passwordField.hidden = NO;
    self.loginButton.hidden = NO;
    self.loginButton.titleLabel.alpha = 1;
    self.loginButton.transform = CGAffineTransformMakeRotation(0);
//    self.loginButton.frame = CGRectMake(193, 252, 46, 46);
    self.undoButton.hidden = NO;
    self.signupButton.hidden = NO;
    [self textFieldsAnimations];

}

- (void)textFieldsAnimations
{
    self.usernameField.alpha = 0;
    self.usernameField.frame = CGRectMake(81, 800, 158, 30);
    [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.usernameField.alpha = 1;
        self.usernameField.frame = CGRectMake(81, 100, 158, 30);
    } completion:nil];
    
    self.passwordField.alpha = 0;
    self.passwordField.frame = CGRectMake(81, -100, self.passwordField.frame.size.width, self.passwordField.frame.size.height);
    [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.passwordField.alpha = 1;
        self.passwordField.frame = CGRectMake(81, 140, 158, 30);
    } completion:nil];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.logo.hidden =YES;
}


- (IBAction)undo:(id)sender
{
    self.logo.frame = CGRectMake(81, 800, 158, 158);

    self.logo.hidden = NO;
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.logo.frame = CGRectMake(81, 44, 158, 158);
        self.inspireButton.alpha = 1;
        self.laughButton.alpha = 1;
        self.smartButton.alpha = 1;
        self.randomButton.alpha = 1;
        self.navigationController.toolbarHidden = NO;
        self.usernameField.hidden = YES;
        self.passwordField.hidden = YES;
        self.loginButton.hidden = YES;
        self.undoButton.hidden = YES;
        self.signupButton.hidden = YES;

        
    } completion:nil];


    [self.passwordField resignFirstResponder];
    [self.usernameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    self.emailField.hidden = YES;
    self.goButton.hidden = YES;
    self.cancelButton.hidden = YES;

    
}

- (IBAction)log:(id)sender

{
    [self.passwordField resignFirstResponder];
    [self.usernameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self toolbarLogout];
    
    [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (!error){
            
            self.loginButton.titleLabel.alpha = 0;

            [UIView animateWithDuration:1.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{

                self.loginButton.alpha = 1;


                self.loginButton.bounds = CGRectMake(0, 0, 700, 700);

                self.loginButton.transform = CGAffineTransformMakeRotation(1.5);
                self.usernameField.hidden = YES;
                self.passwordField.hidden = YES;
                self.undoButton.hidden = YES;
                self.signupButton.hidden = YES;


            } completion:^(BOOL finished) {
                self.logo.hidden = NO;
                self.logo.frame = CGRectMake(81, 44, 158, 158);

                self.view.backgroundColor = self.loginButton.backgroundColor;

                [UIView animateWithDuration:1.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                    self.view.backgroundColor = self.loginButton.backgroundColor;
                    self.successLabel.hidden = NO;

                    self.successLabel.alpha = 1;

                    self.successLabel.text = [NSString stringWithFormat:@"Hello, %@!" ,user.username];
                    self.loginButton.alpha = 0;
                    self.usernameField.alpha = 0;
                    self.passwordField.alpha = 0;
                    self.undoButton.alpha = 0;
                    self.signupButton.alpha = 0;

                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.view.backgroundColor = [UIColor whiteColor];

                        self.successLabel.alpha = 0;
                        self.inspireButton.alpha = 1;
                        self.laughButton.alpha = 1;
                        self.smartButton.alpha = 1;
                        self.randomButton.alpha = 1;
                        self.navigationController.toolbarHidden = NO;
                        self.loginButton.bounds = CGRectMake(0, 0, 46, 46);

                    } completion:nil];
                }];
            }];
            
        } else {
            [self.usernameField becomeFirstResponder];
            [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.1 initialSpringVelocity:130 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.loginButton.frame = CGRectMake(self.loginButton.frame.origin.x + 1, self.loginButton.frame.origin.y + 1, self.loginButton.frame.size.width, self.loginButton.frame.size.height);
            } completion:nil];
        }
    }];
}

- (IBAction)signup:(id)sender
{
    self.loginButton.hidden = YES;
    self.signupButton.hidden = YES;
    self.undoButton.hidden = YES;
    self.logo.hidden = YES;
    
    self.goButton.alpha = 0;
    self.cancelButton.alpha = 0;
    self.emailField.alpha = 0;
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.goButton.hidden = NO;
        self.cancelButton.hidden = NO;
        self.emailField.hidden = NO;
        self.goButton.alpha = 1;
        self.cancelButton.alpha = 1;
        self.emailField.alpha = 1;
    } completion:nil];



    [self.emailField becomeFirstResponder];
}

- (IBAction)sign:(id)sender
{
    PFUser*user = [PFUser user];
    user.username = self.usernameField.text;
    user.password = self.passwordField.text;
    user.email = self.emailField.text;
    user[@"pinnedVideos"] = @[];
    
    [self.passwordField resignFirstResponder];
    [self.usernameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
          
            [UIView animateWithDuration:1.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.goButton.bounds = CGRectMake(0, 0, 1500, 1500);

                self.successLabel.hidden = YES;
                self.goButton.titleLabel.hidden = YES;
                self.goButton.bounds = CGRectMake(0, 0, 1500, 1500);
                self.goButton.transform = CGAffineTransformMakeRotation(1.5);
                self.usernameField.hidden = YES;
                self.passwordField.hidden = YES;
                self.undoButton.hidden = YES;
                self.signupButton.hidden = YES;
                self.emailField.hidden = YES;
                self.cancelButton.hidden = YES;
                self.goButton.hidden = YES;
                
                self.view.backgroundColor = self.loginButton.backgroundColor;
            } completion:^(BOOL finished) {
                [self toolbarLogout];

                self.logo.hidden = NO;
                self.logo.frame = CGRectMake(81, 44, 158, 158);
                
                [UIView animateWithDuration:1.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    
                    self.successLabel.hidden = NO;
                    
                    self.successLabel.alpha = 1;
                    
                    self.successLabel.text = [NSString stringWithFormat:@"Welcome, %@!" ,user.username];
                    self.usernameField.alpha = 0;
                    self.passwordField.alpha = 0;
                    self.undoButton.alpha = 0;
                    self.signupButton.alpha = 0;
                    
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.view.backgroundColor = [UIColor whiteColor];
                        
                        self.successLabel.alpha = 0;
                        self.inspireButton.alpha = 1;
                        self.laughButton.alpha = 1;
                        self.smartButton.alpha = 1;
                        self.randomButton.alpha = 1;
                        self.navigationController.toolbarHidden = NO;
                    } completion:nil];
                }];
            }];
        } else
        {
            [self.emailField becomeFirstResponder];

            [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.1 initialSpringVelocity:130 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.goButton.frame = CGRectMake(self.goButton.frame.origin.x + 1, self.goButton.frame.origin.y + 1, self.goButton.frame.size.width, self.goButton.frame.size.height);
            } completion:nil];
        }
    }];
}


- (void)makeRotate:(CALayer*)layer
{
        CABasicAnimation *halfTurn;
        halfTurn = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        halfTurn.fromValue = [NSNumber numberWithFloat:0];
        halfTurn.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
        halfTurn.duration = 0.5;
        halfTurn.repeatCount = 100;
        [layer addAnimation:halfTurn forKey:@"180"];
}



@end


