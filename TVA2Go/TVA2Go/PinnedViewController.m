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
@property (strong,nonatomic) NSArray *array;


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
    
    [query getObjectInBackgroundWithId:self.array[indexPath.row] block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        
        CGRect rect = CGRectMake(0, 0, 70, 70);
        PFImageView *image = [[PFImageView alloc] initWithFrame:rect];
        
        image.file = object[@"thumbnail"];
        [image loadInBackground];
        cell.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:image];
    }];
    
    return cell;
}






@end
