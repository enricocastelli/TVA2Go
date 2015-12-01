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
#import "PinCollectionViewCell.h"


@interface PinnedViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *pinned;
@property (strong,nonatomic) NSMutableArray *array;
@property (strong,nonatomic) NSArray *videos;
@property (strong,nonatomic) PFUser *user;

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

    [self.pinned registerNib:[UINib nibWithNibName:@"PinCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
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
    self.firstTime = @"YES";

    self.view.backgroundColor = self.pinned.backgroundColor;
    
    self.user = [PFUser currentUser];
    [self.user fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        self.array = self.user[@"pinnedVideos"];
        
        self.query = [PFQuery queryWithClassName:@"Video"];
        
        [self.query whereKey:@"videoID" containedIn:self.array];
        
        [self.query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
           
            self.videos = [objects sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                PFObject *object1 = obj1;
                PFObject *object2 = obj2;
                NSUInteger one =[self.array indexOfObject:object1[@"videoID"]];
                NSUInteger two = [self.array indexOfObject:object2[@"videoID"]];
                
                if (one > two) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedAscending;
                }

            }];
            
            
            [self.pinned reloadData];
            [self cellFading];

            
        }];

    }];
}

- (void)viewDidAppear:(BOOL)animated
{
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
}


- (UICollectionViewCell *)createCell:(PinCollectionViewCell*)cell atIndex:(NSIndexPath *)indexPath
{
    
    cell.thumbnail.file = self.videos[indexPath.row][@"thumbnail"];
    [cell.thumbnail loadInBackground];
    
    return cell;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PinCollectionViewCell *cell = [self.pinned dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if ([self.deleting  isEqualToString: @"YES"]) {
        [self dancingCells];
        cell.deleteImage.hidden = NO;
        cell.playImage.hidden = YES;
        
    } else {
        [self stopDancing];
        cell.deleteImage.hidden = YES;
        cell.playImage.hidden = NO;
    }
    
    [self createCell:cell atIndex:indexPath];
    
    return cell;
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FullVideoViewController *f = [[FullVideoViewController alloc]init];


        if ([self.deleting  isEqualToString: @"NO"]) {
            
        f.video = self.videos[indexPath.row];
        
        [self.navigationController pushViewController:f animated:YES];
        } else {
            
            UICollectionViewCell *cellToDelete = [self.pinned cellForItemAtIndexPath:indexPath];
            

            UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            act.frame = CGRectMake(30, 30, 32, 32);
            [cellToDelete.contentView addSubview:act];
            [act startAnimating];
            
                
           
            
                [self.array removeObjectAtIndex:indexPath.row];
  
                
            self.user[@"pinnedVideos"] = [self.array copy];
                [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded){
                        [UIView animateWithDuration:0.6 animations:^{
                            cellToDelete.alpha = 0;
                        }];
                        [self.pinned deleteItemsAtIndexPaths:@[indexPath]];
                        [self.pinned reloadData];
                        [self dancingCells];
                    }

            }];
        }
}

- (void)edit

{
    if ([self.deleting  isEqualToString: @"NO"]) {
        self.navigationItem.rightBarButtonItem.title = @"Done";
        self.deleting = @"YES";
        [self dancingCells];

    } else {

    self.navigationItem.rightBarButtonItem.title = @"Edit";
    self.deleting = @"NO";
        
        self.firstTime = @"NO";
            [self stopDancing];
    }
}

- (void)dancingCells
{
    for (PinCollectionViewCell *cell in self.pinned.visibleCells){
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:10 options: UIViewAnimationOptionAutoreverse |UIViewAnimationOptionRepeat |UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             cell.transform = CGAffineTransformMakeRotation(0.02);
                             cell.transform = CGAffineTransformMakeRotation(-0.02);
                         } completion:nil];
        cell.deleteImage.hidden = NO;
        cell.playImage.hidden = YES;

    }
    
}

- (void)stopDancing
{
    for (PinCollectionViewCell *cell in self.pinned.visibleCells)
    {
        cell.transform = CGAffineTransformMakeRotation(0);
        [cell.layer removeAllAnimations];
        cell.deleteImage.hidden = YES;
        cell.playImage.hidden = NO;
    }

}

- (void)cellFading
{
    for (PinCollectionViewCell *cell in self.pinned.visibleCells) {
        [UIView animateWithDuration:1 delay:1.2 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            cell.bounds = CGRectMake(0, cell.frame.origin.y + 30, 85, 85);
            cell.contentView.alpha = 1;
        } completion:nil];
    }
}




@end
