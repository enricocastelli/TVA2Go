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
@property (nonatomic) BOOL deleting;
@property (strong,nonatomic) NSMutableArray *cellArray;





@end

@implementation PinnedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.pinned registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
    self.navigationItem.rightBarButtonItem = edit;
    self.pinned.delegate = self;
    self.pinned.allowsSelection = YES;
    self.pinned.frame = self.view.frame;
    self.cellArray = [[NSMutableArray alloc] init];
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
    PFQuery *query = [PFQuery queryWithClassName:@"Video"];
    
    self.query = query;
    
    [query getObjectInBackgroundWithId:self.array[indexPath.row] block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        
        
        CGRect rect = CGRectMake(0, 0, 70, 70);
        PFImageView *image = [[PFImageView alloc] initWithFrame:rect];
        
        image.file = object[@"thumbnail"];
        [image loadInBackground];
        [cell.contentView addSubview:image];
        CGRect little = CGRectMake(25, 25, 20, 20);
        UIImage *play = [UIImage imageNamed:@"playButton"];
        UIImageView *im = [[UIImageView alloc] initWithFrame:little];
        im.image = play;
        [cell.contentView addSubview:im];
        
        cell.contentView.alpha = 0;
        [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            cell.bounds = CGRectMake(0, cell.frame.origin.y + 10, 70, 70);
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
        if (self.deleting == NO) {
        f.video = object;
        
        [self.navigationController pushViewController:f animated:YES];
        } else {
            NSLog(@"%i", indexPath.row);
            PFUser *user = [PFUser currentUser];
            NSMutableArray *arr = [NSMutableArray arrayWithObject:user[@"pinnedVideos"]];
            [arr removeObjectAtIndex:indexPath.row];
            NSArray *arr2 = [NSArray arrayWithArray:arr];
            
            [user setObject:arr2 forKey:@"pinnedVideos"];
            
            NSAssert(arr2 != nil, @"array is not nil");
            NSLog(@"%i", indexPath.row);
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [self.pinned reloadData];
            }];
        }
    }];

}

- (void)edit

{
    self.deleting = YES;
    for (UICollectionViewCell *cell in self.cellArray){
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:10 options: UIViewAnimationOptionAutoreverse |UIViewAnimationOptionRepeat
                         animations:^{
//            cell.bounds = CGRectMake(cell.bounds.origin.x, cell.bounds.origin.y, cell.bounds.size.width + 1, cell.bounds.size.height + 1);
            cell.transform = CGAffineTransformMakeRotation(0.02);
            cell.transform = CGAffineTransformMakeRotation(-0.03);
//            cell.transform = CGAffineTransformMakeRotation(0.1);
        } completion:nil];
        
    }

}





@end
