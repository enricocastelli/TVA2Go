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
}


- (IBAction)inspireMe:(id)sender {
    VideoPlayerViewController *v = [[VideoPlayerViewController alloc] init];
        [self.navigationController pushViewController:v animated:YES];
}

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
    PinnedViewController *p = [[PinnedViewController alloc] init];
    [self.navigationController pushViewController:p animated:YES];
}

- (void) login
{
    UIAlertController *login = [UIAlertController alertControllerWithTitle:@"Log In" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [login addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Username";
    }];
    [login addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Password";
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *log = [UIAlertAction actionWithTitle:@"Log In" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.act.hidden = NO;
        [self.act startAnimating];
        [PFUser logInWithUsernameInBackground:login.textFields[0].text  password:login.textFields[1].text  block:^(PFUser * _Nullable user, NSError * _Nullable error) {
            [self.act stopAnimating];
            self.act.hidden = YES;
            UIAlertController *logsuccess = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Hi, %@", login.textFields[0].text ] message:@"You are logged in" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
                [self toolbarLogout];
              }];
            [logsuccess addAction:ok];
            [self presentViewController:logsuccess animated:YES completion:nil];

        }];
        
    }];
    [login addAction:cancel];
    [login addAction:log];
    [self presentViewController:login animated:YES completion:nil];
    
}

- (void) logout
{
    [PFUser logOutInBackground];
    [self toolbarLogin];
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






@end






