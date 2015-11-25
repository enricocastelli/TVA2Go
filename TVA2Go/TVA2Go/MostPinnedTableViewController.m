//
//  MostPinnedTableViewController.m
//  TVA2Go
//
//  Created by Alyson Vivattanapa on 11/24/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "MostPinnedTableViewController.h"

#import "RankingTableViewCell.h"

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
    
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(nullable PFObject *)object {

    RankingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    PFFile *thumbnail = [object objectForKey:@"thumbnail"];
    
    PFImageView *thumbnailImageView = (PFImageView*) [cell viewWithTag:100];
    thumbnailImageView.file = thumbnail;
    [thumbnailImageView loadInBackground];
    
    NSString *title = object[@"title"];
    cell.titleLabel.text = title;
    
    NSString *description = object[@"description"];
    cell.descriptionLabel.text = description;
    
    return cell;
}


@end
