//
//  MostPinnedTableViewController.m
//  TVA2Go
//
//  Created by Alyson Vivattanapa on 11/24/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "MostPinnedTableViewController.h"

#import "RankingTableViewCell.h"
#import "FullVideoViewController.h"

@interface MostPinnedTableViewController () 

@end

@implementation MostPinnedTableViewController

- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Video"];
    
    [query orderByDescending:@"pinCount"];
    
    return query;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RankingTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorColor = [UIColor blackColor];
    UIButton *title = [UIButton buttonWithType:UIButtonTypeSystem];
    title.tintColor = [UIColor whiteColor];
    [title setTitle:@"Most Pinned Videos" forState:UIControlStateNormal];
    UIFont * font = [UIFont fontWithName:@"Helvetica Neuw" size:20];
    
    title.titleLabel.font = font;


    
    self.navigationItem.titleView = title;
    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
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
    cell.descriptionLabel.text = object[@"description"];
    cell.rankingLabel.text = [NSString stringWithFormat:@"%@", object[@"pinCount"]];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FullVideoViewController *f = [[FullVideoViewController alloc] init];
    f.video = self.objects[indexPath.row];
    
    [self.navigationController pushViewController:f animated:YES];
}




@end






