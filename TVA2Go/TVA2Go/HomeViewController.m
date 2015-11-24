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


@end

@implementation HomeViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = NO;
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *myPins = [[UIBarButtonItem alloc] initWithTitle:@"My Pins" style:UIBarButtonItemStylePlain target:self action:@selector(myPins)];

        UIBarButtonItem *login = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(login)];
        UIBarButtonItem *mostPinned = [[UIBarButtonItem alloc] initWithTitle:@"Most Pinned" style:UIBarButtonItemStylePlain target:self action:@selector(mostPinned)];

    
    self.toolbarItems = @[myPins, space, login, space, mostPinned];

    
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
        
    }];
    
    
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










@end






