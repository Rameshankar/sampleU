//
//  FavoritesCell.h
//  uTu
//
//  Created by Sankar on 21/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *channelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UILabel *timelLabel;

@end
