//
//  PinnedViewController.m
//  TVA2Go
//
//  Created by Alyson Vivattanapa on 11/24/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "PinnedViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface PinnedViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *pinned;

@end

@implementation PinnedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.pinned registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.pinned.frame = self.view.frame;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView * _Nonnull)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [self.pinned dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    UIImage *logo = [UIImage imageNamed:@"logo"];
    UIImageView *im = [[UIImageView alloc] initWithImage:logo];
    
    [cell.contentView addSubview:im];
    
    
    return cell;
}






@end
