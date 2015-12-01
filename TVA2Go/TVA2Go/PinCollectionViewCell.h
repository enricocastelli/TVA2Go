//
//  PinCollectionViewCell.h
//  TVA2Go
//
//  Created by Eyolph on 24/11/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface PinCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UIImageView *playImage;
@property (weak, nonatomic) IBOutlet UIImageView *deleteImage;





@end
