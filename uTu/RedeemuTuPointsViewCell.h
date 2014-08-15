//
//  RedeemuTuPointsViewCell.h
//  uTu
//
//  Created by Sankar on 20/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedeemuTuPointsViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoPic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UIButton *cartButton;
@property (weak, nonatomic) IBOutlet UIImageView *cartImageView;

- (IBAction)cartButton:(id)sender;

@end
