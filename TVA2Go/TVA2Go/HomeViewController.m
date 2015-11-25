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


@interface HomeViewController () <UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *inspireButton;
@property (weak, nonatomic) IBOutlet UIButton *laughButton;
@property (weak, nonatomic) IBOutlet UIButton *smartButton;
@property (weak, nonatomic) IBOutlet UIButton *randomButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *act;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;




@end

@implementation HomeViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = NO;
    PFUser *user = [PFUser currentUser];
    if (user){
    [self toolbarLogout];
    } else {
        [self toolbarLogin];
    }
    self.act.hidden = YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.loginButton.layer.cornerRadius = self.loginButton.bounds.size.width/2.0;
    self.undoButton.layer.cornerRadius = self.undoButton.bounds.size.width/2.0;
    self.loginButton.titleLabel.alpha = 1;

}


- (IBAction)inspireMe:(id)sender {
    VideoPlayerViewController *v = [[VideoPlayerViewController alloc] init];
    v.view.alpha = 0;
    self.navigationController.navigationBar.alpha = 0;
    [UIView animateWithDuration:0.75
                     animations:^{
                         [self.navigationController pushViewController:v animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
                         v.view.alpha = 1.0;
                         self.navigationController.navigationBar.alpha = 1.0;

                     }];}

- (IBAction)makeMeLaugh:(id)sender {
    VideoPlayerViewController *v = [[VideoPlayerViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}


- (IBAction)makeMeSmarter:(id)sender {
    VideoPlayerViewController *v = [[VideoPlayerViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

- (IBAction)random:(id)sender {
    VideoPlayerViewController *v = [[VideoPlayerViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

- (void) myPins
{
    PFUser *user = [PFUser currentUser];
    if (user){
    PinnedViewController *p = [[PinnedViewController alloc] init];
        [UIView animateWithDuration:0.75
                         animations:^{
                             [self.navigationController pushViewController:p animated:NO];
                             [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                         }];
    } else {
    [self notLogin];
    }
}

- (void) login
{
    [self loginFade];
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
        [self.navigationController pushViewController:m animated:YES];
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
    UIBarButtonItem *myPins = [[UIBarButtonItem alloc] initWithTitle:@"My Pins" style:UIBarButtonItemStylePlain target:self action:@selector(myPins)];
    UIBarButtonItem *logout = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    UIBarButtonItem *mostPinned = [[UIBarButtonItem alloc] initWithTitle:@"Most Pinned" style:UIBarButtonItemStylePlain target:self action:@selector(mostPinned)];
    
    
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
    self.loginButton.alpha = 1;
    self.loginButton.titleLabel.alpha = 1;
    self.loginButton.transform = CGAffineTransformMakeRotation(0);
    self.loginButton.frame = CGRectMake(193, 330, 46, 46);
    self.undoButton.hidden = NO;
    self.undoButton.alpha = 1;

    [self textFieldsAnimations];

}

- (void)textFieldsAnimations
{
    self.usernameField.alpha = 0;
    self.usernameField.frame = CGRectMake(-10, self.usernameField.frame.origin.y, self.usernameField.frame.size.width, self.usernameField.frame.size.height);
    [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.usernameField.alpha = 1;
        self.usernameField.frame = CGRectMake(81, 231, 158, 30);
    } completion:nil];
    
    self.passwordField.alpha = 0;
    self.passwordField.frame = CGRectMake(-20, self.passwordField.frame.origin.y, self.passwordField.frame.size.width, self.passwordField.frame.size.height);
    [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.passwordField.alpha = 1;
        self.passwordField.frame = CGRectMake(81, 269, 158, 30);
    } completion:nil];
    
}

- (IBAction)undo:(id)sender
{
    self.inspireButton.alpha = 1;
    self.laughButton.alpha = 1;
    self.smartButton.alpha = 1;
    self.randomButton.alpha = 1;
    self.navigationController.toolbarHidden = NO;
    self.usernameField.hidden = YES;
    self.passwordField.hidden = YES;
    self.loginButton.hidden = YES;
    self.undoButton.hidden = YES;
}

- (IBAction)log:(id)sender

{
    [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (!error){
            [self toolbarLogout];
            self.loginButton.titleLabel.alpha = 0;
            [UIView animateWithDuration:1.8 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.loginButton.bounds = CGRectMake(0, 0, 1500, 1500);
                //        self.loginButton.layer.cornerRadius = self.loginButton.bounds.size.width/2.0;
                CGRect rect = CGRectMake(81, 231, 158, 30);
                UILabel *label = [[UILabel alloc] initWithFrame:rect];
                label.textColor = [UIColor whiteColor];
                label.text = [NSString stringWithFormat:@"Hello, %@" , user.username];
                
                self.loginButton.transform = CGAffineTransformMakeRotation(1.5);
                self.usernameField.hidden = YES;
                self.passwordField.hidden = YES;
                self.undoButton.hidden = YES;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:1.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.loginButton.alpha = 0;
                    self.usernameField.alpha = 0;
                    self.passwordField.alpha = 0;
                    self.undoButton.alpha = 0;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.inspireButton.alpha = 1;
                        self.laughButton.alpha = 1;
                        self.smartButton.alpha = 1;
                        self.randomButton.alpha = 1;
                        self.navigationController.toolbarHidden = NO;
                    } completion:nil];
                }];
            }];

            
        } else {
            [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.1 initialSpringVelocity:130 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.loginButton.frame = CGRectMake(self.loginButton.frame.origin.x + 1, self.loginButton.frame.origin.y + 1, self.loginButton.frame.size.width, self.loginButton.frame.size.height);
            } completion:nil];
        }
        
    }];
    

}



@end






