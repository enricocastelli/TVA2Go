//
//  RankingTableViewCell.h
//  TVA2Go
//
//  Created by Alyson Vivattanapa on 11/24/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageThumbnail;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
