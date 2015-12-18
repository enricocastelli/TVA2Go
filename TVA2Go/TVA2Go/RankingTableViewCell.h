//
//  RankingTableViewCell.h
//  
//
//  Created by Alyson Vivattanapa on 11/25/15.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface RankingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *imageThumbnail;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *rankingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pinImage;

@end
