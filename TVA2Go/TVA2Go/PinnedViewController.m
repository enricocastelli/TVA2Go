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
#import "GTLYouTube.h"
#import "PinCollectionViewCell.h"
#import "TVA2Go-Swift.h"
#import "AllTableViewController.h"
#import "MostPinnedTableViewController.h"
#import "HomeViewController.h"


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
@property (weak, nonatomic) IBOutlet UIView *headerView;


@end

@implementation PinnedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.deleting = @"NO";

    [self setCollectionView];
    
    [self setObjects];
    self.firstTime = @"YES";
    [self setNav];


    self.view.backgroundColor = self.pinned.backgroundColor;
    [self createHeader];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)createHeader
{
    UIView * header = [[[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil]firstObject];
    
    [self.headerView addSubview:header];
    
    UIButton*all = [header viewWithTag:1];
    [all addTarget:self action:@selector(pushAll) forControlEvents:UIControlEventTouchUpInside];
    UILabel * allLabel = [header viewWithTag:4];
    allLabel.hidden = YES;
    
    UILabel * mineLabel = [header viewWithTag:5];
    mineLabel.hidden = NO;
    UIButton*most = [header viewWithTag:3];
    [most addTarget:self action:@selector(pushMost) forControlEvents:UIControlEventTouchUpInside];
    UILabel * mostlabel = [header viewWithTag:6];
    mostlabel.hidden = YES;
 
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.pinned.allowsMultipleSelection = NO;
}

- (void)setCollectionView
{
    
    [self.pinned registerNib:[UINib nibWithNibName:@"PinCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    self.pinned.delegate = self;
    self.pinned.allowsSelection = YES;
    self.pinned.frame = self.view.frame;
}

- (void)setNav
{
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
    self.navigationItem.rightBarButtonItem = edit;
    UIButton *title = [UIButton buttonWithType:UIButtonTypeSystem];
    title.tintColor = [UIColor whiteColor];
    [title setTitle:@"Pinned Videos" forState:UIControlStateNormal];
    UIFont * font = [UIFont fontWithName:@"Helvetica Neuw" size:20];
    
    title.titleLabel.font = font;
    self.navigationItem.titleView = title;
    
    UIImage *home = [UIImage imageNamed:@"Home"];
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage:home style:UIBarButtonItemStylePlain target:self action:@selector(home)];
    self.navigationItem.leftBarButtonItem = homeButton;
    self.navigationItem.hidesBackButton = YES;

}

- (void)setObjects
{
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
}


- (UICollectionViewCell *)createCell:(PinCollectionViewCell*)cell atIndex:(NSIndexPath *)indexPath
{
    
    cell.thumbnail.file = self.videos[indexPath.row][@"thumbnail"];
    cell.thumbnail.layer.cornerRadius = 10;
    cell.thumbnail.clipsToBounds = YES;
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
    
     FullVideoSwift*f = [[FullVideoSwift alloc]initWithNibName:@"FullSwiftViewController" bundle:nil]; 
    
    if ([self.deleting  isEqualToString: @"NO"]) {
        
        PFObject *selected = self.videos[indexPath.row];
        
        f.parseVideoObject = selected;
        
        [self.navigationController pushViewController:f animated:YES];
        } else {
            
            self.pinned.allowsSelection = NO;
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
                        self.pinned.allowsSelection = YES;
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


- (void)home
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)pushAll
{
    AllTableViewController *all = [[AllTableViewController alloc] init];
    HomeViewController *h = [[HomeViewController alloc] init];
    [self.navigationController setViewControllers: @[h,all]];
    [self.navigationController popToViewController:all animated:YES];
}

- (void)pushMost
{
     MostPinnedTableViewController *most = [[MostPinnedTableViewController alloc] init];
    HomeViewController *h = [[HomeViewController alloc] init];
    [self.navigationController setViewControllers: @[h,most]];
    [self.navigationController popToViewController:most animated:YES];
}

@end
