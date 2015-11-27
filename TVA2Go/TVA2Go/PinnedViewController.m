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
@property (strong,nonatomic) NSString* deleting;
@property (strong,nonatomic) NSMutableArray *cellArray;
@property (strong, nonatomic) UIImageView *playImage;
@property (strong, nonatomic) UIImageView *deleteImage;






@end

@implementation PinnedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.deleting = @"NO";

    [self.pinned registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
    self.navigationItem.rightBarButtonItem = edit;
    self.pinned.delegate = self;
    self.pinned.allowsSelection = YES;
    self.pinned.frame = self.view.frame;
    self.cellArray = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"Pinned Videos";


}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    PFUser*user = [PFUser currentUser];
    [user fetchInBackground];
    self.array = user[@"pinnedVideos"];
    
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [self.pinned dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    self.query = [PFQuery queryWithClassName:@"Video"];
    [self.query getObjectInBackgroundWithId:self.array[indexPath.row] block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        
        CGRect rect = CGRectMake(0, 0, 85, 85);
        PFImageView *image = [[PFImageView alloc] initWithFrame:rect];
        
        image.file = object[@"thumbnail"];
        [image loadInBackground];
        [cell.contentView addSubview:image];
        
        UIImage *play = [UIImage imageNamed:@"playButton"];
        CGRect little = CGRectMake(30, 30, 32, 32);
        self.playImage = [[UIImageView alloc] initWithFrame:little];
        self.playImage.image = play;
        [cell.contentView addSubview:self.playImage];
       
        
            

        cell.contentView.alpha = 0;
        [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            cell.bounds = CGRectMake(0, cell.frame.origin.y + 10, 85, 85);
            cell.contentView.alpha = 1;
        } completion:nil];

        
    }];
    
    [self.cellArray addObject:cell];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FullVideoViewController *f = [[FullVideoViewController alloc]init];
    [self.query getObjectInBackgroundWithId:self.array[indexPath.row] block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if ([self.deleting  isEqualToString: @"NO"]) {
        f.video = object;
        
        [self.navigationController pushViewController:f animated:YES];
        } else {
            PFUser *user = [PFUser currentUser];
            NSMutableArray *arr = [user[@"pinnedVideos"] mutableCopy];
            [arr removeObjectAtIndex:indexPath.row];
            
            [user setObject:[arr copy] forKey:@"pinnedVideos"];
            
            NSAssert(arr != nil, @"array is not nil");
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [self.pinned reloadData];
            }];
        }
    }];

}

- (void)edit

{
    if ([self.deleting  isEqualToString: @"NO"]) {
        self.navigationItem.rightBarButtonItem.title = @"Done";
        
        for (UICollectionViewCell *cell in self.cellArray){
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:10 options: UIViewAnimationOptionAutoreverse |UIViewAnimationOptionRepeat |UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 cell.transform = CGAffineTransformMakeRotation(0.06);
                                 cell.transform = CGAffineTransformMakeRotation(-0.06);
                             } completion:nil];
            UIImage *play = [UIImage imageNamed:@"deleteIcon"];
            CGRect little = CGRectMake(0, 0, 16, 16);
            self.deleteImage = [[UIImageView alloc] initWithFrame:little];


            self.deleteImage.image = play;
            [cell.contentView addSubview:self.deleteImage];
        }
        self.deleting = @"YES";
        

    } else {

    self.navigationItem.rightBarButtonItem.title = @"Edit";
    self.deleting = @"NO";
        for (UICollectionViewCell *cell in self.cellArray)
        {
            [self.deleteImage removeFromSuperview];
            self.deleteImage.hidden =YES;
            [self.pinned setNeedsDisplay];
            cell.transform = CGAffineTransformMakeRotation(0.0);
            [cell.layer removeAllAnimations];
    }
    
    }
}





@end
