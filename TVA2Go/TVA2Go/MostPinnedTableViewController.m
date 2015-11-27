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
    self.tableView.separatorColor = [UIColor clearColor];
    self.navigationItem.title = @"Most Pinned Videos";
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(nullable PFObject *)object {

    RankingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    cell.imageThumbnail.file = [object objectForKey:@"thumbnail"];
    [cell.imageThumbnail loadInBackground];
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






