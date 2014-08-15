//
//  uTuContactsCell.h
//  uTu
//
//  Created by Sankar on 22/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface uTuContactsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contactPic;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *contactNumber;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
