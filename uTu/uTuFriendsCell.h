//
//  uTuFriendsCell.h
//  uTu
//
//  Created by Sankar on 21/05/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface uTuFriendsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contactPic;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *contactNumber;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
