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
@property (nonatomic) CGRect originalLogo;
@property (nonatomic) CGRect original;

@end

@implementation HomeViewController


- (void)viewWillAppear:(BOOL)animated
{
    self.original = self.view.frame;
    
    [super viewWillAppear:animated];
    [self allButtonsEnabled];
    
    self.originalLogo = self.logo.frame;
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;

    [self settingLabel];
    [self settingToolbar];
    [self loadingAnimation:self.inspireButton.layer withDelay:1];
    [self loadingAnimation:self.laughButton.layer withDelay:1.4];
    [self loadingAnimation:self.smartButton.layer withDelay:1.8];
    [self loadingAnimation:self.randomButton.layer withDelay:2.2];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    self.v = [[VideoPlayerViewController alloc] init];
    
    [self roundedButtons:self.loginButton byNumber:4];
    [self roundedButtons:self.signupButton byNumber:4];
    [self roundedButtons:self.inspireButton byNumber:9];
    [self roundedButtons:self.smartButton byNumber:9];
    [self roundedButtons:self.laughButton byNumber:9];
    [self roundedButtons:self.randomButton byNumber:9];

    self.usernameField.delegate = self;
    
    [self.userButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
}

- (UIButton*)roundedButtons:(UIButton*)button byNumber:(NSInteger)divider

{
    button.layer.cornerRadius = button.bounds.size.width/divider;
    
    return button;
}


- (IBAction)inspireMe:(id)sender {
    
    
    [self makeRotate:self.logo.layer];
    [self allButtonsDisabled];
    [self loadingText];

    [TAAYouTubeWrapper videosForPlaylist:@"MADE BY TVA" forUser:@"TVAcademyNL" onCompletion:^(BOOL succeeded, NSArray *videos, NSError *error) {
        [self pushToVideoPlayer:videos];
    }
    ];

}

- (IBAction)makeMeLaugh:(id)sender {

    [self makeRotate:self.logo.layer];
    self.laughButton.enabled = NO;
    [self loadingText];

    [TAAYouTubeWrapper videosForPlaylist:@"AWESOME AFTERTALKS" forUser:@"TVAcademyNL" onCompletion:^(BOOL succeeded, NSArray *videos, NSError *error) {

        
        [self pushToVideoPlayer:videos];

    }];

}

- (IBAction)makeMeSmarter:(id)sender {
    [self makeRotate:self.logo.layer];
    self.smartButton.enabled = NO;
    [self loadingText];


    [TAAYouTubeWrapper videosForPlaylist:@"Algemeen" forUser:@"TVAcademyNL" onCompletion:^(BOOL succeeded, NSArray *videos, NSError *error) {
        [self pushToVideoPlayer:videos];

    }];
    

}

- (IBAction)random:(id)sender
{
    [self makeRotate:self.logo.layer];
    self.randomButton.enabled = NO;
    [self loadingText];

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

- (void)settingLabel
{
    if ([PFUser currentUser]) {
        
        [self.navigationController setToolbarHidden:NO];
        [self.successLabel.layer removeAllAnimations];
        self.successLabel.hidden = NO;
        self.successLabel.alpha = 1;
        self.successLabel.textColor = [UIColor blackColor];
        self.successLabel.text = [NSString stringWithFormat:@"%@", [PFUser currentUser].username];
    } else {
        
        [self.navigationController setToolbarHidden:YES];

        self.successLabel.hidden = NO;
        self.successLabel.alpha = 0;
    }
}

- (void)allButtonsEnabled
{
    self.inspireButton.enabled = YES;
    self.laughButton.enabled = YES;
    self.smartButton.enabled = YES;
    self.randomButton.enabled = YES;
}

- (void)allButtonsDisabled
{
    self.inspireButton.enabled = NO;
    self.laughButton.enabled = NO;
    self.smartButton.enabled = NO;
    self.randomButton.enabled = NO;
}

- (void) login
{
    [self.userButton setSelected:YES];
    if ([PFUser currentUser]) {
        [self.loginButton setTitle:@" Logout " forState:UIControlStateNormal];
        [self logoutFade];

        
    } else {
    [self userUtilities];
    
    [self.userButton removeTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
     [self.userButton addTarget:self action:@selector(undo) forControlEvents:UIControlEventTouchUpInside];
    self.userButton.selected = YES;

    }
}

- (void) logout
{
    [PFUser logOutInBackground];
    self.successLabel.alpha = 0;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.logo.frame = CGRectMake(self.logo.frame.origin.x, self.logo.frame.origin.y + 900, self.logo.frame.size.width, self.logo.frame.size.height);
        self.inspireButton.alpha = 0;
        self.laughButton.alpha = 0;
        self.smartButton.alpha = 0;
        self.randomButton.alpha = 0;
        [self.navigationController setToolbarHidden:YES];
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
}

- (void)loadingText
{
    self.successLabel.text = @"Loading...";

    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        self.successLabel.alpha = 0;

    } completion:nil];
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

- (void)userUtilities
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
    self.loginView.hidden = NO;
    self.signupButton.hidden = NO;
    [self.loginButton removeTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton addTarget:self action:@selector(loginFade)forControlEvents:UIControlEventTouchUpInside];
    [self.signupButton removeTarget:self action:@selector(sign) forControlEvents:UIControlEventTouchUpInside];
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
        self.inspireButton.alpha = 0.1;
        self.laughButton.alpha = 0.1;
        self.smartButton.alpha = 0.1;
        self.randomButton.alpha = 0.1;
        
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

- (void)loginFade
{
    self.textFieldView.hidden = NO;
    self.emailField.hidden = YES;
    [self.textFieldView updateConstraints];
    self.signupButton.hidden = YES;
    self.textFieldView.hidden = NO;
    [self textFieldsAnimations];
    [self.usernameField becomeFirstResponder];
    [self.loginButton removeTarget:self action:@selector(loginFade) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton addTarget:self action:@selector(log)forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.toolbarHidden = YES;

}

- (void)log

{
    [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (!error){

            self.loginButton.titleLabel.alpha = 0;

            [UIView animateWithDuration:1.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{

                [self.passwordField resignFirstResponder];
                [self.usernameField resignFirstResponder];
                [self.emailField resignFirstResponder];
                self.loginButton.alpha = 1;


                self.loginButton.bounds = CGRectMake(0, 0, 1000, 1000);
                

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
                        [self.navigationController setToolbarHidden:NO];
                    } completion:nil];
                }];
            }];
            
        } else {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Ops" message:@"something went wrong! Try Again!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:^{
                    [self loginFade];
                }];
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)signup
{
    self.navigationController.toolbarHidden = YES;
    self.loginView.hidden = NO;
    self.textFieldView.hidden = NO;
    self.loginButton.hidden = YES;
    self.signupButton.hidden = NO;
    [self.signupButton removeTarget:self action:@selector(signup) forControlEvents:UIControlEventTouchUpInside];
    [self.signupButton addTarget:self action:@selector(sign) forControlEvents:UIControlEventTouchUpInside];
    self.logo.hidden = YES;
    [self.usernameField becomeFirstResponder];
    
    self.emailField.alpha = 0;
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.emailField.hidden = NO;
        self.emailField.alpha = 1;
    } completion:nil];

    
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

    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
          
            self.signupButton.hidden = YES;
            self.userButton.hidden = YES;
            self.textFieldView.hidden = YES;

            [UIView animateWithDuration:1.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                
                self.view.backgroundColor = self.loginButton.backgroundColor;
                self.successLabel.hidden = NO;
                
                self.successLabel.alpha = 1;
                self.successLabel.textColor = [UIColor whiteColor];
                
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
                    self.signupButton.hidden = NO;
                    [self.signupButton removeTarget:self action:@selector(sign) forControlEvents:UIControlEventTouchUpInside];
                    self.successLabel.textColor = [UIColor blackColor];

                    self.successLabel.text = [NSString stringWithFormat:@"%@" ,user.username];
                    [self.navigationController setToolbarHidden:NO];


                } completion:nil];
            }];
             
        } else {
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Ops" message:@"something went wrong! Try Again!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:^{
                    [self signup];
                }];
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
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


- (void)loadingAnimation: (CALayer*)layer withDelay:(CGFloat)delay

{
   [UIView animateWithDuration:1 delay:delay usingSpringWithDamping:1 initialSpringVelocity:0 options: UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat |UIViewAnimationOptionAllowUserInteraction animations:^{
       layer.bounds = CGRectMake(0, 0, layer.bounds.size.width + 2, layer.bounds.size.height +2);
   } completion:nil];
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];

    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [self.view endEditing:YES];
    return YES;
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0,-110,320,460);
    }];

}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:self.original];
}








@end


