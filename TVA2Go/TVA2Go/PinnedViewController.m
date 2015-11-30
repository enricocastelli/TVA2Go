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
#import "GTLYouTube.h"


@interface PinnedViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *pinned;
@property (strong,nonatomic) NSArray *array;
@property (strong, nonatomic) PFQuery* query;
@property (strong,nonatomic) NSString* deleting;
@property (strong, nonatomic) UIImageView *playImage;
@property (strong, nonatomic) UIImageView *deleteImage;
@property (strong, nonatomic) NSString *firstTime;






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
    UIButton *title = [UIButton buttonWithType:UIButtonTypeSystem];
    title.tintColor = [UIColor whiteColor];
    [title setTitle:@"Pinned Videos" forState:UIControlStateNormal];
    UIFont * font = [UIFont fontWithName:@"Helvetica Neuw" size:20];
    
    title.titleLabel.font = font;

    self.navigationItem.titleView = title;



}

- (void)viewWillAppear:(BOOL)animated
{
    self.firstTime = @"YES";

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
        if ([self.firstTime isEqualToString: @"YES"]) {
            cell.contentView.alpha = 0;
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:3 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                cell.bounds = CGRectMake(0, cell.frame.origin.y + 13, 85, 85);
                cell.contentView.alpha = 1;
            } completion:nil];
        } else {
            cell.contentView.alpha = 0;

            [UIView animateWithDuration:1.6 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                cell.contentView.alpha = 1;
            } completion:nil];
            
            
            
        }
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

    }];


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
            UICollectionViewCell *cellToDelete = [self.pinned cellForItemAtIndexPath:indexPath];
            
            UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            act.frame = CGRectMake(30, 30, 32, 32);
            [cellToDelete.contentView addSubview:act];
            [act startAnimating];
            PFUser *user = [PFUser currentUser];
            NSMutableArray *arr = [user[@"pinnedVideos"] mutableCopy];
            [arr removeObjectAtIndex:indexPath.row];
            
            [user setObject:[arr copy] forKey:@"pinnedVideos"];
            
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded){
                    
                    [UIView animateWithDuration:0.6 animations:^{
                        cellToDelete.alpha = 0;
                    }];
                }
                

   
            }];
        }
    }];

}

- (void)edit

{
    if ([self.deleting  isEqualToString: @"NO"]) {
        self.navigationItem.rightBarButtonItem.title = @"Done";
        [self dancingCells];
        self.deleting = @"YES";
        

    } else {

    self.navigationItem.rightBarButtonItem.title = @"Edit";
    self.deleting = @"NO";
        for (UICollectionViewCell *cell in self.pinned.visibleCells)
        {
            cell.transform = CGAffineTransformMakeRotation(0);

           
            [self.deleteImage removeFromSuperview];
            self.deleteImage.hidden =YES;
            [cell.layer removeAllAnimations];
    }

        self.firstTime = @"NO";
        self.pinned.alpha = 0.6;
        [UIView animateWithDuration:0.8 animations:^{
            [self.pinned reloadData];
            self.pinned.alpha = 1;


        }];
        
        
    }
}

- (void)dancingCells
{
    for (UICollectionViewCell *cell in self.pinned.visibleCells){
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:10 options: UIViewAnimationOptionAutoreverse |UIViewAnimationOptionRepeat |UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             cell.transform = CGAffineTransformMakeRotation(0.02);
                             cell.transform = CGAffineTransformMakeRotation(-0.02);
                         } completion:nil];
        UIImage *play = [UIImage imageNamed:@"deleteIcon"];
        CGRect little = CGRectMake(30, 30, 30, 30);
        self.deleteImage = [[UIImageView alloc] initWithFrame:little];
        
        self.deleteImage.image = play;
        [cell.contentView addSubview:self.deleteImage];
    }
}



@end
