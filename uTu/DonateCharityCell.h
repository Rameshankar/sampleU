//
//  DonateCharityCell.h
//  uTu
//
//  Created by Sankar on 21/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DonateCharityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UIButton *giftButton;
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;

- (IBAction)CartButton:(id)sender;

@end
