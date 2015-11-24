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
#import "FullVideoViewController.h"

@interface PinnedViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *pinned;
@property (strong,nonatomic) NSArray *array;
@property (strong, nonatomic) PFQuery* query;


@end

@implementation PinnedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.pinned registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.pinned.frame = self.view.frame;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    PFUser*user = [PFUser currentUser];
    
    self.array = user[@"pinnedVideos"];
    
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [self.pinned dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    PFQuery *query = [PFQuery queryWithClassName:@"Video"];
    
    self.query = query;
    
    [query getObjectInBackgroundWithId:self.array[indexPath.row] block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        
        
        CGRect rect = CGRectMake(0, 0, 70, 70);
        PFImageView *image = [[PFImageView alloc] initWithFrame:rect];
        
        image.file = object[@"thumbnail"];
        [image loadInBackground];
        [cell.contentView addSubview:image];
        CGRect little = CGRectMake(0, 0, 20, 20);
        UIImage *logo = [UIImage imageNamed:@"logo"];
        UIImageView *im = [[UIImageView alloc] initWithFrame:little];
        im.image = logo;
        [cell.contentView addSubview:im];
        
        [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:10 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            CGRect back = CGRectMake(300, 20, 70, 70);
            cell.bounds = back;
        } completion:nil];

        
    }];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FullVideoViewController *f = [[FullVideoViewController alloc]init];
    [self.query getObjectInBackgroundWithId:self.array[indexPath.row] block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        
        f.video = object;
        
        [self.navigationController pushViewController:f animated:YES];

        
    }];
    
    
    
    
}







@end
