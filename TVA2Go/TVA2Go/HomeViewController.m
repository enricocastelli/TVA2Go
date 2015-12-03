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


static CGFloat timeInterval = 0.4;

@interface HomeViewController () <UINavigationControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *inspireButton;
@property (weak, nonatomic) IBOutlet UIButton *laughButton;
@property (weak, nonatomic) IBOutlet UIButton *smartButton;
@property (weak, nonatomic) IBOutlet UIButton *randomButton;
@property (weak, nonatomic) IBOutlet UIButton *userButton;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

@property (weak, nonatomic) IBOutlet UIStackView *textFieldView;
@property (weak, nonatomic) IBOutlet UIStackView *loginView;


@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *successLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (nonatomic) VideoPlayerViewController *v;
@property (strong, nonatomic) NSArray *objects;

@property (nonatomic) CGFloat number;
@property (nonatomic) CGFloat red;
@property (nonatomic) CGFloat green;
@property (nonatomic) CGFloat blue;
@property (nonatomic, strong) UIView * loadingView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) CGRect originalLogo;


@end

@implementation HomeViewController


- (void)viewWillAppear:(BOOL)animated
{
    
    if ([PFUser currentUser]) {
        self.successLabel.hidden = NO;
        self.successLabel.textColor = [UIColor blackColor];
        self.successLabel.text = [NSString stringWithFormat:@"%@", [PFUser currentUser].username];
    } else {
        self.successLabel.hidden = YES;

    }
    [super viewWillAppear:animated];
    
    [self.timer fire];
    self.number = 80;
    
    self.originalLogo = self.logo.frame;
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.barTintColor = [UIColor colorWithRed:0.18823 green:0.7215 blue:0.94117 alpha:1];
    self.navigationController.toolbar.tintColor = [UIColor whiteColor];
    [self settingToolbar];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.red = 0.18823;
    self.green = 0.7215;
    self.blue = 0.94117;
    
    self.v = [[VideoPlayerViewController alloc] init];
    
    [self roundedButtons:self.loginButton byNumber:4];
    [self roundedButtons:self.signupButton byNumber:4];
    [self roundedButtons:self.inspireButton byNumber:9];
    [self roundedButtons:self.smartButton byNumber:9];
    [self roundedButtons:self.laughButton byNumber:9];
    [self roundedButtons:self.randomButton byNumber:9];

    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    
    [self.userButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    
}

     - (UIButton*)roundedButtons:(UIButton*)button byNumber:(NSInteger)divider
{
    button.layer.cornerRadius = button.bounds.size.width/divider;
    
    return button;
}


- (IBAction)inspireMe:(id)sender {
    
    
    [self makeRotate:self.logo.layer];
    [self timerForAnimation];



    [TAAYouTubeWrapper videosForPlaylist:@"MADE BY TVA" forUser:@"TVAcademyNL" onCompletion:^(BOOL succeeded, NSArray *videos, NSError *error) {
        [self pushToVideoPlayer:videos];
    }
    ];

}

- (IBAction)makeMeLaugh:(id)sender {

    [self makeRotate:self.logo.layer];
    [self timerForAnimation];


    [TAAYouTubeWrapper videosForPlaylist:@"AWESOME AFTERTALKS" forUser:@"TVAcademyNL" onCompletion:^(BOOL succeeded, NSArray *videos, NSError *error) {

        
        [self pushToVideoPlayer:videos];

    }];

}

- (IBAction)makeMeSmarter:(id)sender {
    [self makeRotate:self.logo.layer];
    [self timerForAnimation];


    [TAAYouTubeWrapper videosForPlaylist:@"Algemeen" forUser:@"TVAcademyNL" onCompletion:^(BOOL succeeded, NSArray *videos, NSError *error) {
        [self pushToVideoPlayer:videos];

    }];
    

}

- (IBAction)random:(id)sender
{
    [self makeRotate:self.logo.layer];
    [self timerForAnimation];

 
    [TAAYouTubeWrapper videosForUser:@"TVAcademyNL" onCompletion:^(BOOL succeeded, NSArray *videos, NSError *error) {
        [self pushToVideoPlayer:videos];

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
    if ([PFUser currentUser]) {
        [self.loginButton setTitle:@" Logout " forState:UIControlStateNormal];
        [self logoutFade];
        
    } else {
    [self loginOrSignup];
    
    [self.userButton removeTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
     [self.userButton addTarget:self action:@selector(undo) forControlEvents:UIControlEventTouchUpInside];
    self.userButton.selected = YES;
    }
}

- (void) logout
{
    [PFUser logOutInBackground];
    self.successLabel.hidden = YES;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.logo.frame = CGRectMake(self.logo.frame.origin.x, self.logo.frame.origin.y + 900, self.logo.frame.size.width, self.logo.frame.size.height);
        self.inspireButton.alpha = 0;
        self.laughButton.alpha = 0;
        self.smartButton.alpha = 0;
        self.randomButton.alpha = 0;
        self.navigationController.toolbarHidden = YES;
        
        
    } completion:^(BOOL finished) {
    }];
    [self undo];
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
    [self.loadingView removeFromSuperview];
    self.loadingView = nil;
    [self.timer invalidate];
}

- (void)pushToVideoPlayer:(NSArray*)videos
{
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

- (void)settingToolbar
{
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIImage *pins = [UIImage imageNamed:@"Pin"];
    UIBarButtonItem *myPins = [[UIBarButtonItem alloc] initWithImage:pins style:UIBarButtonItemStylePlain target:self action:@selector(myPins)];
    UIImage *search = [UIImage imageNamed:@"Search"];
    UIBarButtonItem *mostPinned = [[UIBarButtonItem alloc] initWithImage:search style:UIBarButtonItemStylePlain target:self action:@selector(mostPinned)];
    [mostPinned setWidth:10];

    
    
    self.toolbarItems = @[myPins, space, mostPinned];
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
    [self.loginButton.layer removeAllAnimations];

    [UIView animateWithDuration:1.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.loginButton.alpha = 1;
        self.signupButton.alpha = 1;
        self.logo.frame = CGRectMake(self.logo.frame.origin.x, self.logo.frame.origin.y + 900, self.logo.frame.size.width, self.logo.frame.size.height);
    } completion:nil];
    self.inspireButton.alpha = 0;
    self.laughButton.alpha = 0;
    self.smartButton.alpha = 0;
    self.randomButton.alpha = 0;
    self.navigationController.toolbarHidden = YES;
    self.textFieldView.hidden = NO;
    self.emailField.hidden = YES;
    self.loginView.hidden = NO;
    self.signupButton.hidden = NO;
    [self.loginButton removeTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton addTarget:self action:@selector(log)forControlEvents:UIControlEventTouchUpInside];
    [self.signupButton addTarget:self action:@selector(signup) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton setTitle:@" Log in " forState:UIControlStateNormal];

}

- (void)logoutFade
{
    self.loginButton.alpha = 0;

    self.loginView.hidden = NO;
    [UIView animateWithDuration:0.4 animations:^{
        self.loginButton.alpha = 1;
         self.logo.alpha = 0.3;
    }];
    self.signupButton.hidden = YES;

    [self.loginButton removeTarget:self action:@selector(log) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.userButton addTarget:self action:@selector(undo) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)textFieldsAnimations
{
    self.usernameField.center = CGPointMake(self.usernameField.center.x, self.usernameField.center.y + 100);
    self.usernameField.alpha = 0;
    [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        self.usernameField.alpha = 1;
        self.usernameField.center = CGPointMake(self.usernameField.center.x, self.usernameField.center.y- 100);
    } completion:nil];
    
    self.passwordField.center = CGPointMake(self.passwordField.center.x, self.passwordField.center.y - 100);
    self.passwordField.alpha = 0;
    [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.passwordField.alpha = 1;
        self.passwordField.center = CGPointMake(self.passwordField.center.x, self.passwordField.center.y + 100);
    } completion:nil];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.logo.hidden = YES;
}


- (void)undo
{
    self.logo.hidden = NO;
    self.logo.alpha = 1;

    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.inspireButton.alpha = 1;
        self.laughButton.alpha = 1;
        self.smartButton.alpha = 1;
        self.randomButton.alpha = 1;
        self.navigationController.toolbarHidden = NO;
        self.textFieldView.hidden = YES;
        self.loginView.hidden = YES;
        self.loginButton.hidden = NO;
        self.logo.frame = self.originalLogo;
        self.userButton.hidden = NO;

    } completion:nil];
    [self.userButton removeTarget:self action:@selector(undo) forControlEvents:UIControlEventTouchUpInside];
    [self.userButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    self.userButton.selected = NO;
    

    [self.passwordField resignFirstResponder];
    [self.usernameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    self.emailField.hidden = YES;

    
}

- (void)loginOrSignup
{
    
}

- (void)log

{
    [self.passwordField resignFirstResponder];
    [self.usernameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    
    [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (!error){
            
            self.loginButton.titleLabel.alpha = 0;

            [UIView animateWithDuration:1.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{

                self.loginButton.alpha = 1;


                self.loginButton.bounds = CGRectMake(0, 0, 900, 900);
                

                [self makeRotate:self.loginButton.layer];
//                self.loginButton.layer.cornerRadius = self.loginButton.frame.size.width /2;


            } completion:^(BOOL finished) {
                
                self.userButton.hidden = YES;
                self.logo.hidden = NO;
                self.loginView.hidden = YES;
                self.textFieldView.hidden = YES;

                self.view.backgroundColor = self.loginButton.backgroundColor;
                self.successLabel.textColor = [UIColor whiteColor];
                
                self.successLabel.text = [NSString stringWithFormat:@"Hello, %@!" ,user.username];

                [UIView animateWithDuration:1.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                    self.view.backgroundColor = self.loginButton.backgroundColor;
                    self.successLabel.hidden = NO;

                    self.successLabel.alpha = 1;


                    
                    self.logo.frame = self.originalLogo;


                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.view.backgroundColor = [UIColor whiteColor];

                        self.successLabel.alpha = 0.5;
                        [self undo];
                        self.userButton.hidden = NO;
                        self.loginButton.titleLabel.alpha = 1;
                        [self.loginButton.layer removeAllAnimations];
                        self.successLabel.textColor = [UIColor blackColor];
                        self.successLabel.text = [NSString stringWithFormat:@"%@" ,user.username];
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

- (void)signup
{
    self.textFieldView.hidden = NO;
    self.loginButton.hidden = YES;
    self.signupButton.hidden = NO;
    [self.signupButton removeTarget:self action:@selector(signup) forControlEvents:UIControlEventTouchUpInside];
    [self.signupButton addTarget:self action:@selector(sign) forControlEvents:UIControlEventTouchUpInside];
    self.logo.hidden = YES;
    
    self.emailField.alpha = 0;
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.emailField.hidden = NO;
        self.emailField.alpha = 1;
    } completion:nil];

    [self.emailField becomeFirstResponder];
}

- (void)sign
{
    PFUser*user = [PFUser user];
    user.username = self.usernameField.text;
    user.password = self.passwordField.text;
    user.email = self.emailField.text;
    user[@"pinnedVideos"] = @[];
    
    [self.passwordField resignFirstResponder];
    [self.usernameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    
    self.textFieldView.hidden = YES;
    self.emailField.hidden = YES;
    self.signupButton.hidden = YES;

    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
          
            [UIView animateWithDuration:1.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                self.view.backgroundColor = self.loginButton.backgroundColor;
                self.successLabel.hidden = NO;
                
                self.successLabel.alpha = 1;
                
                self.successLabel.text = [NSString stringWithFormat:@"Welcome, %@!" ,user.username];
                self.logo.hidden = NO;
                self.logo.frame = self.originalLogo;
                
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.view.backgroundColor = [UIColor whiteColor];
                    
                    self.successLabel.alpha = 0.5;
                    [self undo];
                    self.userButton.hidden = NO;
                    self.loginButton.titleLabel.alpha = 1;
                    self.loginButton.hidden = NO;
                    [self.signupButton removeTarget:self action:@selector(sign) forControlEvents:UIControlEventTouchUpInside];
                    
                } completion:nil];
            }];
             
            } else {

            [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.1 initialSpringVelocity:130 options:UIViewAnimationOptionCurveEaseIn animations:^{
            } completion:^(BOOL finished) {
                self.signupButton.center = CGPointMake(self.signupButton.center.x +1, self.signupButton.center.y + 1);
                [self signup];
            }];
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

- (void)timerForAnimation{
    
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 280, 400, 400)];
    [self.view addSubview:self.loadingView];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                      target:self
                                                    selector:@selector(loadingAnimation:)
                                                    userInfo:nil
                                                     repeats:YES];
    [self.timer fire];
}

- (void)loadingAnimation:(NSTimer*)timer

{
    UIButton*l = [[UIButton alloc] initWithFrame:CGRectMake(self.number, 0, 20, 20)];
    l.backgroundColor = [UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:1];

    l.layer.cornerRadius = l.frame.size.width/2;
    l.alpha = 0;
    [self.loadingView addSubview:l];
    [self makeRotate:l.layer];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAutoreverse animations:^{
        l.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            l.alpha = 0;
            [l removeFromSuperview];
        }];
    }];

    self.number += 60;
    
    if (self.number > 200){
        self.number = 80;
    }
}

@end


