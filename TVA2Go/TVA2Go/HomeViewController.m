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


@interface HomeViewController () <UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *inspireButton;
@property (weak, nonatomic) IBOutlet UIButton *laughButton;
@property (weak, nonatomic) IBOutlet UIButton *smartButton;
@property (weak, nonatomic) IBOutlet UIButton *randomButton;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
}


- (IBAction)inspireMe:(id)sender {
}

- (IBAction)makeMeLaugh:(id)sender {
}


- (IBAction)makeMeSmarter:(id)sender {
}

- (IBAction)random:(id)sender {
}



@end
