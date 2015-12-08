//
//  FullVideoViewController.m
//  TVA2Go
//
//  Created by Alyson Vivattanapa on 11/24/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "AllTableViewController.h"
#import "PinnedViewController.h"
#import "TAAYouTubeWrapper.h"
#import "RankingTableViewCell.h"
#import "TVA2Go-Swift.h"

@interface AllTableViewController () <UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *videos;

@end

@implementation AllTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.hidden = YES;
    [self.tableView registerNib:[UINib nibWithNibName: @"RankingTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    UIImage *home = [UIImage imageNamed:@"Home"];
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage:home style:UIBarButtonItemStylePlain target:self action:@selector(home)];
    self.navigationItem.rightBarButtonItem = homeButton;
    [TAAYouTubeWrapper videosForUser:@"TVAcademyNL" onCompletion:^(BOOL succeeded, NSArray *videos, NSError *error) {
        self.videos = videos;
        [self.tableView reloadData];
        self.tableView.hidden = NO;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videos.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RankingTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    GTLYouTubeVideo *video = self.videos[indexPath.row];

    cell.titleLabel.text = video.snippet.title;
    
    NSURL *url = [NSURL URLWithString:video.snippet.thumbnails.standard.url];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage*im = [UIImage imageWithData:data];
    cell.imageThumbnail.image = im;
    [cell.imageThumbnail loadInBackground];
    cell.pinImage.alpha = 0;
    cell.rankingLabel.alpha = 0;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FullVideoSwift *f = [[FullVideoSwift alloc] initWithNibName:@"FullSwiftViewController" bundle:nil];
    f.fullVideo = self.videos[indexPath.row];
    
    [self.navigationController pushViewController:f animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

- (void)home
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
