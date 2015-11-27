//
//  PinCollectionViewCell.m
//  TVA2Go
//
//  Created by Eyolph on 24/11/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "PinCollectionViewCell.h"

@implementation PinCollectionViewCell



- (void)viewDidLoad
{
    [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.logo.alpha = 1;
    } completion:nil];
}

@end
