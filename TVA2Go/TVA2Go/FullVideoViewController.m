//
//  FullVideoViewController.m
//  TVA2Go
//
//  Created by Alyson Vivattanapa on 11/24/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "FullVideoViewController.h"
#import "PinnedViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "TAAYouTubeWrapper.h"
#import "RankingTableViewCell.h"

@interface FullVideoViewController () <UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *videos;

@end

@implementation FullVideoViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName: @"RankingTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [TAAYouTubeWrapper videosForUser:@"TVAcademyNL" onCompletion:^(BOOL succeeded, NSArray *videos, NSError *error) {
        self.videos = videos;
        [self.tableView reloadData];
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
    
    
    
    
    return cell;
    
}




@end
