//
//  MostPinnedTableViewController.m
//  TVA2Go
//
//  Created by Alyson Vivattanapa on 11/24/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "MostPinnedTableViewController.h"
#import "RankingTableViewCell.h"
#import "TVA2Go-Swift.h"
#import "PinnedViewController.h"
#import "HomeViewController.h"

@interface MostPinnedTableViewController ()

@end

@implementation MostPinnedTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        
    }
    return self;
}

- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Video"];
    
    [query orderByDescending:@"pinCount"];
    
    return query;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.tableView setBackgroundColor:[UIColor blackColor]];
    [self.tableView registerNib:[UINib nibWithNibName:@"RankingTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorColor = [UIColor clearColor];
    [self createHeader];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationBar];

}

- (void)createHeader
{
    UIView * header = [[[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil]firstObject];
    
    header.frame = CGRectMake(0, 0, self.view.frame.size.width, 25);
    self.tableView.tableHeaderView = header;
    self.tableView.tableHeaderView.userInteractionEnabled = YES;
    
    
    UIButton*all = [header viewWithTag:1];
    [all addTarget:self action:@selector(allVideos) forControlEvents:UIControlEventTouchUpInside];
    UILabel * allLabel = [header viewWithTag:4];
    allLabel.hidden = YES;
    
    UIButton*mine = [header viewWithTag:2];
      [mine addTarget:self action:@selector(pushMine) forControlEvents:UIControlEventTouchUpInside];
    UILabel * mineLabel = [header viewWithTag:5];
    mineLabel.hidden = YES;
      UILabel * mostlabel = [header viewWithTag:6];
    mostlabel.hidden = NO;
    
}

- (void)setNavigationBar
{
    self.navigationItem.title = @"Most Pinned";
    
  [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans-Light" size:22.0f], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIImage *home = [UIImage imageNamed:@"Home"];
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage:home style:UIBarButtonItemStylePlain target:self action:@selector(home)];
    
    self.navigationItem.leftBarButtonItem = homeButton;
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView * _Nonnull)tableView
heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView * _Nonnull)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(nullable PFObject *)object {

    RankingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];


    if ([object[@"thumbnail"] isKindOfClass:[PFFile class]]) {
        cell.imageThumbnail.hidden = NO;
    cell.imageThumbnail.file = object[@"thumbnail"];
        [cell.imageThumbnail loadInBackground];

    } else {
        cell.imageThumbnail.image = nil;
        cell.imageThumbnail.hidden = YES;
    }
    
    cell.titleLabel.text = object[@"title"];
    cell.rankingLabel.text = [NSString stringWithFormat:@"%@", object[@"pinCount"]];
    cell.selectionStyle = UITableViewCellSeparatorStyleSingleLine;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FullVideoSwift *f = [[FullVideoSwift alloc] initWithNibName:@"FullSwiftViewController" bundle:nil];
    f.parseVideoObject = self.objects[indexPath.row];
    
    [self.navigationController pushViewController:f animated:YES];
    
}

- (void)home
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)allVideos
{
    AllVTableViewController *full = [[AllVTableViewController alloc] init];
    HomeViewController *h = [[HomeViewController alloc] init];
    [self.navigationController setViewControllers: @[h,full]];
    [self.navigationController popToViewController:full animated:YES];
}


- (void)pushMine
{
    PinnedViewController *pin = [[PinnedViewController alloc] init];
    HomeViewController *h = [[HomeViewController alloc] init];
    [self.navigationController setViewControllers: @[h,pin]];
    [self.navigationController popToViewController:pin animated:YES];
}


@end






